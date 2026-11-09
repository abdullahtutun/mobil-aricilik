// Command arici is the Mobil Arıcı backend: PocketBase extended in Go (K-1).
package main

import (
	"log"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
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

	bootstrap.Register(app, config.Load(nil), version)

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
