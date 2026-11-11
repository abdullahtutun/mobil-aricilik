// Package bootstrap wires the server's hooks and routes into a PocketBase app.
//
// main.go and the tests call the same Register, so tests exercise exactly
// what runs in production.
package bootstrap

import (
	"context"
	"errors"
	"log/slog"
	"net/http"
	"os"
	"strings"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/fcm"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/files"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/notify"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/orgs"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/recordapi"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/schemadump"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/team"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/users"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/weather"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

// Info is the body of GET /api/app/info. It carries no secrets; tools use it
// to tell dev from prod.
type Info struct {
	Env     string `json:"env"`
	Version string `json:"version"`
}

// SchemaHash is the body of GET /api/app/schema-hash (superusers only).
type SchemaHash struct {
	SHA256 string `json:"sha256"`
}

// Register binds the record hooks, the startup log and the app routes.
func Register(app core.App, cfg config.Config, version string) {
	// Model-level hooks, bound before Start so that migrations and CLI
	// commands run them too.
	ids.Register(app)
	users.Register(app)
	appsync.RegisterSeq(app)
	deletion.RegisterLogGuard(app)
	recordapi.Register(app)
	files.Register(app)
	mail := newMailGate(cfg.Mail)
	auth.Register(app, mail.On)
	appsync.RegisterPull(app)
	appsync.RegisterPush(app)
	orgs.Register(app)
	team.Register(app)
	weather.Register(app, weather.Options{
		Key:  cfg.Weather.Key,
		Days: weather.ForecastDays(cfg.Weather.Days),
	})
	push, pushErr := newFCM(cfg.FCMServiceAccountB64)
	notify.Register(app, notify.Options{FCM: push})

	app.OnBootstrap().BindFunc(func(e *core.BootstrapEvent) error {
		if err := e.Next(); err != nil {
			return err
		}
		log := startupLogger(e.App)
		logStartup(log, cfg, version)
		applyBackups(e.App, cfg.Backups, log)
		if !applyMail(e.App, cfg.Mail, log) {
			mail.on.Store(false)
		}
		applyTrustedProxy(e.App, cfg.TrustedProxy, log)
		applyRateLimits(e.App, log)
		if pushErr != nil {
			// The error names the problem, never the value.
			log.Error("FCM_SERVICE_ACCOUNT_B64 is invalid; push notifications are off", "error", pushErr)
		}
		return nil
	})

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.GET("/api/app/info", func(e *core.RequestEvent) error {
			return e.JSON(http.StatusOK, Info{Env: cfg.Env, Version: version})
		})
		// Live drift check (P2.8): server/ops/schema_check.sh compares this
		// with the SHA-256 of server/schema/collections.json.
		se.Router.GET("/api/app/schema-hash", func(e *core.RequestEvent) error {
			sum, err := schemadump.Hash(e.App)
			if err != nil {
				return e.InternalServerError("", err)
			}
			return e.JSON(http.StatusOK, SchemaHash{SHA256: sum})
		}).Bind(apis.RequireSuperuserAuth())
		return se.Next()
	})
}

// newFCM builds the FCM sender from FCM_SERVICE_ACCOUNT_B64; nil (push
// off) when it is unset or invalid. An invalid value is returned as the
// error for the startup log.
func newFCM(b64 string) (*fcm.Client, error) {
	if b64 == "" {
		return nil, nil
	}
	account, err := fcm.ParseServiceAccountB64(b64)
	if err != nil {
		return nil, err
	}
	return fcm.New(account, fcm.Options{})
}

// logStartup logs the environment and the names (never values) of missing
// variables, grouped by the feature that stays off.
func logStartup(log *slog.Logger, cfg config.Config, version string) {
	log.Info("Mobil Arıcı server starting", "env", cfg.Env, "version", version)

	if cfg.InvalidEnv {
		log.Error("APP_ENV must be dev or prod")
	}

	byFeature := map[string][]string{}
	var order []string
	for _, v := range cfg.Missing {
		if _, ok := byFeature[v.Feature]; !ok {
			order = append(order, v.Feature)
		}
		byFeature[v.Feature] = append(byFeature[v.Feature], v.Name)
	}
	for _, f := range order {
		log.Warn("Missing environment variables", "feature", f, "names", strings.Join(byFeature[f], ","))
	}
}

// startupLogger writes to the app log and, outside --dev mode, to stderr.
// app.Logger() prints to the console only in --dev mode; otherwise it writes
// to the dashboard log table, while Coolify shows the container's stderr.
func startupLogger(app core.App) *slog.Logger {
	handlers := fanout{app.Logger().Handler()}
	if !app.IsDev() {
		handlers = append(handlers, slog.NewTextHandler(os.Stderr, nil))
	}
	return slog.New(handlers)
}

// fanout sends each record to every handler.
type fanout []slog.Handler

func (f fanout) Enabled(ctx context.Context, l slog.Level) bool {
	for _, h := range f {
		if h.Enabled(ctx, l) {
			return true
		}
	}
	return false
}

func (f fanout) Handle(ctx context.Context, r slog.Record) error {
	var errs []error
	for _, h := range f {
		if h.Enabled(ctx, r.Level) {
			errs = append(errs, h.Handle(ctx, r.Clone()))
		}
	}
	return errors.Join(errs...)
}

func (f fanout) WithAttrs(attrs []slog.Attr) slog.Handler {
	out := make(fanout, len(f))
	for i, h := range f {
		out[i] = h.WithAttrs(attrs)
	}
	return out
}

func (f fanout) WithGroup(name string) slog.Handler {
	out := make(fanout, len(f))
	for i, h := range f {
		out[i] = h.WithGroup(name)
	}
	return out
}
