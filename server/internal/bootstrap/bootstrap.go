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

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/users"
	"github.com/pocketbase/pocketbase/core"
)

// Info is the body of GET /api/app/info. It carries no secrets; tools use it
// to tell dev from prod.
type Info struct {
	Env     string `json:"env"`
	Version string `json:"version"`
}

// Register binds the record hooks, the startup log and the app routes.
func Register(app core.App, cfg config.Config, version string) {
	// Model-level hooks, bound before Start so that migrations and CLI
	// commands run them too.
	ids.Register(app)
	users.Register(app)
	appsync.RegisterSeq(app)

	app.OnBootstrap().BindFunc(func(e *core.BootstrapEvent) error {
		if err := e.Next(); err != nil {
			return err
		}
		log := startupLogger(e.App)
		logStartup(log, cfg, version)
		applyBackups(e.App, cfg.Backups, log)
		return nil
	})

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.GET("/api/app/info", func(e *core.RequestEvent) error {
			return e.JSON(http.StatusOK, Info{Env: cfg.Env, Version: version})
		})
		return se.Next()
	})
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
