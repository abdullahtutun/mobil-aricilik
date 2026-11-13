// Package schemadump writes the collection schema as stable JSON (K-3, P2.8).
//
// server/schema/collections.json is the dump of a fresh app with every Go
// migration applied. A test regenerates it and fails on any difference, so a
// migration change without a new dump is caught; GET /api/app/schema-hash
// returns the SHA-256 of the live app's dump, so a change made in the
// dashboard is caught by server/ops/schema_check.sh.
package schemadump

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"os"
	"slices"
	"strings"

	"github.com/pocketbase/pocketbase/core"
)

// File is the dump's path relative to the server/ directory.
const File = "schema/collections.json"

// Collection is one collection in the dump. Ids and timestamps are left out:
// they say nothing about the shape and differ between installs.
type Collection struct {
	Name       string  `json:"name"`
	Type       string  `json:"type"`
	ListRule   *string `json:"listRule"`
	ViewRule   *string `json:"viewRule"`
	CreateRule *string `json:"createRule"`
	UpdateRule *string `json:"updateRule"`
	DeleteRule *string `json:"deleteRule"`
	// Auth collections only.
	AuthRule   *string `json:"authRule,omitempty"`
	ManageRule *string `json:"manageRule,omitempty"`
	// Each field's own JSON (type, required, min/max, pattern, select
	// values, …) without its id, in collection order.
	Fields []map[string]any `json:"fields"`
	// Sorted; their order carries no meaning.
	Indexes []string `json:"indexes"`
}

// Collections returns the app's non-system collections sorted by name.
// System collections (_superusers, _otps, …) come from PocketBase itself.
func Collections(app core.App) ([]Collection, error) {
	all, err := app.FindAllCollections()
	if err != nil {
		return nil, err
	}
	slices.SortFunc(all, func(a, b *core.Collection) int { return strings.Compare(a.Name, b.Name) })

	out := make([]Collection, 0, len(all))
	for _, c := range all {
		if c.System {
			continue
		}
		dc := Collection{
			Name:       c.Name,
			Type:       c.Type,
			ListRule:   c.ListRule,
			ViewRule:   c.ViewRule,
			CreateRule: c.CreateRule,
			UpdateRule: c.UpdateRule,
			DeleteRule: c.DeleteRule,
			Fields:     []map[string]any{},
			Indexes:    slices.Sorted(slices.Values(c.Indexes)),
		}
		if dc.Indexes == nil {
			dc.Indexes = []string{}
		}
		if c.IsAuth() {
			dc.AuthRule = c.AuthRule
			dc.ManageRule = c.ManageRule
		}
		for _, f := range c.Fields {
			raw, err := json.Marshal(f)
			if err != nil {
				return nil, fmt.Errorf("schemadump: %s.%s: %w", c.Name, f.GetName(), err)
			}
			var m map[string]any
			if err := json.Unmarshal(raw, &m); err != nil {
				return nil, fmt.Errorf("schemadump: %s.%s: %w", c.Name, f.GetName(), err)
			}
			delete(m, "id")
			// A field's own JSON has no type; FieldsList adds it.
			m["type"] = f.Type()
			dc.Fields = append(dc.Fields, m)
		}
		out = append(out, dc)
	}
	return out, nil
}

// Dump returns the dump file's bytes: indented JSON (map keys sorted by
// encoding/json) ending in a newline.
func Dump(app core.App) ([]byte, error) {
	cols, err := Collections(app)
	if err != nil {
		return nil, err
	}
	var buf bytes.Buffer
	enc := json.NewEncoder(&buf)
	enc.SetEscapeHTML(false)
	enc.SetIndent("", "  ")
	if err := enc.Encode(cols); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}

// Hash is the hex SHA-256 of [Dump]; `shasum -a 256` of the file gives the
// same value.
func Hash(app core.App) (string, error) {
	b, err := Dump(app)
	if err != nil {
		return "", err
	}
	sum := sha256.Sum256(b)
	return hex.EncodeToString(sum[:]), nil
}

// Fresh dumps a new, empty app in a temporary directory with every
// registered migration applied (the caller imports the migrations package).
// The local pb_data is never read, so the result depends on the code only.
func Fresh() ([]byte, error) {
	dir, err := os.MkdirTemp("", "arici-schema-*")
	if err != nil {
		return nil, err
	}
	defer os.RemoveAll(dir)

	app := core.NewBaseApp(core.BaseAppConfig{DataDir: dir})
	if err := app.Bootstrap(); err != nil {
		return nil, err
	}
	defer app.ResetBootstrapState()

	if err := app.RunAllMigrations(); err != nil {
		return nil, fmt.Errorf("schemadump: migrations: %w", err)
	}
	return Dump(app)
}
