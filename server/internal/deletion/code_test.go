package deletion_test

// supabase/tests/database/account_deletion_code.test.sql: the deletion code
// and the member about to leave (20261115120000). The SQL calls the
// functions directly; here they are the routes (send_code, verify_code,
// request, cancel). 1111 owner of A, 2222 partner of A.

import (
	"net/http"
	"regexp"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

func codeRow(t testing.TB, f *fixture, user string) *core.Record {
	t.Helper()
	r, err := f.app.FindFirstRecordByData(deletion.CodesCollection, "user_id", user)
	if err != nil {
		return nil
	}
	return r
}

func TestAccountDeletionCodeSQL(t *testing.T) {
	const src = "account_deletion_code.test.sql/"
	f := newFixture(t,
		member{orgA, owner, "owner"},
		member{orgA, partner, "partner"},
	)

	var code string
	step(t, src+"kod 6 hanelidir", func(t *testing.T) {
		code = f.sendCode(t, partner)
		if !regexp.MustCompile(`^[0-9]{6}$`).MatchString(code) {
			t.Fatalf("code %q", code)
		}
	})
	step(t, src+"kod düz saklanmaz", func(t *testing.T) {
		r := codeRow(t, f, partner)
		if r == nil {
			t.Fatal("no code row")
		}
		if got := r.GetString("code_hash"); got == code || got != deletion.Hash(partner+":"+code) {
			t.Fatalf("code_hash = %q", got)
		}
	})
	step(t, src+"60 saniye dolmadan yeni kod istenemez", func(t *testing.T) {
		f.advance(59 * time.Second)
		f.post(t, partner, "send_code", nil, http.StatusTooManyRequests, deletion.CodeRateLimited)
	})
	step(t, src+"doğrulanmamış kodla talep açılamaz", func(t *testing.T) {
		f.post(t, partner, "request", map[string]any{"org_id": orgA}, http.StatusForbidden, deletion.CodeCodeRequired)
	})
	step(t, src+"yanlış kod reddedilir", func(t *testing.T) {
		wrong := "000000"
		if code == wrong {
			wrong = "111111"
		}
		f.post(t, partner, "verify_code", map[string]any{"code": wrong}, http.StatusBadRequest, deletion.CodeInvalidCode)
	})
	step(t, src+"başkasının kodu geçmez", func(t *testing.T) {
		f.post(t, owner, "verify_code", map[string]any{"code": code}, http.StatusBadRequest, deletion.CodeInvalidCode)
	})
	step(t, src+"doğru kod doğrulanır", func(t *testing.T) {
		out := f.post(t, partner, "verify_code", map[string]any{"code": code}, http.StatusOK, "")
		if string(out.body) != `{"verified":true}` {
			t.Fatalf("body %s", out.body)
		}
	})
	step(t, src+"doğrulanmış kod 15 dakika geçerli", func(t *testing.T) {
		start := f.clock
		defer func() { f.clock = start }()
		f.advance(deletion.CodeVerifiedFor - time.Second)
		if ok, err := deletion.CodeVerified(f.app, partner); err != nil || !ok {
			t.Fatalf("at 14:59 verified = %v, %v", ok, err)
		}
		f.advance(2 * time.Second)
		if ok, err := deletion.CodeVerified(f.app, partner); err != nil || ok {
			t.Fatalf("at 15:01 verified = %v, %v", ok, err)
		}
	})

	// Expired and locked codes (1111).
	var ownerCode string
	step(t, src+"süresi dolan kod geçmez", func(t *testing.T) {
		f.advance(2 * time.Minute)
		ownerCode = f.sendCode(t, owner)
		f.advance(deletion.CodeTTL + time.Second)
		if got, err := deletion.CheckCode(f.app, owner, ownerCode); err != nil || got != deletion.VerifyExpired {
			t.Fatalf("CheckCode = %q, %v", got, err)
		}
		f.post(t, owner, "verify_code", map[string]any{"code": ownerCode}, http.StatusBadRequest, deletion.CodeInvalidCode)
	})
	step(t, src+"beşinci yanlış denemede kod kilitlenir", func(t *testing.T) {
		r := codeRow(t, f, owner)
		r.Set("expires_at", stampAt(f.clock.Add(5*time.Minute)))
		r.Set("attempts", 4)
		f.save(t, r)
		wrong := "000000"
		if ownerCode == wrong {
			wrong = "111111"
		}
		f.post(t, owner, "verify_code", map[string]any{"code": wrong}, http.StatusTooManyRequests, deletion.CodeTooManyAttempts)
	})
	step(t, src+"kilitli kod doğruyla da geçmez", func(t *testing.T) {
		f.post(t, owner, "verify_code", map[string]any{"code": ownerCode}, http.StatusTooManyRequests, deletion.CodeTooManyAttempts)
	})
	step(t, src+"saatte 5 koddan fazlası istenemez", func(t *testing.T) {
		r := codeRow(t, f, owner)
		r.Set("sent_at", stampAt(f.clock.Add(-2*time.Minute)))
		r.Set("sent_in_window", 5)
		f.save(t, r)
		f.post(t, owner, "send_code", nil, http.StatusTooManyRequests, deletion.CodeRateLimited)
		// Ek: pencere dolunca yeniden gönderilir, sayaç baştan başlar.
		f.advance(deletion.CodeWindow)
		f.sendCode(t, owner)
		if got := codeRow(t, f, owner).GetInt("sent_in_window"); got != 1 {
			t.Fatalf("sent_in_window = %d", got)
		}
	})
	step(t, src+"oturumlu kullanıcı kod fonksiyonunu doğrudan çağıramaz", func(t *testing.T) {
		// The codes are not open to the record API (rules null).
		f.call(t, http.MethodGet, "/api/collections/deletion_codes/records", f.tokens[owner], "", http.StatusForbidden)
		f.call(t, http.MethodPost, "/api/collections/deletion_codes/records", f.tokens[owner],
			`{"user_id":"`+owner+`","code_hash":"x"}`, http.StatusForbidden)
	})

	// The member about to leave.
	seqBefore := f.membership(t, orgA, partner).GetInt("server_seq")
	var scheduled string
	step(t, src+"talepte üyeliğe silme tarihi yazılır", func(t *testing.T) {
		out := f.request(t, partner, map[string]any{"org_id": orgA}, http.StatusOK, "")
		scheduled, _ = requestOf(t, out)["scheduled_for"].(string)
		if got := f.membership(t, orgA, partner).GetString("deletion_scheduled_for"); got == "" || got != scheduled {
			t.Fatalf("deletion_scheduled_for = %q, request %q", got, scheduled)
		}
	})
	step(t, src+"kod tüketilir", func(t *testing.T) {
		if codeRow(t, f, partner) != nil {
			t.Fatal("the code row is still there")
		}
	})
	step(t, src+"tüketilen kod yeniden kullanılamaz", func(t *testing.T) {
		f.signIn(t, partner)
		f.post(t, partner, "request", map[string]any{"org_id": orgA}, http.StatusForbidden, deletion.CodeCodeRequired)
	})
	step(t, src+"işaret diğer cihazlara senkronla ulaşır", func(t *testing.T) {
		if got := f.membership(t, orgA, partner).GetInt("server_seq"); got <= seqBefore {
			t.Fatalf("server_seq %d, before %d", got, seqBefore)
		}
	})
	step(t, src+"diğer üyeler işaretlenmez", func(t *testing.T) {
		if got := f.membership(t, orgA, owner).GetString("deletion_scheduled_for"); got != "" {
			t.Fatalf("owner marked %q", got)
		}
	})
	step(t, src+"talep iptal edilir", func(t *testing.T) {
		out := f.post(t, partner, "cancel", nil, http.StatusOK, "")
		if string(out.body) != `{"cancelled":true}` {
			t.Fatalf("body %s", out.body)
		}
	})
	step(t, src+"iptalde işaret kalkar", func(t *testing.T) {
		if got := f.membership(t, orgA, partner).GetString("deletion_scheduled_for"); got != "" {
			t.Fatalf("still marked %q", got)
		}
		if n := f.count(t, "memberships", dbx.NewExp("deletion_scheduled_for != ''")); n != 0 {
			t.Fatalf("%d marked memberships", n)
		}
	})
}

func stampAt(v time.Time) string { return v.UTC().Format("2006-01-02T15:04:05.000000Z") }
