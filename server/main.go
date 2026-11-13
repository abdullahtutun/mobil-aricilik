// Command arici is the Mobil Arıcı backend: PocketBase extended in Go (K-1).
package main

import (
	"log"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/schemadump"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/seed"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
)

// version is the git commit, set at build time:
// go build -ldflags "-X main.version=<commit>".
var version = "dev-local"

func main() {
	// Default for every command, not only `serve`: the superuser and other
	// CLI commands must read the same key, or they cannot decrypt settings.
	app := pocketbase.NewWithConfig(pocketbase.Config{
		DefaultEncryptionEnv: "PB_ENCRYPTION_KEY",
	})

	// Schema changes come only from Go migrations in ./migrations (K-3).
	migratecmd.MustRegister(app, app.RootCmd, migratecmd.Config{
		Dir:         "migrations",
		Automigrate: false,
	})

	// `go run . schema dump` rewrites schema/collections.json (P2.8).
	app.RootCmd.AddCommand(schemadump.NewCommand())
	cfg := config.Load(nil)
	// `arici seed demo-user|demo|verify-ref` (P8.1), `seed deletion expire`
	// (P9.2, dev only).
	app.RootCmd.AddCommand(seed.NewCommand(app, nil, cfg.Env))

	bootstrap.Register(app, cfg, version)

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
