package seed

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"reflect"
	"slices"
	"sort"
	"strings"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// RefTables are the reference tables `seed verify-ref` checks.
var RefTables = []string{"ref_drugs", "ref_support_periods"}

// RefExpect is one table of the --expect file: Supabase's row count
// (count(*), soft-deleted rows included) and sample rows as Supabase's
// row_to_json gives them. A sample needs "id"; every other key is compared.
//
//	{"ref_drugs": {"count": 21, "samples": [{"id": "…", "name_tr": "…"}]},
//	 "ref_support_periods": {"count": 0, "samples": []}}
type RefExpect struct {
	Count   *int                         `json:"count"`
	Samples []map[string]json.RawMessage `json:"samples"`
}

// RefTableResult is the outcome for one table.
type RefTableResult struct {
	Table       string
	Expected    int
	Actual      int
	Samples     int
	Differences []string
}

// RefReport is the outcome of `seed verify-ref`.
type RefReport struct {
	Tables []RefTableResult
}

// OK reports whether every count and sample matched.
func (r RefReport) OK() bool {
	for _, t := range r.Tables {
		if t.Expected != t.Actual || len(t.Differences) > 0 {
			return false
		}
	}
	return true
}

// String is the report the command prints.
func (r RefReport) String() string {
	var b strings.Builder
	for _, t := range r.Tables {
		status := "equal"
		if t.Expected != t.Actual || len(t.Differences) > 0 {
			status = "DIFFERENT"
		}
		fmt.Fprintf(&b, "%-20s count %d (expected %d), %d sample(s): %s\n", t.Table, t.Actual, t.Expected, t.Samples, status)
		for _, d := range t.Differences {
			fmt.Fprintf(&b, "  - %s\n", d)
		}
	}
	return b.String()
}

// VerifyRef is `seed verify-ref`: it compares the reference tables with the
// expected counts and sample rows (from the P0.2 backup, or the query in
// server/ops/ref_expected.sql). Both tables must be in the file. Sample
// values compare as JSON; null and an empty text are the same (PocketBase
// stores null text as ""), and times compare as instants (Supabase writes
// +00:00, PocketBase K-5 text).
func VerifyRef(app core.App, expectJSON []byte) (RefReport, error) {
	var expect map[string]RefExpect
	dec := json.NewDecoder(bytes.NewReader(expectJSON))
	if err := dec.Decode(&expect); err != nil {
		return RefReport{}, fmt.Errorf("--expect is not a JSON object of tables: %w", err)
	}
	for name := range expect {
		if !slices.Contains(RefTables, name) {
			return RefReport{}, fmt.Errorf("--expect: unknown table %q (only %s)", name, strings.Join(RefTables, ", "))
		}
	}
	var report RefReport
	for _, table := range RefTables {
		e, ok := expect[table]
		if !ok || e.Count == nil {
			return RefReport{}, fmt.Errorf("--expect: %s needs a count", table)
		}
		res, err := verifyTable(app, table, e)
		if err != nil {
			return RefReport{}, err
		}
		report.Tables = append(report.Tables, res)
	}
	return report, nil
}

func verifyTable(app core.App, table string, e RefExpect) (RefTableResult, error) {
	res := RefTableResult{Table: table, Expected: *e.Count, Samples: len(e.Samples)}
	actual, err := app.CountRecords(table, dbx.NewExp("1=1"))
	if err != nil {
		return res, err
	}
	res.Actual = int(actual)

	c, err := app.FindCachedCollectionByNameOrId(table)
	if err != nil {
		return res, err
	}
	for i, sample := range e.Samples {
		var id string
		if json.Unmarshal(sample["id"], &id) != nil || id == "" {
			return res, fmt.Errorf("--expect: %s sample %d has no id", table, i+1)
		}
		rec, err := app.FindRecordById(table, id)
		if errors.Is(err, sql.ErrNoRows) {
			res.Differences = append(res.Differences, fmt.Sprintf("%s: missing", id))
			continue
		}
		if err != nil {
			return res, err
		}
		row, err := appsync.RowJSON(rec)
		if err != nil {
			return res, err
		}
		keys := make([]string, 0, len(sample))
		for k := range sample {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		for _, k := range keys {
			if k == "id" || k == appsync.FieldServerSeq {
				continue
			}
			f := c.Fields.GetByName(k)
			if f == nil {
				res.Differences = append(res.Differences, fmt.Sprintf("%s.%s: no such field", id, k))
				continue
			}
			got, err := json.Marshal(row[k])
			if err != nil {
				return res, err
			}
			if !sameValue(f, sample[k], got) {
				res.Differences = append(res.Differences, fmt.Sprintf("%s.%s: %s, expected %s", id, k, got, bytes.TrimSpace(sample[k])))
			}
		}
	}
	return res, nil
}

// sameValue compares an expected (Supabase) and an actual (PocketBase)
// JSON value of field f.
func sameValue(f core.Field, want, got json.RawMessage) bool {
	var w, g any
	if json.Unmarshal(want, &w) != nil || json.Unmarshal(got, &g) != nil {
		return false
	}
	if w == "" {
		w = nil
	}
	if text, ok := f.(*core.TextField); ok {
		if text.Pattern == pattern.Timestamp {
			ws, wok := w.(string)
			gs, gok := g.(string)
			if wok && gok {
				wt, err1 := time.Parse(time.RFC3339Nano, ws)
				gt, err2 := time.Parse(time.RFC3339Nano, gs)
				return err1 == nil && err2 == nil && wt.Equal(gt)
			}
		}
	}
	return reflect.DeepEqual(w, g)
}
