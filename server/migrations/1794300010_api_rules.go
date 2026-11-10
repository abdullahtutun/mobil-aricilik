package migrations

import (
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// The API rules of the collections the app reaches through PocketBase's
// record API (P3.2). Everything else keeps all five rules nil: only server
// code reads and writes it (K-7), and the sync routes ask internal/authz.
// File collections get their rules in P6.1. api_rules_test.go walks every
// collection and fails on any rule not listed there, and on any "" (public)
// rule.
//
// Each rule starts with `@request.auth.id != ""`: an anonymous request
// resolves @request.auth.id to "", which would otherwise match a row whose
// user_id is empty (a deletion request keeps its row with user_id emptied).
//
//   - users: a user lists and views only their own record. Create, update
//     and delete are nil: the OTP route opens the account (P4.1), the
//     locale route changes the language (P4.1), account deletion removes it
//     (P5.8–P5.9). Supabase: auth.users was not in the API.
//   - feedback: create only, by a signed-in user for an organization where
//     they hold a live membership, with created_by = themselves. Supabase
//     "Üyeler işletmeleri adına görüş bildirir" (20261027120000):
//     private.is_member(org_id) and created_by = auth.uid(). The three
//     membership conditions use one alias so they must hold on the same
//     memberships row. received_at is set by internal/recordapi.
//   - analytics_events: create only, any signed-in user. Supabase "Oturumlu
//     kullanıcılar kullanım olayı ekler" (20261027120000).
//   - deletion_requests: list and view own. Supabase "Kullanıcı kendi silme
//     talebini görür" (20261113120000); routes write (P5.8).
//   - device_tokens: list and view own. Supabase "Kullanıcı kendi
//     token'larını görür" (20261027160000); a route writes (P5.6).
func init() {
	m.Register(upAPIRules, downAPIRules)
}

const (
	ruleOwnRecord = `@request.auth.id != "" && id = @request.auth.id`
	ruleOwnUserID = `@request.auth.id != "" && user_id = @request.auth.id`
	ruleSignedIn  = `@request.auth.id != ""`
	ruleFeedback  = `@request.auth.id != "" && created_by = @request.auth.id && ` +
		`@collection.memberships:own.user_id ?= @request.auth.id && ` +
		`@collection.memberships:own.org_id ?= org_id && ` +
		`@collection.memberships:own.deleted_at ?= ""`
)

// apiRules are the five rules per collection; a missing rule is nil.
type apiRules struct {
	list, view, create, update, delete *string
}

func (r apiRules) apply(c *core.Collection) {
	c.ListRule, c.ViewRule, c.CreateRule = r.list, r.view, r.create
	c.UpdateRule, c.DeleteRule = r.update, r.delete
}

var openedRules = map[string]apiRules{
	"users": {
		list: types.Pointer(ruleOwnRecord),
		view: types.Pointer(ruleOwnRecord),
	},
	"feedback":          {create: types.Pointer(ruleFeedback)},
	"analytics_events":  {create: types.Pointer(ruleSignedIn)},
	"deletion_requests": {list: types.Pointer(ruleOwnUserID), view: types.Pointer(ruleOwnUserID)},
	"device_tokens":     {list: types.Pointer(ruleOwnUserID), view: types.Pointer(ruleOwnUserID)},
}

func upAPIRules(app core.App) error {
	for name, rules := range openedRules {
		c, err := app.FindCollectionByNameOrId(name)
		if err != nil {
			return err
		}
		rules.apply(c)
		if err := app.Save(c); err != nil {
			return err
		}
	}
	return nil
}

// downAPIRules closes the opened collections again; users gets back
// PocketBase's default rules (1640988000_init), which it had before.
func downAPIRules(app core.App) error {
	for name := range openedRules {
		c, err := app.FindCollectionByNameOrId(name)
		if err != nil {
			return err
		}
		rules := apiRules{}
		if name == "users" {
			own := "id = @request.auth.id"
			rules = apiRules{
				list:   types.Pointer(own),
				view:   types.Pointer(own),
				create: types.Pointer(""),
				update: types.Pointer(own),
				delete: types.Pointer(own),
			}
		}
		rules.apply(c)
		if err := app.Save(c); err != nil {
			return err
		}
	}
	return nil
}
