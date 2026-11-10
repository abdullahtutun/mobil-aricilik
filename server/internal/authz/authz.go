// Package authz is the Go counterpart of Supabase's row level security: the
// private.is_member / private.has_role helpers and, in policy.go, every
// table's read, insert and update roles. The sync routes (P5) and the other
// custom routes ask only this package who may do what (K-18).
//
// Every function takes the app it reads memberships from; inside a
// transaction pass the transaction's app so the answer sees its writes.
package authz

import (
	"database/sql"
	"errors"
	"slices"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// Role is a membership role: the values of Supabase's public.membership_role.
type Role string

// The four membership roles.
const (
	Owner   Role = "owner"
	Partner Role = "partner"
	Worker  Role = "worker"
	Viewer  Role = "viewer"
)

// Role sets the Supabase policies use.
var (
	// AllRoles is any live member: private.is_member.
	AllRoles = []Role{Owner, Partner, Worker, Viewer}
	// Writers is '{owner,partner,worker}': the ordinary data tables.
	Writers = []Role{Owner, Partner, Worker}
	// Managers is '{owner,partner}': finance, organizations, invites.
	Managers = []Role{Owner, Partner}
)

// role returns the user's role in the organization: the role of the live
// (deleted_at empty) membership. A user has at most one live membership per
// organization (idx_memberships_org_id_user_id). An empty user (not signed
// in) or organization has no role.
func role(app core.App, userID, orgID string) (Role, bool, error) {
	if userID == "" || orgID == "" {
		return "", false, nil
	}
	var row struct {
		Role string `db:"role"`
	}
	err := app.DB().
		Select("role").
		From("memberships").
		Where(dbx.HashExp{"user_id": userID, "org_id": orgID, "deleted_at": ""}).
		Limit(1).
		One(&row)
	if errors.Is(err, sql.ErrNoRows) {
		return "", false, nil
	}
	if err != nil {
		return "", false, err
	}
	return Role(row.Role), true, nil
}

// IsMember reports whether the user has a live membership in the
// organization: private.is_member(org_id). A removed member (deleted_at set)
// is not a member.
func IsMember(app core.App, userID, orgID string) (bool, error) {
	_, ok, err := role(app, userID, orgID)
	return ok, err
}

// HasRole reports whether the user's live membership in the organization has
// one of roles: private.has_role(org_id, roles). No roles means no one.
func HasRole(app core.App, userID, orgID string, roles ...Role) (bool, error) {
	r, ok, err := role(app, userID, orgID)
	if err != nil || !ok {
		return false, err
	}
	return slices.Contains(roles, r), nil
}

// OrgIDsForUser returns, sorted, the organizations in which the user has a
// live membership with one of roles; no roles means any role. The pull route
// filters org-scoped tables with it, passing the table's [Policy.Read].
func OrgIDsForUser(app core.App, userID string, roles ...Role) ([]string, error) {
	if userID == "" {
		return []string{}, nil
	}
	where := dbx.HashExp{"user_id": userID, "deleted_at": ""}
	if len(roles) > 0 {
		in := make([]any, len(roles))
		for i, r := range roles {
			in[i] = string(r)
		}
		where["role"] = in
	}
	ids := []string{}
	err := app.DB().
		Select("org_id").
		Distinct(true).
		From("memberships").
		Where(where).
		OrderBy("org_id").
		Column(&ids)
	if err != nil {
		return nil, err
	}
	return ids, nil
}
