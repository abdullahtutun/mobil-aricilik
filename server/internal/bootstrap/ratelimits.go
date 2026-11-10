package bootstrap

import (
	"log/slog"

	"github.com/pocketbase/pocketbase/core"
)

// rateLimitRules are PocketBase's built-in rate limiter rules (P3.2). The
// limiter counts per client IP (RequestEvent.RealIP) and per rule; a request
// takes the first matching rule, so a specific label wins over the `/api/`
// prefix. Superusers are never limited. Values and label syntax checked
// against v0.40.6: core/settings_model.go (RateLimitRule, its label regex and
// the conflicting-label check) and apis/middlewares_rate_limit.go (labels:
// "<collection>:<action>", "*:<action>", "<METHOD> <path>", "<path>").
//
// The app's own routes are matched by "<METHOD> <path>". The OTP and team
// routes come in P4.1 and P5.4; their rules are here so that they are
// limited from the first deploy. Mobile carriers share one IP among many
// phones (CGNAT), so the limits stop scripts, not a family on one network;
// the routes add their own per-e-mail (P4.1) and per-user (P5.4) limits.
var rateLimitRules = []core.RateLimitRule{
	// OTP code request, the app's route (P4.1): it also refuses the same
	// e-mail more often than once in 60 s.
	{Label: "POST /api/app/auth/otp", MaxRequests: 5, Duration: 60},
	// PocketBase's own request-otp; P4.1 decides whether the app uses it.
	{Label: "users:requestOTP", MaxRequests: 3, Duration: 60},
	// Entering the code: 6 digits; a few typos are fine, guessing is not.
	{Label: "users:authWithOTP", MaxRequests: 5, Duration: 60},
	// Invite code redemption (P5.4): 31^6 codes; the route also limits each
	// user to 10 a minute.
	{Label: "POST /api/app/team/redeem", MaxRequests: 10, Duration: 60},
	// Record API creates the app makes directly. Analytics events go one by
	// one after a long offline period; the client retries on 429.
	{Label: "feedback:create", MaxRequests: 10, Duration: 60},
	{Label: "analytics_events:create", MaxRequests: 120, Duration: 60},
	// PocketBase's defaults (core.NewSettings): password login (demo
	// account) and any other create; the batch API is off anyway.
	{Label: "*:auth", MaxRequests: 2, Duration: 3},
	{Label: "*:create", MaxRequests: 20, Duration: 5},
	{Label: "/api/batch", MaxRequests: 3, Duration: 1},
	// Everything else under /api/, sync and token refresh included.
	{Label: "/api/", MaxRequests: 300, Duration: 10},
}

// applyRateLimits turns the rate limiter on with [rateLimitRules] on every
// start, like the backup settings: the code is the source, not the
// dashboard. Excluded IPs stay as stored. If the settings do not validate,
// the stored ones stay and the error names the fields.
func applyRateLimits(app core.App, log *slog.Logger) {
	s, err := app.Settings().Clone()
	if err != nil {
		log.Error("Rate limits not applied", "error", err.Error())
		return
	}
	s.RateLimits.Enabled = true
	s.RateLimits.Rules = append([]core.RateLimitRule(nil), rateLimitRules...)

	if err := app.Save(s); err != nil {
		log.Error("Rate limits rejected; keeping the stored ones", "fields", invalidFields(err))
		return
	}
	log.Info("Rate limits applied", "rules", len(rateLimitRules))
}
