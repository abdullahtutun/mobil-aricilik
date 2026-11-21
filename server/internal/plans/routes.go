package plans

import (
	"crypto/subtle"
	"encoding/json"
	"net/http"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

// Routes.
const (
	// PlanRoute is POST {org_id} → [Status], for members of the
	// organization.
	PlanRoute = "/api/app/plan"
	// WebhookRoute receives RevenueCat's events.
	WebhookRoute = "/api/app/billing/revenuecat"
)

// Error codes in the JSON body's data.code.
const (
	CodeBadRequest   = "bad_request"
	CodeForbidden    = "forbidden"
	CodeUnauthorized = "unauthorized"
	// CodeConfig (503): REVENUECAT_WEBHOOK_AUTH is not set.
	CodeConfig = "config"
)

func registerRoutes(app core.App, opts Options) {
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.POST(PlanRoute, handlePlan).Bind(apis.RequireAuth(auth.UsersCollection))
		se.Router.POST(WebhookRoute, opts.handleWebhook)
		return se.Next()
	})
}

func handlePlan(e *core.RequestEvent) error {
	var body struct {
		OrgID string `json:"org_id"`
	}
	if err := json.NewDecoder(e.Request.Body).Decode(&body); err != nil || !pattern.IsUUID(body.OrgID) {
		return apiError(e, http.StatusBadRequest, CodeBadRequest, "The request is not valid.")
	}
	member, err := authz.IsMember(e.App, e.Auth.Id, body.OrgID)
	if err != nil {
		return e.InternalServerError("", err)
	}
	if !member {
		return apiError(e, http.StatusForbidden, CodeForbidden, "You are not a member of this organization.")
	}
	st, err := Lookup(e.App, body.OrgID)
	if err != nil {
		return e.InternalServerError("", err)
	}
	return e.JSON(http.StatusOK, st)
}

func (o Options) handleWebhook(e *core.RequestEvent) error {
	if o.WebhookAuth == "" {
		e.App.Logger().Error("REVENUECAT_WEBHOOK_AUTH is not set; RevenueCat event refused")
		return apiError(e, http.StatusServiceUnavailable, CodeConfig, "Billing is not configured.")
	}
	got := e.Request.Header.Get("Authorization")
	if subtle.ConstantTimeCompare([]byte(got), []byte(o.WebhookAuth)) != 1 {
		return apiError(e, http.StatusUnauthorized, CodeUnauthorized, "Unauthorized.")
	}
	var body struct {
		Event *Event `json:"event"`
	}
	if err := json.NewDecoder(http.MaxBytesReader(e.Response, e.Request.Body, 1<<20)).Decode(&body); err != nil || body.Event == nil {
		return apiError(e, http.StatusBadRequest, CodeBadRequest, "The request is not valid.")
	}
	result, err := Apply(e.App, *body.Event, o.Now())
	if err != nil {
		// 5xx: RevenueCat retries the event later.
		return e.InternalServerError("", err)
	}
	e.App.Logger().Info("RevenueCat event", "type", body.Event.Type, "id", body.Event.ID, "result", result)
	return e.JSON(http.StatusOK, map[string]string{"result": result})
}

func apiError(e *core.RequestEvent, status int, code, message string) error {
	return e.JSON(status, auth.ErrorBody{Status: status, Message: message, Data: auth.ErrorData{Code: code}})
}
