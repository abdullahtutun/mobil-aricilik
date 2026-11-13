package migrations

import (
	"fmt"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/validate"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// The collections Supabase never synced: invites, device_tokens, feedback,
// analytics_events, weather_cache, deletion_requests and, from its private
// schema, deletion_log, deletion_codes and support_period_notifications.
// Each field names the Supabase migration that defined it
// (supabase/migrations/…): 20261026200000_weather,
// 20261027120000_feedback_analytics, 20261027140000_invites,
// 20261027160000_device_tokens_notify, 20261105120000_support_periods,
// 20261113120000_account_deletion and
// 20261115120000_deletion_code_and_leaving_member. 20261114120000 and
// 20261116120000 change only functions. Compared with the live project on
// 2026-11-10 (columns, CHECK names, unique keys).
//
// No server_seq, no sync registry entry, no PocketBase autodate fields
// except deletion_log.created. UUID id (K-4): tables keyed by another column
// in Supabase (weather_cache.cell, deletion_codes.user_id,
// support_period_notifications.period_id, deletion_log's bigint identity)
// get a UUIDv7 id and a unique index on that column. Times are K-5 text and
// have no column default (`default now()`): the server code that writes the
// row sets them. API rules are nil; P3.2 opens the ones the client reads
// directly.
//
// Checks a field option cannot express are in internal/validate:
// InvitesCheck, FeedbackMessageCheck, FeedbackDeviceInfoCheck,
// FeedbackCheck, AnalyticsEventsPropsCheck, DeletionRequestsCheck…Check3 and
// DeletionRequestsDeleteOrgIdsCheck. The protect_deletion_log trigger is
// internal/deletion.RegisterLogGuard.
func init() {
	m.Register(upUnsyncedCollections, downUnsyncedCollections)
}

var (
	// public.feedback_kind (20261027120000).
	feedbackKinds = []string{"bug", "suggestion", "missing_feature", "thanks"}
	// public.membership_role without owner: invites_role_check
	// (role <> 'owner'); the first owner founds the organization.
	inviteRoles = []string{"partner", "worker", "viewer"}
	// deletion_requests_kind_check, deletion_log_kind_check: text + CHECK in
	// Supabase, not an enum (20261113120000).
	deletionKinds = []string{"hesap", "hesap_ve_isletme"}
	// deletion_requests_channel_check, deletion_log_channel_check.
	deletionChannels = []string{"uygulama", "web"}
	// deletion_requests_status_check.
	deletionStatuses = []string{"bekliyor", "iptal", "tamamlandi"}
)

// unsyncedCollections lists this migration's collections, in creation
// order; down removes them in reverse.
var unsyncedCollections = []string{
	"invites", "device_tokens", "feedback", "analytics_events", "weather_cache",
	"deletion_requests", "deletion_log", "deletion_codes",
	"support_period_notifications",
}

// plainCollection is a server-only collection: UUID id (K-4), the given
// fields, all API rules nil.
func plainCollection(name string, fields ...core.Field) *core.Collection {
	c := core.NewBaseCollection(name)
	useUUIDPrimaryKey(c)
	c.Fields.Add(fields...)
	return c
}

// hashField is a hex SHA-256 digest (private.deletion_hash). Supabase has no
// CHECK; the server always writes 64 lower-case hex digits.
func hashField(name string, required bool) *core.TextField {
	return &core.TextField{Name: name, Required: required, Min: 64, Max: 64, Pattern: `^[0-9a-f]{64}$`}
}

func upUnsyncedCollections(app core.App) error {
	// All of invites comes from 20261027140000. The team routes
	// (internal/team, P5.4) create and redeem codes.
	invites := plainCollection("invites",
		// org_id uuid not null references organizations on delete cascade.
		uuidField(fieldOrgID, true),
		// code text not null check (code ~
		// '^[ABCDEFGHJKMNPQRSTUVWXYZ23456789]{6}$') (invites_code_check): no
		// 0/O, 1/I/L.
		&core.TextField{Name: "code", Required: true, Min: 6, Max: 6, Pattern: `^[ABCDEFGHJKMNPQRSTUVWXYZ23456789]{6}$`},
		// role membership_role not null check (role <> 'owner').
		selectField("role", true, inviteRoles...),
		// created_at timestamptz not null default now().
		timeField(fieldCreatedAt, true),
		// created_by uuid not null default auth.uid().
		uuidField(fieldCreatedBy, true),
		// expires_at timestamptz not null default now() + 48 hours.
		timeField("expires_at", true),
		// used_at timestamptz, used_by uuid; both set or both null
		// (invites_check → validate).
		timeField("used_at", false),
		uuidField("used_by", false),
	)
	// invites_code_key: the code is unique across organizations; the code
	// finds the organization.
	invites.AddIndex("idx_invites_code", true, "`code`", "")
	// invites_org_id_idx, invites_created_by_idx, invites_used_by_idx.
	invites.AddIndex("idx_invites_org_id", false, "`org_id`", "")
	invites.AddIndex("idx_invites_created_by", false, "`created_by`", "")
	invites.AddIndex("idx_invites_used_by", false, "`used_by`", "")
	if err := app.Save(invites); err != nil {
		return err
	}

	// device_tokens comes from 20261027160000; locale is new (decision
	// 2026-11-10): the device's language for the push text, falling back to
	// users.locale (P5.6).
	tokens := plainCollection("device_tokens",
		// user_id uuid not null references auth.users on delete cascade.
		uuidField("user_id", true),
		// token text not null check (char_length(token) between 1 and 4096)
		// (device_tokens_token_check).
		&core.TextField{Name: "token", Required: true, Min: 1, Max: 4096},
		// platform text not null check (platform in ('android', 'ios'))
		// (device_tokens_platform_check).
		selectField("platform", true, "android", "ios"),
		// New: one of the app languages, or empty.
		&core.TextField{Name: "locale", Max: 2, Pattern: localePattern},
		// created_at, updated_at timestamptz not null default now().
		timeField(fieldCreatedAt, true),
		timeField(fieldUpdatedAt, true),
	)
	// device_tokens_token_key, device_tokens_user_id_idx.
	tokens.AddIndex("idx_device_tokens_token", true, "`token`", "")
	tokens.AddIndex("idx_device_tokens_user_id", false, "`user_id`", "")
	if err := app.Save(tokens); err != nil {
		return err
	}

	// feedback comes from 20261027120000. The client inserts only; a second
	// send of the same id is a conflict the client counts as sent.
	feedback := plainCollection("feedback",
		// org_id uuid not null references organizations on delete cascade.
		uuidField(fieldOrgID, true),
		// kind feedback_kind not null.
		selectField("kind", true, feedbackKinds...),
		// message text not null check (char_length(btrim(message)) between 1
		// and 4000) (feedback_message_check → validate).
		&core.TextField{Name: "message", Required: true, Min: 1, Max: 4000},
		// screenshot_path text, nullable; exactly `<org_id>/<id>.jpg`
		// (feedback_check → validate.FeedbackCheck).
		&core.TextField{Name: "screenshot_path", Max: 2*36 + 1 + len(".jpg"), Pattern: validate.FeedbackScreenshotPath},
		// device_info jsonb, nullable; an object of at most 2048 bytes as
		// jsonb text (feedback_device_info_check → validate). The field
		// limit only stops oversized bodies early.
		&core.JSONField{Name: "device_info", MaxSize: 2 * validate.MaxFeedbackDeviceInfo},
		// created_at: written on the phone; received_at: arrival. Both
		// timestamptz not null default now().
		timeField(fieldCreatedAt, true),
		timeField("received_at", true),
		// created_by uuid default auth.uid(), on delete set null.
		uuidField(fieldCreatedBy, false),
	)
	// feedback_org_id_idx, feedback_created_by_idx.
	feedback.AddIndex("idx_feedback_org_id", false, "`org_id`", "")
	feedback.AddIndex("idx_feedback_created_by", false, "`created_by`", "")
	if err := app.Save(feedback); err != nil {
		return err
	}

	// analytics_events comes from 20261027120000: no user or organization,
	// only this install's random id.
	analytics := plainCollection("analytics_events",
		// install_id uuid not null.
		uuidField("install_id", true),
		// name text not null check (name ~ '^[a-z][a-z_]{0,39}$')
		// (analytics_events_name_check).
		&core.TextField{Name: "name", Required: true, Min: 1, Max: 40, Pattern: `^[a-z][a-z_]{0,39}$`},
		// props jsonb not null default '{}', an object of at most 1024 bytes
		// as jsonb text (analytics_events_props_check → validate). Not
		// Required: PocketBase's Required rejects `{}`.
		&core.JSONField{Name: "props", MaxSize: 2 * validate.MaxAnalyticsProps},
		// occurred_at timestamptz not null.
		timeField("occurred_at", true),
		// app_version text check (char_length(app_version) <= 32), nullable.
		&core.TextField{Name: "app_version", Max: 32},
		// platform text check (platform in ('android', 'ios', 'other')),
		// nullable.
		selectField("platform", false, "android", "ios", "other"),
		// received_at timestamptz not null default now().
		timeField("received_at", true),
	)
	// analytics_events_name_occurred_at_idx.
	analytics.AddIndex("idx_analytics_events_name_occurred_at", false, "`name`, `occurred_at`", "")
	if err := app.Save(analytics); err != nil {
		return err
	}

	// weather_cache comes from 20261026200000 (provider WeatherAPI since
	// 20261026230000, which only emptied the table).
	weather := plainCollection("weather_cache",
		// cell text primary key check (cell ~
		// '^-?\d{1,2}\.\d{2},-?\d{1,3}\.\d{2}$') (weather_cache_cell_check):
		// "lat,lon" with two decimals.
		&core.TextField{Name: "cell", Required: true, Min: 9, Max: 14, Pattern: `^-?[0-9]{1,2}\.[0-9]{2},-?[0-9]{1,3}\.[0-9]{2}$`},
		// forecast jsonb not null. A forecast bundle is a few tens of KiB.
		&core.JSONField{Name: "forecast", Required: true, MaxSize: 1 << 20},
		// fetched_at timestamptz not null default now().
		timeField("fetched_at", true),
	)
	// weather_cache_pkey (cell).
	weather.AddIndex("idx_weather_cache_cell", true, "`cell`", "")
	if err := app.Save(weather); err != nil {
		return err
	}

	// All of deletion_requests comes from 20261113120000.
	requests := plainCollection("deletion_requests",
		// user_id uuid references auth.users on delete set null.
		uuidField("user_id", false),
		// org_id uuid, nullable: the organization open in the app.
		uuidField(fieldOrgID, false),
		// kind text not null check (kind in (…)) (deletion_requests_kind_check).
		selectField("kind", true, deletionKinds...),
		// requested_at timestamptz not null default now().
		timeField("requested_at", true),
		// scheduled_for timestamptz not null; after requested_at
		// (deletion_requests_check → validate).
		timeField("scheduled_for", true),
		// channel text not null check (channel in (…)).
		selectField("channel", true, deletionChannels...),
		// status text not null default 'bekliyor' check (status in (…)). No
		// column default: the request route sets it (P5.8).
		selectField("status", true, deletionStatuses...),
		// delete_org_ids uuid[] not null default '{}': a JSON array of UUIDs;
		// non-empty exactly for hesap_ve_isletme (deletion_requests_check3 →
		// validate).
		&core.JSONField{Name: "delete_org_ids", MaxSize: 64 << 10},
		// user_hash text not null, email_hash text: hex SHA-256.
		hashField("user_hash", true),
		hashField("email_hash", false),
		// storage_prefixes jsonb, nullable: [{bucket, prefix}].
		&core.JSONField{Name: "storage_prefixes", MaxSize: 1 << 20},
		// purge_started_at, cancelled_at, completed_at timestamptz. Status
		// iptal exactly with cancelled_at, tamamlandi exactly with
		// completed_at (deletion_requests_check1, _check2 → validate).
		timeField("purge_started_at", false),
		timeField("cancelled_at", false),
		timeField("completed_at", false),
	)
	// deletion_requests_pending_user_key: at most one pending request per
	// user. Postgres skips null user_id in a unique index; PocketBase stores
	// it as '', hence the extra condition.
	requests.AddIndex("idx_deletion_requests_pending_user", true, "`user_id`", "`status` = 'bekliyor' AND `user_id` != ''")
	// deletion_requests_due_idx, deletion_requests_user_id_idx,
	// deletion_requests_email_hash_idx.
	requests.AddIndex("idx_deletion_requests_due", false, "`scheduled_for`", "`status` = 'bekliyor'")
	requests.AddIndex("idx_deletion_requests_user_id", false, "`user_id`, `requested_at`", "")
	requests.AddIndex("idx_deletion_requests_email_hash", false, "`email_hash`, `requested_at`", "")
	if err := app.Save(requests); err != nil {
		return err
	}

	// private.deletion_log comes from 20261113120000: no name, e-mail or
	// phone. completed_at (default now()) is PocketBase's `created` here
	// (decision 2026-11-10); the 3-year guard counts from it.
	log := plainCollection("deletion_log",
		// request_id uuid not null unique.
		uuidField("request_id", true),
		// user_hash text not null.
		hashField("user_hash", true),
		// kind, channel text not null check (… in (…)).
		selectField("kind", true, deletionKinds...),
		selectField("channel", true, deletionChannels...),
		// requested_at timestamptz not null.
		timeField("requested_at", true),
		// completed_at timestamptz not null default now() → created.
		&core.AutodateField{Name: "created", OnCreate: true},
	)
	// deletion_log_request_id_key.
	log.AddIndex("idx_deletion_log_request_id", true, "`request_id`", "")
	if err := app.Save(log); err != nil {
		return err
	}

	// private.deletion_codes comes from 20261115120000: one code per user,
	// stored as a digest.
	codes := plainCollection("deletion_codes",
		// user_id uuid primary key references auth.users on delete cascade.
		uuidField("user_id", true),
		// code_hash text not null: deletion_hash(user_id || ':' || code).
		hashField("code_hash", true),
		// expires_at timestamptz not null.
		timeField("expires_at", true),
		// attempts integer not null default 0. Not Required: 0 is valid.
		&core.NumberField{Name: "attempts", OnlyInt: true, Min: types.Pointer(0.0)},
		// verified_at timestamptz.
		timeField("verified_at", false),
		// sent_at, window_started_at timestamptz not null default now().
		timeField("sent_at", true),
		timeField("window_started_at", true),
		// sent_in_window integer not null default 1.
		&core.NumberField{Name: "sent_in_window", OnlyInt: true, Min: types.Pointer(0.0)},
	)
	// deletion_codes_pkey (user_id).
	codes.AddIndex("idx_deletion_codes_user_id", true, "`user_id`", "")
	if err := app.Save(codes); err != nil {
		return err
	}

	// private.support_period_notifications comes from 20261105120000: the
	// periods already announced (notify-support-periods, P5.6).
	notifications := plainCollection("support_period_notifications",
		// period_id uuid primary key references ref_support_periods on
		// delete cascade (not a relation, like every other link).
		uuidField("period_id", true),
		// notified_at timestamptz not null default now().
		timeField("notified_at", true),
	)
	// support_period_notifications_pkey (period_id).
	notifications.AddIndex("idx_support_period_notifications_period_id", true, "`period_id`", "")
	return app.Save(notifications)
}

// downUnsyncedCollections drops the collections. It refuses while
// deletion_log has rows: dropping the table would bypass the 3-year guard
// (the deletion records are kept by law).
func downUnsyncedCollections(app core.App) error {
	n, err := app.CountRecords("deletion_log")
	if err != nil {
		return err
	}
	if n > 0 {
		return fmt.Errorf("deletion_log has %d records kept for 3 years; not dropping it", n)
	}
	for i := len(unsyncedCollections) - 1; i >= 0; i-- {
		c, err := app.FindCollectionByNameOrId(unsyncedCollections[i])
		if err != nil {
			return err
		}
		if err := app.Delete(c); err != nil {
			return err
		}
	}
	return nil
}
