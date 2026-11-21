package migrations

import (
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// org_subscriptions (2026-11-21): an organization's paid plan, written only
// by the server (internal/plans: the RevenueCat webhook). It is not a sync
// table and not a column of organizations, because a client pushes its whole
// organizations row and could set its own plan. The app reads the plan
// through POST /api/app/plan.
//
// One row per organization; an organization without a row is on the free
// plan. expires_at is when the store says the paid period ends (K-5 text,
// empty for a purchase that does not expire). last_event_ms is the RevenueCat
// event time of the last write: webhooks can arrive out of order, and an
// older event never overwrites a newer one. API rules are nil.
func init() {
	m.Register(upOrgSubscriptions, downOrgSubscriptions)
}

// subscriptionPlans are the plan names; internal/plans uses the same.
var subscriptionPlans = []string{"free", "pro"}

func upOrgSubscriptions(app core.App) error {
	c := plainCollection("org_subscriptions",
		uuidField(fieldOrgID, true),
		selectField("plan", true, subscriptionPlans...),
		timeField("expires_at", false),
		// The store product (e.g. mobil_arici_pro_yearly), for support.
		&core.TextField{Name: "product_id", Max: 200},
		// RevenueCat's store name (PLAY_STORE, APP_STORE, …).
		&core.TextField{Name: "store", Max: 40},
		// PRODUCTION or SANDBOX.
		&core.TextField{Name: "environment", Max: 20},
		&core.NumberField{Name: "last_event_ms", OnlyInt: true, Min: types.Pointer(0.0)},
		timeField(fieldUpdatedAt, true),
	)
	c.AddIndex("idx_org_subscriptions_org_id", true, "`org_id`", "")
	// Like every UUID-keyed collection (1794300016_id_nocase_index.go).
	c.AddIndex(IDNocaseIndexName(c.Name), false, "`id` COLLATE NOCASE", "")
	return app.Save(c)
}

func downOrgSubscriptions(app core.App) error {
	c, err := app.FindCollectionByNameOrId("org_subscriptions")
	if err != nil {
		return err
	}
	return app.Delete(c)
}
