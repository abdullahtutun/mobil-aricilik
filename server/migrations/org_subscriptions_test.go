package migrations

import (
	"testing"
)

func TestOrgSubscriptions(t *testing.T) {
	app := newApp(t)
	c, err := app.FindCollectionByNameOrId("org_subscriptions")
	if err != nil {
		t.Fatal(err)
	}
	want := fieldSpec{
		"id": "text!", "org_id": "text!", "plan": "select!", "expires_at": "text",
		"product_id": "text", "store": "text", "environment": "text",
		"last_event_ms": "number", "updated_at": "text!",
	}
	if got := describeFields(c); !mapsEqual(got, want) {
		t.Fatalf("fields = %v, want %v", got, want)
	}
	if c.ListRule != nil || c.ViewRule != nil || c.CreateRule != nil || c.UpdateRule != nil || c.DeleteRule != nil {
		t.Fatal("org_subscriptions has an open API rule")
	}
	if len(c.Indexes) != 2 {
		t.Fatalf("indexes = %v", c.Indexes)
	}

	// One row per organization.
	insert := "INSERT INTO org_subscriptions (id, org_id, plan, updated_at) VALUES ({:id}, {:org}, 'pro', {:t})"
	params := map[string]any{"id": "0195f2a4-c1c1-7000-8000-000000000001", "org": testOrg, "t": testTime}
	if _, err := app.DB().NewQuery(insert).Bind(params).Execute(); err != nil {
		t.Fatal(err)
	}
	params["id"] = "0195f2a4-c1c1-7000-8000-000000000002"
	if _, err := app.DB().NewQuery(insert).Bind(params).Execute(); err == nil {
		t.Fatal("second row for the same organization was accepted")
	}

	if err := downOrgSubscriptions(app); err != nil {
		t.Fatal(err)
	}
	if _, err := app.FindCollectionByNameOrId("org_subscriptions"); err == nil {
		t.Fatal("down kept org_subscriptions")
	}
	if err := upOrgSubscriptions(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
}
