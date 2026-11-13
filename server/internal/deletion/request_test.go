package deletion_test

// supabase/tests/database/account_deletion.test.sql up to the cron part:
// request, cancel, the rate limit and the record API's closure. The
// permanent deletion (account_deletion_due, purge_records, complete, the
// deletion log) is P5.9. 1111 owner of A (with a team), 2222 partner of A,
// 3333 worker of A, 4444 owner of the one-person B, 9999 in no
// organization.

import (
	"net/http"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// orgRows counts B's rows in the tables the fixture fills.
func orgRows(t testing.TB, f *fixture, org string) int {
	t.Helper()
	n := 0
	for _, table := range []string{"apiaries", "hives", "inspections", "harvests", "documents", "media", "lots", "memberships"} {
		n += f.count(t, table, dbx.HashExp{"org_id": org})
	}
	return n
}

func TestAccountDeletionSQL(t *testing.T) {
	const src = "account_deletion.test.sql/"
	f := newFixture(t,
		member{orgA, owner, "owner"},
		member{orgB, solo, "owner"},
		member{orgA, partner, "partner"},
		member{orgA, worker, "worker"},
	)
	deleted := dbx.Params{"deleted_at": testTime}
	// A: the worker's records.
	f.row(t, "apiaries", "a1000000-0000-0000-0000-000000000001", orgA, dbx.Params{"created_by": worker})
	f.row(t, "hives", "a2000000-0000-0000-0000-000000000001", orgA, dbx.Params{"created_by": worker})
	f.row(t, "inspections", "a3000000-0000-0000-0000-000000000001", orgA, dbx.Params{"created_by": worker})
	// B: one of each kind; the soft-deleted hive is not counted.
	f.row(t, "apiaries", "b1000000-0000-0000-0000-000000000001", orgB, nil)
	f.row(t, "hives", "b2000000-0000-0000-0000-000000000001", orgB, nil)
	f.row(t, "hives", "b2000000-0000-0000-0000-000000000002", orgB, deleted)
	f.row(t, "inspections", "b3000000-0000-0000-0000-000000000001", orgB, nil)
	f.row(t, "harvests", "b4000000-0000-0000-0000-000000000001", orgB, nil)
	f.row(t, "documents", "b5000000-0000-0000-0000-000000000001", orgB, nil)
	f.row(t, "media", "b6000000-0000-0000-0000-000000000001", orgB, dbx.Params{"kind": "photo"})
	f.row(t, "lots", "b7000000-0000-0000-0000-000000000001", orgB, dbx.Params{"published": true})
	f.deviceToken(t, worker, "token-worker")
	f.deviceToken(t, solo, "token-solo")
	f.invite(t, orgA, "AAAAAA", partner)
	f.invite(t, orgB, "BBBBBB", solo)

	// The client cannot reach the deletion functions or write a request.
	step(t, src+"anonim çağrı silme talebi açamaz", func(t *testing.T) {
		f.post(t, "", "request", map[string]any{}, http.StatusUnauthorized, "")
	})
	step(t, src+"oturumlu kullanıcı da fonksiyonu doğrudan çağıramaz (kod onayı olmadan talep yok)", func(t *testing.T) {
		f.post(t, worker, "request", map[string]any{}, http.StatusForbidden, deletion.CodeCodeRequired)
	})
	step(t, src+"kullanıcı kalıcı silmeyi doğrudan çağıramaz", func(t *testing.T) {
		f.post(t, worker, "purge_due", map[string]any{}, http.StatusBadRequest, deletion.CodeBadRequest)
	})
	step(t, src+"kullanıcı tabloya talep yazamaz", func(t *testing.T) {
		f.call(t, http.MethodPost, "/api/collections/deletion_requests/records", f.tokens[worker],
			`{"user_id":"`+worker+`","kind":"hesap","channel":"uygulama","status":"bekliyor","user_hash":"x"}`,
			http.StatusForbidden)
		if n := f.count(t, deletion.RequestsCollection, nil); n != 0 {
			t.Fatalf("%d requests", n)
		}
	})

	// A member: the account goes, the organization stays.
	var workerReq map[string]any
	var workerOut response
	step(t, src+"üyenin talebi yalnız hesap", func(t *testing.T) {
		workerOut = f.request(t, worker, map[string]any{"org_id": orgA}, http.StatusOK, "")
		workerReq = requestOf(t, workerOut)
		if workerReq["kind"] != deletion.KindAccount {
			t.Fatalf("request %v", workerReq)
		}
	})
	step(t, src+"talep bekliyor", func(t *testing.T) {
		if workerReq["status"] != deletion.StatusPending {
			t.Fatalf("status %v", workerReq["status"])
		}
	})
	step(t, src+"kalıcı silme 7 gün sonra", func(t *testing.T) {
		requested, _ := time.Parse(time.RFC3339Nano, workerReq["requested_at"].(string))
		scheduled, _ := time.Parse(time.RFC3339Nano, workerReq["scheduled_for"].(string))
		if scheduled.Sub(requested) != 7*24*time.Hour || deletion.GracePeriod != 7*24*time.Hour {
			t.Fatalf("requested %v, scheduled %v", requested, scheduled)
		}
	})
	step(t, src+"üye silinince işletmeden hiçbir şey silinmez", func(t *testing.T) {
		counts, _ := workerOut.object(t)["counts"].(map[string]any)
		for _, k := range []string{"hives", "photos", "apiaries", "harvests", "documents", "inspections", "public_lot_pages"} {
			if counts[k] != 0.0 {
				t.Errorf("%s = %v", k, counts[k])
			}
		}
		if len(counts) != 7 {
			t.Errorf("counts %v", counts)
		}
	})
	step(t, src+"bekleyen talep varken yenisi açılmaz", func(t *testing.T) {
		f.signIn(t, worker)
		out := f.request(t, worker, map[string]any{}, http.StatusOK, "")
		if out.object(t)["already_pending"] != true || requestOf(t, out)["id"] != workerReq["id"] {
			t.Fatalf("body %s", out.body)
		}
		if n := len(f.requests(t, worker)); n != 1 {
			t.Fatalf("%d requests", n)
		}
	})
	step(t, src+"talep anında bildirim token'ları silinir", func(t *testing.T) {
		if n := f.count(t, "device_tokens", dbx.HashExp{"user_id": worker}); n != 0 {
			t.Fatalf("%d tokens", n)
		}
		if n := f.count(t, "device_tokens", dbx.HashExp{"user_id": solo}); n != 1 {
			t.Fatalf("solo has %d tokens", n)
		}
	})

	// Record API: each user sees only their own request.
	listRequests := func(t *testing.T, user string) int {
		out := f.call(t, http.MethodGet, "/api/collections/deletion_requests/records", f.signIn(t, user), "", http.StatusOK)
		items, _ := out.object(t)["items"].([]any)
		return len(items)
	}
	step(t, src+"kullanıcı kendi talebini görür", func(t *testing.T) {
		if n := listRequests(t, worker); n != 1 {
			t.Fatalf("%d", n)
		}
	})
	step(t, src+"kullanıcı talebi doğrudan değiştiremez", func(t *testing.T) {
		f.call(t, http.MethodPatch, "/api/collections/deletion_requests/records/"+workerReq["id"].(string),
			f.tokens[worker], `{"status":"iptal"}`, http.StatusForbidden)
		if got := f.requests(t, worker)[0].GetString("status"); got != deletion.StatusPending {
			t.Fatalf("status %q", got)
		}
	})
	step(t, src+"başkasının talebi görünmez", func(t *testing.T) {
		if n := listRequests(t, outsider); n != 0 {
			t.Fatalf("%d", n)
		}
	})
	step(t, src+"aynı işletmenin owner'ı da üyenin talebini görmez", func(t *testing.T) {
		if n := listRequests(t, owner); n != 0 {
			t.Fatalf("%d", n)
		}
	})

	// Owner with a team: transfer or delete the organization.
	step(t, src+"devir yapılmadan ekipli işletmenin owner'ı hesabını silemez", func(t *testing.T) {
		out := f.request(t, owner, map[string]any{"org_id": orgA}, http.StatusConflict, deletion.CodeOwnerMustTransfer)
		data, _ := out.object(t)["data"].(map[string]any)
		if ids, _ := data["org_ids"].([]any); len(ids) != 1 || ids[0] != orgA {
			t.Fatalf("org_ids %v", data["org_ids"])
		}
	})
	step(t, src+"owner olmayan işletmeyi silmeyi seçemez", func(t *testing.T) {
		f.request(t, partner, map[string]any{"org_id": orgA, "delete_organization": true}, http.StatusForbidden, deletion.CodeForbidden)
	})
	step(t, src+"owner işletmeyi silmeyi seçerse ekip olsa da talep açılır", func(t *testing.T) {
		out := f.post(t, owner, "request", map[string]any{"org_id": orgA, "delete_organization": true, "channel": "web"}, http.StatusOK, "")
		req := requestOf(t, out)
		if req["kind"] != deletion.KindAccountOrganization || req["channel"] != deletion.ChannelWeb {
			t.Fatalf("request %v", req)
		}
	})
	step(t, src+"talep iptal edilir", func(t *testing.T) {
		f.signIn(t, owner)
		if out := f.post(t, owner, "cancel", nil, http.StatusOK, ""); string(out.body) != `{"cancelled":true}` {
			t.Fatalf("body %s", out.body)
		}
	})

	// After handing the ownership to the partner, the old owner leaves like
	// a member.
	setRole := func(user, role string) {
		m := f.membership(t, orgA, user)
		m.Set("role", role)
		f.save(t, m)
	}
	setRole(partner, "owner")
	setRole(owner, "partner")
	step(t, src+"devirden sonra eski owner'ın talebi açılır, işletme kalır", func(t *testing.T) {
		out := f.request(t, owner, map[string]any{"org_id": orgA}, http.StatusOK, "")
		if got := requestOf(t, out)["kind"]; got != deletion.KindAccount {
			t.Fatalf("kind %v", got)
		}
	})
	step(t, src+"ikinci talep de iptal", func(t *testing.T) {
		f.signIn(t, owner)
		f.post(t, owner, "cancel", nil, http.StatusOK, "")
	})

	// Rate limit: at most 3 requests in 24 hours, per user and per e-mail.
	step(t, src+"üçüncü talep açılır", func(t *testing.T) {
		f.request(t, owner, map[string]any{}, http.StatusOK, "")
	})
	step(t, src+"üçüncü talep iptal", func(t *testing.T) {
		f.signIn(t, owner)
		if out := f.post(t, owner, "cancel", nil, http.StatusOK, ""); string(out.body) != `{"cancelled":true}` {
			t.Fatalf("body %s", out.body)
		}
	})
	step(t, src+"aynı kullanıcının dördüncü talebi reddedilir", func(t *testing.T) {
		f.request(t, owner, map[string]any{}, http.StatusTooManyRequests, deletion.CodeRateLimited)
	})
	step(t, src+"aynı e-postayla başka hesaptan gelen talep de sınırlanır", func(t *testing.T) {
		// The SQL passes another account's e-mail; an account's e-mail is
		// its own here, so Request is called as the route would.
		err := f.app.RunInTransaction(func(txApp core.App) error {
			_, err := deletion.Request(txApp, deletion.RequestInput{
				UserID: outsider, Email: " OWNER@test.local", Channel: deletion.ChannelApp,
			})
			return err
		})
		if err == nil || err.Error() != deletion.CodeRateLimited+": Too many requests; please try again later." {
			t.Fatalf("err = %v", err)
		}
	})
	step(t, src+"bekleyen talep yoksa iptal false döner", func(t *testing.T) {
		if out := f.post(t, outsider, "cancel", nil, http.StatusOK, ""); string(out.body) != `{"cancelled":false}` {
			t.Fatalf("body %s", out.body)
		}
	})

	// One-person organization: deleting the account deletes it too.
	f.invite(t, orgA, "CCCCCC", partner)
	var soloOut response
	step(t, src+"tek kişilikte işletme de silinir", func(t *testing.T) {
		soloOut = f.request(t, solo, map[string]any{}, http.StatusOK, "")
		if got := requestOf(t, soloOut)["kind"]; got != deletion.KindAccountOrganization {
			t.Fatalf("kind %v", got)
		}
	})
	step(t, src+"yanıt silinecekleri ve yayımdaki lot sayfasını sayar", func(t *testing.T) {
		counts, _ := soloOut.object(t)["counts"].(map[string]any)
		for _, k := range []string{"hives", "photos", "apiaries", "harvests", "documents", "inspections", "public_lot_pages"} {
			if counts[k] != 1.0 {
				t.Errorf("%s = %v", k, counts[k])
			}
		}
	})
	step(t, src+"işletme verilmezse silinecek işletme yazılır", func(t *testing.T) {
		req := requestOf(t, soloOut)
		if req["org_id"] != orgB {
			t.Fatalf("org_id %v", req["org_id"])
		}
		if ids, _ := req["delete_org_ids"].([]any); len(ids) != 1 || ids[0] != orgB {
			t.Fatalf("delete_org_ids %v", req["delete_org_ids"])
		}
	})
	step(t, src+"silinecek işletmenin bekleyen davet kodu iptal olur", func(t *testing.T) {
		if f.inviteLive(t, "BBBBBB") {
			t.Fatal("BBBBBB is live")
		}
	})
	step(t, src+"işletmeyi silme seçilince ekibin davet kodları da iptal olmuştu", func(t *testing.T) {
		if f.inviteLive(t, "AAAAAA") {
			t.Fatal("AAAAAA is live")
		}
	})
	step(t, src+"başka işletmenin davet kodu etkilenmez", func(t *testing.T) {
		if !f.inviteLive(t, "CCCCCC") {
			t.Fatal("CCCCCC expired")
		}
	})

	// Signing in within the 7 days does not cancel; the user confirms
	// (20261114120000_account_deletion_app_flow).
	soloID := requestOf(t, soloOut)["id"].(string)
	step(t, src+"giriş talebi kendiliğinden iptal etmez; uygulama önce sorar", func(t *testing.T) {
		f.signIn(t, solo)
		r, err := f.app.FindRecordById(deletion.RequestsCollection, soloID)
		if err != nil || r.GetString("status") != deletion.StatusPending {
			t.Fatalf("request %v, %v", r, err)
		}
	})
	step(t, src+"bekleyen talep sorulabilir", func(t *testing.T) {
		if got := requestOf(t, f.post(t, solo, "status", nil, http.StatusOK, ""))["id"]; got != soloID {
			t.Fatalf("id %v", got)
		}
	})
	step(t, src+"kullanıcı devam etmeyi onaylayınca talep iptal olur", func(t *testing.T) {
		if out := f.post(t, solo, "cancel", nil, http.StatusOK, ""); string(out.body) != `{"cancelled":true}` {
			t.Fatalf("body %s", out.body)
		}
	})
	step(t, src+"iptal edilen talep iptal durumunda", func(t *testing.T) {
		r, err := f.app.FindRecordById(deletion.RequestsCollection, soloID)
		if err != nil || r.GetString("status") != deletion.StatusCancelled || r.GetString("cancelled_at") == "" {
			t.Fatalf("request %v, %v", r, err)
		}
	})
	step(t, src+"iptalde veriler durur", func(t *testing.T) {
		if n := orgRows(t, f, orgB); n != 9 {
			t.Fatalf("%d rows of B", n)
		}
	})
}

// Ek: kalıcı silme başladıysa iptal edilmez (account_deletion_cancel'in
// purge_started_at koşulu).
func TestCancelAfterPurgeStarted(t *testing.T) {
	f := newFixture(t, member{orgA, owner, "owner"}, member{orgA, worker, "worker"})
	out := f.request(t, worker, map[string]any{"org_id": orgA}, http.StatusOK, "")
	r, err := f.app.FindRecordById(deletion.RequestsCollection, requestOf(t, out)["id"].(string))
	if err != nil {
		t.Fatal(err)
	}
	r.Set("purge_started_at", stampAt(f.clock))
	f.save(t, r)
	f.signIn(t, worker)
	if got := requestOf(t, f.post(t, worker, "status", nil, http.StatusOK, "")); got["id"] != r.Id {
		t.Fatalf("status %v", got)
	}
	if out := f.post(t, worker, "cancel", nil, http.StatusOK, ""); string(out.body) != `{"cancelled":false}` {
		t.Fatalf("body %s", out.body)
	}
	if got := f.membership(t, orgA, worker).GetString("deletion_scheduled_for"); got == "" {
		t.Fatal("mark cleared")
	}
}
