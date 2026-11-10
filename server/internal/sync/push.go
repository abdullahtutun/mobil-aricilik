package sync

import (
	"bytes"
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"net/http"
	"strings"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/actor"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/validate"
	"github.com/pocketbase/dbx"
	validation "github.com/pocketbase/ozzo-validation/v4"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/types"
)

// PushRoute is the push endpoint of the sync contract (K-7):
//
//	POST /api/sync/push
//	{"changes": [{"id", "table", "operation", "payload"}], "client_time", "schema_version"}
//	→ {"results": [{"id", "status": "ok", "applied"} |
//	               {"id", "status": "rejected", "reason", "message"}],
//	   "server_time", "warning"}
//
// The counterpart of Supabase's public.sync_push and
// private.sync_push_change in their last state (20261112120000,
// 20261116120000). A result's "id" echoes the change's id (the client's
// outbox id); results come in the order of changes.
const PushRoute = "/api/sync/push"

// MaxPushChanges is the largest packet a push accepts.
const MaxPushChanges = 100

// MaxClockSkew: a client clock further than this from the server's gets a
// clock_skew warning (Supabase's max_clock_skew).
const MaxClockSkew = 5 * time.Minute

// Error codes of a refused push request (data.code), besides [CodeInvalid].
const (
	// CodeUpgradeRequired (HTTP 426): the schema_version is not in
	// [SupportedSchemaVersions]; nothing is written.
	CodeUpgradeRequired = "upgrade_required"
	// CodeUnavailable (HTTP 503): a transient database error; the whole
	// packet was rolled back and the client retries it.
	CodeUnavailable = "unavailable"
)

// Reasons of a rejected change: the sqlstate mapping of Supabase's
// sync_push.
const (
	// ReasonForbidden: the caller's role may not write the row (42501).
	ReasonForbidden = "forbidden"
	// ReasonConflict: a unique index refused the row (23505).
	ReasonConflict = "conflict"
	// ReasonMissingReference: a referenced row of the same organization is
	// missing (23503). Checked from P5.3 on.
	ReasonMissingReference = "missing_reference"
	// ReasonUnsupported: the table cannot be written by push (0A000).
	ReasonUnsupported = "unsupported"
	// ReasonInvalid: the change or a value is malformed (anything else).
	ReasonInvalid = "invalid"
)

// Result statuses.
const (
	StatusOK       = "ok"
	StatusRejected = "rejected"
)

// Result is the outcome of one change. Applied is set only for "ok": true
// when the row was written, false when the change was already in (same
// packet again, older updated_at, an event row that exists).
type Result struct {
	ID      json.RawMessage `json:"id"`
	Status  string          `json:"status"`
	Applied *bool           `json:"applied,omitempty"`
	Reason  string          `json:"reason,omitempty"`
	Message string          `json:"message,omitempty"`
}

// Warning is the optional warning of a push answer.
type Warning struct {
	Code        string `json:"code"`
	SkewSeconds int64  `json:"skew_seconds"`
}

// PushResponse is the body of a push answer. Warning is null when there is
// none, like Supabase's.
type PushResponse struct {
	Results    []Result `json:"results"`
	ServerTime string   `json:"server_time"`
	Warning    *Warning `json:"warning"`
}

type pushRequest struct {
	Changes       json.RawMessage `json:"changes"`
	ClientTime    json.RawMessage `json:"client_time"`
	SchemaVersion json.RawMessage `json:"schema_version"`
}

// RegisterPush binds POST [PushRoute]. Only a signed-in app user (users
// collection) may push; superusers and anonymous callers get 401/403.
func RegisterPush(app core.App) {
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.POST(PushRoute, handlePush).Bind(apis.RequireAuth(auth.UsersCollection))
		return se.Next()
	})
}

func handlePush(e *core.RequestEvent) error {
	var req pushRequest
	if err := json.NewDecoder(e.Request.Body).Decode(&req); err != nil {
		return apiError(e, http.StatusBadRequest, CodeInvalid, "The body must be a JSON object.")
	}
	var version int
	if err := json.Unmarshal(req.SchemaVersion, &version); err != nil || !SchemaVersionSupported(version) {
		return apiError(e, http.StatusUpgradeRequired, CodeUpgradeRequired, "Update the app: this schema version is not supported.")
	}
	var changes []json.RawMessage
	if !isJSON(req.Changes, '[') || json.Unmarshal(req.Changes, &changes) != nil {
		return apiError(e, http.StatusBadRequest, CodeInvalid, "changes must be an array.")
	}
	if len(changes) > MaxPushChanges {
		return apiError(e, http.StatusBadRequest, CodeInvalid, fmt.Sprintf("A push carries at most %d changes.", MaxPushChanges))
	}
	var clientText string
	if err := json.Unmarshal(req.ClientTime, &clientText); err != nil {
		return apiError(e, http.StatusBadRequest, CodeInvalid, "client_time must be a time.")
	}
	clientTime, err := time.Parse(time.RFC3339Nano, clientText)
	if err != nil {
		return apiError(e, http.StatusBadRequest, CodeInvalid, "client_time must be a time.")
	}

	results, err := Push(e.App, e.Auth.Id, changes)
	if err != nil {
		if IsTransient(err) {
			e.App.Logger().Warn("sync push rolled back", "error", err.Error())
			return apiError(e, http.StatusServiceUnavailable, CodeUnavailable, "The server is busy; send the changes again.")
		}
		return e.InternalServerError("", err)
	}

	now := time.Now()
	return e.JSON(http.StatusOK, PushResponse{
		Results:    results,
		ServerTime: pattern.FormatTimestamp(now),
		Warning:    ClockSkewWarning(clientTime, now),
	})
}

// ClockSkewWarning returns the clock_skew warning when client is more than
// [MaxClockSkew] away from now, else nil. skew_seconds is client − now,
// rounded: negative when the client is behind.
func ClockSkewWarning(client, now time.Time) *Warning {
	skew := int64(math.Round(client.Sub(now).Seconds()))
	if math.Abs(float64(skew)) <= MaxClockSkew.Seconds() {
		return nil
	}
	return &Warning{Code: "clock_skew", SkewSeconds: skew}
}

// Push writes changes for userID and returns one result per change, in
// order. All changes run in one transaction; each in its own savepoint, so a
// rejected change leaves no trace (server_seq included) and does not affect
// the others. An error means nothing was written: [IsTransient] tells
// whether the client should simply retry.
func Push(app core.App, userID string, changes []json.RawMessage) ([]Result, error) {
	results := make([]Result, 0, len(changes))
	err := app.RunInTransaction(func(txApp core.App) error {
		results = results[:0]
		for _, raw := range changes {
			r, err := pushInSavepoint(txApp, userID, raw)
			if err != nil {
				return err
			}
			results = append(results, r)
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return results, nil
}

const savepoint = "sync_push_change"

func pushInSavepoint(txApp core.App, userID string, raw json.RawMessage) (Result, error) {
	db := txApp.NonconcurrentDB()
	if _, err := db.NewQuery("SAVEPOINT " + savepoint).Execute(); err != nil {
		return Result{}, err
	}
	id, applied, err := pushChange(txApp, userID, raw)
	if id == nil {
		id = json.RawMessage("null")
	}

	var rej *rejection
	switch {
	case err == nil:
		if _, err := db.NewQuery("RELEASE " + savepoint).Execute(); err != nil {
			return Result{}, err
		}
		return Result{ID: id, Status: StatusOK, Applied: &applied}, nil
	case errors.As(err, &rej):
		if _, err := db.NewQuery("ROLLBACK TO " + savepoint).Execute(); err != nil {
			return Result{}, err
		}
		if _, err := db.NewQuery("RELEASE " + savepoint).Execute(); err != nil {
			return Result{}, err
		}
		return Result{ID: id, Status: StatusRejected, Reason: rej.reason, Message: rej.message}, nil
	default:
		return Result{}, err
	}
}

// rejection is a change the server refuses: it becomes a "rejected" result.
type rejection struct {
	reason  string
	message string
}

func (r *rejection) Error() string { return r.reason + ": " + r.message }

func reject(reason, format string, args ...any) error {
	return &rejection{reason: reason, message: fmt.Sprintf(format, args...)}
}

// change is one element of "changes", decoded leniently: a malformed change
// is rejected on its own (Supabase read it with ->> and got null).
type change struct {
	id        json.RawMessage
	table     string
	operation string
	payload   map[string]json.RawMessage
}

func decodeChange(raw json.RawMessage) (change, error) {
	var c change
	var fields map[string]json.RawMessage
	if !isJSON(raw, '{') || json.Unmarshal(raw, &fields) != nil {
		return c, reject(ReasonInvalid, "A change must be a JSON object.")
	}
	c.id = fields["id"]
	shapeErr := reject(ReasonInvalid, "A change needs table, operation (upsert or delete) and a payload object with id and updated_at.")
	if json.Unmarshal(fields["table"], &c.table) != nil || c.table == "" ||
		json.Unmarshal(fields["operation"], &c.operation) != nil ||
		(c.operation != "upsert" && c.operation != "delete") ||
		!isJSON(fields["payload"], '{') || json.Unmarshal(fields["payload"], &c.payload) != nil {
		return c, shapeErr
	}
	if isNull(c.payload["id"]) || isNull(c.payload["updated_at"]) {
		return c, shapeErr
	}
	return c, nil
}

// pushChange applies one change: private.sync_push_change. It returns the
// change's id (for the result), whether the row was written, and a
// *rejection or an unexpected error.
func pushChange(txApp core.App, userID string, raw json.RawMessage) (json.RawMessage, bool, error) {
	c, err := decodeChange(raw)
	if err != nil {
		return c.id, false, err
	}
	table, ok := Lookup(c.table)
	if !ok || table.Kind == KindReference {
		// Reference tables are never written by clients.
		return c.id, false, reject(ReasonUnsupported, "Table %q cannot be written by sync.", c.table)
	}
	if c.operation == "delete" && isNull(c.payload["deleted_at"]) {
		return c.id, false, reject(ReasonInvalid, "A delete must carry deleted_at.")
	}
	var applied bool
	switch table.Kind {
	case KindOwnMembership:
		applied, err = pushOwnMembership(txApp, userID, c.operation, c.payload)
	case KindOrganization:
		applied, err = pushOrganization(txApp, userID, c.payload)
	default:
		applied, err = applyRow(txApp, userID, table, c.payload)
	}
	return c.id, applied, err
}

// pushOwnMembership is private.set_own_member_name after 20261116120000:
// memberships are written only by the team routes (P5.4). An older app may
// still send the member's own name; the change is accepted and not applied
// when it is the caller's own live membership, forbidden otherwise. A
// membership is never deleted by sync.
func pushOwnMembership(txApp core.App, userID, operation string, payload map[string]json.RawMessage) (bool, error) {
	if operation != "upsert" {
		return false, reject(ReasonUnsupported, "Memberships are not deleted by sync.")
	}
	var id string
	if json.Unmarshal(payload["id"], &id) != nil || !pattern.IsUUID(id) {
		return false, reject(ReasonInvalid, "id must be a UUID.")
	}
	var own struct {
		ID string `db:"id"`
	}
	err := txApp.DB().Select("id").From("memberships").
		Where(dbx.HashExp{"id": id, "user_id": userID, "deleted_at": ""}).
		Limit(1).One(&own)
	if errors.Is(err, sql.ErrNoRows) {
		return false, reject(ReasonForbidden, "Only your own membership can be sent.")
	}
	if err != nil {
		return false, err
	}
	return false, nil
}

// pushOrganization is the organization branch of private.sync_push_change:
// an organization is created only by the create route (P5.4); push updates
// a visible one, for owners and partners, when updated_at is newer. Columns
// the payload lacks (an older app's: operation_type, avatar_color,
// logo_path) keep the stored value (existing_row || row_data).
func pushOrganization(txApp core.App, userID string, payload map[string]json.RawMessage) (bool, error) {
	collection, err := txApp.FindCachedCollectionByNameOrId("organizations")
	if err != nil {
		return false, err
	}
	var id string
	if json.Unmarshal(payload["id"], &id) != nil || !pattern.IsUUID(id) {
		return false, reject(ReasonInvalid, "id must be a UUID.")
	}
	values, err := decodeValues(collection, payload, true)
	if err != nil {
		return false, err
	}
	notFound := reject(ReasonForbidden, "No such organization, or you are not its member; an organization is created with create_organization.")
	existing, err := txApp.FindRecordById(collection, id)
	if errors.Is(err, sql.ErrNoRows) {
		return false, notFound
	}
	if err != nil {
		return false, err
	}
	visible, err := authz.CanSeeRow(txApp, "organizations", existing, userID)
	if err != nil {
		return false, err
	}
	if !visible {
		return false, notFound
	}
	updatedAt, _ := values["updated_at"].(string)
	if updatedAt <= existing.GetString("updated_at") {
		return false, nil
	}
	ok, err := authz.Can(txApp, userID, "organizations", id, authz.Update)
	if err != nil {
		return false, err
	}
	if !ok {
		return false, reject(ReasonForbidden, "Only owners and partners update the organization.")
	}
	for name, v := range values {
		if !keptOnUpdate[name] {
			existing.Set(name, v)
		}
	}
	if err := checkRow(txApp, "organizations", existing, false); err != nil {
		return false, err
	}
	return save(txApp, userID, existing)
}

// skipped are the columns push never takes from the payload: id is the
// row's key, created_by is always the caller, server_seq comes from the
// counter.
var skipped = map[string]bool{"id": true, "created_by": true, FieldServerSeq: true}

// keptOnUpdate are the columns a state update leaves as they are (with
// skipped): Supabase's set list excludes id, org_id, created_at, created_by
// and server_seq.
var keptOnUpdate = map[string]bool{"org_id": true, "created_at": true}

func applyRow(txApp core.App, userID string, table Table, payload map[string]json.RawMessage) (bool, error) {
	collection, err := txApp.FindCachedCollectionByNameOrId(table.Name)
	if err != nil {
		return false, err
	}
	var id string
	if json.Unmarshal(payload["id"], &id) != nil || !pattern.IsUUID(id) {
		return false, reject(ReasonInvalid, "id must be a UUID.")
	}
	values, err := decodeValues(collection, payload, false)
	if err != nil {
		return false, err
	}
	if table.Name == "apiaries" {
		// Supabase's sync_push_change checked this before building the
		// PostGIS point.
		if err := validate.ApiariesLocationCheck(rawJSON(payload["latitude"]), rawJSON(payload["longitude"])); err != nil {
			return false, reject(ReasonInvalid, "%s", err.Error())
		}
	}
	roundNumerics(table.Name, values)
	updatedAt, _ := values["updated_at"].(string)
	deletedAt, _ := values["deleted_at"].(string)
	orgID, _ := values["org_id"].(string)

	existing, err := txApp.FindRecordById(collection, id)
	if errors.Is(err, sql.ErrNoRows) {
		existing, err = nil, nil
	}
	if err != nil {
		return false, err
	}

	// The row as the payload proposes it: Supabase's insert tuple, which
	// the BEFORE INSERT triggers rewrote and the CHECKs saw before the
	// conflict with a stored row was known.
	candidate := core.NewRecord(collection)
	candidate.Id = id
	for name, v := range values {
		candidate.Set(name, v)
	}
	candidate.Set("created_by", userID)
	proposed := func() error {
		if err := guardRow(txApp, userID, table.Name, orgID, candidate, existing, payload); err != nil {
			return err
		}
		return checkRow(txApp, table.Name, candidate, true)
	}

	if existing == nil {
		if err := require(txApp, userID, table.Name, orgID, authz.Insert); err != nil {
			return false, err
		}
		if err := proposed(); err != nil {
			return false, err
		}
		if _, err := save(txApp, userID, candidate); err != nil {
			return false, err
		}
		// After the write, like Postgres' foreign key triggers: a unique
		// index conflict is reported first.
		return true, checkRefs(txApp, table.Name, candidate, nil)
	}

	// Supabase's upsert updates a row the caller cannot see (another
	// organization's) whatever its updated_at, and RLS refuses the update:
	// writing to another organization's row is forbidden even when the
	// change is older (the `not exists` fix of 20261108120000).
	visible, err := authz.CanSeeRow(txApp, table.Name, existing, userID)
	if err != nil {
		return false, err
	}
	if !visible {
		return false, reject(ReasonForbidden, "The row belongs to an organization you cannot write to.")
	}
	// Guards run in the stored row's organization (org_id never changes).
	orgID = existing.GetString("org_id")
	if err := proposed(); err != nil {
		return false, err
	}

	switch table.Kind {
	case KindState:
		// K-5: fixed-width UTC text, so text order is time order.
		if updatedAt <= existing.GetString("updated_at") {
			return false, nil
		}
		if err := require(txApp, userID, table.Name, orgID, authz.Update); err != nil {
			return false, err
		}
		before := map[string]string{}
		for _, ref := range refsOf(table.Name) {
			before[ref.Column] = existing.GetString(ref.Column)
		}
		for name := range values {
			if !keptOnUpdate[name] {
				// The candidate holds the guarded values.
				existing.Set(name, candidate.Get(name))
			}
		}
		// The CHECKs again on the updated row: org_id and created_at are
		// the stored ones.
		if err := checkRow(txApp, table.Name, existing, false); err != nil {
			return false, err
		}
		if _, err := save(txApp, userID, existing); err != nil {
			return false, err
		}
		return true, checkRefs(txApp, table.Name, existing, func(column string) bool {
			return existing.GetString(column) != before[column]
		})
	case KindEvent:
		// An event row is written once; only its deletion is recorded,
		// once.
		if existing.GetString("deleted_at") != "" || deletedAt == "" {
			return false, nil
		}
		if err := require(txApp, userID, table.Name, existing.GetString("org_id"), authz.Update); err != nil {
			return false, err
		}
		existing.Set("deleted_at", deletedAt)
		existing.Set("updated_at", updatedAt)
		return save(txApp, userID, existing)
	}
	return false, fmt.Errorf("sync: table %q has kind %q, not pushable", table.Name, table.Kind)
}

// require rejects with forbidden unless the user may do action in orgID.
func require(txApp core.App, userID, table, orgID string, action authz.Action) error {
	ok, err := authz.Can(txApp, userID, table, orgID, action)
	if err != nil {
		return err
	}
	if !ok {
		return reject(ReasonForbidden, "Your role cannot write this row in this organization.")
	}
	return nil
}

// save writes the record through the model hooks (server_seq, validation)
// and turns a refusal into a rejection.
func save(txApp core.App, userID string, record *core.Record) (bool, error) {
	// The pushing user is the actor: the task hook skips a notification
	// to oneself (notify, P5.6).
	if err := txApp.SaveWithContext(actor.With(context.Background(), userID), record); err != nil {
		return false, classifySaveError(err)
	}
	return true, nil
}

// classifySaveError maps a failed save to a rejection: a unique index is a
// conflict, any other validation or constraint failure is invalid. Other
// errors (I/O, busy) are returned as they are and roll the packet back.
func classifySaveError(err error) error {
	var verrs validation.Errors
	if errors.As(err, &verrs) {
		if hasCode(verrs, "validation_not_unique") {
			return reject(ReasonConflict, "%s", err.Error())
		}
		return reject(ReasonInvalid, "%s", err.Error())
	}
	msg := strings.ToLower(err.Error())
	switch {
	case strings.Contains(msg, "unique constraint failed"):
		return reject(ReasonConflict, "%s", err.Error())
	case strings.Contains(msg, "constraint failed"):
		return reject(ReasonInvalid, "%s", err.Error())
	}
	return err
}

// IsUniqueViolation reports whether a failed save broke a unique index; the
// team route retries a new invite code on it.
func IsUniqueViolation(err error) bool {
	var verrs validation.Errors
	if errors.As(err, &verrs) {
		return hasCode(verrs, "validation_not_unique")
	}
	return strings.Contains(strings.ToLower(err.Error()), "unique constraint failed")
}

func hasCode(errs validation.Errors, code string) bool {
	for _, e := range errs {
		switch v := e.(type) {
		case validation.Errors:
			if hasCode(v, code) {
				return true
			}
		case validation.Error:
			if v.Code() == code {
				return true
			}
		}
	}
	return false
}

// IsTransient reports whether err is a temporary database failure (busy,
// locked) after which the same packet can simply be sent again; the
// counterpart of the sqlstates Supabase's sync_push re-raised.
func IsTransient(err error) bool {
	if err == nil {
		return false
	}
	msg := strings.ToLower(err.Error())
	for _, s := range []string{"database is locked", "database table is locked", "sqlite_busy", "sqlite_locked"} {
		if strings.Contains(msg, s) {
			return true
		}
	}
	return false
}

// decodeValues reads the payload into the collection's column values, by
// column name. Keys that are not columns are ignored (an older app's
// payload; Supabase's jsonb_populate_record did the same), and a missing
// column counts as null, as there; with onlyPresent it is left out instead
// (organizations keep the stored value). id, created_by and server_seq are
// never taken from the payload.
func decodeValues(collection *core.Collection, payload map[string]json.RawMessage, onlyPresent bool) (map[string]any, error) {
	values := map[string]any{}
	for _, f := range collection.Fields {
		name := f.GetName()
		if skipped[name] {
			continue
		}
		raw, present := payload[name]
		if onlyPresent && !present {
			continue
		}
		v, err := decodeValue(f, raw)
		if err != nil {
			return nil, reject(ReasonInvalid, "%s: %s", name, err.Error())
		}
		values[name] = v
	}
	return values, nil
}

func decodeValue(f core.Field, raw json.RawMessage) (any, error) {
	null := isNull(raw)
	switch field := f.(type) {
	case *core.TextField:
		if null {
			return "", nil
		}
		var s string
		if json.Unmarshal(raw, &s) != nil {
			return nil, errors.New("must be a string or null")
		}
		if field.Pattern == pattern.Timestamp {
			return normalizeTimestamp(s)
		}
		return s, nil
	case *core.SelectField:
		if null {
			return "", nil
		}
		if field.IsMultiple() {
			var list []string
			if json.Unmarshal(raw, &list) != nil {
				return nil, errors.New("must be a list of strings or null")
			}
			return list, nil
		}
		var s string
		if json.Unmarshal(raw, &s) != nil {
			return nil, errors.New("must be a string or null")
		}
		return s, nil
	case *core.JSONField:
		if null {
			return nil, nil
		}
		return types.JSONRaw(bytes.Clone(raw)), nil
	case *core.NumberField:
		var v float64
		if null || json.Unmarshal(raw, &v) != nil {
			return nil, errors.New("must be a number")
		}
		return v, nil
	case *core.BoolField:
		// A missing boolean takes PocketBase's false. Supabase's columns
		// are `not null default false`; where an absent value must keep
		// the stored one (hives.quarantined) the table rule does it (P5.3).
		if null {
			return false, nil
		}
		var b bool
		if json.Unmarshal(raw, &b) != nil {
			return nil, errors.New("must be true, false or null")
		}
		return b, nil
	}
	return nil, fmt.Errorf("field type %q has no push mapping", f.Type())
}

// normalizeTimestamp writes any RFC 3339 time as a K-5 sync time (UTC,
// microseconds, fixed width), so that last-writer-wins can compare text.
// Supabase's timestamptz columns took any precision and offset; the app
// sends Dart's toIso8601String (milliseconds when the microseconds are 0).
func normalizeTimestamp(s string) (string, error) {
	t, err := time.Parse(time.RFC3339Nano, s)
	if err != nil {
		return "", fmt.Errorf("must be an RFC 3339 time, got %q", s)
	}
	if y := t.UTC().Year(); y < 1 || y > 9999 {
		return "", fmt.Errorf("year out of range in %q", s)
	}
	return pattern.FormatTimestamp(t), nil
}

func isNull(raw json.RawMessage) bool {
	t := bytes.TrimSpace(raw)
	return len(t) == 0 || bytes.Equal(t, []byte("null"))
}

func isJSON(raw json.RawMessage, first byte) bool {
	t := bytes.TrimSpace(raw)
	return len(t) > 0 && t[0] == first
}

func rawJSON(raw json.RawMessage) types.JSONRaw {
	if isNull(raw) {
		return nil
	}
	return types.JSONRaw(raw)
}
