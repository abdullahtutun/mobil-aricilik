// Package plans is the free and Pro plans (2026-11-21): what an
// organization may use, the plan route the app reads and the RevenueCat
// webhook that records purchases.
//
// The plans are switched on with PLANS_ENABLED. While it is off (the
// default) every organization gets everything, whatever it bought: no hive
// limit, team use, every forecast day. When it is on, an organization
// without an active Pro subscription is on the free plan:
//
//   - at most [FreeHiveLimit] live hives. Only the app enforces this (it
//     stops adding new hives); the server never rejects a pushed hive, so a
//     hive written offline is never lost, and hives over the limit stay.
//   - no team: only the owner. Creating and redeeming invite codes is
//     refused with 403 plan_required (internal/team). Existing members stay.
//   - a [FreeForecastDays]-day forecast (internal/weather).
//
// Records are never locked or deleted because of the plan.
//
// The subscription belongs to the organization: the app logs in to
// RevenueCat with the organization id as app_user_id, and the webhook writes
// org_subscriptions. Only the server writes that collection.
package plans

import (
	"database/sql"
	"errors"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// Plan names, as org_subscriptions.plan.
const (
	PlanFree = "free"
	PlanPro  = "pro"
)

// Free plan limits.
const (
	FreeHiveLimit    = 30
	FreeForecastDays = 3
)

// Collection is the server-only subscription table.
const Collection = "org_subscriptions"

// CodePlanRequired (403) is the error code of a request the free plan does
// not allow.
const CodePlanRequired = "plan_required"

// Options configure the plans.
type Options struct {
	// Enabled is PLANS_ENABLED.
	Enabled bool
	// WebhookAuth is REVENUECAT_WEBHOOK_AUTH: the exact Authorization
	// header RevenueCat sends. Secret; never log it. Empty turns the
	// webhook off (503).
	WebhookAuth string
	// Now is the clock; time.Now when nil.
	Now func() time.Time
}

// storeKey keeps the options in the app store, so that the team and weather
// routes read them without new parameters. An app without them (tests of
// other packages) has the plans off.
const storeKey = "plans.options"

// Register stores the options and binds the plan route and the webhook.
func Register(app core.App, opts Options) {
	if opts.Now == nil {
		opts.Now = time.Now
	}
	app.Store().Set(storeKey, opts)
	registerRoutes(app, opts)
}

func options(app core.App) Options {
	opts, ok := app.Store().Get(storeKey).(Options)
	if !ok {
		return Options{Now: time.Now}
	}
	return opts
}

// Subscription is an organization's org_subscriptions row.
type Subscription struct {
	Plan      string
	ExpiresAt string
}

// Status is what an organization may use; the body of the plan route.
type Status struct {
	// PlansEnabled is PLANS_ENABLED.
	PlansEnabled bool `json:"plans_enabled"`
	// Plan is the organization's effective plan: "pro" while a Pro
	// subscription is active, else "free". Reported even while the plans
	// are off.
	Plan string `json:"plan"`
	// ExpiresAt is when the Pro period ends (K-5), empty when it does not
	// expire or the plan is free.
	ExpiresAt string `json:"expires_at"`
	// HiveLimit is the most live hives; null means no limit.
	HiveLimit *int `json:"hive_limit"`
	// Team is whether members other than the owner may be invited.
	Team bool `json:"team"`
	// ForecastDays is the most forecast days; null means all there are.
	ForecastDays *int `json:"forecast_days"`
}

// Resolve is the status of an organization with the given row (nil: no
// row) at now.
func Resolve(enabled bool, sub *Subscription, now time.Time) Status {
	st := Status{PlansEnabled: enabled, Plan: PlanFree}
	if sub != nil && sub.Plan == PlanPro && !expired(sub.ExpiresAt, now) {
		st.Plan = PlanPro
		st.ExpiresAt = sub.ExpiresAt
	}
	if !enabled || st.Plan == PlanPro {
		st.Team = true
		return st
	}
	hives, days := FreeHiveLimit, FreeForecastDays
	st.HiveLimit = &hives
	st.ForecastDays = &days
	return st
}

// expired reports whether a Pro period ending at expiresAt is over. Empty
// never expires; an unreadable time counts as over.
func expired(expiresAt string, now time.Time) bool {
	if expiresAt == "" {
		return false
	}
	t, err := time.Parse(pattern.TimestampLayout, expiresAt)
	return err != nil || !now.Before(t)
}

// Lookup is the organization's status now.
func Lookup(app core.App, orgID string) (Status, error) {
	opts := options(app)
	sub, err := find(app, orgID)
	if err != nil {
		return Status{}, err
	}
	return Resolve(opts.Enabled, sub, opts.Now()), nil
}

// find reads the organization's row; nil when it has none.
func find(app core.App, orgID string) (*Subscription, error) {
	var row struct {
		Plan      string `db:"plan"`
		ExpiresAt string `db:"expires_at"`
	}
	err := app.DB().
		Select("plan", "expires_at").
		From(Collection).
		Where(dbx.HashExp{"org_id": orgID}).
		Limit(1).
		One(&row)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return &Subscription{Plan: row.Plan, ExpiresAt: row.ExpiresAt}, nil
}
