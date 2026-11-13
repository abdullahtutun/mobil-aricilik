package sync

import (
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"net/http"
	"strconv"
	"strings"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

// PullRoute is the pull endpoint of the sync contract (K-7):
//
//	GET /api/sync/pull?table=<name>&since_seq=<cursor>&page_size=<1..1000>
//	→ {"rows": [...], "next_seq": n, "has_more": bool}
//
// The counterpart of Supabase's public.sync_pull (20261023174000).
const PullRoute = "/api/sync/pull"

// MaxPageSize is the largest page_size a pull accepts.
const MaxPageSize = 1000

// Error codes in the JSON body's "data.code".
const (
	// CodeUnsupported: the table is not a synced collection ([Tables]).
	CodeUnsupported = "unsupported"
	// CodeInvalid: a query parameter is missing or out of range.
	CodeInvalid = "invalid"
)

// Page is the body of a pull answer. Rows are in server_seq order and carry
// the server's column names, server_seq included; deleted rows come with
// deleted_at set. NextSeq is the since_seq of the next call; HasMore false
// means the table is done for now.
type Page struct {
	Rows    []map[string]any `json:"rows"`
	NextSeq int64            `json:"next_seq"`
	HasMore bool             `json:"has_more"`
}

// ErrUnsupported is returned by [Pull] for a table outside [Tables].
var ErrUnsupported = errors.New("sync: table is not synced")

// RegisterPull binds GET [PullRoute]. Only a signed-in app user (users
// collection) may pull; superusers and anonymous callers get 401/403.
func RegisterPull(app core.App) {
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.GET(PullRoute, handlePull).Bind(apis.RequireAuth(auth.UsersCollection))
		return se.Next()
	})
}

func handlePull(e *core.RequestEvent) error {
	q := e.Request.URL.Query()
	table := q.Get("table")
	since, err := strconv.ParseInt(q.Get("since_seq"), 10, 64)
	if err != nil || since < 0 {
		return apiError(e, http.StatusBadRequest, CodeInvalid, "since_seq must be a whole number ≥ 0.")
	}
	size, err := strconv.Atoi(q.Get("page_size"))
	if err != nil || size < 1 || size > MaxPageSize {
		return apiError(e, http.StatusBadRequest, CodeInvalid, "page_size must be between 1 and 1000.")
	}

	page, err := Pull(e.App, e.Auth.Id, table, since, size)
	if errors.Is(err, ErrUnsupported) {
		return apiError(e, http.StatusBadRequest, CodeUnsupported, "This table cannot be pulled.")
	}
	if err != nil {
		return e.InternalServerError("", err)
	}
	return e.JSON(http.StatusOK, page)
}

// Pull returns the rows of table after since that userID may read, at most
// pageSize of them (callers keep it within 1..[MaxPageSize]).
//
// Who sees what is the select policy of authz.Policies: org tables give the
// rows of the organizations where the user holds one of the policy's read
// roles (finance tables: owner and partner only; worker and viewer get an
// empty page); organizations gives the organizations the user is a member
// of; memberships also gives the user's own rows in other organizations,
// removed ones included, so a removed member's device learns it; reference
// tables go to every signed-in user.
//
// The cursor needs no lookback (K-7). Supabase handed numbers out with
// nextval before commit, so a later number could become visible first, and
// sync_pull held the cursor 1000 numbers back. Here the number comes from the
// sync_meta counter, bumped inside the transaction that writes the row
// (seq.go), and SQLite has one writer: the transaction that took N commits
// before the one that takes N+1 starts. A reader that sees N+1 therefore sees
// every row up to N+1, and the cursor can move to the last row it returned.
//
// The cursor moves only to the last row returned; an empty page leaves it
// where it was. has_more is true only when a row exists after the page, so a
// last page that is exactly full answers false.
func Pull(app core.App, userID, table string, since int64, pageSize int) (Page, error) {
	empty := Page{Rows: []map[string]any{}, NextSeq: since}
	if _, ok := Lookup(table); !ok {
		return Page{}, fmt.Errorf("%w: %q", ErrUnsupported, table)
	}
	policy, err := authz.Lookup(table)
	if err != nil {
		return Page{}, err
	}
	collection, err := app.FindCachedCollectionByNameOrId(table)
	if err != nil {
		return Page{}, err
	}

	var orgs []string
	if policy.Scope != authz.ScopeAnyUser {
		if len(policy.Read) == 0 {
			// No select policy: no one reads. OrgIDsForUser would read
			// "no roles" as "any role".
			return empty, nil
		}
		orgs, err = authz.OrgIDsForUser(app, userID, policy.Read...)
		if err != nil {
			return Page{}, err
		}
	}

	ids, params, err := pageIDsQuery(table, policy.Scope, userID, orgs, since, pageSize+1)
	if err != nil {
		return Page{}, err
	}
	if ids == "" {
		return empty, nil
	}

	var records []*core.Record
	err = app.RecordQuery(collection).
		AndWhere(dbx.NewExp("[[id]] IN ("+ids+")", params)).
		OrderBy("[[" + FieldServerSeq + "]] ASC").
		All(&records)
	if err != nil {
		return Page{}, err
	}

	page := empty
	if len(records) > pageSize {
		page.HasMore = true
		records = records[:pageSize]
	}
	for _, r := range records {
		row, err := RowJSON(r)
		if err != nil {
			return Page{}, err
		}
		page.Rows = append(page.Rows, row)
	}
	if n := len(records); n > 0 {
		page.NextSeq = int64(records[n-1].GetInt(FieldServerSeq))
	}
	return page, nil
}

// pageIDsQuery returns a sub-select of the ids of the first limit rows after
// since that the scope lets the user see, and its parameters; "" means no
// row can match (no organization).
//
// For org tables each organization is its own branch that reads the
// `(org_id, server_seq)` index in order (INDEXED BY: the query fails rather
// than falls back to a scan) and stops after limit rows; the branches are
// merged and cut to limit. Rows of other organizations are never read, so
// they neither fill a page nor slow it down.
func pageIDsQuery(table string, scope authz.Scope, userID string, orgs []string, since int64, limit int) (string, dbx.Params, error) {
	params := dbx.Params{"since": since, "limit": limit}
	orgParams := make([]string, len(orgs))
	for i, org := range orgs {
		name := fmt.Sprintf("org%d", i)
		params[name] = org
		orgParams[i] = "{:" + name + "}"
	}

	var branches []string
	switch scope {
	case authz.ScopeAnyUser:
		branches = append(branches, branch(table, "", "1 = 1"))
	case authz.ScopeOrganization:
		if len(orgs) > 0 {
			branches = append(branches, branch(table, "", "[[id]] IN ("+strings.Join(orgParams, ", ")+")"))
		}
	case authz.ScopeOrg, authz.ScopeMembership:
		index := OrgSeqIndex(table)
		for _, p := range orgParams {
			branches = append(branches, branch(table, index, "[[org_id]] = "+p))
		}
		if scope == authz.ScopeMembership {
			// The user's own rows in organizations not listed above:
			// removed memberships ("user_id = auth.uid() or is_member").
			own := "[[user_id]] = {:user}"
			if len(orgParams) > 0 {
				own += " AND [[org_id]] NOT IN (" + strings.Join(orgParams, ", ") + ")"
			}
			params["user"] = userID
			branches = append(branches, branch(table, "", own))
		}
	default:
		return "", nil, fmt.Errorf("sync: table %q has scope %q, not pullable", table, scope)
	}
	if len(branches) == 0 {
		return "", nil, nil
	}
	return "SELECT [[id]] FROM (" + strings.Join(branches, " UNION ALL ") +
		" ORDER BY [[" + FieldServerSeq + "]] LIMIT {:limit})", params, nil
}

// branch is one ordered, limited read of table: the ids and numbers of the
// first {:limit} rows after {:since} that match where.
func branch(table, index, where string) string {
	from := "{{" + table + "}}"
	if index != "" {
		from += " INDEXED BY [[" + index + "]]"
	}
	return "SELECT * FROM (SELECT [[id]], [[" + FieldServerSeq + "]] FROM " + from +
		" WHERE " + where + " AND [[" + FieldServerSeq + "]] > {:since}" +
		" ORDER BY [[" + FieldServerSeq + "]] LIMIT {:limit})"
}

// OrgSeqIndex is the name of an org collection's `(org_id, server_seq)`
// index (migrations.syncedCollection).
func OrgSeqIndex(table string) string {
	return "idx_" + table + "_org_id_server_seq"
}

// RowJSON is a record as the app's pull expects it (lib/core/sync/
// sync_service.dart, _Row.parse): every field by its column name, and null
// where Supabase had null. PocketBase stores an empty optional text or
// select as "" and an unset JSON field as null; both go out as null (a
// required one is never empty). JSON fields go out as their JSON value,
// integer fields as integers.
func RowJSON(r *core.Record) (map[string]any, error) {
	row := map[string]any{}
	for _, f := range r.Collection().Fields {
		name := f.GetName()
		switch field := f.(type) {
		case *core.TextField, *core.SelectField:
			if s := r.GetString(name); s != "" {
				row[name] = s
			} else {
				row[name] = nil
			}
		case *core.JSONField:
			raw, _ := r.GetRaw(name).(interface{ String() string })
			text := ""
			if raw != nil {
				text = strings.TrimSpace(raw.String())
			}
			if text == "" || text == "null" {
				row[name] = nil
			} else {
				row[name] = json.RawMessage(text)
			}
		case *core.NumberField:
			v := r.GetFloat(name)
			if field.OnlyInt || (v == math.Trunc(v) && math.Abs(v) < 1<<53) {
				row[name] = int64(v)
			} else {
				row[name] = v
			}
		case *core.BoolField:
			row[name] = r.GetBool(name)
		default:
			return nil, fmt.Errorf("sync: %s.%s: field type %q has no pull mapping", r.Collection().Name, name, f.Type())
		}
	}
	return row, nil
}

// apiError is PocketBase's error body ({status, message, data}) with our
// code in data.code, like the auth routes.
func apiError(e *core.RequestEvent, status int, code, message string) error {
	return e.JSON(status, auth.ErrorBody{Status: status, Message: message, Data: auth.ErrorData{Code: code}})
}
