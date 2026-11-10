// Package team is the team invite and membership routes (P5.4), the Go port
// of supabase/functions/invite (index.ts, code.ts). Each action of the Edge
// Function is its own route, POST /api/app/team/<action>, with the same body
// minus "action", the same answers and the same HTTP statuses and error
// codes. The error body is the one of the other app routes, {status,
// message, data: {code}}: data.code is the Edge Function's "error".
//
//   - create   {org_id, role}: an owner or partner gets a 6-character code,
//     valid for [InviteTTL], for role partner, worker or viewer.
//     → {code, role, expires_at}
//   - redeem   {code}: joins the code's organization with the code's role.
//     → {org_id, role}. 404 invalid_code (unknown, expired or used: no
//     difference), 409 already_member, 429 too_many_requests.
//   - members  {org_id}: the organization's live members with their e-mail,
//     for members. → {members: [{user_id, email}]}
//   - set_role {org_id, user_id, role} and remove {org_id, user_id}: owner
//     only; an owner's membership is not changed (409 owner_locked: the
//     organization keeps its owner), nor one whose account deletion is
//     pending (409 member_leaving). → {ok: true}
//
// All of it is online; memberships written here reach the devices by sync
// (server_seq comes from the model hook).
package team

import (
	"database/sql"
	"encoding/json"
	"errors"
	"net/http"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

// RoutePrefix is followed by the action name.
const RoutePrefix = "/api/app/team/"

// InviteTTL is how long a code is valid (index.ts ttlMs; the invites column
// default now() + 48 hours).
const InviteTTL = 48 * time.Hour

// createAttempts is how many codes create tries when a code is taken.
const createAttempts = 5

// Error codes (data.code), as the Edge Function's "error".
const (
	CodeBadRequest      = "bad_request"
	CodeBadRole         = "bad_role"
	CodeForbidden       = "forbidden"
	CodeInvalidCode     = "invalid_code"
	CodeAlreadyMember   = "already_member"
	CodeNotFound        = "not_found"
	CodeOwnerLocked     = "owner_locked"
	CodeMemberLeaving   = "member_leaving"
	CodeServer          = "server"
	CodeTooManyRequests = "too_many_requests"
)

// Clock and code source; tests replace them.
var (
	now          = time.Now
	generateCode = GenerateCode
)

// failure is a refused request: its HTTP status and code.
type failure struct {
	status  int
	code    string
	message string
}

func (f *failure) Error() string { return f.code + ": " + f.message }

func fail(status int, code, message string) error {
	return &failure{status: status, code: code, message: message}
}

var (
	errBadRequest    = fail(http.StatusBadRequest, CodeBadRequest, "The request is not valid.")
	errBadRole       = fail(http.StatusBadRequest, CodeBadRole, "The role must be partner, worker or viewer.")
	errForbidden     = fail(http.StatusForbidden, CodeForbidden, "You may not do this in this organization.")
	errInvalidCode   = fail(http.StatusNotFound, CodeInvalidCode, "The code is not valid.")
	errAlreadyMember = fail(http.StatusConflict, CodeAlreadyMember, "You are already a member of this organization.")
	errNotFound      = fail(http.StatusNotFound, CodeNotFound, "No such member.")
	errOwnerLocked   = fail(http.StatusConflict, CodeOwnerLocked, "The owner's membership cannot be changed.")
	errMemberLeaving = fail(http.StatusConflict, CodeMemberLeaving, "This member is deleting their account.")
	errTooMany       = fail(http.StatusTooManyRequests, CodeTooManyRequests, "Too many attempts; please wait a minute.")
)

type action func(app core.App, userID string, body map[string]json.RawMessage) (any, error)

// Register binds the five routes; all need a signed-in app user (401
// otherwise, which the app maps like 403).
func Register(app core.App) {
	redeemLimit := newLimiter(RedeemLimit, RedeemWindow)
	actions := map[string]action{
		"create": createInvite,
		"redeem": func(app core.App, userID string, body map[string]json.RawMessage) (any, error) {
			if !redeemLimit.allow(userID, now()) {
				return nil, errTooMany
			}
			return redeem(app, userID, body)
		},
		"members":  members,
		"set_role": setRole,
		"remove":   remove,
	}
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		for name, act := range actions {
			se.Router.POST(RoutePrefix+name, handler(act)).Bind(apis.RequireAuth(auth.UsersCollection))
		}
		return se.Next()
	})
}

func handler(act action) func(*core.RequestEvent) error {
	return func(e *core.RequestEvent) error {
		var body map[string]json.RawMessage
		if err := json.NewDecoder(e.Request.Body).Decode(&body); err != nil || body == nil {
			return apiError(e, errBadRequest.(*failure))
		}
		out, err := act(e.App, e.Auth.Id, body)
		var f *failure
		switch {
		case errors.As(err, &f):
			return apiError(e, f)
		case err != nil:
			e.App.Logger().Error("team route failed", "path", e.Request.URL.Path, "error", err)
			return apiError(e, &failure{status: http.StatusInternalServerError, code: CodeServer, message: "Something went wrong; try again."})
		}
		return e.JSON(http.StatusOK, out)
	}
}

func apiError(e *core.RequestEvent, f *failure) error {
	return e.JSON(f.status, auth.ErrorBody{Status: f.status, Message: f.message, Data: auth.ErrorData{Code: f.code}})
}

// str is body[key] when it is a JSON string.
func str(body map[string]json.RawMessage, key string) (string, bool) {
	var s string
	if json.Unmarshal(body[key], &s) != nil {
		return "", false
	}
	return s, true
}

// uuidOf is body[key] when it is a UUID. index.ts's test was case
// insensitive; every id here is stored lower-case (K-4), so only that
// matches anything.
func uuidOf(body map[string]json.RawMessage, key string) (string, bool) {
	s, ok := str(body, key)
	return s, ok && pattern.IsUUID(s)
}

// CreateResponse is the answer of create.
type CreateResponse struct {
	Code      string `json:"code"`
	Role      string `json:"role"`
	ExpiresAt string `json:"expires_at"`
}

func createInvite(app core.App, userID string, body map[string]json.RawMessage) (any, error) {
	orgID, ok := uuidOf(body, "org_id")
	if !ok {
		return nil, errBadRequest
	}
	role, _ := str(body, "role")
	if !IsInviteRole(role) {
		return nil, errBadRole
	}
	// invites insert policy: owner or partner of the organization.
	allowed, err := authz.Can(app, userID, "invites", orgID, authz.Insert)
	if err != nil {
		return nil, err
	}
	if !allowed {
		return nil, errForbidden
	}

	invites, err := app.FindCachedCollectionByNameOrId("invites")
	if err != nil {
		return nil, err
	}
	// The code is unique across organizations; a taken one is drawn again.
	for range createAttempts {
		t := now()
		invite := core.NewRecord(invites)
		invite.Set("org_id", orgID)
		invite.Set("code", generateCode())
		invite.Set("role", role)
		invite.Set("created_at", pattern.FormatTimestamp(t))
		invite.Set("created_by", userID)
		invite.Set("expires_at", pattern.FormatTimestamp(t.Add(InviteTTL)))
		err := app.Save(invite)
		if err == nil {
			return CreateResponse{Code: invite.GetString("code"), Role: role, ExpiresAt: invite.GetString("expires_at")}, nil
		}
		if !appsync.IsUniqueViolation(err) {
			return nil, err
		}
	}
	return nil, errors.New("team: no free invite code after retries")
}

// RedeemResponse is the answer of redeem.
type RedeemResponse struct {
	OrgID string `json:"org_id"`
	Role  string `json:"role"`
}

// redeem claims the code and adds the membership in one transaction: either
// both are written or neither, so a failed join leaves the code usable
// (index.ts released it by hand). PocketBase runs transactions on its
// single-connection write pool, one at a time, so two users cannot claim the
// same code.
func redeem(app core.App, userID string, body map[string]json.RawMessage) (any, error) {
	input, _ := str(body, "code")
	code := NormalizeCode(input)
	if !IsCode(code) {
		return nil, errInvalidCode
	}

	var out RedeemResponse
	err := app.RunInTransaction(func(txApp core.App) error {
		t := now()
		stamp := pattern.FormatTimestamp(t)
		invite := &core.Record{}
		err := txApp.RecordQuery("invites").
			AndWhere(dbx.HashExp{"code": code, "used_at": ""}).
			AndWhere(dbx.NewExp("[[expires_at]] > {:now}", dbx.Params{"now": stamp})).
			Limit(1).
			One(invite)
		if errors.Is(err, sql.ErrNoRows) {
			return errInvalidCode
		}
		if err != nil {
			return err
		}
		orgID, role := invite.GetString("org_id"), invite.GetString("role")

		member, err := authz.IsMember(txApp, userID, orgID)
		if err != nil {
			return err
		}
		if member {
			return errAlreadyMember
		}

		invite.Set("used_at", stamp)
		invite.Set("used_by", userID)
		if err := txApp.Save(invite); err != nil {
			return err
		}

		memberships, err := txApp.FindCachedCollectionByNameOrId("memberships")
		if err != nil {
			return err
		}
		m := core.NewRecord(memberships)
		m.Id = ids.New()
		m.Set("org_id", orgID)
		m.Set("user_id", userID)
		m.Set("role", role)
		m.Set("created_by", userID)
		m.Set("created_at", stamp)
		m.Set("updated_at", stamp)
		if err := txApp.Save(m); err != nil {
			return err
		}
		out = RedeemResponse{OrgID: orgID, Role: role}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// Member is one element of the members answer; Email is null when the
// account is gone.
type Member struct {
	UserID string  `json:"user_id"`
	Email  *string `json:"email"`
}

// MembersResponse is the answer of members.
type MembersResponse struct {
	Members []Member `json:"members"`
}

func members(app core.App, userID string, body map[string]json.RawMessage) (any, error) {
	orgID, ok := uuidOf(body, "org_id")
	if !ok {
		return nil, errBadRequest
	}
	member, err := authz.IsMember(app, userID, orgID)
	if err != nil {
		return nil, err
	}
	if !member {
		return nil, errForbidden
	}
	var userIDs []string
	err = app.DB().Select("user_id").From("memberships").
		Where(dbx.HashExp{"org_id": orgID, "deleted_at": ""}).
		OrderBy("created_at ASC", "id ASC").
		Column(&userIDs)
	if err != nil {
		return nil, err
	}
	out := MembersResponse{Members: make([]Member, 0, len(userIDs))}
	for _, id := range userIDs {
		m := Member{UserID: id}
		u, err := app.FindRecordById(auth.UsersCollection, id)
		switch {
		case err == nil:
			email := u.Email()
			m.Email = &email
		case !errors.Is(err, sql.ErrNoRows):
			return nil, err
		}
		out.Members = append(out.Members, m)
	}
	return out, nil
}

// OKResponse is the answer of set_role and remove.
type OKResponse struct {
	OK bool `json:"ok"`
}

func setRole(app core.App, userID string, body map[string]json.RawMessage) (any, error) {
	return changeMember(app, userID, body, true)
}

func remove(app core.App, userID string, body map[string]json.RawMessage) (any, error) {
	return changeMember(app, userID, body, false)
}

// changeMember is set_role (setRole true) and remove: the owner changes the
// role of, or soft-deletes, another live member.
func changeMember(app core.App, userID string, body map[string]json.RawMessage, setRole bool) (any, error) {
	orgID, okOrg := uuidOf(body, "org_id")
	target, okTarget := uuidOf(body, "user_id")
	if !okOrg || !okTarget {
		return nil, errBadRequest
	}
	role, _ := str(body, "role")
	if setRole && !IsInviteRole(role) {
		return nil, errBadRole
	}

	err := app.RunInTransaction(func(txApp core.App) error {
		owner, err := authz.HasRole(txApp, userID, orgID, authz.Owner)
		if err != nil {
			return err
		}
		if !owner {
			return errForbidden
		}
		m := &core.Record{}
		err = txApp.RecordQuery("memberships").
			AndWhere(dbx.HashExp{"org_id": orgID, "user_id": target, "deleted_at": ""}).
			Limit(1).
			One(m)
		if errors.Is(err, sql.ErrNoRows) {
			return errNotFound
		}
		if err != nil {
			return err
		}
		if m.GetString("role") == string(authz.Owner) {
			return errOwnerLocked
		}
		// A member who confirmed deleting their account is neither changed
		// nor removed while it is pending; cancelling clears the mark.
		if m.GetString("deletion_scheduled_for") != "" {
			return errMemberLeaving
		}
		stamp := pattern.FormatTimestamp(now())
		if setRole {
			m.Set("role", role)
		} else {
			m.Set("deleted_at", stamp)
		}
		m.Set("updated_at", stamp)
		return txApp.Save(m)
	})
	if err != nil {
		return nil, err
	}
	return OKResponse{OK: true}, nil
}
