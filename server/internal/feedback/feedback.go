// Package feedback is the feedback e-mail (P5.7): the Go port of the
// feedback-mail Edge Function and of its notify_feedback_mail trigger
// (20261027120000).
//
//   - Hook: a new feedback record is mailed to FEEDBACK_TO_EMAIL from the
//     feedback mailbox (MAIL_FEEDBACK_USER/PASS), a client of its own;
//     PocketBase's mailer is the noreply account (P4.2). Reply-To is the
//     sender's e-mail, so answering the mail answers the user. The hook
//     runs after the transaction commits (OnRecordAfterCreateSuccess fires
//     only then, and not on rollback), in the background: the feedback never
//     waits for SMTP and a failure never undoes it.
//   - Route: GET /api/app/feedback-shot/{id}?exp=&sig= serves the screenshot
//     from feedback_files (P6.1). The mail carries this link, signed for 7
//     days with a key derived from PB_ENCRYPTION_KEY, in place of
//     Supabase's signed storage URL; feedback_files has no read rule, so a
//     PocketBase file token would need a superuser.
//
// Without the mailbox variables the feedback is still stored and the mail
// is skipped.
package feedback

import (
	"database/sql"
	"encoding/json"
	"errors"
	"log/slog"
	"sync"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/mail"
	"github.com/pocketbase/pocketbase/core"
)

const (
	// RoutePrefix is the screenshot route without its id.
	RoutePrefix = "/api/app/feedback-shot/"

	collection = "feedback"
	shots      = "feedback_files"
)

// Sender delivers one e-mail; *mail.Sender in production.
type Sender interface {
	Send(m mail.Message) error
}

// Options configure the feedback mail.
type Options struct {
	// Sender sends from the feedback mailbox; nil turns the mail off.
	Sender Sender
	// To is the recipient (FEEDBACK_TO_EMAIL).
	To string
	// BaseURL is the server's own address (APP_URL); empty leaves the
	// screenshot link out of the mail.
	BaseURL string
	// Signer signs the screenshot links; nil leaves them out and refuses
	// every link.
	Signer *Signer
	// Logger receives send errors; the app logger when nil.
	Logger *slog.Logger
	// Now is the clock; time.Now when nil.
	Now func() time.Time
}

// Mailer holds the options and the background sends in flight.
type Mailer struct {
	opts Options
	wg   sync.WaitGroup
}

// Register binds the feedback hook and the screenshot route.
func Register(app core.App, opts Options) *Mailer {
	if opts.Now == nil {
		opts.Now = time.Now
	}
	m := &Mailer{opts: opts}

	app.OnRecordAfterCreateSuccess(collection).BindFunc(func(e *core.RecordEvent) error {
		m.onCreate(e)
		return e.Next()
	})

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.GET(RoutePrefix+"{id}", m.handleShot)
		return se.Next()
	})
	return m
}

// Wait blocks until the background sends started so far are done. Tests
// and shutdown use it.
func (m *Mailer) Wait() { m.wg.Wait() }

func (m *Mailer) logger(app core.App) *slog.Logger {
	if m.opts.Logger != nil {
		return m.opts.Logger
	}
	return app.Logger()
}

// onCreate only schedules the send.
func (m *Mailer) onCreate(e *core.RecordEvent) {
	if m.opts.Sender == nil {
		return
	}
	app, r := e.App, e.Record
	rec := Record{
		ID:             r.Id,
		OrgID:          r.GetString("org_id"),
		Kind:           r.GetString("kind"),
		Message:        r.GetString("message"),
		ScreenshotPath: r.GetString("screenshot_path"),
		// Stored as text with microseconds (K-5), shown as is.
		CreatedAt: r.GetString("created_at"),
	}
	// device_info is checked to be an object on write; anything else is
	// left out.
	var info map[string]any
	if raw, err := json.Marshal(r.Get("device_info")); err == nil && json.Unmarshal(raw, &info) == nil {
		rec.DeviceInfo = info
	}
	createdBy := r.GetString("created_by")
	if rec.ID == "" || rec.Message == "" {
		return
	}
	m.wg.Add(1)
	go func() {
		defer m.wg.Done()
		m.send(app, rec, createdBy)
	}()
}

// send builds and delivers the mail. The organization's name and the
// sender's e-mail are courtesies: when they cannot be read, the mail still
// goes out.
func (m *Mailer) send(app core.App, rec Record, createdBy string) {
	log := m.logger(app)
	var c Context
	if org, err := app.FindRecordById("organizations", rec.OrgID); err == nil {
		c.OrgName = org.GetString("name")
	} else if !errors.Is(err, sql.ErrNoRows) {
		log.Warn("feedback mail: organization read failed", "feedback_id", rec.ID, "error", err)
	}
	if createdBy != "" {
		if u, err := app.FindRecordById("users", createdBy); err == nil {
			c.SenderEmail = u.Email()
		} else if !errors.Is(err, sql.ErrNoRows) {
			log.Warn("feedback mail: user read failed", "feedback_id", rec.ID, "error", err)
		}
	}
	if rec.ScreenshotPath != "" && m.opts.Signer != nil && m.opts.BaseURL != "" {
		// The screenshot's feedback_files id is the feedback id: the path
		// is exactly <org_id>/<id>.jpg (validate.FeedbackCheck). The link
		// is resolved when opened, so a screenshot uploaded after the
		// feedback still shows.
		c.ScreenshotURL = m.opts.Signer.URL(m.opts.BaseURL, rec.ID, m.opts.Now().Add(LinkTTL))
	}

	out := Compose(rec, c)
	err := m.opts.Sender.Send(mail.Message{
		To:      m.opts.To,
		ReplyTo: c.SenderEmail,
		Subject: out.Subject,
		Text:    out.Text,
	})
	if err != nil {
		// The error may carry the SMTP server's reply, never the password.
		log.Error("feedback mail: send failed", "feedback_id", rec.ID, "error", err)
	}
}

// handleShot serves a screenshot to a valid link: 403 for a bad or expired
// signature, 404 when there is no such screenshot.
func (m *Mailer) handleShot(e *core.RequestEvent) error {
	id := e.Request.PathValue("id")
	q := e.Request.URL.Query()
	if err := m.opts.Signer.Verify(id, q.Get("exp"), q.Get("sig"), m.opts.Now()); err != nil {
		return e.ForbiddenError("The link is invalid or has expired.", nil)
	}

	record, err := e.App.FindRecordById(shots, id)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return e.NotFoundError("", nil)
		}
		return e.InternalServerError("", err)
	}
	name := record.GetString("file")
	if name == "" {
		return e.NotFoundError("", nil)
	}

	fsys, err := e.App.NewFilesystem()
	if err != nil {
		return e.InternalServerError("", err)
	}
	defer fsys.Close()

	// The link is a bearer secret: no shared cache may keep the picture.
	e.Response.Header().Set("Cache-Control", "private, no-store")
	e.Response.Header().Set("Referrer-Policy", "no-referrer")
	if err := fsys.Serve(e.Response, e.Request, record.BaseFilesPath()+"/"+name, id+".jpg"); err != nil {
		return e.NotFoundError("", err)
	}
	return nil
}
