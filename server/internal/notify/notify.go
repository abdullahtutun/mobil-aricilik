// Package notify is push notifications (P5.6): the Go port of the
// device-token and notify Edge Functions, of the notify_task_assigned
// trigger (20261027160000_device_tokens_notify) and of the
// notify-support-periods pg_cron job (20261105120000_support_periods).
//
//   - POST /api/app/device-token {action: register|unregister, token,
//     platform, locale}: the caller's FCM token. A token belongs to one
//     user; registering it moves it to the caller (another user signed in
//     on the same phone). locale is the device's language, preferred over
//     users.locale for the push text.
//   - Task hook: when a task is created, or its assigned_to changes, with an
//     assignee who is not the writer, the assignee's phones get a push,
//     data.task_id opening the task. It runs after the transaction commits
//     (OnRecordAfter*Success fire only then, and not on rollback), in the
//     background: the write never waits for FCM and a failure never undoes
//     it.
//   - Cron notify-support-periods: a support application period that has
//     started and not ended (Turkish date) and was never announced is sent,
//     once, to the owners and partners of the TR organizations.
//
// Without FCM_SERVICE_ACCOUNT_B64 every send is skipped silently; the route
// still records tokens and the cron leaves periods unannounced, so they go
// out on the first run after the variable is set.
package notify

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"
	"sync"
	"time"
	_ "time/tzdata" // Europe/Istanbul without the image's zoneinfo.

	"github.com/abdullahtutun/mobil-aricilik/server/internal/actor"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/fcm"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

const (
	// Route is the device token route.
	Route = "/api/app/device-token"

	// CronJob is the support period job's id, shown under Settings →
	// Crons.
	CronJob = "notify-support-periods"
	// CronSchedule is Supabase's '0 6 * * *' (06:00 UTC, 09:00 in
	// Turkey). PocketBase v0.40.6's app cron ticks in UTC: tools/cron.New()
	// sets time.UTC and nothing in PocketBase calls SetTimezone, so the
	// expression needs no shift.
	CronSchedule = "0 6 * * *"

	// CodeBadRequest (400) and CodeServer (500) are device-token's error
	// codes, in the body's data.code.
	CodeBadRequest = "bad_request"
	CodeServer     = "server"

	maxTokenLength = 4096
	tokens         = "device_tokens"
)

// Data types the app reads from data.type.
const (
	TypeTask          = "task"
	TypeSupportPeriod = "support_period"
)

// turkey is the zone of the support period dates
// (notify_support_periods: now() at time zone 'Europe/Istanbul').
var turkey = func() *time.Location {
	if loc, err := time.LoadLocation("Europe/Istanbul"); err == nil {
		return loc
	}
	return time.FixedZone("+03", 3*60*60)
}()

// Options configure the notifier.
type Options struct {
	// FCM sends; nil turns sending off (FCM_SERVICE_ACCOUNT_B64 unset).
	FCM *fcm.Client
	// Logger receives send errors; the app logger when nil.
	Logger *slog.Logger
	// Now is the clock; time.Now when nil.
	Now func() time.Time
}

// Notifier holds the options and the background sends in flight.
type Notifier struct {
	opts Options
	wg   sync.WaitGroup
}

// Register binds the route, the task hooks and the cron job.
func Register(app core.App, opts Options) *Notifier {
	if opts.Now == nil {
		opts.Now = time.Now
	}
	n := &Notifier{opts: opts}

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.POST(Route, n.handleDeviceToken).Bind(apis.RequireAuth(auth.UsersCollection))
		return se.Next()
	})

	app.OnRecordAfterCreateSuccess("tasks").BindFunc(func(e *core.RecordEvent) error {
		n.onTask(e, false)
		return e.Next()
	})
	app.OnRecordAfterUpdateSuccess("tasks").BindFunc(func(e *core.RecordEvent) error {
		n.onTask(e, true)
		return e.Next()
	})

	app.Cron().MustAdd(CronJob, CronSchedule, func() {
		if _, err := n.NotifySupportPeriods(context.Background(), app); err != nil {
			n.logger(app).Error("notify-support-periods failed", "error", err)
		}
	})
	return n
}

// Wait blocks until the background sends started so far are done. Tests
// and shutdown use it.
func (n *Notifier) Wait() { n.wg.Wait() }

func (n *Notifier) logger(app core.App) *slog.Logger {
	if n.opts.Logger != nil {
		return n.opts.Logger
	}
	return app.Logger()
}

// ---------------------------------------------------------------------------
// Device tokens
// ---------------------------------------------------------------------------

// deviceTokenBody is the request; Locale is optional.
type deviceTokenBody struct {
	Action   string  `json:"action"`
	Token    string  `json:"token"`
	Platform string  `json:"platform"`
	Locale   *string `json:"locale"`
}

// OK is the success body, as the Edge Function's.
type OK struct {
	OK bool `json:"ok"`
}

func (n *Notifier) handleDeviceToken(e *core.RequestEvent) error {
	var body deviceTokenBody
	if err := json.NewDecoder(http.MaxBytesReader(e.Response, e.Request.Body, 64<<10)).Decode(&body); err != nil {
		return apiError(e, http.StatusBadRequest, CodeBadRequest, "The body is not valid JSON.")
	}
	if body.Token == "" || len([]rune(body.Token)) > maxTokenLength {
		return apiError(e, http.StatusBadRequest, CodeBadRequest, "token must be 1 to 4096 characters.")
	}
	userID := e.Auth.Id

	switch body.Action {
	case "register":
		if body.Platform != "android" && body.Platform != "ios" {
			return apiError(e, http.StatusBadRequest, CodeBadRequest, "platform must be android or ios.")
		}
		if err := RegisterToken(e.App, userID, body.Token, body.Platform, body.Locale, n.opts.Now()); err != nil {
			n.logger(e.App).Error("device token register failed", "error", err)
			return apiError(e, http.StatusInternalServerError, CodeServer, "The token could not be saved.")
		}
	case "unregister":
		if _, err := e.App.DB().Delete(tokens, dbx.HashExp{"token": body.Token, "user_id": userID}).Execute(); err != nil {
			n.logger(e.App).Error("device token unregister failed", "error", err)
			return apiError(e, http.StatusInternalServerError, CodeServer, "The token could not be removed.")
		}
	default:
		return apiError(e, http.StatusBadRequest, CodeBadRequest, "action must be register or unregister.")
	}
	return e.JSON(http.StatusOK, OK{OK: true})
}

// RegisterToken upserts the token by its value: the device-token
// function's upsert on conflict (token). The token moves to userID when
// another user had it. A nil locale keeps the stored one; an unsupported
// language is stored empty (users.locale is used).
func RegisterToken(app core.App, userID, token, platform string, locale *string, now time.Time) error {
	return app.RunInTransaction(func(txApp core.App) error {
		collection, err := txApp.FindCachedCollectionByNameOrId(tokens)
		if err != nil {
			return err
		}
		stamp := pattern.FormatTimestamp(now)
		record, err := txApp.FindFirstRecordByData(collection, "token", token)
		switch {
		case errors.Is(err, sql.ErrNoRows):
			record = core.NewRecord(collection)
			record.Set("token", token)
			record.Set("created_at", stamp)
		case err != nil:
			return err
		}
		record.Set("user_id", userID)
		record.Set("platform", platform)
		if locale != nil {
			code, _ := auth.ParseLocale(*locale)
			record.Set("locale", code)
		}
		record.Set("updated_at", stamp)
		return txApp.Save(record)
	})
}

// ---------------------------------------------------------------------------
// Task assignment
// ---------------------------------------------------------------------------

// onTask is notify_task_assigned: an assigned, open, live task that is new
// or whose assignee changed, assigned by someone else. It only schedules
// the send.
func (n *Notifier) onTask(e *core.RecordEvent, update bool) {
	if n.opts.FCM == nil {
		return
	}
	r := e.Record
	assignee := r.GetString("assigned_to")
	if assignee == "" || r.GetString("deleted_at") != "" || r.GetString("completed_at") != "" {
		return
	}
	// The record's original data is the row as it was read before the
	// save; PocketBase refreshes it only on a new read (Record.PostScan).
	if update && r.Original().GetString("assigned_to") == assignee {
		return
	}
	// Assigning oneself notifies no one.
	if assignee == actor.From(e.Context) {
		return
	}
	app, taskID := e.App, r.Id
	n.wg.Add(1)
	go func() {
		defer n.wg.Done()
		n.notifyTask(context.Background(), app, taskID, assignee)
	}()
}

// notifyTask sends the assignment push. The task is read again: a push
// change rolled back to its savepoint (rejected after the save) still
// fires the hook when the batch commits, and the stored row then is not
// the one the hook saw.
func (n *Notifier) notifyTask(ctx context.Context, app core.App, taskID, assignee string) {
	log := n.logger(app)
	task, err := app.FindRecordById("tasks", taskID)
	if err != nil {
		if !errors.Is(err, sql.ErrNoRows) {
			log.Error("task notification: read failed", "task_id", taskID, "error", err)
		}
		return
	}
	if task.GetString("assigned_to") != assignee || task.GetString("deleted_at") != "" || task.GetString("completed_at") != "" {
		return
	}
	// The assignee must still be a member of the task's organization.
	member, err := authz.IsMember(app, assignee, task.GetString("org_id"))
	if err != nil {
		log.Error("task notification: membership read failed", "task_id", taskID, "error", err)
		return
	}
	if !member {
		return
	}
	devices, err := deviceTokens(app, []string{assignee})
	if err != nil {
		log.Error("task notification: token read failed", "task_id", taskID, "error", err)
		return
	}
	title := task.GetString("title")
	n.send(ctx, app, devices, func(locale string) fcm.Message {
		t, b := TaskText(title, locale)
		return fcm.Message{Title: t, Body: b, Data: map[string]string{"type": TypeTask, "task_id": taskID}}
	})
}

// ---------------------------------------------------------------------------
// Support periods
// ---------------------------------------------------------------------------

// NotifySupportPeriods is private.notify_support_periods(): every period
// open today in Turkey and not yet announced is marked in
// support_period_notifications and sent to [SupportPeriodRecipients]. It
// returns the number of periods announced. With sending off or no
// recipient it does nothing, and the periods wait for a later run.
func (n *Notifier) NotifySupportPeriods(ctx context.Context, app core.App) (int, error) {
	if n.opts.FCM == nil {
		return 0, nil
	}
	recipients, err := SupportPeriodRecipients(app)
	if err != nil || len(recipients) == 0 {
		return 0, err
	}
	today := n.opts.Now().In(turkey).Format(time.DateOnly)
	periods := []struct {
		ID     string `db:"id"`
		Name   string `db:"name"`
		EndsOn string `db:"application_ends_on"`
	}{}
	err = app.DB().
		Select("p.id", "p.name", "p.application_ends_on").
		From("ref_support_periods p").
		Where(dbx.HashExp{"p.deleted_at": ""}).
		AndWhere(dbx.NewExp("p.application_starts_on <= {:today} AND p.application_ends_on >= {:today}", dbx.Params{"today": today})).
		AndWhere(dbx.NewExp("NOT EXISTS (SELECT 1 FROM support_period_notifications n WHERE n.period_id = p.id)")).
		OrderBy("p.application_starts_on", "p.id").
		All(&periods)
	if err != nil || len(periods) == 0 {
		return 0, err
	}
	devices, err := deviceTokens(app, recipients)
	if err != nil {
		return 0, err
	}

	marks, err := app.FindCachedCollectionByNameOrId("support_period_notifications")
	if err != nil {
		return 0, err
	}
	sent := 0
	for _, p := range periods {
		// Marked before sending, as the SQL did: a period goes out once,
		// even when FCM then fails. The unique period_id index stops a
		// second, concurrent run.
		mark := core.NewRecord(marks)
		mark.Set("period_id", p.ID)
		mark.Set("notified_at", pattern.FormatTimestamp(n.opts.Now()))
		if err := app.Save(mark); err != nil {
			n.logger(app).Warn("support period already announced", "period_id", p.ID, "error", err)
			continue
		}
		sent++
		n.send(ctx, app, devices, func(locale string) fcm.Message {
			t, b := SupportPeriodText(p.Name, p.EndsOn, locale)
			return fcm.Message{Title: t, Body: b, Data: map[string]string{"type": TypeSupportPeriod, "period_id": p.ID}}
		})
	}
	return sent, nil
}

// SupportPeriodRecipients is private.support_period_recipients(): the live
// owner and partner members of live TR organizations, each once.
func SupportPeriodRecipients(app core.App) ([]string, error) {
	ids := []string{}
	err := app.DB().
		Select("m.user_id").
		Distinct(true).
		From("memberships m").
		InnerJoin("organizations o", dbx.NewExp("o.id = m.org_id")).
		Where(dbx.HashExp{
			"o.country_code": "TR",
			"o.deleted_at":   "",
			"m.deleted_at":   "",
			"m.role":         []any{string(authz.Owner), string(authz.Partner)},
		}).
		OrderBy("m.user_id").
		Column(&ids)
	return ids, err
}

// ---------------------------------------------------------------------------
// Sending
// ---------------------------------------------------------------------------

// device is one phone and the language of its push.
type device struct {
	Token  string `db:"token"`
	Locale string `db:"locale"`
}

// deviceTokens returns the phones of users. The language is the device's
// locale, else the user's, else English.
func deviceTokens(app core.App, userIDs []string) ([]device, error) {
	if len(userIDs) == 0 {
		return nil, nil
	}
	in := make([]any, len(userIDs))
	for i, id := range userIDs {
		in[i] = id
	}
	rows := []struct {
		Token        string         `db:"token"`
		DeviceLocale string         `db:"device_locale"`
		UserLocale   sql.NullString `db:"user_locale"`
	}{}
	err := app.DB().
		Select("d.token", "d.locale AS device_locale", "u.locale AS user_locale").
		From(tokens+" d").
		LeftJoin("users u", dbx.NewExp("u.id = d.user_id")).
		Where(dbx.HashExp{"d.user_id": in}).
		OrderBy("d.user_id", "d.token").
		All(&rows)
	if err != nil {
		return nil, err
	}
	out := make([]device, len(rows))
	for i, r := range rows {
		locale, ok := auth.ParseLocale(r.DeviceLocale)
		if !ok {
			locale = auth.PickLocale(r.UserLocale.String)
		}
		out[i] = device{Token: r.Token, Locale: locale}
	}
	return out, nil
}

// send delivers one message per device and deletes the tokens FCM no
// longer knows. Errors are logged, never returned: a notification is a
// courtesy.
func (n *Notifier) send(ctx context.Context, app core.App, devices []device, build func(locale string) fcm.Message) int {
	if len(devices) == 0 {
		return 0
	}
	log := n.logger(app)
	if _, err := n.opts.FCM.AccessToken(ctx); err != nil {
		log.Error("push: FCM authorization failed", "error", err)
		return 0
	}
	sent := 0
	var invalid []any
	for _, d := range devices {
		result, err := n.opts.FCM.Send(ctx, d.Token, build(d.Locale))
		switch result {
		case fcm.Sent:
			sent++
		case fcm.InvalidToken:
			invalid = append(invalid, d.Token)
		default:
			log.Error("push: send failed", "error", err)
		}
	}
	if len(invalid) > 0 {
		if _, err := app.DB().Delete(tokens, dbx.HashExp{"token": invalid}).Execute(); err != nil {
			log.Error("push: invalid token delete failed", "error", err)
		}
	}
	return sent
}

func apiError(e *core.RequestEvent, status int, code, message string) error {
	return e.JSON(status, auth.ErrorBody{Status: status, Message: message, Data: auth.ErrorData{Code: code}})
}
