// Package migrations holds the Go schema migrations (K-3).
//
// Each migration file registers itself in init() with
// m.Register(up, down); main.go imports this package for that side effect.
// New files are created with `go run . migrate create <name>` and are never
// generated from the dashboard (Automigrate is off).
package migrations
