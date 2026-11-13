package deletion

import (
	"database/sql"
	"encoding/json"
	"errors"
	"strings"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// RequestsCollection holds the deletion requests (public.deletion_requests).
const RequestsCollection = "deletion_requests"

// GracePeriod is the time between the request and the permanent deletion
// (private.account_deletion_grace: 7 days, within KVKK's 30). The one
// source: the request, the e-mail and the tests read it from here.
const GracePeriod = 7 * 24 * time.Hour

// The request rate limit of account_deletion_request: the same user or the
// same e-mail digest may make at most RequestLimit requests per
// RequestWindow.
const (
	RequestLimit  = 3
	RequestWindow = 24 * time.Hour
)

// Kinds, channels and statuses of a request (the deletion_requests checks).
const (
	KindAccount             = "hesap"
	KindAccountOrganization = "hesap_ve_isletme"
	ChannelApp              = "uygulama"
	ChannelWeb              = "web"
	StatusPending           = "bekliyor"
	StatusCancelled         = "iptal"
	StatusCompleted         = "tamamlandi"
)

// RequestJSON is private.deletion_request_json: what the client sees of a
// request (no digests, no internal steps). Times are K-5.
type RequestJSON struct {
	ID           string   `json:"id"`
	OrgID        *string  `json:"org_id"`
	Kind         string   `json:"kind"`
	Channel      string   `json:"channel"`
	Status       string   `json:"status"`
	RequestedAt  string   `json:"requested_at"`
	ScheduledFor string   `json:"scheduled_for"`
	DeleteOrgIDs []string `json:"delete_org_ids"`
}

// Counts is private.account_deletion_counts: the live records of the
// organizations that will be deleted, and their published lot pages.
type Counts struct {
	Hives          int `json:"hives"`
	Apiaries       int `json:"apiaries"`
	Inspections    int `json:"inspections"`
	Harvests       int `json:"harvests"`
	Documents      int `json:"documents"`
	Photos         int `json:"photos"`
	PublicLotPages int `json:"public_lot_pages"`
}

// RequestResponse is the answer of request.
type RequestResponse struct {
	Request        RequestJSON `json:"request"`
	Counts         Counts      `json:"counts"`
	AlreadyPending bool        `json:"already_pending"`
}

// StatusResponse is the answer of status: the pending request or null.
type StatusResponse struct {
	Request *RequestJSON `json:"request"`
}

// CancelResponse is the answer of cancel.
type CancelResponse struct {
	Cancelled bool `json:"cancelled"`
}

// RequestInput is account_deletion_request's arguments.
type RequestInput struct {
	UserID             string
	Email              string
	OrgID              string
	DeleteOrganization bool
	Channel            string
	TransferTo         string
}

// parseRequest is handler.ts's input check of request.
func parseRequest(b body) (RequestInput, bool) {
	var in RequestInput
	if !isNull(b, "org_id") {
		if json.Unmarshal(b["org_id"], &in.OrgID) != nil || !pattern.IsUUID(in.OrgID) {
			return in, false
		}
	}
	if !isNull(b, "delete_organization") && json.Unmarshal(b["delete_organization"], &in.DeleteOrganization) != nil {
		return in, false
	}
	if !isNull(b, "transfer_to") {
		if json.Unmarshal(b["transfer_to"], &in.TransferTo) != nil || !pattern.IsUUID(in.TransferTo) ||
			in.OrgID == "" || in.DeleteOrganization {
			return in, false
		}
	}
	in.Channel = ChannelApp
	if !isNull(b, "channel") && json.Unmarshal(b["channel"], &in.Channel) != nil {
		return in, false
	}
	if in.Channel != ChannelApp && in.Channel != ChannelWeb {
		return in, false
	}
	if in.DeleteOrganization && in.OrgID == "" {
		return in, false
	}
	return in, true
}

// requestDeletion is handler.ts request {org_id?, delete_organization?,
// transfer_to?, channel?}, for the caller only (a user_id in the body is
// ignored).
//
// One transaction: the verified code is required (403 code_required), the
// request is written with the transfer of ownership, the code is consumed
// and every session of the user ends (a new tokenKey makes every issued
// token invalid). A refused request changes nothing, the code included. A
// request already pending is returned as it is (already_pending), and the
// sessions end again (handler.ts signed out again). A new request sends the
// "will be deleted on" e-mail after the commit.
func requestDeletion(e *core.RequestEvent, b body) (any, error) {
	in, ok := parseRequest(b)
	if !ok {
		return nil, errBadRequest
	}
	user := e.Auth
	in.UserID, in.Email = user.Id, user.Email()

	var out RequestResponse
	err := e.App.RunInTransaction(func(txApp core.App) error {
		verified, err := CodeVerified(txApp, user.Id)
		if err != nil {
			return err
		}
		if !verified {
			return errCodeRequired
		}
		out, err = Request(txApp, in)
		if err != nil {
			return err
		}
		if err := consumeCode(txApp, user.Id); err != nil {
			return err
		}
		return endSessions(txApp, user.Id)
	})
	if err != nil {
		return nil, err
	}

	if !out.AlreadyPending && user.Email() != "" {
		scheduled := parseTime(out.Request.ScheduledFor)
		m := RequestedMail(scheduled, out.Request.Kind == KindAccountOrganization, MailLocale(user.GetString("locale")))
		if err := sendMail(e.App, user.Email(), m); err != nil {
			e.App.Logger().Error("account deletion request e-mail not sent", "error", err, "userId", user.Id)
		}
	}
	return out, nil
}

// endSessions gives the user a new tokenKey: every token issued before is
// refused from now on (Supabase signed out every session).
func endSessions(app core.App, userID string) error {
	u, err := app.FindRecordById(auth.UsersCollection, userID)
	if err != nil {
		return err
	}
	u.RefreshTokenKey()
	return app.Save(u)
}

// Request is account_deletion_request (20261114120000): it writes the
// user's deletion request, or returns the pending one. Call it inside a
// transaction (PocketBase's single writer orders concurrent requests, as
// the advisory lock did). Refusals: bad_request (22023), forbidden (42501),
// owner_must_transfer (DL409), invalid_transfer_target (DL422),
// rate_limited (DL429).
//
// In the same transaction: ownership goes to the partner of transfer_to;
// the user's device tokens are deleted; the unused invite codes the user
// made, and those of the organizations to delete, expire; the hook of
// deletion_requests marks the user's memberships with the date.
func Request(txApp core.App, in RequestInput) (RequestResponse, error) {
	if in.UserID == "" || (in.Channel != ChannelApp && in.Channel != ChannelWeb) {
		return RequestResponse{}, errBadRequest
	}
	if in.TransferTo != "" && (in.OrgID == "" || in.DeleteOrganization || in.TransferTo == in.UserID) {
		return RequestResponse{}, errBadRequest
	}
	t := now()
	emailHash := ""
	if email := strings.ToLower(strings.TrimSpace(in.Email)); email != "" {
		emailHash = Hash(email)
	}

	existing, err := pendingRequest(txApp, in.UserID)
	if err != nil {
		return RequestResponse{}, err
	}
	if existing != nil {
		ids := deleteOrgIDs(existing)
		counts, err := countRecords(txApp, ids)
		if err != nil {
			return RequestResponse{}, err
		}
		return RequestResponse{Request: requestJSON(existing), Counts: counts, AlreadyPending: true}, nil
	}

	since := pattern.FormatTimestamp(t.Add(-RequestWindow))
	who := dbx.Or(dbx.HashExp{"user_id": in.UserID})
	if emailHash != "" {
		who = dbx.Or(dbx.HashExp{"user_id": in.UserID}, dbx.HashExp{"email_hash": emailHash})
	}
	var recent int
	err = txApp.DB().Select("count(*)").From(RequestsCollection).
		Where(dbx.NewExp("[[requested_at]] > {:since}", dbx.Params{"since": since})).
		AndWhere(who).
		Row(&recent)
	if err != nil {
		return RequestResponse{}, err
	}
	if recent >= RequestLimit {
		return RequestResponse{}, errRateLimited
	}

	if in.OrgID != "" {
		member, err := authz.IsMember(txApp, in.UserID, in.OrgID)
		if err != nil {
			return RequestResponse{}, err
		}
		if !member {
			return RequestResponse{}, errForbidden
		}
	}

	// The transfer comes before the request; the owner check below sees the
	// roles after it, and a refused request rolls it back.
	if in.TransferTo != "" {
		if err := transferOwnership(txApp, in, t); err != nil {
			return RequestResponse{}, err
		}
	}

	owned, toDelete, blocked, err := ownedOrganizations(txApp, in)
	if err != nil {
		return RequestResponse{}, err
	}
	if in.DeleteOrganization && !contains(owned, in.OrgID) {
		return RequestResponse{}, errForbidden
	}
	if len(blocked) > 0 {
		return RequestResponse{}, errOwnerMustTransfer(blocked)
	}

	requests, err := txApp.FindCachedCollectionByNameOrId(RequestsCollection)
	if err != nil {
		return RequestResponse{}, err
	}
	r := core.NewRecord(requests)
	r.Id = ids.New()
	r.Set("user_id", in.UserID)
	orgID := in.OrgID
	if orgID == "" && len(toDelete) > 0 {
		orgID = toDelete[0]
	}
	r.Set("org_id", orgID)
	kind := KindAccount
	if len(toDelete) > 0 {
		kind = KindAccountOrganization
	}
	r.Set("kind", kind)
	r.Set("requested_at", pattern.FormatTimestamp(t))
	r.Set("scheduled_for", pattern.FormatTimestamp(t.Add(GracePeriod)))
	r.Set("channel", in.Channel)
	r.Set("status", StatusPending)
	r.Set("delete_org_ids", toDelete)
	r.Set("user_hash", Hash(in.UserID))
	r.Set("email_hash", emailHash)
	if err := txApp.Save(r); err != nil {
		return RequestResponse{}, err
	}

	// Notifications stop; signing in again registers the device anew.
	tokens, err := txApp.FindAllRecords("device_tokens", dbx.HashExp{"user_id": in.UserID})
	if err != nil {
		return RequestResponse{}, err
	}
	for _, tok := range tokens {
		if err := txApp.Delete(tok); err != nil {
			return RequestResponse{}, err
		}
	}

	// Pending invite codes expire.
	stampNow := pattern.FormatTimestamp(t)
	whose := dbx.Or(dbx.HashExp{"created_by": in.UserID})
	if len(toDelete) > 0 {
		whose = dbx.Or(dbx.HashExp{"created_by": in.UserID}, dbx.In("org_id", anys(toDelete)...))
	}
	invites, err := txApp.FindAllRecords("invites",
		dbx.HashExp{"used_at": ""},
		dbx.NewExp("[[expires_at]] > {:now}", dbx.Params{"now": stampNow}),
		whose,
	)
	if err != nil {
		return RequestResponse{}, err
	}
	for _, inv := range invites {
		inv.Set("expires_at", stampNow)
		if err := txApp.Save(inv); err != nil {
			return RequestResponse{}, err
		}
	}

	counts, err := countRecords(txApp, toDelete)
	if err != nil {
		return RequestResponse{}, err
	}
	return RequestResponse{Request: requestJSON(r), Counts: counts}, nil
}

// transferOwnership makes the partner transfer_to the owner of org_id and
// the user a partner. Only the owner may (forbidden); only to a live
// partner whose own deletion is not pending (invalid_transfer_target).
func transferOwnership(txApp core.App, in RequestInput, t time.Time) error {
	owner, err := authz.HasRole(txApp, in.UserID, in.OrgID, authz.Owner)
	if err != nil {
		return err
	}
	if !owner {
		return errForbidden
	}
	partner, err := authz.HasRole(txApp, in.TransferTo, in.OrgID, authz.Partner)
	if err != nil {
		return err
	}
	leaving, err := pendingRequest(txApp, in.TransferTo)
	if err != nil {
		return err
	}
	if !partner || leaving != nil {
		return errInvalidTransferTarget
	}
	if err := setRole(txApp, in.OrgID, in.TransferTo, authz.Owner, t); err != nil {
		return err
	}
	return setRole(txApp, in.OrgID, in.UserID, authz.Partner, t)
}

// setRole changes a live membership's role; updated_at only moves forward
// (greatest(updated_at, now())), so the change reaches the devices by sync.
func setRole(txApp core.App, orgID, userID string, role authz.Role, t time.Time) error {
	m := &core.Record{}
	err := txApp.RecordQuery("memberships").
		AndWhere(dbx.HashExp{"org_id": orgID, "user_id": userID, "deleted_at": ""}).
		Limit(1).
		One(m)
	if err != nil {
		return err
	}
	m.Set("role", string(role))
	m.Set("updated_at", later(m.GetString("updated_at"), pattern.FormatTimestamp(t)))
	return txApp.Save(m)
}

// later is greatest() of two K-5 times (text order is time order).
func later(a, b string) string {
	if a > b {
		return a
	}
	return b
}

// ownedOrganizations splits the organizations the user owns: a one-person
// organization is deleted with the account; one with a team is deleted only
// when the user chose to delete org_id, otherwise it blocks the request.
// The order is that of the memberships (created_at, id).
func ownedOrganizations(txApp core.App, in RequestInput) (owned, toDelete, blocked []string, err error) {
	var orgIDs []string
	err = txApp.DB().Select("org_id").From("memberships").
		Where(dbx.HashExp{"user_id": in.UserID, "deleted_at": "", "role": string(authz.Owner)}).
		OrderBy("created_at ASC", "id ASC").
		Column(&orgIDs)
	if err != nil {
		return nil, nil, nil, err
	}
	toDelete, blocked = []string{}, []string{}
	for _, org := range orgIDs {
		var others int
		err = txApp.DB().Select("count(*)").From("memberships").
			Where(dbx.HashExp{"org_id": org, "deleted_at": ""}).
			AndWhere(dbx.Not(dbx.HashExp{"user_id": in.UserID})).
			Row(&others)
		if err != nil {
			return nil, nil, nil, err
		}
		chosen := in.DeleteOrganization && org == in.OrgID
		if others == 0 || chosen {
			toDelete = append(toDelete, org)
		} else {
			blocked = append(blocked, org)
		}
	}
	return orgIDs, toDelete, blocked, nil
}

// countRecords is private.account_deletion_counts.
func countRecords(app core.App, orgIDs []string) (Counts, error) {
	var c Counts
	if len(orgIDs) == 0 {
		return c, nil
	}
	in := dbx.In("org_id", anys(orgIDs)...)
	count := func(table string, dst *int, extra ...dbx.Expression) error {
		q := app.DB().Select("count(*)").From(table).Where(in).AndWhere(dbx.HashExp{"deleted_at": ""})
		for _, x := range extra {
			q = q.AndWhere(x)
		}
		return q.Row(dst)
	}
	for _, step := range []func() error{
		func() error { return count("hives", &c.Hives) },
		func() error { return count("apiaries", &c.Apiaries) },
		func() error { return count("inspections", &c.Inspections) },
		func() error { return count("harvests", &c.Harvests) },
		func() error { return count("documents", &c.Documents) },
		func() error { return count("media", &c.Photos, dbx.HashExp{"kind": "photo"}) },
		func() error { return count("lots", &c.PublicLotPages, dbx.HashExp{"published": true}) },
	} {
		if err := step(); err != nil {
			return Counts{}, err
		}
	}
	return c, nil
}

// pendingRequest returns the user's pending request, nil if none.
func pendingRequest(app core.App, userID string) (*core.Record, error) {
	r := &core.Record{}
	err := app.RecordQuery(RequestsCollection).
		AndWhere(dbx.HashExp{"user_id": userID, "status": StatusPending}).
		Limit(1).
		One(r)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return r, nil
}

func requestJSON(r *core.Record) RequestJSON {
	out := RequestJSON{
		ID:           r.Id,
		Kind:         r.GetString("kind"),
		Channel:      r.GetString("channel"),
		Status:       r.GetString("status"),
		RequestedAt:  r.GetString("requested_at"),
		ScheduledFor: r.GetString("scheduled_for"),
		DeleteOrgIDs: deleteOrgIDs(r),
	}
	if org := r.GetString("org_id"); org != "" {
		out.OrgID = &org
	}
	return out
}

func deleteOrgIDs(r *core.Record) []string {
	out := []string{}
	_ = r.UnmarshalJSONField("delete_org_ids", &out)
	if out == nil {
		out = []string{}
	}
	return out
}

// status is handler.ts status (account_deletion_pending): the pending
// request, also while the permanent deletion runs (cancel then answers
// false), or null. It never cancels.
func status(e *core.RequestEvent, _ body) (any, error) {
	r, err := pendingRequest(e.App, e.Auth.Id)
	if err != nil {
		return nil, err
	}
	if r == nil {
		return StatusResponse{}, nil
	}
	j := requestJSON(r)
	return StatusResponse{Request: &j}, nil
}

// cancel is handler.ts cancel (account_deletion_cancel): the user chose to
// keep the account after signing in. Not once the permanent deletion has
// started. The hook clears the memberships' mark.
func cancel(e *core.RequestEvent, _ body) (any, error) {
	ok, err := Cancel(e.App, e.Auth.Id)
	if err != nil {
		return nil, err
	}
	return CancelResponse{Cancelled: ok}, nil
}

// Cancel cancels the user's pending request; false when there is none or
// its permanent deletion has started.
func Cancel(app core.App, userID string) (bool, error) {
	cancelled := false
	err := app.RunInTransaction(func(txApp core.App) error {
		r, err := pendingRequest(txApp, userID)
		if err != nil || r == nil || r.GetString("purge_started_at") != "" {
			return err
		}
		r.Set("status", StatusCancelled)
		r.Set("cancelled_at", pattern.FormatTimestamp(now()))
		if err := txApp.Save(r); err != nil {
			return err
		}
		cancelled = true
		return nil
	})
	return cancelled, err
}

func contains(list []string, s string) bool {
	for _, x := range list {
		if x == s {
			return true
		}
	}
	return false
}

func anys(list []string) []any {
	out := make([]any, len(list))
	for i, s := range list {
		out[i] = s
	}
	return out
}
