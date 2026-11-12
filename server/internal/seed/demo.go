// Package seed writes the store reviewers' demo account and checks the
// reference data (P8.1, K-12, K-17). It is the counterpart of
// supabase/admin/demo_account.sql; the commands are in command.go.
package seed

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/google/uuid"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/types"
)

// DemoOrgID is the demo organization's id, the same as in Supabase
// (demo_account.sql `org`).
const DemoOrgID = "01900000-0000-7000-8000-00000000de00"

// bayvarolID is the TR reference drug of the demo treatment.
const bayvarolID = "01900000-0000-7000-8000-000000000201"

// ErrNoDemoUser: the demo account must be opened first (`seed demo-user`).
var ErrNoDemoUser = fmt.Errorf("open the %s account first: seed demo-user --email %s", auth.DemoEmail, auth.DemoEmail)

// row is one record to write, in writing order.
type row struct {
	table  string
	values map[string]any
	id     string
}

// demoNamespace makes the fixed ids: UUIDv5 of a name ("hive/5") in the
// organization's namespace. The SQL used gen_random_uuid(); fixed ids let a
// second run, or a --force-reset, write the same rows again.
var demoNamespace = uuid.MustParse(DemoOrgID)

func demoID(format string, args ...any) string {
	return uuid.NewSHA1(demoNamespace, []byte(fmt.Sprintf(format, args...))).String()
}

// demoClock is the reference time of the data: demo_account.sql's
// now_ts = date_trunc('hour', now()), in UTC (Supabase's session time zone).
// A --date day gives that day at 12:00 UTC, so a run can be repeated.
func demoClock(now time.Time, day string) (time.Time, error) {
	if day == "" {
		return now.UTC().Truncate(time.Hour), nil
	}
	d, err := time.Parse(time.DateOnly, day)
	if err != nil {
		return time.Time{}, fmt.Errorf("--date must be YYYY-MM-DD, got %q", day)
	}
	return d.Add(12 * time.Hour), nil
}

// refDrug is the part of a ref_drugs row the treatment copies.
type refDrug struct {
	nameTR, activeIngredient, doseUnit string
	withdrawalDays                     int
}

func loadRefDrug(app core.App, id string) (refDrug, error) {
	r, err := app.FindRecordById("ref_drugs", id)
	if errors.Is(err, sql.ErrNoRows) {
		return refDrug{}, fmt.Errorf("reference drug %s is missing; the ref_drugs migration must run first", id)
	}
	if err != nil {
		return refDrug{}, err
	}
	d := refDrug{
		nameTR:           r.GetString("name_tr"),
		activeIngredient: r.GetString("active_ingredient"),
		doseUnit:         r.GetString("dose_unit"),
	}
	// coalesce(r.withdrawal_days, 0): the column is JSON (null or a number).
	if raw, ok := r.GetRaw("withdrawal_days").(types.JSONRaw); ok && len(raw) > 0 {
		var days *int
		if err := json.Unmarshal(raw, &days); err != nil {
			return refDrug{}, fmt.Errorf("ref_drugs %s withdrawal_days: %w", id, err)
		}
		if days != nil {
			d.withdrawalDays = *days
		}
	}
	return d, nil
}

// js is a JSON column's value.
func js(v any) types.JSONRaw {
	b, err := json.Marshal(v)
	if err != nil {
		panic(err)
	}
	return b
}

// demoRows builds demo_account.sql's rows, statement by statement and in the
// same order. uid is the demo user; nowTS the reference time (demoClock);
// stamp the created_at/updated_at of every row (the SQL's column default
// now()).
func demoRows(uid string, nowTS time.Time, stamp string, drug refDrug) []row {
	var rows []row
	add := func(table, id string, values map[string]any) {
		if table != "organizations" {
			values["org_id"] = DemoOrgID
		}
		values["created_by"] = uid
		values["created_at"] = stamp
		values["updated_at"] = stamp
		rows = append(rows, row{table: table, id: id, values: values})
	}
	at := func(d time.Duration) string { return pattern.FormatTimestamp(nowTS.Add(d)) }
	day := func(days int) string { return nowTS.AddDate(0, 0, days).Format(time.DateOnly) }
	const dayDur = 24 * time.Hour

	add("organizations", DemoOrgID, map[string]any{
		"name":             "Demo Arıcılık",
		"country_code":     "TR",
		"currency":         "TRY",
		"hive_count_range": "up_to_50",
		"operation_type":   "migratory",
		"avatar_color":     "honey",
	})
	add("memberships", demoID("membership/owner"), map[string]any{
		"user_id": uid,
		"role":    "owner",
	})

	// Apiaries: Muğla pine honey, Ordu chestnut, Bursa village apiary.
	type apiary struct {
		name, tenure, water, notes string
		lon, lat                   float64
		alt, distance              int
	}
	apiaries := []apiary{
		{"Yayla Arılığı", "permitted", "Dere, 200 m", "Çam balı sezonu için ağustosta getirildi.", 28.3636, 37.2153, 820, 150},
		{"Kestane Arılığı", "rented", "Çeşme", "", 37.8764, 40.9839, 540, 40},
		{"Köy Arılığı", "owned", "Su deposu", "Kışlak; ana arı yetiştirme burada.", 29.0610, 40.1826, 310, 10},
	}
	apiaryIDs := make([]string, len(apiaries))
	for i, a := range apiaries {
		apiaryIDs[i] = demoID("apiary/%d", i+1)
		add("apiaries", apiaryIDs[i], map[string]any{
			"name":               a.name,
			"latitude":           js(a.lat),
			"longitude":          js(a.lon),
			"altitude_m":         js(a.alt),
			"land_tenure":        a.tenure,
			"water_source":       a.water,
			"vehicle_distance_m": js(a.distance),
			"notes":              a.notes,
		})
	}

	// Hives: 6, 5 and 4 per apiary, each with its queen and first location
	// entry. The village apiary's last hive died of varroa.
	type hive struct {
		id, apiary string
		n          int
		active     bool
	}
	var hives []hive
	n := 0
	for a, count := range []int{6, 5, 4} {
		apiaryID := apiaryIDs[a]
		for i := 1; i <= count; i++ {
			n++
			dead := a == 2 && i == 4
			queenID := demoID("queen/%d", n)
			hiveID := demoID("hive/%d", n)
			hives = append(hives, hive{id: hiveID, apiary: apiaryID, n: n, active: !dead})

			add("queens", queenID, map[string]any{
				"year":          js(pick(n%3 == 0, 2025, 2026)),
				"mark_color":    pick(n%3 == 0, "blue", "white"),
				"breed":         pick(n%2 == 0, "Kafkas", "Anadolu"),
				"source":        pick(n%4 == 0, "purchased", "own_rearing"),
				"mating_status": "mated",
				"wing_clipped":  n%5 == 0,
			})
			add("hives", hiveID, map[string]any{
				"number":      fmt.Sprint(n),
				"type":        pick(n%4 == 0, "dadant", "langstroth"),
				"status":      pick(dead, "dead", "active"),
				"apiary_id":   apiaryID,
				"queen_id":    pick(dead, "", queenID),
				"box_count":   pick(n%3 == 0, 1, 2),
				"frame_count": js(10),
				"source":      pick(n%3 == 0, "split", "purchase"),
				"quarantined": false,
			})
			add("hive_location_history", demoID("hive_location_history/%d", n), map[string]any{
				"hive_id":   hiveID,
				"apiary_id": apiaryID,
				"moved_at":  at(-90 * dayDur),
			})

			if dead {
				add("hive_status_events", demoID("hive_status_event/%d", n), map[string]any{
					"hive_id":     hiveID,
					"apiary_id":   apiaryID,
					"from_status": "active",
					"to_status":   "dead",
					"changed_at":  at(-12 * dayDur),
					"loss_reason": "varroa",
				})
				continue
			}

			// Two inspections: 40 and 10 days ago.
			minutes := time.Duration(n) * 7 * time.Minute
			add("inspections", demoID("inspection/%d/1", n), map[string]any{
				"hive_id":           hiveID,
				"apiary_id":         apiaryID,
				"inspected_at":      at(-40*dayDur + minutes),
				"queen_state":       "eggs",
				"bee_frames":        js(8 + n%3),
				"brood_frames":      js(4 + n%2),
				"honey_frames":      js(3),
				"temperament":       "calm",
				"swarm_signs":       js(false),
				"queen_cells":       "none",
				"disease_suspected": js(false),
				"data":              js(map[string]any{"actions": []string{"super_removed"}}),
			})
			add("inspections", demoID("inspection/%d/2", n), map[string]any{
				"hive_id":           hiveID,
				"apiary_id":         apiaryID,
				"inspected_at":      at(-10*dayDur + minutes),
				"queen_state":       pick(n == 5, "none", "seen"),
				"bee_frames":        js(6 + n%3),
				"brood_frames":      js(2 + n%2),
				"honey_frames":      js(4 + n%2),
				"temperament":       pick(n%4 == 0, "nervous", "calm"),
				"swarm_signs":       js(false),
				"queen_cells":       pick(n == 5, "emergency", "none"),
				"disease_suspected": js(n == 8),
				"data":              js(map[string]any{"actions": []string{"fed", "entrance_reduced"}}),
			})

			// Varroa count: 20 days ago, sugar roll, 300 bees.
			add("mite_counts", demoID("mite_count/%d", n), map[string]any{
				"hive_id":     hiveID,
				"apiary_id":   apiaryID,
				"counted_at":  at(-20 * dayDur),
				"method":      "sugar_roll",
				"mites":       2 + (n*7)%9,
				"sample_bees": js(300),
			})
		}
	}

	// hivesOf are the apiary's hives in creation order; the SQL's selects
	// have no order by, and the rows are independent of it.
	hivesOf := func(apiaryID string, activeOnly bool) []hive {
		var out []hive
		for _, h := range hives {
			if h.apiary == apiaryID && (h.active || !activeOnly) {
				out = append(out, h)
			}
		}
		return out
	}

	// Feeding: one session per apiary, 2:1 syrup, 10 days ago.
	for a, apiaryID := range apiaryIDs {
		groupID := demoID("feeding_group/%d", a+1)
		for _, h := range hivesOf(apiaryID, true) {
			add("feedings", demoID("feeding/%d", h.n), map[string]any{
				"hive_id":          h.id,
				"apiary_id":        apiaryID,
				"feeding_group_id": groupID,
				"fed_at":           at(-10 * dayDur),
				"kind":             "syrup_2_1",
				"amount":           3,
			})
		}
	}

	// Treatment: Bayvarol strips in the village apiary, 18 days ago; the
	// strips come out after 42 days. The drug is from the TR reference list.
	applicationID := demoID("treatment_application/1")
	for _, h := range hivesOf(apiaryIDs[2], true) {
		add("treatments", demoID("treatment/%d", h.n), map[string]any{
			"hive_id":            h.id,
			"apiary_id":          h.apiary,
			"ref_drug_id":        bayvarolID,
			"product_name":       drug.nameTR,
			"active_ingredient":  drug.activeIngredient,
			"batch_no":           "BV-2026-114",
			"dose":               2,
			"dose_unit":          drug.doseUnit,
			"started_at":         at(-18 * dayDur),
			"planned_removal_at": at(24 * dayDur),
			"withdrawal_days":    drug.withdrawalDays,
			"application_id":     applicationID,
		})
	}

	// Harvests: pine honey from the plateau apiary 55 days ago (all of its
	// hives), chestnut honey 70 days ago (its active hives).
	harvests := []struct {
		apiary     int
		kind       string
		units      int
		netKg      float64
		daysAgo    int
		activeOnly bool
	}{
		{0, "pine", 11, 162.5, 55, false},
		{1, "chestnut", 8, 96, 70, true},
	}
	for i, hv := range harvests {
		harvestID := demoID("harvest/%d", i+1)
		add("harvests", harvestID, map[string]any{
			"apiary_id":    apiaryIDs[hv.apiary],
			"harvested_at": at(-time.Duration(hv.daysAgo) * dayDur),
			"honey_kind":   hv.kind,
			"unit":         "super",
			"unit_count":   hv.units,
			"net_kg":       hv.netKg,
		})
		for _, h := range hivesOf(apiaryIDs[hv.apiary], hv.activeOnly) {
			add("harvest_hives", demoID("harvest_hive/%d/%d", i+1, h.n), map[string]any{
				"harvest_id": harvestID,
				"hive_id":    h.id,
			})
		}
	}

	// Tasks: one overdue, two in the coming days, one done.
	hive5 := ""
	for _, h := range hives {
		if h.n == 5 {
			hive5 = h.id
		}
	}
	tasks := []struct {
		title, due, apiary, hive, completed string
	}{
		{"Kışlık şurup kontrolü", at(-2 * dayDur), apiaryIDs[0], "", ""},
		{"5 numaralı kovanda ana arı kontrolü", at(2 * dayDur), apiaryIDs[0], hive5, ""},
		{"Şeritleri çıkar", at(24 * dayDur), apiaryIDs[2], "", ""},
		{"Kovan altlıklarını temizle", at(-6 * dayDur), apiaryIDs[1], "", at(-5 * dayDur)},
	}
	for i, t := range tasks {
		add("tasks", demoID("task/%d", i+1), map[string]any{
			"title":        t.title,
			"due_at":       t.due,
			"apiary_id":    t.apiary,
			"hive_id":      t.hive,
			"completed_at": t.completed,
			"source":       "manual",
		})
	}

	// Finance: honey sales and expenses. occurred_on is
	// (now_ts - interval)::date.
	transactions := []struct {
		kind, category string
		amount         float64
		daysAgo        int
		description    string
		apiary         string
	}{
		{"income", "honey", 48750, 45, "Çam balı, 162 kg", apiaryIDs[0]},
		{"income", "honey", 33600, 60, "Kestane balı, 96 kg", apiaryIDs[1]},
		{"expense", "feeding", 6200, 11, "Şeker, 200 kg", ""},
		{"expense", "treatment", 1450, 19, "Bayvarol, 2 kutu", apiaryIDs[2]},
		{"expense", "fuel_transport", 9800, 85, "Yaylaya nakliye", apiaryIDs[0]},
		{"expense", "land_rent", 5000, 80, "Kestane arılığı yer kirası", apiaryIDs[1]},
	}
	for i, t := range transactions {
		add("transactions", demoID("transaction/%d", i+1), map[string]any{
			"kind":        t.kind,
			"category":    t.category,
			"amount":      t.amount,
			"currency":    "TRY",
			"occurred_on": day(-t.daysAgo),
			"description": t.description,
			"apiary_id":   t.apiary,
		})
	}
	return rows
}

func pick[T any](cond bool, yes, no T) T {
	if cond {
		return yes
	}
	return no
}
