package sync_test

import (
	"encoding/json"
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"maps"
	"os"
	"path/filepath"
	"regexp"
	"slices"
	"sort"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/types"
)

// Tests of the table rules of push (P5.3). Each TestPush…Test ports the
// pgTAP file in its name: supabase/tests/database/<name>.test.sql. Direct
// INSERT/UPDATE statements of those files become pushes, because push is
// the only way clients write (K-7).

// Times after the fixtures' testTime (2026-11-10T10:15:30.123456Z): "now() +
// interval 'n seconds'" of the pgTAP files.
func later(n int) string { return fmt.Sprintf("2026-11-11T00:00:%02d.000Z", n) }

const refDrugAmitraz = "01900000-0000-7000-8000-000000000001"

func upsert(outboxID int, table string, payload map[string]any) map[string]any {
	return map[string]any{"id": outboxID, "table": table, "operation": "upsert", "payload": payload}
}

// with returns a copy of p with patch applied.
func with(p, patch map[string]any) map[string]any {
	out := maps.Clone(p)
	maps.Copy(out, patch)
	return out
}

// without returns a copy of p without keys.
func without(p map[string]any, keys ...string) map[string]any {
	out := maps.Clone(p)
	for _, k := range keys {
		delete(out, k)
	}
	return out
}

// rowPayload is `to_jsonb(row) - 'server_seq'`: the stored row as a client
// would send it, empty text as null.
func rowPayload(r *core.Record) map[string]any {
	out := map[string]any{}
	for _, f := range r.Collection().Fields {
		name := f.GetName()
		if name == appsync.FieldServerSeq {
			continue
		}
		switch v := r.Get(name).(type) {
		case types.JSONRaw:
			if len(v) == 0 {
				out[name] = nil
			} else {
				out[name] = json.RawMessage(v)
			}
		case string:
			if v == "" {
				out[name] = nil
			} else {
				out[name] = v
			}
		default:
			out[name] = v
		}
	}
	return out
}

func (f *pullFixture) member(t testing.TB, id, org, user string, role authz.Role) {
	t.Helper()
	f.insert(t, "memberships", id, map[string]any{"org_id": org, "user_id": user, "role": string(role)})
}

func (f *pullFixture) setField(t testing.TB, collection, id string, fields map[string]any) {
	t.Helper()
	r := f.record(t, collection, id)
	for k, v := range fields {
		r.Set(k, v)
	}
	mustSave(t, f.app, r)
}

func hivePayload(id, org, number, apiary string, extra map[string]any) map[string]any {
	return with(map[string]any{
		"id": id, "org_id": org, "number": number, "type": "langstroth", "status": "active",
		"apiary_id": apiary, "box_count": 1, "tag_code": nil, "queen_id": nil,
		"frame_count": nil, "source": nil, "marking": nil,
		"quarantined": false, "quarantined_at": nil, "quarantine_disease": nil,
		"created_at": later(0), "updated_at": later(0), "created_by": nil, "deleted_at": nil,
	}, extra)
}

// TestPushHivesConsistencyTest ports hives_consistency.test.sql: linked
// rows are in the same organization (missing_reference), a tag code is
// unique among an organization's live hives (conflict), a queen is not her
// own mother (invalid). The PostGIS point scenarios have no counterpart
// (latitude/longitude, TestPushSyncPushTest); moving a row to another
// organization is not possible by push (org_id is kept on update).
func TestPushHivesConsistencyTest(t *testing.T) {
	f := newPullFixture(t)
	// pOwner owns A and works in B: authz lets them write in both, only the
	// same-organization rule stops a cross-organization link.
	f.member(t, "c0000000-0000-0000-0000-0000000000c1", pOrgB, pOwner, authz.Worker)

	const (
		aApiary = "a1000000-0000-0000-0000-000000000001"
		eApiary = "e1000000-0000-0000-0000-000000000001"
		aQueen  = "a2000000-0000-0000-0000-000000000001"
		eQueen  = "e2000000-0000-0000-0000-000000000001"
		aHive   = "a3000000-0000-0000-0000-000000000001"
		aHive2  = "a3000000-0000-0000-0000-000000000002"
		aHive3  = "a3000000-0000-0000-0000-000000000003"
		eHive   = "e3000000-0000-0000-0000-000000000001"
		eHive2  = "e3000000-0000-0000-0000-000000000002"
	)
	f.apiary(t, aApiary, pOrgA, "Yayla")
	f.apiary(t, eApiary, pOrgB, "Ova")
	f.insert(t, "queens", aQueen, map[string]any{"org_id": pOrgA})
	f.insert(t, "queens", eQueen, map[string]any{"org_id": pOrgB})
	f.insert(t, "hives", aHive, map[string]any{
		"org_id": pOrgA, "number": "101", "tag_code": "TAG-1", "type": "langstroth",
		"status": "active", "apiary_id": aApiary, "box_count": 1,
	})
	f.insert(t, "hive_location_history", "a4000000-0000-0000-0000-000000000001", map[string]any{
		"org_id": pOrgA, "hive_id": aHive, "apiary_id": aApiary, "moved_at": "2026-04-01T05:00:00.000000Z",
	})
	stored := rowPayload(f.record(t, "hives", aHive))

	// Kovan → arılık ve ana
	wantOutcomes(t, "kovan kendi işletmesinin arılığına ve anasına bağlanır",
		f.push(t, pOwner, upsert(1, "hives", hivePayload(aHive2, pOrgA, "102", aApiary, map[string]any{"queen_id": aQueen}))),
		"1 ok true")
	wantOutcomes(t, "kovan başka işletmenin arılığına bağlanamaz; anası da verilemez",
		f.push(t, pOwner,
			upsert(2, "hives", hivePayload(aHive3, pOrgA, "103", eApiary, nil)),
			upsert(3, "hives", hivePayload(aHive3, pOrgA, "103", aApiary, map[string]any{"queen_id": eQueen})),
		),
		"2 rejected missing_reference", "3 rejected missing_reference")
	wantOutcomes(t, "kovan başka işletmenin arılığına taşınamaz, anası değiştirilemez",
		f.push(t, pOwner,
			upsert(4, "hives", with(stored, map[string]any{"apiary_id": eApiary, "updated_at": later(1)})),
			upsert(5, "hives", with(stored, map[string]any{"queen_id": eQueen, "updated_at": later(1)})),
		),
		"4 rejected missing_reference", "5 rejected missing_reference")
	if h := f.record(t, "hives", aHive); h.GetString("apiary_id") != aApiary || h.GetString("queen_id") != "" {
		t.Errorf("rejected moves left the hive: apiary %q queen %q", h.GetString("apiary_id"), h.GetString("queen_id"))
	}
	if _, err := f.app.FindRecordById("hives", aHive3); err == nil {
		t.Error("rejected hive 103 exists")
	}

	// "kovan, arılığı A'da kalırken B işletmesine geçirilemez" / "kovanı
	// olan arılık başka işletmeye geçirilemez": push keeps org_id.
	wantOutcomes(t, "org_id güncellemede değişmez",
		f.push(t, pOwner,
			upsert(6, "hives", with(stored, map[string]any{"org_id": pOrgB, "marking": "Mavi", "updated_at": later(2)})),
			upsert(7, "apiaries", with(rowPayload(f.record(t, "apiaries", aApiary)), map[string]any{"org_id": pOrgB, "updated_at": later(2)})),
		),
		"6 ok true", "7 ok true")
	if h, a := f.record(t, "hives", aHive), f.record(t, "apiaries", aApiary); h.GetString("org_id") != pOrgA || a.GetString("org_id") != pOrgA || h.GetString("marking") != "Mavi" {
		t.Errorf("org_id moved: hive %q apiary %q, marking %q", h.GetString("org_id"), a.GetString("org_id"), h.GetString("marking"))
	}

	// Ana → anne ana
	wantOutcomes(t, "ananın annesi başka işletmeden olamaz",
		f.push(t, pOwner, upsert(8, "queens", map[string]any{
			"id": "a2000000-0000-0000-0000-000000000002", "org_id": pOrgA, "mother_queen_id": eQueen,
			"created_at": later(0), "updated_at": later(0),
		})),
		"8 rejected missing_reference")
	wantOutcomes(t, "ana kendi annesi olamaz",
		f.push(t, pOwner, upsert(9, "queens", with(rowPayload(f.record(t, "queens", aQueen)), map[string]any{
			"mother_queen_id": aQueen, "updated_at": later(3),
		}))),
		"9 rejected invalid")

	// Geçmiş → kovan ve arılık
	history := func(org, hive, apiary string) map[string]any {
		return map[string]any{
			"id": "a4000000-0000-0000-0000-000000000002", "org_id": org, "hive_id": hive, "apiary_id": apiary,
			"moved_at": later(0), "created_at": later(0), "updated_at": later(0),
		}
	}
	wantOutcomes(t, "geçmiş kaydı başka işletmenin arılığını ya da kovanını gösteremez",
		f.push(t, pOwner,
			upsert(10, "hive_location_history", history(pOrgA, aHive, eApiary)),
			upsert(11, "hive_location_history", history(pOrgB, aHive, eApiary)),
		),
		"10 rejected missing_reference", "11 rejected missing_reference")

	// Etiket kodu
	wantOutcomes(t, "aynı etiket kodu işletmede iki kovanda olamaz",
		f.push(t, pOwner, upsert(12, "hives", hivePayload(aHive3, pOrgA, "103", aApiary, map[string]any{"tag_code": "TAG-1"}))),
		"12 rejected conflict")
	wantOutcomes(t, "başka işletme aynı etiket kodunu kullanabilir",
		f.push(t, pOwner, upsert(13, "hives", hivePayload(eHive, pOrgB, "101", eApiary, map[string]any{"tag_code": "TAG-1"}))),
		"13 ok true")
	wantOutcomes(t, "kovan silinir",
		f.push(t, pOwner, map[string]any{"id": 14, "table": "hives", "operation": "delete",
			"payload": with(rowPayload(f.record(t, "hives", aHive)), map[string]any{"updated_at": later(4), "deleted_at": later(4)})}),
		"14 ok true")
	wantOutcomes(t, "silinen kovanın etiket kodu yeni kovanda kullanılabilir",
		f.push(t, pOwner, upsert(15, "hives", hivePayload(aHive3, pOrgA, "103", aApiary, map[string]any{"tag_code": "TAG-1"}))),
		"15 ok true")

	// Konum: out of range is invalid (the PostGIS point test's counterpart).
	wantOutcomes(t, "arılık konumu aralık dışında olamaz",
		f.push(t, pOwner, upsert(16, "apiaries", map[string]any{
			"id": "a1000000-0000-0000-0000-000000000002", "org_id": pOrgA, "name": "Alan",
			"latitude": 91, "longitude": 40, "created_at": later(0), "updated_at": later(0),
		})),
		"16 rejected invalid")

	// Yalnız B üyesi
	wantOutcomes(t, "A'nın arılık ve ana id'sini bilen B üyesi kovanını onlara bağlayamaz",
		f.push(t, pOutsider,
			upsert(17, "hives", hivePayload(eHive2, pOrgB, "102", aApiary, nil)),
			upsert(18, "hives", hivePayload(eHive2, pOrgB, "102", eApiary, map[string]any{"queen_id": aQueen})),
		),
		"17 rejected missing_reference", "18 rejected missing_reference")
}

// newLotFixture is the fixture of lot_publish.test.sql: lot ab01 published,
// ab02 not, in A (pOwner owner, pWorker worker).
func newLotFixture(t *testing.T) *pullFixture {
	t.Helper()
	f := newPullFixture(t)
	for _, l := range []struct {
		id        string
		seq       int
		published bool
	}{
		{"ab000000-0000-0000-0000-000000000001", 7, true},
		{"ab000000-0000-0000-0000-000000000002", 8, false},
	} {
		f.insert(t, "lots", l.id, map[string]any{
			"org_id": pOrgA, "year": 2026, "seq": l.seq, "honey_kind": "pine", "status": "open",
			"origin": "Ula, Muğla", "published": l.published, "public_producer": true,
			"public_origin": true, "public_lab": true, "public_report": true,
		})
	}
	return f
}

func lotFlags(r *core.Record) string {
	out := make([]string, 0, 5)
	for _, name := range []string{"published", "public_producer", "public_origin", "public_lab", "public_report"} {
		out = append(out, fmt.Sprintf("%s=%v", name, r.GetBool(name)))
	}
	return strings.Join(out, " ")
}

// TestPushLotPublishTest ports the guard_lot_publication scenarios of
// lot_publish.test.sql. The lot_public_page, privilege and bucket scenarios
// are P5.10's.
func TestPushLotPublishTest(t *testing.T) {
	f := newLotFixture(t)
	const (
		lot1 = "ab000000-0000-0000-0000-000000000001"
		lot3 = "ab000000-0000-0000-0000-000000000003"
		lot4 = "ab000000-0000-0000-0000-000000000004"
		lot5 = "ab000000-0000-0000-0000-000000000005"
	)
	newLot := func(id string, seq int, extra map[string]any) map[string]any {
		return with(map[string]any{
			"id": id, "org_id": pOrgA, "year": 2026, "seq": seq, "honey_kind": "pine", "status": "open",
			"created_at": later(0), "updated_at": later(0),
		}, extra)
	}

	// Worker
	wantOutcomes(t, "worker'ın sync_push ile lot yazması kabul edilir",
		f.push(t, pWorker, upsert(0, "lots", with(rowPayload(f.record(t, "lots", lot1)), map[string]any{
			"published": false, "public_origin": false, "public_lab": false, "origin": "Ula", "updated_at": later(1),
		}))),
		"0 ok true")
	l := f.record(t, "lots", lot1)
	if l.GetString("origin") != "Ula" || !l.GetBool("published") || !l.GetBool("public_origin") || !l.GetBool("public_lab") {
		t.Errorf("worker lotu düzenler ama yayımı ve alanları değiştiremez: origin %q, %s", l.GetString("origin"), lotFlags(l))
	}
	wantOutcomes(t, "worker lot ekler",
		f.push(t, pWorker,
			upsert(1, "lots", newLot(lot3, 9, map[string]any{"published": true})),
			upsert(2, "lots", newLot(lot5, 11, map[string]any{"published": true, "public_lab": false})),
		),
		"1 ok true", "2 ok true")
	if got := lotFlags(f.record(t, "lots", lot3)); got != "published=false public_producer=true public_origin=true public_lab=true public_report=true" {
		t.Errorf("worker'ın eklediği lot yayımda değil: %s", got)
	}
	// A new lot takes the public_* columns as sent (coalesce(new, true)).
	if got := lotFlags(f.record(t, "lots", lot5)); got != "published=false public_producer=true public_origin=true public_lab=false public_report=true" {
		t.Errorf("worker's new lot keeps the sent public_*: %s", got)
	}

	// Owner
	wantOutcomes(t, "owner yayımdan kaldırır ve alan seçer",
		f.push(t, pOwner, upsert(3, "lots", with(rowPayload(f.record(t, "lots", lot1)), map[string]any{
			"published": false, "public_report": false, "updated_at": later(2),
		}))),
		"3 ok true")
	if l := f.record(t, "lots", lot1); l.GetBool("published") || l.GetBool("public_report") {
		t.Errorf("owner's write: %s", lotFlags(l))
	}
	wantOutcomes(t, "sync_push ile lot yazar",
		f.push(t, pOwner, upsert(4, "lots", with(rowPayload(f.record(t, "lots", lot1)), map[string]any{
			"published": true, "updated_at": later(5),
		}))),
		"4 ok true")
	if !f.record(t, "lots", lot1).GetBool("published") {
		t.Error("owner sync_push ile yayımlar")
	}

	// Eski uygulama yayım kolonlarını göndermez.
	old := without(rowPayload(f.record(t, "lots", lot1)), "published", "public_producer", "public_origin", "public_lab", "public_report")
	wantOutcomes(t, "eski uygulamanın lot yazması kabul edilir",
		f.push(t, pOwner, upsert(5, "lots", with(old, map[string]any{"origin": "Ula, Muğla", "updated_at": later(10)}))),
		"5 ok true")
	if l := f.record(t, "lots", lot1); l.GetString("origin") != "Ula, Muğla" || !l.GetBool("published") || l.GetBool("public_report") {
		t.Errorf("eski uygulamanın yazması yayımı ve alanları korur: origin %q, %s", l.GetString("origin"), lotFlags(l))
	}
	wantOutcomes(t, "eski uygulama yayım kolonları olmadan yeni lot ekler",
		f.push(t, pOwner, upsert(6, "lots", newLot(lot4, 10, nil))),
		"6 ok true")
	if got := lotFlags(f.record(t, "lots", lot4)); got != "published=false public_producer=true public_origin=true public_lab=true public_report=true" {
		t.Errorf("eski uygulamanın lotu yayımda değil, alanlar varsayılan: %s", got)
	}
}

// TestPushHiveQuarantineTest ports hive_quarantine.test.sql. The direct
// UPDATE scenarios (CHECKs) become pushes.
func TestPushHiveQuarantineTest(t *testing.T) {
	f := newPullFixture(t)
	const (
		apiary = "a1000000-0000-0000-0000-000000000001"
		hive   = "a3000000-0000-0000-0000-000000000001"
		hive2  = "a3000000-0000-0000-0000-000000000002"
	)
	f.apiary(t, apiary, pOrgA, "Kızılçam")
	f.insert(t, "hives", hive, map[string]any{
		"org_id": pOrgA, "number": "101", "type": "langstroth", "status": "active", "apiary_id": apiary, "box_count": 1,
	})
	quarantine := func(id string) string {
		h := f.record(t, "hives", id)
		return fmt.Sprintf("%v %q %q", h.GetBool("quarantined"), h.GetString("quarantined_at"), h.GetString("quarantine_disease"))
	}
	if got := quarantine(hive); got != `false "" ""` {
		t.Errorf("yeni kovan karantinada değil: %s", got)
	}

	base := rowPayload(f.record(t, "hives", hive))
	wantOutcomes(t, "tutarlılık",
		f.push(t, pWorker,
			upsert(0, "hives", with(base, map[string]any{"quarantined": true, "updated_at": later(1)})),
			upsert(1, "hives", with(base, map[string]any{"quarantine_disease": "american_foulbrood", "updated_at": later(1)})),
			upsert(2, "hives", with(base, map[string]any{"quarantined": true, "quarantined_at": later(1), "quarantine_disease": " ", "updated_at": later(1)})),
		),
		// karantinadaki kovanın başlangıç zamanı olmalı; karantinada
		// olmayan kovanın hastalığı olmaz; hastalık kimliği boş olamaz
		"0 rejected invalid", "1 rejected invalid", "2 rejected invalid")

	wantOutcomes(t, "worker sync_push ile kovanı karantinaya alır",
		f.push(t, pWorker, upsert(3, "hives", with(base, map[string]any{
			"quarantined": true, "quarantined_at": "2026-11-02T09:00:00Z",
			"quarantine_disease": "american_foulbrood", "updated_at": later(1),
		}))),
		"3 ok true")
	if got, status := quarantine(hive), f.record(t, "hives", hive).GetString("status"); got != `true "2026-11-02T09:00:00.000000Z" "american_foulbrood"` || status != "active" {
		t.Errorf("karantinadaki kovan aktif kalır: %s, %s", got, status)
	}

	// Eski uygulama karantina kolonlarını göndermez.
	old := without(rowPayload(f.record(t, "hives", hive)), "quarantined", "quarantined_at", "quarantine_disease")
	wantOutcomes(t, "eski uygulamanın kovan yazması kabul edilir",
		f.push(t, pWorker, upsert(4, "hives", with(old, map[string]any{"marking": "Mavi", "updated_at": later(2)}))),
		"4 ok true")
	if got, marking := quarantine(hive), f.record(t, "hives", hive).GetString("marking"); got != `true "2026-11-02T09:00:00.000000Z" "american_foulbrood"` || marking != "Mavi" {
		t.Errorf("eski uygulamanın yazması karantinayı korur: %s, %q", got, marking)
	}
	wantOutcomes(t, "eski uygulama karantina kolonları olmadan yeni kovan ekler",
		f.push(t, pWorker, upsert(5, "hives", map[string]any{
			"id": hive2, "org_id": pOrgA, "number": "102", "type": "langstroth", "status": "active",
			"apiary_id": apiary, "box_count": 1, "created_at": later(0), "updated_at": later(0),
		})),
		"5 ok true")
	if got := quarantine(hive2); got != `false "" ""` {
		t.Errorf("eski uygulamanın eklediği kovan karantinada değil: %s", got)
	}

	wantOutcomes(t, "yeni uygulama karantinayı kaldırır",
		f.push(t, pWorker, upsert(6, "hives", with(rowPayload(f.record(t, "hives", hive)), map[string]any{
			"quarantined": false, "quarantined_at": nil, "quarantine_disease": nil, "updated_at": later(3),
		}))),
		"6 ok true")
	if got := quarantine(hive); got != `false "" ""` {
		t.Errorf("karantinadan çıkan kovanın zamanı ve hastalığı boş: %s", got)
	}
}

// TestPushCustomersRLSTest ports the write scenarios of
// customers_rls.test.sql; who sees customers and payments is pull's
// (TestPullFinanceRoles).
func TestPushCustomersRLSTest(t *testing.T) {
	f := newPullFixture(t)
	const (
		c1  = "c1000000-0000-0000-0000-000000000001"
		c3  = "c1000000-0000-0000-0000-000000000003"
		c9  = "c9000000-0000-0000-0000-000000000001"
		f11 = "f1000000-0000-0000-0000-000000000001"
		f12 = "f1000000-0000-0000-0000-000000000002"
		f14 = "f1000000-0000-0000-0000-000000000004"
		f91 = "f9000000-0000-0000-0000-000000000001"
		d14 = "d1000000-0000-0000-0000-000000000004"
	)
	f.insert(t, "customers", c1, map[string]any{"org_id": pOrgA, "name": "Ayşe Hanım", "phone": "+90 532 000 00 00"})
	f.insert(t, "customers", c9, map[string]any{"org_id": pOrgB, "name": "Mehmet Bey"})
	for _, tr := range []struct{ id, org, customer string }{{f11, pOrgA, c1}, {f12, pOrgA, ""}, {f91, pOrgB, c9}} {
		f.insert(t, "transactions", tr.id, map[string]any{
			"org_id": tr.org, "kind": "income", "category": "honey", "amount": 900,
			"currency": "TRY", "occurred_on": "2026-10-01", "customer_id": tr.customer,
		})
	}
	f.insert(t, "customer_payments", "d1000000-0000-0000-0000-000000000001", map[string]any{
		"org_id": pOrgA, "transaction_id": f11, "amount": 2000, "paid_on": "2026-10-05",
	})

	customer := func(id, org, name string) map[string]any {
		return map[string]any{
			"id": id, "org_id": org, "name": name, "phone": nil, "address": nil, "notes": nil,
			"created_at": "2026-11-04T09:00:00.000Z", "updated_at": later(0), "created_by": nil, "deleted_at": nil,
		}
	}
	transaction := func(id, org, kind, category, customer string) map[string]any {
		return map[string]any{
			"id": id, "org_id": org, "kind": kind, "category": category, "amount": 100,
			"currency": "TRY", "occurred_on": "2026-10-01", "description": nil, "receipt_path": nil,
			"apiary_id": nil, "lot_id": nil, "transport_id": nil, "lot_sale_id": nil, "customer_id": customer,
			"created_at": later(0), "updated_at": later(0), "created_by": nil, "deleted_at": nil,
		}
	}
	payment := func(id, org, tx string, amount float64) map[string]any {
		return map[string]any{
			"id": id, "org_id": org, "transaction_id": tx, "amount": amount, "paid_on": "2026-10-10",
			"created_at": later(0), "updated_at": later(0), "created_by": nil, "deleted_at": nil,
		}
	}

	// B'nin owner'ı
	wantOutcomes(t, "B'nin owner'ı",
		f.push(t, pOutsider,
			upsert(1, "customers", customer("c9000000-0000-0000-0000-000000000002", pOrgA, "X")),
			upsert(2, "customers", with(rowPayload(f.record(t, "customers", c1)), map[string]any{"name": "Y", "updated_at": later(1)})),
			upsert(3, "transactions", transaction("f9000000-0000-0000-0000-000000000002", pOrgB, "income", "honey", c1)),
			upsert(4, "customer_payments", payment("d9000000-0000-0000-0000-000000000002", pOrgB, f11, 100)),
		),
		// başka işletmeye müşteri ekleyemez; başka işletmenin müşterisini
		// güncelleyemez; başka işletmenin müşterisine satış ve satışına
		// tahsilat bağlayamaz
		"1 rejected forbidden", "2 rejected forbidden", "3 rejected missing_reference", "4 rejected missing_reference")
	if got := f.record(t, "customers", c1).GetString("name"); got != "Ayşe Hanım" {
		t.Errorf("A's customer renamed to %q", got)
	}

	// A'nın partner'ı
	wantOutcomes(t, "A'nın partner'ı",
		f.push(t, pPartner,
			upsert(5, "customer_payments", payment("d1000000-0000-0000-0000-000000000002", pOrgA, f11, 4000)),
			upsert(6, "customer_payments", payment("d1000000-0000-0000-0000-000000000003", pOrgA, f12, 100)),
			upsert(7, "customer_payments", payment("d1000000-0000-0000-0000-000000000003", pOrgA, f11, 0)),
			upsert(8, "transactions", transaction("f1000000-0000-0000-0000-000000000003", pOrgA, "expense", "other", c1)),
			upsert(9, "customers", customer("c1000000-0000-0000-0000-000000000002", pOrgA, "  ")),
		),
		// müşterili satışa tahsilat ekler; müşterisiz satışa tahsilat
		// alınamaz; tutar pozitif; müşteri yalnız gelire bağlanır; ad boş
		// olamaz
		"5 ok true", "6 rejected invalid", "7 rejected invalid", "8 rejected invalid", "9 rejected invalid")

	sale := transaction(f14, pOrgA, "income", "honey", c3)
	sale["amount"] = 56000
	wantOutcomes(t, "sync_push müşteri, müşterili satış ve tahsilatı yazar",
		f.push(t, pPartner,
			upsert(1, "customers", with(customer(c3, pOrgA, "Toptancı"), map[string]any{"address": "Rize"})),
			upsert(2, "transactions", sale),
			upsert(3, "customer_payments", payment(d14, pOrgA, f14, 20000)),
			upsert(4, "customers", with(customer(c3, pOrgA, "Toptancı Ali"), map[string]any{"address": "Rize", "updated_at": later(1)})),
		),
		"1 ok true", "2 ok true", "3 ok true", "4 ok true")
	if got := f.record(t, "customers", c3).GetString("name"); got != "Toptancı Ali" {
		t.Errorf("müşteri durum kaydı: son yazan kazanır: %q", got)
	}
	wantOutcomes(t, "sync_push tahsilatın silinmesini işler",
		f.push(t, pPartner, map[string]any{"id": 1, "table": "customer_payments", "operation": "delete",
			"payload": with(payment(d14, pOrgA, f14, 1), map[string]any{"updated_at": later(5), "deleted_at": later(5)})}),
		"1 ok true")
	if p := f.record(t, "customer_payments", d14); p.GetFloat("amount") != 20000 || p.GetString("deleted_at") == "" {
		t.Errorf("tahsilat olay kaydı: silme yalnız deleted_at yazar, tutar değişmez: %v %q", p.GetFloat("amount"), p.GetString("deleted_at"))
	}

	// A'nın worker'ı
	wantOutcomes(t, "worker senkronla da müşteri yazamaz",
		f.push(t, pWorker, upsert(1, "customers", customer("c1000000-0000-0000-0000-000000000005", pOrgA, "X"))),
		"1 rejected forbidden")
}

// TestPushTreatmentGroupsTest ports treatment_groups.test.sql.
func TestPushTreatmentGroupsTest(t *testing.T) {
	f := newPullFixture(t)
	const (
		aApiary = "a1000000-0000-0000-0000-000000000001"
		eApiary = "e1000000-0000-0000-0000-000000000001"
		aHive   = "a3000000-0000-0000-0000-000000000001"
		eHive   = "e3000000-0000-0000-0000-000000000001"
		aInsp   = "a5000000-0000-0000-0000-000000000001"
		aTreat  = "a9000000-0000-0000-0000-000000000001"
		aTreat2 = "a9000000-0000-0000-0000-000000000002"
		eTreat  = "e9000000-0000-0000-0000-000000000001"
	)
	f.apiary(t, aApiary, pOrgA, "Yayla")
	f.apiary(t, eApiary, pOrgB, "Ova")
	for _, h := range []struct{ id, org, apiary string }{{aHive, pOrgA, aApiary}, {eHive, pOrgB, eApiary}} {
		f.insert(t, "hives", h.id, map[string]any{
			"org_id": h.org, "number": "101", "type": "langstroth", "status": "active", "apiary_id": h.apiary, "box_count": 1,
		})
	}
	f.insert(t, "inspections", aInsp, map[string]any{
		"org_id": pOrgA, "hive_id": aHive, "apiary_id": aApiary, "inspected_at": testTime, "data": map[string]any{},
	})
	for _, tr := range []struct{ id, org, hive, apiary, app string }{
		{aTreat, pOrgA, aHive, aApiary, "a7000000-0000-0000-0000-000000000001"},
		{eTreat, pOrgB, eHive, eApiary, ""},
	} {
		f.insert(t, "treatments", tr.id, map[string]any{
			"org_id": tr.org, "hive_id": tr.hive, "apiary_id": tr.apiary, "ref_drug_id": refDrugAmitraz,
			"product_name": "Amitraz", "active_ingredient": "amitraz", "dose": 2, "dose_unit": "strip",
			"started_at": testTime, "withdrawal_days": 0, "application_id": tr.app,
		})
	}

	treatment := func(id string, extra map[string]any) map[string]any {
		return with(map[string]any{
			"id": id, "org_id": pOrgA, "hive_id": aHive, "apiary_id": aApiary,
			"ref_drug_id": refDrugAmitraz, "drug_id": nil,
			"product_name": "Amitraz", "active_ingredient": "amitraz", "batch_no": nil,
			"dose": 2, "dose_unit": "strip", "started_at": "2026-10-25T09:00:00.000Z",
			"planned_removal_at": nil, "withdrawal_days": 0,
			"created_at": later(0), "updated_at": later(0), "created_by": nil, "deleted_at": nil,
		}, extra)
	}
	media := func(id string, extra map[string]any) map[string]any {
		return with(map[string]any{
			"id": id, "org_id": pOrgA, "hive_id": aHive, "inspection_id": nil, "treatment_id": nil,
			"kind": "photo", "storage_path": pOrgA + "/" + aHive + "/" + id + ".jpg",
			"captured_at": later(0), "byte_size": 1000, "duration_ms": nil,
			"created_at": later(0), "updated_at": later(0), "created_by": nil, "deleted_at": nil,
		}, extra)
	}

	wantOutcomes(t, "sync_push grubu ve uygulamaya bağlı fotoğrafı yazar",
		f.push(t, pWorker,
			upsert(1, "treatments", treatment(aTreat2, map[string]any{"application_id": "a7000000-0000-0000-0000-000000000002"})),
			upsert(2, "media", media("a6000000-0000-0000-0000-000000000001", map[string]any{"treatment_id": aTreat2})),
		),
		"1 ok true", "2 ok true")
	if got := f.record(t, "treatments", aTreat2).GetString("application_id"); got != "a7000000-0000-0000-0000-000000000002" {
		t.Errorf("grup kimliği saklanır: %q", got)
	}
	wantOutcomes(t, "grupsuz kayıt hâlâ yazılır",
		f.push(t, pWorker, upsert(1, "treatments", without(treatment("a9000000-0000-0000-0000-000000000003", nil), "application_id"))),
		"1 ok true")
	wantOutcomes(t, "fotoğraf",
		f.push(t, pWorker,
			upsert(1, "media", media("a6000000-0000-0000-0000-000000000002", map[string]any{"treatment_id": eTreat})),
			upsert(2, "media", media("a6000000-0000-0000-0000-000000000003", map[string]any{"inspection_id": aInsp, "treatment_id": aTreat})),
			upsert(3, "media", media("a6000000-0000-0000-0000-000000000004", map[string]any{"treatment_id": aTreat})),
		),
		// başka işletmenin uygulamasına bağlanamaz; hem muayeneye hem
		// uygulamaya bağlı olamaz; kendi uygulamasına reçete fotoğrafı ekler
		"1 rejected missing_reference", "2 rejected invalid", "3 ok true")
}

// TestPushTasksPlanTest ports tasks_plan.test.sql.
func TestPushTasksPlanTest(t *testing.T) {
	f := newPullFixture(t)
	const (
		apiary = "a1000000-0000-0000-0000-000000000001"
		aDrug  = "ad000000-0000-0000-0000-000000000001"
		eDrug  = "ed000000-0000-0000-0000-000000000001"
	)
	f.apiary(t, apiary, pOrgA, "Yayla")
	f.insert(t, "drugs", aDrug, map[string]any{"org_id": pOrgA, "name": "Kendi timol jelim", "active_ingredient": "thymol", "dose_unit": "g"})
	f.insert(t, "drugs", eDrug, map[string]any{"org_id": pOrgB, "name": "Oxalsäure", "active_ingredient": "oxalic_acid", "dose_unit": "ml"})

	task := func(n int, extra map[string]any) map[string]any {
		return with(map[string]any{
			"id": fmt.Sprintf("a7000000-0000-0000-0000-00000000000%d", n), "org_id": pOrgA,
			"title": "İlaçlama", "due_at": "2026-11-05T09:00:00.000Z", "apiary_id": apiary, "hive_id": nil,
			"assigned_to": nil, "completed_at": nil, "source": "manual", "source_id": nil,
			"ref_drug_id": nil, "drug_id": nil, "dose": nil,
			"created_at": later(0), "updated_at": later(0), "created_by": nil, "deleted_at": nil,
		}, extra)
	}
	wantOutcomes(t, "planlı ilaçlama görevleri",
		f.push(t, pWorker,
			upsert(1, "tasks", task(1, map[string]any{"ref_drug_id": refDrugAmitraz, "dose": 2})),
			upsert(2, "tasks", task(2, map[string]any{"drug_id": aDrug, "dose": 50})),
			upsert(3, "tasks", task(3, map[string]any{"drug_id": eDrug, "dose": 5})),
			upsert(4, "tasks", task(4, map[string]any{"ref_drug_id": refDrugAmitraz})),
			upsert(5, "tasks", task(5, map[string]any{"dose": 2})),
			upsert(6, "tasks", task(6, map[string]any{"ref_drug_id": refDrugAmitraz, "drug_id": aDrug, "dose": 2})),
			upsert(7, "tasks", task(7, map[string]any{"apiary_id": nil, "ref_drug_id": refDrugAmitraz, "dose": 2})),
			upsert(8, "tasks", task(8, map[string]any{"title": nil, "source": "treatment",
				"source_id": "b0000000-0000-0000-0000-000000000001", "ref_drug_id": refDrugAmitraz, "dose": 2})),
		),
		// worker referans ilaçla ve işletmenin ilacıyla görev açar;
		// başka işletmenin ilacına bağlanamaz; ilaçlı görev doz taşır; doz
		// ilaçsız yazılamaz; en çok bir ilaç; ilaçlı görev arılığa
		// bağlıdır; otomatik görev ilaç taşımaz
		"1 ok true", "2 ok true", "3 rejected missing_reference", "4 rejected invalid",
		"5 rejected invalid", "6 rejected invalid", "7 rejected invalid", "8 rejected invalid")

	wantOutcomes(t, "sync_push ilaçlı görevi yazar",
		f.push(t, pWorker, upsert(1, "tasks", task(9, map[string]any{"title": "İlaçlama · Amitraz", "ref_drug_id": refDrugAmitraz, "dose": 2}))),
		"1 ok true")
	if r := f.record(t, "tasks", "a7000000-0000-0000-0000-000000000009"); r.GetString("ref_drug_id") != refDrugAmitraz || jsonField(r, "dose") != "2" {
		t.Errorf("ilaç ve doz senkronla yazılır: %q %s", r.GetString("ref_drug_id"), jsonField(r, "dose"))
	}
}

// orgPayload is business_profile.test.sql's org_payload.
func orgPayload() map[string]any {
	return map[string]any{
		"id": pOrgA, "name": "Petek Arıcılık Ltd.", "country_code": "TR", "currency": "EUR",
		"tr_registration_no": nil, "tr_aks_no": nil, "hive_count_range": nil,
		"tr_aks_hive_count": nil, "operation_type": "stationary", "avatar_color": "honey",
		"logo_path":  pOrgA + "/f0000000-0000-0000-0000-000000000001.jpg",
		"created_at": "2026-10-01T00:00:00Z", "updated_at": "2026-11-05T10:00:00Z",
		"created_by": nil, "deleted_at": nil,
	}
}

// TestPushBusinessProfileTest ports the push scenarios of
// business_profile.test.sql. create_organization is P5.4's, the logo bucket
// P6.1's.
func TestPushBusinessProfileTest(t *testing.T) {
	f := newPullFixture(t)
	f.setField(t, "organizations", pOrgA, map[string]any{"updated_at": octFirst})
	for _, id := range []string{"c0000000-0000-0000-0000-000000000001", "c0000000-0000-0000-0000-000000000003"} {
		f.setField(t, "memberships", id, map[string]any{"updated_at": octFirst})
	}
	if got := f.record(t, "organizations", pOrgA).GetString("operation_type"); got != "migratory" {
		t.Errorf("var olan işletme gezginci kalır: %q", got)
	}

	wantOutcomes(t, "logo yolu başka işletmenin klasöründe olamaz",
		f.push(t, pPartner, upsert(1, "organizations", with(orgPayload(), map[string]any{
			"logo_path": pOrgB + "/f0000000-0000-0000-0000-000000000001.jpg",
		}))),
		"1 rejected invalid")

	// Partner işletmeyi sync_push ile günceller
	wantOutcomes(t, "partner işletmeyi sync_push ile günceller",
		f.push(t, pPartner, upsert(1, "organizations", orgPayload())),
		"1 ok true")
	o := f.record(t, "organizations", pOrgA)
	if got := []string{o.GetString("name"), o.GetString("currency"), o.GetString("operation_type"), o.GetString("avatar_color")}; !slices.Equal(got, []string{"Petek Arıcılık Ltd.", "EUR", "stationary", "honey"}) {
		t.Errorf("işletmenin yeni alanları yazıldı: %q", got)
	}

	// Worker ve viewer güncelleyemez
	newer := with(orgPayload(), map[string]any{"operation_type": "migratory", "updated_at": "2026-11-06T00:00:00Z"})
	wantOutcomes(t, "worker ve viewer işletmeyi güncelleyemez",
		f.push(t, pWorker, upsert(1, "organizations", newer)), "1 rejected forbidden")
	wantOutcomes(t, "viewer",
		f.push(t, pViewer, upsert(1, "organizations", newer)), "1 rejected forbidden")

	// Eski sürüm üyenin adını gönderir: kabul edilir ama uygulanmaz.
	wantOutcomes(t, "eski sürümün gönderdiği ad yok sayılır",
		f.push(t, pWorker, upsert(1, "memberships", map[string]any{
			"id": "c0000000-0000-0000-0000-000000000003", "org_id": pOrgA, "user_id": pWorker,
			"role": "owner", "full_name": "  Mehmet Kaya ",
			"created_at": "2026-10-01T00:00:00Z", "updated_at": "2026-11-05T10:00:00Z",
			"created_by": nil, "deleted_at": nil,
		})),
		"1 ok false")
	if m := f.record(t, "memberships", "c0000000-0000-0000-0000-000000000003"); m.GetString("role") != "worker" || m.GetString("updated_at") != octFirst {
		t.Errorf("üyelik değişmez, payload'daki rol yok sayılır: %q %q", m.GetString("role"), m.GetString("updated_at"))
	}
	wantOutcomes(t, "başkasının adı yazılamaz",
		f.push(t, pWorker, upsert(1, "memberships", map[string]any{
			"id": "c0000000-0000-0000-0000-000000000001", "full_name": "Sahte", "updated_at": "2026-11-05T10:00:00Z",
		})),
		"1 rejected forbidden")
	wantOutcomes(t, "üyelik senkronla silinmez",
		f.push(t, pWorker, map[string]any{"id": 1, "table": "memberships", "operation": "delete", "payload": map[string]any{
			"id": "c0000000-0000-0000-0000-000000000003", "updated_at": "2026-11-05T11:00:00Z", "deleted_at": "2026-11-05T11:00:00Z",
		}}),
		"1 rejected unsupported")
	// A removed member's own row is not "own" any more (deleted_at set).
	wantOutcomes(t, "removed member",
		f.push(t, pRemoved, upsert(1, "memberships", map[string]any{
			"id": "c0000000-0000-0000-0000-000000000006", "updated_at": "2026-11-05T10:00:00Z",
		})),
		"1 rejected forbidden")
}

// TestPushSyncPushTestOrganizations ports the organization scenarios of
// sync_push.test.sql: only owners (and partners) update, push opens no
// organization. Plus: columns an older payload lacks keep their values;
// an older updated_at is not applied; a non-member is forbidden.
func TestPushSyncPushTestOrganizations(t *testing.T) {
	f := newPullFixture(t)
	f.setField(t, "organizations", pOrgA, map[string]any{"updated_at": octFirst, "avatar_color": "honey"})
	// The payload of schema version 1: no operation_type, avatar_color,
	// logo_path, tr_aks_hive_count.
	change := map[string]any{
		"id": pOrgA, "name": "Petek Arıcılık Ltd.", "country_code": "TR", "currency": "TRY",
		"tr_registration_no": nil, "tr_aks_no": nil, "hive_count_range": nil,
		"created_at": "2026-10-01T00:00:00Z", "updated_at": "2026-10-23T08:00:00Z",
		"created_by": nil, "deleted_at": nil,
	}

	wantOutcomes(t, "worker işletmeyi güncelleyemez",
		f.push(t, pWorker, upsert(11, "organizations", change)), "11 rejected forbidden")
	wantOutcomes(t, "owner işletmeyi günceller; yeni işletme açılamaz",
		f.push(t, pOwner,
			upsert(12, "organizations", change),
			upsert(13, "organizations", with(change, map[string]any{"id": "dddddddd-dddd-dddd-dddd-dddddddddddd"})),
		),
		"12 ok true", "13 rejected forbidden")
	o := f.record(t, "organizations", pOrgA)
	if o.GetString("name") != "Petek Arıcılık Ltd." || o.GetString("operation_type") != "migratory" || o.GetString("avatar_color") != "honey" {
		t.Errorf("missing columns keep their values: name %q operation_type %q avatar_color %q",
			o.GetString("name"), o.GetString("operation_type"), o.GetString("avatar_color"))
	}
	if o.GetString("created_by") != pOwner || o.GetString("updated_at") != "2026-10-23T08:00:00.000000Z" {
		t.Errorf("created_by kept, updated_at written: %q %q", o.GetString("created_by"), o.GetString("updated_at"))
	}
	wantOutcomes(t, "an older change is not applied, for any member",
		f.push(t, pWorker, upsert(14, "organizations", with(change, map[string]any{"name": "Eski"}))), "14 ok false")
	wantOutcomes(t, "a non-member is forbidden whatever the time",
		f.push(t, pOutsider,
			upsert(15, "organizations", with(change, map[string]any{"name": "X", "updated_at": later(1)})),
			upsert(16, "organizations", with(change, map[string]any{"name": "X", "updated_at": "2026-01-01T00:00:00Z"})),
		),
		"15 rejected forbidden", "16 rejected forbidden")
	wantOutcomes(t, "a bad value is invalid",
		f.push(t, pOwner, upsert(17, "organizations", with(change, map[string]any{"tr_aks_hive_count": 1.5, "updated_at": later(2)}))),
		"17 rejected invalid")
	if got := f.record(t, "organizations", pOrgA).GetString("name"); got != "Petek Arıcılık Ltd." {
		t.Errorf("organization renamed to %q", got)
	}
}

// TestPushEveryTableSupported: the 33 writable tables of the registry are
// all handled by push (no "unsupported"); only the 2 reference tables are
// refused. 35 in all.
func TestPushEveryTableSupported(t *testing.T) {
	f := newPullFixture(t)
	writable, reference := 0, 0
	for i, table := range appsync.Tables {
		payload := map[string]any{
			"id": fmt.Sprintf("f0000000-0000-0000-0000-%012d", i), "org_id": pOrgA,
			"created_at": later(0), "updated_at": later(0),
		}
		switch table.Name {
		case "organizations":
			payload["id"] = pOrgA
		case "memberships":
			payload["id"] = "c0000000-0000-0000-0000-000000000001"
		}
		r := f.push(t, pOwner, upsert(i, table.Name, payload))[0]
		if table.Kind == appsync.KindReference {
			reference++
			if r.Reason != appsync.ReasonUnsupported {
				t.Errorf("%s: %s %s, want unsupported", table.Name, r.Status, r.Reason)
			}
			continue
		}
		writable++
		if r.Reason == appsync.ReasonUnsupported {
			t.Errorf("%s: unsupported: %s", table.Name, r.Message)
		}
	}
	if writable != 33 || reference != 2 {
		t.Errorf("writable %d, reference %d; want 33 and 2", writable, reference)
	}
}

// sqlRef is one `references` clause of the Supabase migrations.
var (
	sqlTableRe   = regexp.MustCompile(`(?i)^\s*(?:create|alter) table (?:if not exists )?public\.(\w+)`)
	sqlFKRe      = regexp.MustCompile(`(?i)foreign key \((\w+)(, *org_id)?\)\s*references (public|auth)\.(\w+) \((id)(, *org_id)?\)`)
	sqlColumnRe  = regexp.MustCompile(`(?i)^\s*(?:alter table public\.\w+ )?(?:add column )?(\w+) uuid\b.*\breferences (public|auth)\.(\w+) \(id\)`)
	sqlDropFKRe  = regexp.MustCompile(`(?i)alter table public\.(\w+) drop constraint (\w+)_fkey`)
	sqlCommentRe = regexp.MustCompile(`--.*$`)
)

// refsFromMigrations collects the foreign keys of supabase/migrations as
// "table.column → target (scope)", leaving out org_id and created_by.
func refsFromMigrations(t *testing.T) map[string]bool {
	t.Helper()
	files, err := filepath.Glob("../../../supabase/migrations/*.sql")
	if err != nil || len(files) == 0 {
		t.Fatalf("no migrations: %v", err)
	}
	sort.Strings(files)
	out := map[string]bool{}
	for _, file := range files {
		src, err := os.ReadFile(file)
		if err != nil {
			t.Fatal(err)
		}
		table, previous := "", ""
		for _, line := range strings.Split(string(src), "\n") {
			line = sqlCommentRe.ReplaceAllString(line, "")
			if strings.HasPrefix(strings.TrimSpace(strings.ToLower(line)), "references") {
				// A column definition broken before `references`.
				line = previous + " " + strings.TrimSpace(line)
			}
			previous = line
			if m := sqlDropFKRe.FindStringSubmatch(line); m != nil {
				// memberships_user_id_fkey (20261113120000).
				for k := range out {
					if strings.HasPrefix(k, m[1]+"."+strings.TrimPrefix(m[2], m[1]+"_")+" ") {
						delete(out, k)
					}
				}
			}
			if m := sqlTableRe.FindStringSubmatch(line); m != nil {
				table = m[1]
			}
			if !strings.Contains(strings.ToLower(line), "references") {
				continue
			}
			var column, target, scope string
			if m := sqlFKRe.FindStringSubmatch(line); m != nil {
				column, target, scope = m[1], m[4], string(appsync.RefGlobal)
				if m[2] != "" && m[6] != "" {
					scope = string(appsync.RefSameOrg)
				}
			} else if m := sqlColumnRe.FindStringSubmatch(line); m != nil {
				column, target, scope = m[1], m[3], string(appsync.RefGlobal)
			} else {
				t.Fatalf("%s: unparsed references line: %q", filepath.Base(file), line)
			}
			if column == "org_id" || column == "created_by" {
				continue
			}
			out[fmt.Sprintf("%s.%s → %s (%s)", table, column, target, scope)] = true
		}
	}
	return out
}

// TestRefsMatchMigrations: the reference table of push is exactly the
// foreign keys of supabase/migrations on the pushable tables (auth.users is
// the users collection).
func TestRefsMatchMigrations(t *testing.T) {
	pushable := map[string]bool{}
	for _, table := range appsync.Tables {
		if table.Kind == appsync.KindState || table.Kind == appsync.KindEvent {
			pushable[table.Name] = true
		}
	}
	var fromSQL []string
	for k := range refsFromMigrations(t) {
		if pushable[strings.SplitN(k, ".", 2)[0]] {
			fromSQL = append(fromSQL, k)
		}
	}
	var fromGo []string
	for _, r := range appsync.Refs {
		if !pushable[r.Table] {
			t.Errorf("%s.%s: not a pushable table", r.Table, r.Column)
		}
		fromGo = append(fromGo, fmt.Sprintf("%s.%s → %s (%s)", r.Table, r.Column, r.Target, r.Scope))
	}
	sort.Strings(fromSQL)
	sort.Strings(fromGo)
	if !slices.Equal(fromSQL, fromGo) {
		for _, k := range fromSQL {
			if !slices.Contains(fromGo, k) {
				t.Errorf("missing in refs.go: %s", k)
			}
		}
		for _, k := range fromGo {
			if !slices.Contains(fromSQL, k) {
				t.Errorf("not in the migrations: %s", k)
			}
		}
	}
	if len(fromGo) < 50 {
		t.Errorf("only %d refs; the parser lost some", len(fromGo))
	}
}

// TestTableChecksWireValidate: every exported check of internal/validate
// for a pushable table is called by push (rules.go, push.go). Left out:
// helpers, the reference tables' checks (never pushed) and unsynced.go
// (invites, feedback, analytics, deletion requests: their routes, P5.4+).
func TestTableChecksWireValidate(t *testing.T) {
	notPush := map[string]bool{
		"NullableInt": true, "NullableBool": true, "Amount": true, "RoundNumeric": true,
		"RefDrugsWithdrawalDaysCheck": true, "RefSupportPeriodsNameCheck": true,
		"RefSupportPeriodsDescriptionCheck": true, "RefSupportPeriodsCheck": true,
	}
	fset := token.NewFileSet()
	files, err := filepath.Glob("../validate/*.go")
	if err != nil {
		t.Fatal(err)
	}
	var checks []string
	for _, file := range files {
		if strings.HasSuffix(file, "_test.go") || filepath.Base(file) == "unsynced.go" {
			continue
		}
		parsed, err := parser.ParseFile(fset, file, nil, 0)
		if err != nil {
			t.Fatal(err)
		}
		for _, d := range parsed.Decls {
			if fn, ok := d.(*ast.FuncDecl); ok && fn.Recv == nil && fn.Name.IsExported() && !notPush[fn.Name.Name] {
				checks = append(checks, fn.Name.Name)
			}
		}
	}
	var src strings.Builder
	for _, file := range []string{"rules.go", "push.go"} {
		b, err := os.ReadFile(file)
		if err != nil {
			t.Fatal(err)
		}
		src.Write(b)
	}
	for _, name := range checks {
		if !strings.Contains(src.String(), "validate."+name+"(") {
			t.Errorf("validate.%s is not called by push", name)
		}
	}
	if len(checks) < 60 {
		t.Errorf("only %d checks found", len(checks))
	}
}

// TestPushRunsModelHooks: a push write goes through the model hooks (the
// seq hook and any other bound on the collection, P5.6's task notification
// among them), in the push transaction, on create and on update.
func TestPushRunsModelHooks(t *testing.T) {
	f := newPullFixture(t)
	f.apiary(t, "a1000000-0000-0000-0000-000000000001", pOrgA, "Yayla")
	var seen []string
	record := func(op string) func(e *core.RecordEvent) error {
		return func(e *core.RecordEvent) error {
			if err := e.Next(); err != nil {
				return err
			}
			seen = append(seen, fmt.Sprintf("%s %s seq=%d tx=%v", op, e.Record.Id, e.Record.GetInt(appsync.FieldServerSeq), e.App.IsTransactional()))
			return nil
		}
	}
	f.app.OnRecordCreate("tasks").BindFunc(record("create"))
	f.app.OnRecordUpdate("tasks").BindFunc(record("update"))

	task := map[string]any{
		"id": "a7000000-0000-0000-0000-000000000001", "org_id": pOrgA, "title": "Kontrol",
		"due_at": later(0), "apiary_id": "a1000000-0000-0000-0000-000000000001", "source": "manual",
		"created_at": later(0), "updated_at": later(0),
	}
	f.push(t, pWorker, upsert(1, "tasks", task))
	first := f.lastSeq(t)
	f.push(t, pWorker, upsert(2, "tasks", with(task, map[string]any{"title": "Kontrol 2", "updated_at": later(1)})))
	second := f.lastSeq(t)
	want := []string{
		fmt.Sprintf("create %s seq=%d tx=true", task["id"], first),
		fmt.Sprintf("update %s seq=%d tx=true", task["id"], second),
	}
	if !slices.Equal(seen, want) {
		t.Errorf("hooks saw %q, want %q", seen, want)
	}
	if got := f.seqOf(t, "tasks", task["id"].(string)); got != second {
		t.Errorf("stored server_seq %d, want %d", got, second)
	}
}

// TestPushRoundsNumerics: numeric(p, s) columns are stored rounded to s
// decimals, as Postgres did; money keeps rejecting a third decimal.
func TestPushRoundsNumerics(t *testing.T) {
	f := newPullFixture(t)
	const apiary, hive = "a1000000-0000-0000-0000-000000000001", "a3000000-0000-0000-0000-000000000001"
	f.apiary(t, apiary, pOrgA, "Yayla")
	f.insert(t, "hives", hive, map[string]any{
		"org_id": pOrgA, "number": "1", "type": "langstroth", "status": "active", "apiary_id": apiary, "box_count": 1,
	})
	const treatment, lot, harvest = "a9000000-0000-0000-0000-000000000001", "ab000000-0000-0000-0000-000000000001", "a8000000-0000-0000-0000-000000000001"
	wantOutcomes(t, "rounded",
		f.push(t, pOwner,
			upsert(1, "treatments", map[string]any{
				"id": treatment, "org_id": pOrgA, "hive_id": hive, "apiary_id": apiary,
				"ref_drug_id": refDrugAmitraz, "product_name": "Amitraz", "active_ingredient": "amitraz",
				"dose": 2.005, "dose_unit": "strip", "started_at": later(0), "withdrawal_days": 0,
				"created_at": later(0), "updated_at": later(0),
			}),
			upsert(2, "lots", map[string]any{
				"id": lot, "org_id": pOrgA, "year": 2026, "seq": 1, "honey_kind": "pine", "status": "open",
				"moisture": 17.25, "created_at": later(0), "updated_at": later(0),
			}),
			upsert(3, "harvests", map[string]any{
				"id": harvest, "org_id": pOrgA, "apiary_id": apiary, "harvested_at": later(0),
				"honey_kind": "pine", "unit": "super", "unit_count": 2, "net_kg": 10.0005,
				"created_at": later(0), "updated_at": later(0),
			}),
			upsert(4, "transactions", map[string]any{
				"id": "f1000000-0000-0000-0000-000000000001", "org_id": pOrgA, "kind": "income",
				"category": "honey", "amount": 10.005, "currency": "TRY", "occurred_on": "2026-10-01",
				"created_at": later(0), "updated_at": later(0),
			}),
		),
		"1 ok true", "2 ok true", "3 ok true", "4 rejected invalid")
	if got := f.record(t, "treatments", treatment).GetFloat("dose"); got != 2.01 {
		t.Errorf("dose %v, want 2.01", got)
	}
	if got := jsonField(f.record(t, "lots", lot), "moisture"); got != "17.3" {
		t.Errorf("moisture %s, want 17.3", got)
	}
	if got := f.record(t, "harvests", harvest).GetFloat("net_kg"); got != 10.001 {
		t.Errorf("net_kg %v, want 10.001", got)
	}
}

// TestPushReferences: a link to a soft-deleted row is accepted (as in
// Supabase, where rows are never removed); a global reference (ref_drugs,
// users) needs the row in any organization; an update re-checks only the
// links it changes.
func TestPushReferences(t *testing.T) {
	f := newPullFixture(t)
	const apiary, hive = "a1000000-0000-0000-0000-000000000001", "a3000000-0000-0000-0000-000000000001"
	f.apiary(t, apiary, pOrgA, "Yayla")
	f.setField(t, "apiaries", apiary, map[string]any{"deleted_at": testTime})
	wantOutcomes(t, "silinmiş arılığa bağ kabul edilir",
		f.push(t, pWorker, upsert(1, "hives", hivePayload(hive, pOrgA, "1", apiary, nil))),
		"1 ok true")

	task := func(n int, extra map[string]any) map[string]any {
		return with(map[string]any{
			"id": fmt.Sprintf("a7000000-0000-0000-0000-00000000000%d", n), "org_id": pOrgA, "title": "Görev",
			"due_at": later(0), "source": "manual", "created_at": later(0), "updated_at": later(0),
		}, extra)
	}
	wantOutcomes(t, "global references",
		f.push(t, pWorker,
			upsert(1, "tasks", task(1, map[string]any{"assigned_to": pPartner})),
			upsert(2, "tasks", task(2, map[string]any{"assigned_to": "12345678-1234-1234-1234-123456789012"})),
			upsert(3, "tasks", task(3, map[string]any{"apiary_id": apiary, "ref_drug_id": "01900000-0000-7000-8000-0000000000ff", "dose": 1})),
			// A user of another organization still exists (auth.users).
			upsert(4, "tasks", task(4, map[string]any{"assigned_to": pOutsider})),
		),
		"1 ok true", "2 rejected missing_reference", "3 rejected missing_reference", "4 ok true")

	// The hive's apiary is unchanged on an update: not re-checked. Point
	// the stored row at a missing apiary behind push's back first.
	f.setField(t, "hives", hive, map[string]any{"apiary_id": "a1000000-0000-0000-0000-0000000000ff"})
	stored := rowPayload(f.record(t, "hives", hive))
	wantOutcomes(t, "unchanged link not re-checked; changed one is",
		f.push(t, pWorker,
			upsert(1, "hives", with(stored, map[string]any{"marking": "Sarı", "updated_at": later(1)})),
			upsert(2, "hives", with(stored, map[string]any{"queen_id": "a2000000-0000-0000-0000-0000000000ff", "updated_at": later(2)})),
		),
		"1 ok true", "2 rejected missing_reference")
}

// TestPushUniqueConflicts: the unique indexes besides the tag code
// (TestPushHivesConsistencyTest): a harvest is in at most one lot, a hive
// once per harvest. The invite code's is P5.4's (invites are not pushed).
func TestPushUniqueConflicts(t *testing.T) {
	f := newPullFixture(t)
	const (
		apiary  = "a1000000-0000-0000-0000-000000000001"
		hive    = "a3000000-0000-0000-0000-000000000001"
		harvest = "a8000000-0000-0000-0000-000000000001"
		lot1    = "ab000000-0000-0000-0000-000000000001"
		lot2    = "ab000000-0000-0000-0000-000000000002"
	)
	f.apiary(t, apiary, pOrgA, "Yayla")
	f.insert(t, "hives", hive, map[string]any{
		"org_id": pOrgA, "number": "1", "type": "langstroth", "status": "active", "apiary_id": apiary, "box_count": 1,
	})
	f.insert(t, "harvests", harvest, map[string]any{
		"org_id": pOrgA, "apiary_id": apiary, "harvested_at": testTime, "honey_kind": "pine",
		"unit": "super", "unit_count": 1, "net_kg": 20,
	})
	for i, id := range []string{lot1, lot2} {
		f.insert(t, "lots", id, map[string]any{"org_id": pOrgA, "year": 2026, "seq": i + 1, "honey_kind": "pine", "status": "open"})
	}
	link := func(table, id string, fields map[string]any) map[string]any {
		return with(map[string]any{"id": id, "org_id": pOrgA, "created_at": later(0), "updated_at": later(0)}, fields)
	}
	wantOutcomes(t, "unique",
		f.push(t, pWorker,
			upsert(1, "lot_harvests", link("lot_harvests", "ac000000-0000-0000-0000-000000000001", map[string]any{"lot_id": lot1, "harvest_id": harvest})),
			upsert(2, "lot_harvests", link("lot_harvests", "ac000000-0000-0000-0000-000000000002", map[string]any{"lot_id": lot2, "harvest_id": harvest})),
			upsert(3, "harvest_hives", link("harvest_hives", "ae000000-0000-0000-0000-000000000001", map[string]any{"harvest_id": harvest, "hive_id": hive})),
			upsert(4, "harvest_hives", link("harvest_hives", "ae000000-0000-0000-0000-000000000002", map[string]any{"harvest_id": harvest, "hive_id": hive})),
		),
		"1 ok true", "2 rejected conflict", "3 ok true", "4 rejected conflict")
}
