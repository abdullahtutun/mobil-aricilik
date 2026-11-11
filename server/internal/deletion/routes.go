package deletion

import (
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"net/mail"
	"strings"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/mailer"
)

// RoutePrefix is followed by the action: POST /api/app/account-deletion/
// {send_code|verify_code|request|cancel|status}. The actions are the user
// actions of supabase/functions/account-delete (handler.ts) with the same
// bodies minus "action", the same answers and the same HTTP statuses; the
// error body is the one of the other app routes, {status, message, data:
// {code}}, data.code being handler.ts's "error". The permanent deletion
// (purge_due) is P5.9's cron, not a route.
const RoutePrefix = "/api/app/account-deletion/"

// Error codes (data.code), as handler.ts's "error".
const (
	CodeBadRequest            = "bad_request"
	CodeCodeRequired          = "code_required"
	CodeInvalidCode           = "invalid_code"
	CodeTooManyAttempts       = "too_many_attempts"
	CodeRateLimited           = "rate_limited"
	CodeForbidden             = "forbidden"
	CodeOwnerMustTransfer     = "owner_must_transfer"
	CodeInvalidTransferTarget = "invalid_transfer_target"
	CodeMailFailed            = "mail_failed"
	CodeMailUnavailable       = "mail_unavailable"
	CodeServer                = "server"
)

// failure is a refused request: its HTTP status and code. orgIDs is set for
// owner_must_transfer.
type failure struct {
	status  int
	code    string
	message string
	orgIDs  []string
}

func (f *failure) Error() string { return f.code + ": " + f.message }

func fail(status int, code, message string) *failure {
	return &failure{status: status, code: code, message: message}
}

// The refusals; the SQL error codes of the Supabase functions they replace
// are in parentheses.
var (
	// 22023, and handler.ts's own input checks.
	errBadRequest   = fail(http.StatusBadRequest, CodeBadRequest, "The request is not valid.")
	errCodeRequired = fail(http.StatusForbidden, CodeCodeRequired, "Confirm the deletion with the code sent by e-mail first.")
	errInvalidCode  = fail(http.StatusBadRequest, CodeInvalidCode, "The code is not valid.")
	errTooMany      = fail(http.StatusTooManyRequests, CodeTooManyAttempts, "Too many wrong codes; ask for a new one.")
	// DL429.
	errRateLimited = fail(http.StatusTooManyRequests, CodeRateLimited, "Too many requests; please try again later.")
	// 42501.
	errForbidden = fail(http.StatusForbidden, CodeForbidden, "You may not do this in this organization.")
	// DL422.
	errInvalidTransferTarget = fail(http.StatusUnprocessableEntity, CodeInvalidTransferTarget, "Ownership can only go to an active partner of the organization.")
	errMailFailed            = fail(http.StatusBadGateway, CodeMailFailed, "The code could not be sent. Please try again later.")
	errMailUnavailable       = fail(http.StatusServiceUnavailable, CodeMailUnavailable, "E-mail is not available. Please try again later.")
)

// errOwnerMustTransfer is DL409: the user owns organizations with a team.
func errOwnerMustTransfer(orgIDs []string) *failure {
	f := *fail(http.StatusConflict, CodeOwnerMustTransfer,
		"You own an organization with a team: transfer the ownership or delete the organization first.")
	f.orgIDs = orgIDs
	return &f
}

// ErrorBody is the JSON of a refused request.
type ErrorBody struct {
	Status  int       `json:"status"`
	Message string    `json:"message"`
	Data    ErrorData `json:"data"`
}

// ErrorData carries the code and, for owner_must_transfer, the
// organizations (handler.ts's org_ids).
type ErrorData struct {
	Code   string   `json:"code"`
	OrgIDs []string `json:"org_ids,omitempty"`
}

// body is the request's JSON object.
type body map[string]json.RawMessage

type action func(e *core.RequestEvent, b body) (any, error)

// Register binds the routes and the memberships mark of a pending request
// (sync_member_deletion_schedule) together with the checks of
// deletion_requests. mailOn is the e-mail gate of internal/auth.
func Register(app core.App, mailOn auth.MailOn) {
	registerRequestHooks(app)

	actions := map[string]action{
		"send_code": func(e *core.RequestEvent, _ body) (any, error) {
			// Like the OTP route: without SMTP no code is written (outside
			// --dev, where the e-mail goes to the log).
			if !mailOn() && !e.App.IsDev() {
				return nil, errMailUnavailable
			}
			return sendCode(e)
		},
		"verify_code": verifyCode,
		"request":     requestDeletion,
		"status":      status,
		"cancel":      cancel,
	}
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.POST(RoutePrefix+"{action}", func(e *core.RequestEvent) error {
			act, ok := actions[e.Request.PathValue("action")]
			if !ok {
				// handler.ts: an unknown action (purge_due too) is 400.
				return apiError(e, errBadRequest)
			}
			b, ok := readBody(e)
			if !ok {
				return apiError(e, errBadRequest)
			}
			out, err := act(e, b)
			var f *failure
			switch {
			case errors.As(err, &f):
				return apiError(e, f)
			case err != nil:
				e.App.Logger().Error("account deletion route failed", "path", e.Request.URL.Path, "error", err)
				return apiError(e, fail(http.StatusInternalServerError, CodeServer, "Something went wrong; try again."))
			}
			return e.JSON(http.StatusOK, out)
		}).Bind(apis.RequireAuth(auth.UsersCollection))
		return se.Next()
	})
}

// readBody reads a JSON object; an empty body or null is {} (status, cancel
// and send_code need nothing). Anything else is bad_request.
func readBody(e *core.RequestEvent) (body, bool) {
	var raw json.RawMessage
	if err := json.NewDecoder(e.Request.Body).Decode(&raw); err != nil {
		if errors.Is(err, io.EOF) {
			return body{}, true
		}
		return nil, false
	}
	var b body
	if json.Unmarshal(raw, &b) != nil {
		return nil, false
	}
	if b == nil {
		b = body{}
	}
	return b, true
}

func apiError(e *core.RequestEvent, f *failure) error {
	return e.JSON(f.status, ErrorBody{
		Status:  f.status,
		Message: f.message,
		Data:    ErrorData{Code: f.code, OrgIDs: f.orgIDs},
	})
}

// isNull reports whether the key is missing or JSON null (handler.ts's
// `body.x ?? default`).
func isNull(b body, key string) bool {
	raw, ok := b[key]
	return !ok || strings.TrimSpace(string(raw)) == "null"
}

// sendMail sends a plain-text e-mail from the noreply mailbox (the sender of
// the PocketBase settings, written from MAIL_NOREPLY_USER by P4.2). Every
// mail goes through the gate of internal/auth.
func sendMail(app core.App, to string, m Mail) error {
	meta := app.Settings().Meta
	return app.NewMailClient().Send(&mailer.Message{
		From:    mail.Address{Name: meta.SenderName, Address: meta.SenderAddress},
		To:      []mail.Address{{Address: to}},
		Subject: m.Subject,
		Text:    m.Text,
	})
}
