package migrations

import (
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

// organizations and memberships in their final Supabase shape. Each field
// names the Supabase migration that defined it (supabase/migrations/…).
// Checks a field option cannot express are in internal/validate:
// OrganizationsTrAksHiveCountCheck, OrganizationsLogoPathCheck.
func init() {
	m.Register(upOrganizationsMemberships, downOrganizationsMemberships)
}

// Postgres enums, labels verbatim.
var (
	// public.membership_role (20261021200110).
	membershipRoles = []string{"owner", "partner", "worker", "viewer"}
	// public.hive_count_range (20261022190700).
	hiveCountRanges = []string{"none", "up_to_10", "up_to_50", "up_to_200", "over_200"}
	// public.operation_type (20261112120000).
	operationTypes = []string{"migratory", "stationary"}
	// public.org_avatar_color (20261112120000).
	orgAvatarColors = []string{"pine", "honey", "sky", "slate"}
)

func upOrganizationsMemberships(app core.App) error {
	// The row is the organization, so there is no org_id; the common
	// fields come from 20261021200110.
	orgs := syncedCollectionWithoutOrg("organizations",
		// 20261021200110: name text not null.
		&core.TextField{Name: "name", Required: true},
		// 20261021200110: country_code ~ '^[A-Z]{2}$' (ISO 3166-1 alpha-2).
		&core.TextField{Name: "country_code", Required: true, Min: 2, Max: 2, Pattern: `^[A-Z]{2}$`},
		// 20261021200110: currency ~ '^[A-Z]{3}$' (ISO 4217).
		&core.TextField{Name: "currency", Required: true, Min: 3, Max: 3, Pattern: `^[A-Z]{3}$`},
		// 20261021200110: TR profile only, nullable.
		&core.TextField{Name: "tr_registration_no"},
		// 20261021200110: TR profile only, nullable.
		&core.TextField{Name: "tr_aks_no"},
		// 20261022190700: hive_count_range enum, nullable.
		selectField("hive_count_range", false, hiveCountRanges...),
		// 20261105120000: integer, null or 0..100000
		// (organizations_tr_aks_hive_count_check → validate).
		nullableNumberField("tr_aks_hive_count"),
		// 20261112120000: operation_type not null default 'migratory'.
		// No column default in PocketBase; the push sends it (the client
		// row always has it) and P5.4's create route sets it.
		selectField("operation_type", true, operationTypes...),
		// 20261112120000: org_avatar_color, nullable.
		selectField("avatar_color", false, orgAvatarColors...),
		// 20261112120000: `<id>/<uuid>.jpg` in org-logos, nullable. The shape
		// is checked here; that the folder is this row's id is
		// organizations_logo_path_check → validate.
		&core.TextField{Name: "logo_path", Max: 2*36 + len("/.jpg"), Pattern: `^[0-9a-f-]{36}/[0-9a-f-]{36}\.jpg$`},
	)
	if err := app.Save(orgs); err != nil {
		return err
	}

	members := syncedCollection("memberships",
		// 20261021200110: user_id not null. The auth.users FK was dropped
		// in 20261113120000 (a deleted account leaves a random id).
		uuidField("user_id", true),
		// 20261021200110: membership_role not null.
		selectField("role", true, membershipRoles...),
		// 20261115120000: deletion_scheduled_for timestamptz, nullable.
		timeField("deletion_scheduled_for", false),
		// 20261112120000 full_name: dropped in 20261116120000, not mirrored.
	)
	// 20261021200110 memberships_org_id_user_id_key: one live membership per
	// user and organization; a removed member can be added again.
	members.AddIndex("idx_memberships_org_id_user_id", true, "`org_id`, `user_id`", "`deleted_at` = ''")
	// 20261021200110 memberships_user_id_idx.
	members.AddIndex("idx_memberships_user_id", false, "`user_id`", "")
	return app.Save(members)
}

func downOrganizationsMemberships(app core.App) error {
	for _, name := range []string{"memberships", "organizations"} {
		c, err := app.FindCollectionByNameOrId(name)
		if err != nil {
			return err
		}
		if err := app.Delete(c); err != nil {
			return err
		}
	}
	return nil
}
