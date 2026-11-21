package plans

import (
	"database/sql"
	"errors"
	"slices"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// Entitlement is the RevenueCat entitlement that means Pro.
const Entitlement = "pro"

// Event is the part of a RevenueCat webhook event the server reads
// (https://www.revenuecat.com/docs/integrations/webhooks/event-types-and-fields).
type Event struct {
	ID                string   `json:"id"`
	Type              string   `json:"type"`
	AppUserID         string   `json:"app_user_id"`
	OriginalAppUserID string   `json:"original_app_user_id"`
	Aliases           []string `json:"aliases"`
	EntitlementIDs    []string `json:"entitlement_ids"`
	ProductID         string   `json:"product_id"`
	Store             string   `json:"store"`
	Environment       string   `json:"environment"`
	// ExpirationAtMs is when the paid period ends; null for a purchase
	// that does not expire.
	ExpirationAtMs   *int64   `json:"expiration_at_ms"`
	EventTimestampMs int64    `json:"event_timestamp_ms"`
	TransferredFrom  []string `json:"transferred_from"`
	TransferredTo    []string `json:"transferred_to"`
}

// Results of [Apply], logged and returned to RevenueCat.
const (
	ResultUpdated     = "updated"
	ResultIgnored     = "ignored"
	ResultStale       = "stale"
	ResultUnknownOrg  = "unknown_org"
	ResultTransferred = "transferred"
	ResultEntitlement = "other_entitlement"
)

// grantTypes keep (or start) Pro until the event's expiration. A
// cancellation or billing issue does not end the period early: the store
// sends EXPIRATION when it ends, and a refund comes with an expiration in
// the past.
var grantTypes = []string{
	"INITIAL_PURCHASE", "RENEWAL", "PRODUCT_CHANGE", "UNCANCELLATION",
	"NON_RENEWING_PURCHASE", "SUBSCRIPTION_EXTENDED",
	"TEMPORARY_ENTITLEMENT_GRANT", "CANCELLATION", "BILLING_ISSUE",
	"SUBSCRIPTION_PAUSED", "REFUND_REVERSED",
}

// Apply writes the event to org_subscriptions. Events for other
// entitlements, unknown types (TEST among them) and unknown organizations
// are ignored with a 2xx, so RevenueCat does not retry them; an event older
// than the row's last one is ignored as stale.
func Apply(app core.App, ev Event, now time.Time) (string, error) {
	if len(ev.EntitlementIDs) > 0 && !slices.Contains(ev.EntitlementIDs, Entitlement) {
		return ResultEntitlement, nil
	}
	switch {
	case ev.Type == "TRANSFER":
		return applyTransfer(app, ev, now)
	case ev.Type == "EXPIRATION":
		return write(app, ev, orgOf(ev), PlanFree, "", now)
	case slices.Contains(grantTypes, ev.Type):
		expires := ""
		if ev.ExpirationAtMs != nil {
			expires = pattern.FormatTimestamp(time.UnixMilli(*ev.ExpirationAtMs))
		}
		return write(app, ev, orgOf(ev), PlanPro, expires, now)
	}
	return ResultIgnored, nil
}

// orgOf is the organization id the event belongs to: the app logs in with
// the organization id, so it is app_user_id, or one of the aliases when
// RevenueCat merged an anonymous user into it.
func orgOf(ev Event) string {
	for _, id := range append([]string{ev.AppUserID, ev.OriginalAppUserID}, ev.Aliases...) {
		if pattern.IsUUID(id) {
			return id
		}
	}
	return ""
}

// applyTransfer moves the purchase: the organizations it came from go back
// to free, those it went to get the period of the first one that had it.
// The event carries no expiration.
func applyTransfer(app core.App, ev Event, now time.Time) (string, error) {
	err := app.RunInTransaction(func(tx core.App) error {
		var from *Subscription
		for _, id := range ev.TransferredFrom {
			if !pattern.IsUUID(id) {
				continue
			}
			if from == nil {
				sub, err := find(tx, id)
				if err != nil {
					return err
				}
				from = sub
			}
			if _, err := write(tx, ev, id, PlanFree, "", now); err != nil {
				return err
			}
		}
		if from == nil || from.Plan != PlanPro {
			return nil
		}
		for _, id := range ev.TransferredTo {
			if !pattern.IsUUID(id) {
				continue
			}
			if _, err := write(tx, ev, id, PlanPro, from.ExpiresAt, now); err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return "", err
	}
	return ResultTransferred, nil
}

// write upserts the organization's row unless the row has a newer event.
func write(app core.App, ev Event, orgID, plan, expiresAt string, now time.Time) (string, error) {
	if orgID == "" {
		return ResultUnknownOrg, nil
	}
	exists, err := orgExists(app, orgID)
	if err != nil {
		return "", err
	}
	if !exists {
		return ResultUnknownOrg, nil
	}
	collection, err := app.FindCachedCollectionByNameOrId(Collection)
	if err != nil {
		return "", err
	}
	record, err := app.FindFirstRecordByData(collection, "org_id", orgID)
	switch {
	case errors.Is(err, sql.ErrNoRows):
		record = core.NewRecord(collection)
		record.Id = ids.New()
		record.Set("org_id", orgID)
	case err != nil:
		return "", err
	case int64(record.GetInt("last_event_ms")) > ev.EventTimestampMs:
		return ResultStale, nil
	}
	record.Set("plan", plan)
	record.Set("expires_at", expiresAt)
	if ev.ProductID != "" {
		record.Set("product_id", ev.ProductID)
	}
	if ev.Store != "" {
		record.Set("store", ev.Store)
	}
	if ev.Environment != "" {
		record.Set("environment", ev.Environment)
	}
	record.Set("last_event_ms", max(ev.EventTimestampMs, 0))
	record.Set("updated_at", pattern.FormatTimestamp(now))
	if err := app.Save(record); err != nil {
		return "", err
	}
	return ResultUpdated, nil
}

// orgExists reports whether the organization was ever created; a deleted
// (deleted_at set) one counts, its row goes with the account deletion.
func orgExists(app core.App, orgID string) (bool, error) {
	var n int
	err := app.DB().
		Select("count(*)").
		From("organizations").
		Where(dbx.HashExp{"id": orgID}).
		Row(&n)
	return n > 0, err
}
