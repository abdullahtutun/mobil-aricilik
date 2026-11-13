// Package orgs founds an organization and finds the caller's current one
// (P5.4): the counterparts of Supabase's public.create_organization RPC
// (20261022190700, last changed in 20261112120000) and of the client's
// `organizations` query (lib/features/organization/data/
// organization_service.dart, fetchCurrent).
//
// Sync never creates an organization (push answers "forbidden"); this route
// is the only way in, and it writes the founder's owner membership in the
// same transaction.
package orgs

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"slices"
	"strings"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/dbx"
	validation "github.com/pocketbase/ozzo-validation/v4"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

// Routes.
const (
	CreateRoute = "/api/app/organizations"
	MineRoute   = "/api/app/organizations/mine"
)

// Error codes in the JSON body's data.code.
const (
	// CodeInvalid (400): the body is not an organization (create_organization's
	// 22023 empty name, 23514 check, 23502 not null and type errors).
	CodeInvalid = "invalid"
	// CodeConflict (409): the id belongs to someone else's organization
	// (create_organization's 23505).
	CodeConflict = "conflict"
)

// DefaultOperationType is create_organization's `operation_type default
// 'migratory'`, also used when the client sends null (coalesce).
const DefaultOperationType = "migratory"

// now is the clock; tests replace it.
var now = time.Now

// Register binds the two routes; both need a signed-in app user.
func Register(app core.App) {
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.POST(CreateRoute, handleCreate).Bind(apis.RequireAuth(auth.UsersCollection))
		se.Router.GET(MineRoute, handleMine).Bind(apis.RequireAuth(auth.UsersCollection))
		return se.Next()
	})
}

// Request is the body of POST [CreateRoute]: create_organization's
// parameters, by name.
type Request struct {
	ID             string
	Name           *string
	CountryCode    *string
	Currency       *string
	HiveCountRange *string
	OperationType  *string
}

// ErrInvalid and ErrConflict are the refusals of [Create].
var (
	ErrInvalid  = errors.New("invalid organization")
	ErrConflict = errors.New("this id belongs to another organization")
)

func handleCreate(e *core.RequestEvent) error {
	req, err := decodeRequest(e)
	if err != nil {
		return apiError(e, http.StatusBadRequest, CodeInvalid, err.Error())
	}
	org, err := Create(e.App, e.Auth.Id, req)
	switch {
	case errors.Is(err, ErrConflict):
		return apiError(e, http.StatusConflict, CodeConflict, "This id belongs to another organization.")
	case errors.Is(err, ErrInvalid):
		return apiError(e, http.StatusBadRequest, CodeInvalid, err.Error())
	case err != nil:
		return e.InternalServerError("", err)
	}
	row, err := appsync.RowJSON(org)
	if err != nil {
		return e.InternalServerError("", err)
	}
	return e.JSON(http.StatusOK, row)
}

// decodeRequest reads the body. Like a Postgres function call, a parameter
// of the wrong type or an unknown enum label fails the whole call, before
// the existing-id check; missing and null are the same.
func decodeRequest(e *core.RequestEvent) (Request, error) {
	var body map[string]json.RawMessage
	if err := json.NewDecoder(e.Request.Body).Decode(&body); err != nil || body == nil {
		return Request{}, errors.New("The body must be a JSON object.")
	}
	var req Request
	if json.Unmarshal(body["id"], &req.ID) != nil || !pattern.IsUUID(req.ID) {
		return Request{}, errors.New("id must be a lower-case UUID.")
	}
	for _, f := range []struct {
		key string
		dst **string
	}{
		{"name", &req.Name},
		{"country_code", &req.CountryCode},
		{"currency", &req.Currency},
		{"hive_count_range", &req.HiveCountRange},
		{"operation_type", &req.OperationType},
	} {
		raw, ok := body[f.key]
		if !ok || string(raw) == "null" {
			continue
		}
		var s string
		if json.Unmarshal(raw, &s) != nil {
			return Request{}, fmt.Errorf("%s must be a string.", f.key)
		}
		*f.dst = &s
	}
	if err := checkEnum(e.App, "hive_count_range", req.HiveCountRange); err != nil {
		return Request{}, err
	}
	if err := checkEnum(e.App, "operation_type", req.OperationType); err != nil {
		return Request{}, err
	}
	return req, nil
}

func checkEnum(app core.App, field string, value *string) error {
	if value == nil {
		return nil
	}
	c, err := app.FindCachedCollectionByNameOrId("organizations")
	if err != nil {
		return err
	}
	f, ok := c.Fields.GetByName(field).(*core.SelectField)
	if !ok || !slices.Contains(f.Values, *value) {
		return fmt.Errorf("%s: unknown value %q.", field, *value)
	}
	return nil
}

// Create is create_organization: it founds the organization in userID's
// name and makes them its owner, in one transaction, and returns the
// organization. An organization with req.ID already there is returned as it
// is when userID founded it (a retried request), [ErrConflict] otherwise.
// The name is trimmed of spaces (btrim) and must not be empty.
func Create(app core.App, userID string, req Request) (*core.Record, error) {
	var org *core.Record
	err := app.RunInTransaction(func(txApp core.App) error {
		existing, err := txApp.FindRecordById("organizations", req.ID)
		if err == nil {
			if existing.GetString("created_by") != userID {
				return ErrConflict
			}
			org = existing
			return nil
		}
		if !errors.Is(err, sql.ErrNoRows) {
			return err
		}

		// btrim without characters trims spaces only. A null name is the
		// not-null violation in Postgres.
		if req.Name == nil || strings.Trim(*req.Name, " ") == "" {
			return fmt.Errorf("%w: the name must not be empty", ErrInvalid)
		}
		operationType := DefaultOperationType
		if req.OperationType != nil {
			operationType = *req.OperationType
		}

		orgs, err := txApp.FindCachedCollectionByNameOrId("organizations")
		if err != nil {
			return err
		}
		stamp := pattern.FormatTimestamp(now())
		org = core.NewRecord(orgs)
		org.Id = req.ID
		org.Set("name", strings.Trim(*req.Name, " "))
		org.Set("country_code", deref(req.CountryCode))
		org.Set("currency", deref(req.Currency))
		org.Set("hive_count_range", deref(req.HiveCountRange))
		org.Set("operation_type", operationType)
		org.Set("created_by", userID)
		org.Set("created_at", stamp)
		org.Set("updated_at", stamp)
		if err := saveOrInvalid(txApp, org); err != nil {
			return err
		}

		memberships, err := txApp.FindCachedCollectionByNameOrId("memberships")
		if err != nil {
			return err
		}
		// Supabase gave this id gen_random_uuid() (v4, no uuidv7() in
		// Postgres 17); here it is UUIDv7 like every other id.
		owner := core.NewRecord(memberships)
		owner.Id = ids.New()
		owner.Set("org_id", org.Id)
		owner.Set("user_id", userID)
		owner.Set("role", string(authz.Owner))
		owner.Set("created_by", userID)
		owner.Set("created_at", stamp)
		owner.Set("updated_at", stamp)
		return txApp.Save(owner)
	})
	if err != nil {
		return nil, err
	}
	return org, nil
}

// saveOrInvalid saves r; a validation error (country_code pattern, required
// field) is the Postgres check violation, so [ErrInvalid].
func saveOrInvalid(app core.App, r *core.Record) error {
	err := app.Save(r)
	var verrs validation.Errors
	if errors.As(err, &verrs) {
		return fmt.Errorf("%w: %s", ErrInvalid, err.Error())
	}
	return err
}

func deref(s *string) string {
	if s == nil {
		return ""
	}
	return *s
}

func handleMine(e *core.RequestEvent) error {
	org, err := Current(e.App, e.Auth.Id)
	if err != nil {
		return e.InternalServerError("", err)
	}
	if org == nil {
		return e.JSON(http.StatusOK, nil)
	}
	row, err := appsync.RowJSON(org)
	if err != nil {
		return e.InternalServerError("", err)
	}
	return e.JSON(http.StatusOK, row)
}

// Current is the client's fetchCurrent query: of the organizations userID
// is a live member of (the select policy, private.is_member), the oldest
// one not deleted (`deleted_at is null order by created_at asc limit 1`);
// nil when there is none. Equal created_at values are ordered by id so the
// answer is stable.
func Current(app core.App, userID string) (*core.Record, error) {
	org := &core.Record{}
	err := app.RecordQuery("organizations").
		AndWhere(dbx.HashExp{"organizations.deleted_at": ""}).
		AndWhere(dbx.Exists(dbx.NewExp(
			"SELECT 1 FROM {{memberships}} m WHERE m.[[org_id]] = {{organizations}}.[[id]] AND m.[[user_id]] = {:user} AND m.[[deleted_at]] = ''",
			dbx.Params{"user": userID},
		))).
		OrderBy("organizations.created_at ASC", "organizations.id ASC").
		Limit(1).
		One(org)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return org, nil
}

func apiError(e *core.RequestEvent, status int, code, message string) error {
	return e.JSON(status, auth.ErrorBody{Status: status, Message: message, Data: auth.ErrorData{Code: code}})
}
