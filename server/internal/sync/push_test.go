package sync_test

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"maps"
	"net/http"
	"slices"
	"strings"
	"testing"
	"time"

	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

// Rows of supabase/tests/database/sync_push.test.sql.
const (
	pushApiary  = "a1000000-0000-0000-0000-000000000001"
	pushHive    = "a3000000-0000-0000-0000-000000000001"
	pushHistory = "a4000000-0000-0000-0000-000000000001"
	bApiary     = "e1000000-0000-0000-0000-000000000001"
	bHive       = "e3000000-0000-0000-0000-000000000001"
	octFirst    = "2026-10-01T00:00:00.000000Z"
)

// pushPacket is the packet of sync_push.test.sql: a new apiary, hive and the
// hive's first location record, in outbox order. The hive's created_by is a
// forged other user; the apiary carries the columns dropped in
// 20261116120000 (landowner_*), which an older payload still has.
func pushPacket() []map[string]any {
	return []map[string]any{
		{"id": 1, "table": "apiaries", "operation": "upsert", "payload": map[string]any{
			"id": pushApiary, "org_id": pOrgA, "name": "Yayla",
			"created_at": "2026-10-23T08:00:00.000Z", "updated_at": "2026-10-23T08:00:00.000Z",
			"latitude": 40.98, "longitude": 40.52, "altitude_m": nil,
			"landowner_name": nil, "landowner_phone": nil, "land_tenure": nil,
			"water_source": nil, "vehicle_distance_m": nil, "road_notes": nil,
			"notes": nil, "created_by": nil, "deleted_at": nil,
		}},
		{"id": 2, "table": "hives", "operation": "upsert", "payload": map[string]any{
			"id": pushHive, "org_id": pOrgA, "number": "101", "type": "langstroth",
			"apiary_id":  pushApiary,
			"created_at": "2026-10-23T08:00:00.000Z", "updated_at": "2026-10-23T08:00:00.000Z",
			"status": "active", "tag_code": nil, "queen_id": nil, "box_count": 1,
			"frame_count": nil, "source": nil, "marking": nil,
			"created_by": pOutsider, "deleted_at": nil,
		}},
		{"id": 3, "table": "hive_location_history", "operation": "upsert", "payload": map[string]any{
			"id": pushHistory, "org_id": pOrgA, "hive_id": pushHive, "apiary_id": pushApiary,
			"moved_at":   "2026-10-23T08:00:00.000Z",
			"created_at": "2026-10-23T08:00:00.000Z", "updated_at": "2026-10-23T08:00:00.000Z",
			"created_by": nil, "deleted_at": nil,
		}},
	}
}

// changed is pg_temp.changed: packet[index] with a new outbox id and
// operation, its payload patched.
func changed(outboxID, index int, operation string, patch map[string]any) map[string]any {
	src := pushPacket()[index]
	payload := maps.Clone(src["payload"].(map[string]any))
	maps.Copy(payload, patch)
	return map[string]any{"id": outboxID, "table": src["table"], "operation": operation, "payload": payload}
}

func rawChanges(t testing.TB, changes ...map[string]any) []json.RawMessage {
	t.Helper()
	out := make([]json.RawMessage, len(changes))
	for i, c := range changes {
		b, err := json.Marshal(c)
		if err != nil {
			t.Fatal(err)
		}
		out[i] = b
	}
	return out
}

func (f *pullFixture) push(t testing.TB, user string, changes ...map[string]any) []appsync.Result {
	t.Helper()
	results, err := appsync.Push(f.app, user, rawChanges(t, changes...))
	if err != nil {
		t.Fatalf("push: %v", err)
	}
	return results
}

// outcomes is pg_temp.outcomes: "id status applied|reason" per result.
func outcomes(results []appsync.Result) []string {
	out := make([]string, len(results))
	for i, r := range results {
		detail := r.Reason
		if r.Applied != nil {
			detail = fmt.Sprint(*r.Applied)
		}
		out[i] = fmt.Sprintf("%s %s %s", r.ID, r.Status, detail)
	}
	return out
}

func wantOutcomes(t *testing.T, what string, results []appsync.Result, want ...string) {
	t.Helper()
	if got := outcomes(results); !slices.Equal(got, want) {
		for _, r := range results {
			if r.Message != "" {
				t.Logf("%s: %s", r.ID, r.Message)
			}
		}
		t.Fatalf("%s: outcomes = %q, want %q", what, got, want)
	}
}

func (f *pullFixture) record(t testing.TB, collection, id string) *core.Record {
	t.Helper()
	r, err := f.app.FindRecordById(collection, id)
	if err != nil {
		t.Fatalf("find %s %s: %v", collection, id, err)
	}
	return r
}

// jsonField is a JSON field's stored JSON text, compacted.
func jsonField(r *core.Record, name string) string {
	var buf bytes.Buffer
	raw, _ := r.GetRaw(name).(interface{ String() string })
	if raw == nil || json.Compact(&buf, []byte(raw.String())) != nil {
		return fmt.Sprint(r.GetRaw(name))
	}
	return buf.String()
}

func (f *pullFixture) count(t testing.TB, collection string) int64 {
	t.Helper()
	n, err := f.app.CountRecords(collection)
	if err != nil {
		t.Fatal(err)
	}
	return n
}

func (f *pullFixture) lastSeq(t testing.TB) int64 {
	t.Helper()
	n, err := appsync.LastSeq(f.app)
	if err != nil {
		t.Fatal(err)
	}
	return n
}

// newPushFixture is the fixture of sync_push.test.sql: B's apiary and hive
// (hive updated 2026-10-01) next to the users and organizations.
func newPushFixture(t *testing.T) *pullFixture {
	t.Helper()
	f := newPullFixture(t)
	f.apiary(t, bApiary, pOrgB, "Ova")
	f.insert(t, "hives", bHive, map[string]any{
		"org_id": pOrgB, "number": "201", "type": "dadant", "status": "active",
		"apiary_id": bApiary, "box_count": 1, "updated_at": octFirst,
	})
	return f
}

// TestPushSyncPushTest ports supabase/tests/database/sync_push.test.sql,
// in its order. The organization scenarios are P5.3's (organizations are
// "unsupported" until then; TestPushUnsupportedTables); the schema version,
// clock skew and anonymous scenarios are HTTP ones (TestPushRoute).
func TestPushSyncPushTest(t *testing.T) {
	f := newPushFixture(t)
	packet := pushPacket()

	// "Aynı paket iki kez"
	first := f.push(t, pWorker, packet...)
	wantOutcomes(t, "ilk gönderim üç satırı da yazar ve sonuçları paketin sırasıyla döner",
		first, "1 ok true", "2 ok true", "3 ok true")

	apiary := f.record(t, "apiaries", pushApiary)
	if jsonField(apiary, "latitude") != "40.98" || jsonField(apiary, "longitude") != "40.52" {
		t.Errorf("enlem ve boylam yazılır: got %v, %v", apiary.Get("latitude"), apiary.Get("longitude"))
	}
	hive := f.record(t, "hives", pushHive)
	if got := hive.GetString("created_by"); got != pWorker {
		t.Errorf("created_by çağırandır; istemcinin gönderdiği değer yok sayılır: got %q", got)
	}
	if got := hive.GetString("created_at"); got != "2026-10-23T08:00:00.000000Z" {
		t.Errorf("created_at is written as a K-5 time: got %q", got)
	}

	seqs := func() []int64 {
		return []int64{
			f.seqOf(t, "apiaries", pushApiary),
			f.seqOf(t, "hives", pushHive),
			f.seqOf(t, "hive_location_history", pushHistory),
		}
	}
	seqAfterFirst := seqs()
	lastAfterFirst := f.lastSeq(t)

	second := f.push(t, pWorker, packet...)
	wantOutcomes(t, "aynı paket ikinci kez gelince ok döner ama yazmaz",
		second, "1 ok false", "2 ok false", "3 ok false")
	if got := seqs(); !slices.Equal(got, seqAfterFirst) || f.lastSeq(t) != lastAfterFirst {
		t.Errorf("ikinci gönderim satırlara dokunmaz, server_seq ilerlemez: %v → %v, last %d → %d",
			seqAfterFirst, got, lastAfterFirst, f.lastSeq(t))
	}
	// Plus B's apiary and hive.
	if a, h, l := f.count(t, "apiaries"), f.count(t, "hives"), f.count(t, "hive_location_history"); a != 2 || h != 2 || l != 1 {
		t.Errorf("ikinci gönderim yeni satır açmaz: %d %d %d", a, h, l)
	}

	// "Eski updated_at"
	wantOutcomes(t, "eski updated_at ok döner ama yazmaz",
		f.push(t, pWorker, changed(4, 1, "upsert", map[string]any{"number": "999", "updated_at": "2026-10-23T07:00:00Z"})),
		"4 ok false")
	if got := f.record(t, "hives", pushHive).GetString("number"); got != "101" {
		t.Errorf("eski yazma kovanı değiştirmez: number %q", got)
	}
	wantOutcomes(t, "daha yeni updated_at yazar",
		f.push(t, pWorker, changed(5, 1, "upsert", map[string]any{"number": "102", "updated_at": "2026-10-23T09:00:00Z"})),
		"5 ok true")
	hive = f.record(t, "hives", pushHive)
	if hive.GetString("number") != "102" || hive.GetString("updated_at") != "2026-10-23T09:00:00.000000Z" {
		t.Errorf("yeni yazma kovanı ve updated_at'i günceller: %q %q", hive.GetString("number"), hive.GetString("updated_at"))
	}
	if hive.GetString("created_by") != pWorker || hive.GetString("created_at") != "2026-10-23T08:00:00.000000Z" {
		t.Errorf("update keeps created_by and created_at: %q %q", hive.GetString("created_by"), hive.GetString("created_at"))
	}

	// "Yetkisiz işletme": 6: an apiary for B. 7: B's hive, as B's, newer.
	// 8: B's hive, as A's, older than the server's (Supabase's `not
	// exists` fix). 9: a valid new hive for A.
	lastBefore := f.lastSeq(t)
	wantOutcomes(t, "başka işletmeye yazma reddedilir, paketin geri kalanı yazılır",
		f.push(t, pWorker,
			changed(6, 0, "upsert", map[string]any{"id": "a1000000-0000-0000-0000-000000000002", "org_id": pOrgB}),
			changed(7, 1, "upsert", map[string]any{"id": bHive, "org_id": pOrgB, "apiary_id": bApiary, "updated_at": "2026-10-23T09:00:00Z"}),
			changed(8, 1, "upsert", map[string]any{"id": bHive, "updated_at": "2026-01-01T00:00:00Z"}),
			changed(9, 1, "upsert", map[string]any{"id": "a3000000-0000-0000-0000-000000000002", "number": "103"}),
		),
		"6 rejected forbidden", "7 rejected forbidden", "8 rejected forbidden", "9 ok true")
	if got := f.lastSeq(t); got != lastBefore+1 {
		t.Errorf("rejected changes take no server_seq: last %d → %d, want +1", lastBefore, got)
	}

	// "A'nın viewer'ı"
	wantOutcomes(t, "viewer yazamaz",
		f.push(t, pViewer, changed(10, 1, "upsert", map[string]any{"number": "viewer", "updated_at": "2026-10-23T11:00:00Z"})),
		"10 rejected forbidden")
	// An older change of a visible row is "already in" for anyone, as in
	// Supabase (the conflict condition is false, RLS is not asked).
	wantOutcomes(t, "viewer's older change is not applied",
		f.push(t, pViewer, changed(10, 1, "upsert", map[string]any{"number": "viewer", "updated_at": "2026-10-23T08:30:00Z"})),
		"10 ok false")

	// "B'nin owner'ı"
	bHiveRow := f.record(t, "hives", bHive)
	if bHiveRow.GetString("number") != "201" || bHiveRow.GetString("updated_at") != octFirst || bHiveRow.GetString("org_id") != pOrgB {
		t.Errorf("B'nin kovanı değişmedi: %q %q %q", bHiveRow.GetString("number"), bHiveRow.GetString("updated_at"), bHiveRow.GetString("org_id"))
	}
	if _, err := f.app.FindRecordById("apiaries", "a1000000-0000-0000-0000-000000000002"); err == nil {
		t.Error("B'ye arılık eklenmedi: the apiary exists")
	}

	// "Silme"
	wantOutcomes(t, "kovan (durum) ve arılık kaydı (olay) silinir",
		f.push(t, pWorker,
			changed(14, 1, "delete", map[string]any{"number": "102", "updated_at": "2026-10-23T10:00:00Z", "deleted_at": "2026-10-23T10:00:00Z"}),
			changed(15, 2, "delete", map[string]any{"updated_at": "2026-10-23T10:00:00Z", "deleted_at": "2026-10-23T10:00:00Z"}),
		),
		"14 ok true", "15 ok true")
	deleted := func(what string) {
		t.Helper()
		h := f.record(t, "hives", pushHive).GetString("deleted_at")
		l := f.record(t, "hive_location_history", pushHistory).GetString("deleted_at")
		if h != "2026-10-23T10:00:00.000000Z" || l != "2026-10-23T10:00:00.000000Z" {
			t.Errorf("%s: deleted_at %q, %q", what, h, l)
		}
	}
	deleted("silme deleted_at'i yazar, satır yerinde kalır")

	wantOutcomes(t, "silmeden önceki paket yeniden gelince yazmaz",
		f.push(t, pWorker, packet...), "1 ok false", "2 ok false", "3 ok false")
	deleted("silinen kovan ve arılık kaydı silinmiş kalır")

	wantOutcomes(t, "deleted_at taşımayan silme reddedilir",
		f.push(t, pWorker, changed(16, 2, "delete", map[string]any{"deleted_at": nil})),
		"16 rejected invalid")

	// "Diğer redler": 17 a table push does not write (invites), 18 an
	// unknown hive type, 19 a location without longitude.
	wantOutcomes(t, "senkronla yazılamayan tablo ve bozuk veri reddedilir",
		f.push(t, pWorker,
			map[string]any{"id": 17, "table": "invites", "operation": "upsert", "payload": map[string]any{
				"id": "c0000000-0000-0000-0000-000000000003", "org_id": pOrgA, "user_id": pWorker,
				"role": "owner", "updated_at": "2026-10-23T12:00:00Z",
			}},
			changed(18, 1, "upsert", map[string]any{"id": "a3000000-0000-0000-0000-000000000003", "type": "kare"}),
			changed(19, 0, "upsert", map[string]any{"longitude": nil, "updated_at": "2026-10-23T12:00:00Z"}),
		),
		"17 rejected unsupported", "18 rejected invalid", "19 rejected invalid")
}

// TestPushInspectionsSyncTest ports supabase/tests/database/
// inspections_sync.test.sql: an inspection is an event row.
func TestPushInspectionsSyncTest(t *testing.T) {
	f := newPullFixture(t)
	f.apiary(t, pushApiary, pOrgA, "Yayla")
	f.insert(t, "hives", pushHive, map[string]any{
		"org_id": pOrgA, "number": "101", "type": "langstroth", "status": "active",
		"apiary_id": pushApiary, "box_count": 1,
	})
	const inspection = "a5000000-0000-0000-0000-000000000001"
	push := func(user, operation string, patch map[string]any) string {
		t.Helper()
		payload := map[string]any{
			"id": inspection, "org_id": pOrgA, "hive_id": pushHive, "apiary_id": pushApiary,
			"inspected_at": "2026-10-24T09:00:00.000Z",
			"queen_state":  "seen", "bee_frames": 8, "brood_frames": 5,
			"honey_frames": 2, "temperament": "calm", "swarm_signs": false,
			"queen_cells": "none", "disease_suspected": false,
			"data":       map[string]any{"actions": []string{"super_added"}},
			"created_at": "2026-10-24T09:00:00.000Z", "updated_at": "2026-10-24T09:00:00.000Z",
			"created_by": nil, "deleted_at": nil,
		}
		maps.Copy(payload, patch)
		r := f.push(t, user, map[string]any{"id": 1, "table": "inspections", "operation": operation, "payload": payload})[0]
		if r.Applied != nil {
			return fmt.Sprint(*r.Applied)
		}
		t.Logf("rejected: %s", r.Message)
		return r.Reason
	}
	check := func(what, got, want string) {
		t.Helper()
		if got != want {
			t.Fatalf("%s: got %q, want %q", what, got, want)
		}
	}

	check("muayene yazılır", push(pWorker, "upsert", nil), "true")
	row := f.record(t, "inspections", inspection)
	if jsonField(row, "bee_frames") != "8" || row.GetString("queen_state") != "seen" ||
		jsonField(row, "data") != `{"actions":["super_added"]}` || jsonField(row, "swarm_signs") != "false" ||
		row.GetString("created_by") != pWorker {
		t.Errorf("kolonlar, data nesnesi ve ekleyen kullanıcı yazılır: %s %q %s %s %q",
			jsonField(row, "bee_frames"), row.GetString("queen_state"), jsonField(row, "data"),
			jsonField(row, "swarm_signs"), row.GetString("created_by"))
	}
	seq := f.seqOf(t, "inspections", inspection)

	check("aynı kayıt ikinci kez yazılmaz", push(pWorker, "upsert", nil), "false")
	check("eklenmiş muayene daha yeni updated_at ile de değişmez",
		push(pWorker, "upsert", map[string]any{"bee_frames": 3, "updated_at": "2026-10-24T10:00:00.000Z"}), "false")
	if got := jsonField(f.record(t, "inspections", inspection), "bee_frames"); got != "8" {
		t.Errorf("çerçeve sayısı ilk yazılan değerde kalır: %v", got)
	}
	if got := f.seqOf(t, "inspections", inspection); got != seq {
		t.Errorf("unapplied event changes keep server_seq: %d → %d", seq, got)
	}
	check("silme işlenir", push(pWorker, "delete",
		map[string]any{"deleted_at": "2026-10-24T10:00:00.000Z", "updated_at": "2026-10-24T10:00:00.000Z"}), "true")
	row = f.record(t, "inspections", inspection)
	if row.GetString("deleted_at") != "2026-10-24T10:00:00.000000Z" || row.GetString("updated_at") != "2026-10-24T10:00:00.000000Z" ||
		jsonField(row, "bee_frames") != "8" {
		t.Errorf("delete writes only deleted_at and updated_at: %q %q %v", row.GetString("deleted_at"), row.GetString("updated_at"), row.Get("bee_frames"))
	}
	check("eski paket silinen muayeneyi geri getirmez", push(pWorker, "upsert", nil), "false")
	check("a second deletion is not applied", push(pWorker, "delete",
		map[string]any{"deleted_at": "2026-10-25T10:00:00.000Z", "updated_at": "2026-10-25T10:00:00.000Z"}), "false")
	if got := f.record(t, "inspections", inspection).GetString("deleted_at"); got != "2026-10-24T10:00:00.000000Z" {
		t.Errorf("deletion is recorded once: %q", got)
	}
	check("viewer muayene gönderemez",
		push(pViewer, "upsert", map[string]any{"id": "a5000000-0000-0000-0000-000000000002"}), "forbidden")
}

// TestPushEventDeleteNeedsWriter: the viewer cannot delete an event row of
// its own organization, nor anyone one of another organization.
func TestPushEventDeleteNeedsWriter(t *testing.T) {
	f := newPullFixture(t)
	f.push(t, pWorker, pushPacket()...)
	del := changed(1, 2, "delete", map[string]any{"updated_at": "2026-10-23T10:00:00Z", "deleted_at": "2026-10-23T10:00:00Z"})
	wantOutcomes(t, "viewer", f.push(t, pViewer, del), "1 rejected forbidden")
	wantOutcomes(t, "other organization", f.push(t, pOutsider, del), "1 rejected forbidden")
	wantOutcomes(t, "removed member", f.push(t, pRemoved, del), "1 rejected forbidden")
	if got := f.record(t, "hive_location_history", pushHistory).GetString("deleted_at"); got != "" {
		t.Errorf("deleted_at = %q, want empty", got)
	}
	wantOutcomes(t, "partner", f.push(t, pPartner, del), "1 ok true")
}

// TestPushFinanceRoles: transactions, customers and customer_payments are
// owner and partner only; a worker cannot write them.
func TestPushFinanceRoles(t *testing.T) {
	f := newPullFixture(t)
	customer := func(id int, name string) map[string]any {
		return map[string]any{"id": id, "table": "customers", "operation": "upsert", "payload": map[string]any{
			"id": fmt.Sprintf("a7000000-0000-0000-0000-%012d", id), "org_id": pOrgA, "name": name,
			"created_at": "2026-10-23T08:00:00.000Z", "updated_at": "2026-10-23T08:00:00.000Z",
		}}
	}
	wantOutcomes(t, "worker", f.push(t, pWorker, customer(1, "Ali")), "1 rejected forbidden")
	wantOutcomes(t, "partner", f.push(t, pPartner, customer(2, "Veli")), "2 ok true")
	// The worker cannot see the partner's row either.
	c := customer(2, "Veli")
	c["payload"].(map[string]any)["updated_at"] = "2026-10-23T09:00:00.000Z"
	wantOutcomes(t, "worker update", f.push(t, pWorker, c), "2 rejected forbidden")
}

// TestPushUnsupportedTables: reference tables and everything outside the
// registry are "unsupported" (organizations and memberships have their own
// rules: push_rules_test.go).
func TestPushUnsupportedTables(t *testing.T) {
	f := newPullFixture(t)
	payload := map[string]any{"id": pOrgA, "org_id": pOrgA, "name": "X", "updated_at": "2026-12-01T00:00:00Z"}
	var changes []map[string]any
	var want []string
	for i, table := range []string{"ref_drugs", "ref_support_periods", "invites", "users", "sync_meta", "nope"} {
		changes = append(changes, map[string]any{"id": i, "table": table, "operation": "upsert", "payload": payload})
		want = append(want, fmt.Sprintf("%d rejected unsupported", i))
	}
	wantOutcomes(t, "unsupported", f.push(t, pOwner, changes...), want...)
	if got := f.record(t, "organizations", pOrgA).GetString("name"); got != "Petek Arıcılık" {
		t.Errorf("organization renamed to %q", got)
	}
}

// TestPushMalformedChanges: every malformed change is rejected on its own,
// with its id echoed, and the valid change after it is written.
func TestPushMalformedChanges(t *testing.T) {
	f := newPullFixture(t)
	valid := pushPacket()[0]
	raws := rawChanges(t, valid)
	bad := []string{
		`"text"`,
		`{"id": 2, "operation": "upsert", "payload": {"id": "a1000000-0000-0000-0000-000000000009", "updated_at": "2026-10-23T08:00:00Z"}}`,
		`{"id": 3, "table": "apiaries", "operation": "insert", "payload": {"id": "a1000000-0000-0000-0000-000000000009", "updated_at": "2026-10-23T08:00:00Z"}}`,
		`{"id": 4, "table": "apiaries", "operation": "upsert", "payload": [1]}`,
		`{"id": 5, "table": "apiaries", "operation": "upsert", "payload": {"updated_at": "2026-10-23T08:00:00Z"}}`,
		`{"id": 6, "table": "apiaries", "operation": "upsert", "payload": {"id": "a1000000-0000-0000-0000-000000000009"}}`,
		`{"id": 7, "table": "apiaries", "operation": "upsert", "payload": {"id": "A1000000", "org_id": "` + pOrgA + `", "name": "x", "created_at": "2026-10-23T08:00:00Z", "updated_at": "2026-10-23T08:00:00Z"}}`,
		`{"id": 8, "table": "apiaries", "operation": "upsert", "payload": {"id": "a1000000-0000-0000-0000-000000000009", "org_id": "` + pOrgA + `", "name": "x", "created_at": "2026-10-23T08:00:00Z", "updated_at": "dün"}}`,
		`{"id": 9, "table": "apiaries", "operation": "upsert", "payload": {"id": "a1000000-0000-0000-0000-000000000009", "org_id": "` + pOrgA + `", "name": 5, "created_at": "2026-10-23T08:00:00Z", "updated_at": "2026-10-23T08:00:00Z"}}`,
		`{"id": 10, "table": "apiaries", "operation": "upsert", "payload": {"id": "a1000000-0000-0000-0000-000000000009", "org_id": "` + pOrgA + `", "name": "", "created_at": "2026-10-23T08:00:00Z", "updated_at": "2026-10-23T08:00:00Z"}}`,
		`{"id": 11, "table": "hives", "operation": "upsert", "payload": {"id": "a3000000-0000-0000-0000-000000000009", "org_id": "` + pOrgA + `", "number": "1", "type": "dadant", "status": "active", "apiary_id": "` + pushApiary + `", "box_count": "bir", "created_at": "2026-10-23T08:00:00Z", "updated_at": "2026-10-23T08:00:00Z"}}`,
	}
	for _, b := range bad {
		raws = append(raws, json.RawMessage(b))
	}
	raws = append(raws, rawChanges(t, changed(12, 0, "upsert", map[string]any{"id": "a1000000-0000-0000-0000-000000000005", "unknown_column": 1}))...)

	results, err := appsync.Push(f.app, pWorker, raws)
	if err != nil {
		t.Fatal(err)
	}
	want := []string{"1 ok true", "null rejected invalid"}
	for i := 2; i <= 11; i++ {
		want = append(want, fmt.Sprintf("%d rejected invalid", i))
	}
	want = append(want, "12 ok true")
	wantOutcomes(t, "malformed", results, want...)
	if n := f.count(t, "apiaries"); n != 2 {
		t.Errorf("apiaries = %d, want 2", n)
	}
}

// TestPushConflict: a unique index (hives.tag_code among live hives of an
// organization) answers conflict; the row is not written.
func TestPushConflict(t *testing.T) {
	f := newPullFixture(t)
	f.push(t, pWorker, pushPacket()...)
	tagged := changed(1, 1, "upsert", map[string]any{"tag_code": "KOVAN-1", "updated_at": "2026-10-23T09:00:00Z"})
	wantOutcomes(t, "first tag", f.push(t, pWorker, tagged), "1 ok true")
	last := f.lastSeq(t)
	wantOutcomes(t, "same tag on another hive",
		f.push(t, pWorker, changed(2, 1, "upsert", map[string]any{"id": "a3000000-0000-0000-0000-000000000002", "number": "103", "tag_code": "KOVAN-1"})),
		"2 rejected conflict")
	if f.lastSeq(t) != last {
		t.Error("the rejected row took a server_seq")
	}
	if _, err := f.app.FindRecordById("hives", "a3000000-0000-0000-0000-000000000002"); err == nil {
		t.Error("the conflicting hive was written")
	}
}

// TestPushTransientErrorRollsBack: an error that is not a rejection (here a
// hook that reports a locked database) rolls the whole packet back, rows
// written before it included.
func TestPushTransientErrorRollsBack(t *testing.T) {
	f := newPullFixture(t)
	f.app.OnRecordCreate("hive_location_history").BindFunc(func(e *core.RecordEvent) error {
		return errors.New("database is locked (5) (SQLITE_BUSY)")
	})
	last := f.lastSeq(t)
	_, err := appsync.Push(f.app, pWorker, rawChanges(t, pushPacket()...))
	if err == nil || !appsync.IsTransient(err) {
		t.Fatalf("err = %v, want a transient error", err)
	}
	if a, h := f.count(t, "apiaries"), f.count(t, "hives"); a != 0 || h != 0 || f.lastSeq(t) != last {
		t.Errorf("packet not rolled back: apiaries %d, hives %d, last_seq %d → %d", a, h, last, f.lastSeq(t))
	}

	sc := pushScenario(f, "transient → 503", f.tokens[pWorker], pushBody(t, 26, time.Now(), pushPacket()...))
	sc.ExpectedStatus = http.StatusServiceUnavailable
	sc.ExpectedContent = []string{`"code":"unavailable"`}
	sc.Test(t)
}

// TestPushHundredChanges times a full packet (the contract's maximum).
func TestPushHundredChanges(t *testing.T) {
	f := newPullFixture(t)
	var changes []map[string]any
	for i := range appsync.MaxPushChanges {
		changes = append(changes, changed(i, 0, "upsert", map[string]any{
			"id": fmt.Sprintf("a1000000-0000-0000-0001-%012d", i), "name": fmt.Sprintf("Arılık %d", i),
		}))
	}
	start := time.Now()
	results := f.push(t, pWorker, changes...)
	elapsed := time.Since(start)
	for _, r := range results {
		if r.Status != appsync.StatusOK || !*r.Applied {
			t.Fatalf("result %s: %+v", r.ID, r)
		}
	}
	t.Logf("push of %d new rows: %v", len(results), elapsed)

	start = time.Now()
	results = f.push(t, pWorker, changes...)
	t.Logf("push of %d unchanged rows: %v", len(results), time.Since(start))
}

func TestClockSkewWarning(t *testing.T) {
	now := time.Date(2026, 11, 10, 12, 0, 0, 0, time.UTC)
	for _, c := range []struct {
		client time.Time
		want   *appsync.Warning
	}{
		{now, nil},
		{now.Add(4 * time.Minute), nil},
		{now.Add(-5 * time.Minute), nil},
		{now.Add(5*time.Minute + time.Second), &appsync.Warning{Code: "clock_skew", SkewSeconds: 301}},
		{now.Add(-time.Hour), &appsync.Warning{Code: "clock_skew", SkewSeconds: -3600}},
	} {
		got := appsync.ClockSkewWarning(c.client, now)
		if (got == nil) != (c.want == nil) || (got != nil && *got != *c.want) {
			t.Errorf("skew %v: got %+v, want %+v", c.client.Sub(now), got, c.want)
		}
	}
}

func pushBody(t testing.TB, version any, clientTime time.Time, changes ...map[string]any) string {
	t.Helper()
	if changes == nil {
		changes = []map[string]any{}
	}
	b, err := json.Marshal(map[string]any{
		"changes": changes, "client_time": clientTime.UTC().Format(time.RFC3339Nano), "schema_version": version,
	})
	if err != nil {
		t.Fatal(err)
	}
	return string(b)
}

func pushScenario(f *pullFixture, name, token, body string) tests.ApiScenario {
	headers := map[string]string{"Content-Type": "application/json"}
	if token != "" {
		headers["Authorization"] = token
	}
	return tests.ApiScenario{
		Name:                  name,
		Method:                http.MethodPost,
		URL:                   appsync.PushRoute,
		Body:                  strings.NewReader(body),
		Headers:               headers,
		TestAppFactory:        func(testing.TB) *tests.TestApp { return f.app },
		DisableTestAppCleanup: true,
	}
}

// TestPushRoute covers the request level: schema version, body checks,
// clock skew and authentication.
func TestPushRoute(t *testing.T) {
	f := newPullFixture(t)
	worker := f.tokens[pWorker]
	now := time.Now()
	var tooMany []map[string]any
	for i := range appsync.MaxPushChanges + 1 {
		tooMany = append(tooMany, changed(i, 0, "upsert", nil))
	}

	for _, s := range []struct {
		name, token, body string
		status            int
		content, not      []string
		writes            bool
	}{
		{name: "anon sync_push çağıramaz", body: pushBody(t, 26, now), status: 401, content: []string{`"status":401`}},
		{name: "desteklenmeyen şema sürümü reddedilir", token: worker, body: pushBody(t, 0, now, pushPacket()...), status: 426, content: []string{`"code":"upgrade_required"`}},
		{name: "şema sürümü verilmezse reddedilir", token: worker, body: pushBody(t, nil, now, pushPacket()...), status: 426, content: []string{`"code":"upgrade_required"`}},
		{name: "old schema version 25", token: worker, body: pushBody(t, 25, now, pushPacket()...), status: 426, content: []string{`"code":"upgrade_required"`}},
		{name: "schema version as text", token: worker, body: pushBody(t, "26", now), status: 426, content: []string{`"code":"upgrade_required"`}},
		{name: "body not JSON", token: worker, body: "changes", status: 400, content: []string{`"code":"invalid"`}},
		{name: "changes not an array", token: worker, body: `{"changes": {}, "client_time": "2026-11-10T10:00:00Z", "schema_version": 26}`, status: 400, content: []string{`"code":"invalid"`}},
		{name: "changes missing", token: worker, body: `{"client_time": "2026-11-10T10:00:00Z", "schema_version": 26}`, status: 400, content: []string{`"code":"invalid"`}},
		{name: "client_time missing", token: worker, body: `{"changes": [], "schema_version": 26}`, status: 400, content: []string{`"code":"invalid"`}},
		{name: "client_time not a time", token: worker, body: `{"changes": [], "client_time": "dün", "schema_version": 26}`, status: 400, content: []string{`"code":"invalid"`}},
		{name: "more than 100 changes", token: worker, body: pushBody(t, 26, now, tooMany...), status: 400, content: []string{`"code":"invalid"`}},
		{name: "empty packet", token: worker, body: pushBody(t, 26, now), status: 200, content: []string{`"results":[]`, `"warning":null`, `"server_time":"`}},
		{name: "5 dakikanın altındaki sapma uyarı döndürmez", token: worker, body: pushBody(t, 26, now.Add(4*time.Minute)), status: 200, content: []string{`"warning":null`}},
		{name: "bir saatlik sapma uyarı döner", token: worker, body: pushBody(t, 26, now.Add(-time.Hour)), status: 200, content: []string{`"warning":{"code":"clock_skew","skew_seconds":-36`}},
		{name: "packet", token: worker, body: pushBody(t, 26, now, pushPacket()...), status: 200, writes: true,
			content: []string{`"results":[{"id":1,"status":"ok","applied":true},{"id":2,"status":"ok","applied":true},{"id":3,"status":"ok","applied":true}]`}},
		{name: "packet again", token: worker, body: pushBody(t, 26, now, pushPacket()...), status: 200,
			content: []string{`{"id":1,"status":"ok","applied":false}`}},
		{name: "rejected result", token: f.tokens[pViewer], body: pushBody(t, 26, now, changed(7, 0, "upsert", map[string]any{"id": "a1000000-0000-0000-0000-000000000007"})), status: 200,
			content: []string{`{"id":7,"status":"rejected","reason":"forbidden","message":"`}, not: []string{`"applied"`}},
	} {
		sc := pushScenario(f, s.name, s.token, s.body)
		sc.ExpectedStatus = s.status
		sc.ExpectedContent = s.content
		sc.NotExpectedContent = s.not
		if !s.writes {
			// Refused requests and unapplied changes write nothing.
			sc.ExpectedEvents = map[string]int{"*": 0}
		}
		sc.Test(t)
		f.app.ResetEventCalls()
	}
	if n := f.count(t, "apiaries"); n != 1 {
		t.Errorf("apiaries = %d, want 1 (only the packet)", n)
	}
}
