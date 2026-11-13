package seed

import (
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

// The rows go through the same checks as a push: the table CHECKs, the
// references and the field validation; a failure rolls the whole seed back.
func TestWriteRowsRunsPushChecks(t *testing.T) {
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, config.Config{Env: config.EnvDev}, "test")
	if _, err := DemoUser(app, "demo@tutunsoft.com", "123456"); err != nil {
		t.Fatal(err)
	}
	user, _ := FindDemoUser(app)
	drug, err := loadRefDrug(app, bayvarolID)
	if err != nil {
		t.Fatal(err)
	}
	if drug.withdrawalDays != 0 || drug.doseUnit != "strip" || drug.activeIngredient != "flumethrin" {
		t.Errorf("drug = %+v", drug)
	}

	cases := map[string]struct {
		edit func(rows []row)
		want string
	}{
		"CHECK (inspection data not an object)": {
			edit: func(rows []row) { find(rows, "inspections").values["data"] = js([]string{"x"}) },
			want: "invalid",
		},
		"reference (hive in no apiary of the organization)": {
			edit: func(rows []row) { find(rows, "hives").values["apiary_id"] = demoID("nowhere") },
			want: "missing_reference",
		},
		"field option (feeding amount over 100)": {
			edit: func(rows []row) { find(rows, "feedings").values["amount"] = 101 },
			want: "amount",
		},
	}
	for name, c := range cases {
		t.Run(name, func(t *testing.T) {
			rows := demoRows(user.Id, fixedClock(), "2026-11-12T09:00:00.000000Z", drug)
			c.edit(rows)
			err := app.RunInTransaction(func(txApp core.App) error {
				return writeRows(txApp, user.Id, rows)
			})
			if err == nil || !strings.Contains(err.Error(), c.want) {
				t.Fatalf("err = %v, want %q", err, c.want)
			}
			if n, _ := app.CountRecords("organizations"); n != 0 {
				t.Error("a failed seed left rows")
			}
		})
	}
}

func find(rows []row, table string) row {
	for _, r := range rows {
		if r.table == table {
			return r
		}
	}
	panic(table)
}

func fixedClock() time.Time {
	t, _ := demoClock(time.Time{}, "2026-11-12")
	return t
}
