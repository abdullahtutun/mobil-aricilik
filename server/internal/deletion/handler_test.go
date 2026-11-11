package deletion_test

// supabase/functions/account-delete/handler_test.ts, the user actions. Not
// carried: "anonim kullanıcının çağrısı reddedilir" (PocketBase has no
// anonymous users) and the cron tests (x-cron-secret, purge_due: P5.9).

import (
	"errors"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

const hsrc = "handler_test.ts/"

func handlerFixture(t *testing.T) *fixture {
	return newFixture(t,
		member{orgA, owner, "owner"},
		member{orgA, partner, "partner"},
		member{orgA, worker, "worker"},
	)
}

// nothingWritten checks that no request and no code row exist.
func nothingWritten(t *testing.T, f *fixture) {
	t.Helper()
	if n := f.count(t, deletion.RequestsCollection, nil); n != 0 {
		t.Fatalf("%d requests", n)
	}
	if n := f.count(t, deletion.CodesCollection, nil); n != 0 {
		t.Fatalf("%d codes", n)
	}
}

// sessionOpen checks that the token still opens a session (status 200).
func sessionOpen(t *testing.T, f *fixture, token string) {
	t.Helper()
	f.call(t, http.MethodPost, deletion.RoutePrefix+"status", token, "{}", http.StatusOK)
}

// sessionClosed checks that the token is refused (401).
func sessionClosed(t *testing.T, f *fixture, token string) {
	t.Helper()
	f.call(t, http.MethodPost, deletion.RoutePrefix+"status", token, "{}", http.StatusUnauthorized)
}

func TestHandlerAuth(t *testing.T) {
	t.Run(hsrc+"oturumsuz çağrı reddedilir ve veritabanına gitmez", func(t *testing.T) {
		f := handlerFixture(t)
		for _, action := range []string{"request", "send_code", "verify_code", "status", "cancel"} {
			f.post(t, "", action, map[string]any{}, http.StatusUnauthorized, "")
		}
		nothingWritten(t, f)
		if f.app.TestMailer.TotalSend() != 0 {
			t.Fatal("e-mail sent")
		}
	})
	t.Run(hsrc+"geçersiz JWT reddedilir", func(t *testing.T) {
		f := handlerFixture(t)
		f.postToken(t, "Bearer bozuk", "request", map[string]any{}, http.StatusUnauthorized, "")
		f.postToken(t, "bozuk", "send_code", map[string]any{}, http.StatusUnauthorized, "")
		nothingWritten(t, f)
	})
	t.Run(hsrc+"kullanıcı kalıcı silmeyi doğrudan başlatamaz", func(t *testing.T) {
		f := handlerFixture(t)
		f.post(t, worker, "purge_due", map[string]any{}, http.StatusBadRequest, deletion.CodeBadRequest)
		nothingWritten(t, f)
	})
}

func TestHandlerRequest(t *testing.T) {
	t.Run(hsrc+"talep JWT'nin kullanıcısı için açılır, oturumlar kapanır, e-posta gider", func(t *testing.T) {
		f := handlerFixture(t)
		old := f.tokens[worker]
		f.confirm(t, worker)
		mails := f.app.TestMailer.TotalSend()
		out := f.post(t, worker, "request", map[string]any{"org_id": orgA, "user_id": outsider}, http.StatusOK, "")

		reqs := f.requests(t, worker)
		if len(reqs) != 1 || len(f.requests(t, outsider)) != 0 {
			t.Fatalf("requests: worker %d", len(reqs))
		}
		r := reqs[0]
		if r.GetString("org_id") != orgA || r.GetString("channel") != deletion.ChannelApp ||
			r.GetString("kind") != deletion.KindAccount || r.GetString("user_hash") != deletion.Hash(worker) ||
			r.GetString("email_hash") != deletion.Hash("worker@test.local") {
			t.Fatalf("request %v", r.FieldsData())
		}
		want := `{"request":{"id":"` + r.Id + `","org_id":"` + orgA + `","kind":"hesap","channel":"uygulama","status":"bekliyor",` +
			`"requested_at":"2026-11-05T09:31:01.000000Z","scheduled_for":"2026-11-12T09:31:01.000000Z","delete_org_ids":[]},` +
			`"counts":{"hives":0,"apiaries":0,"inspections":0,"harvests":0,"documents":0,"photos":0,"public_lot_pages":0},` +
			`"already_pending":false}`
		if string(out.body) != want {
			t.Fatalf("body\n%s\nwant\n%s", out.body, want)
		}

		// Every session ends: the old token is refused everywhere.
		sessionClosed(t, f, old)
		f.call(t, http.MethodGet, "/api/sync/pull?table=hives&since_seq=0&page_size=10", old, "", http.StatusUnauthorized)
		sessionOpen(t, f, f.signIn(t, worker))

		if f.app.TestMailer.TotalSend() != mails+1 {
			t.Fatalf("%d e-mails", f.app.TestMailer.TotalSend()-mails)
		}
		m := f.app.TestMailer.LastMessage()
		if len(m.To) != 1 || m.To[0].Address != "worker@test.local" || m.Subject != "Mobil Arıcı hesabın silinecek" {
			t.Fatalf("mail to %v: %q", m.To, m.Subject)
		}
		for _, s := range []string{"12 Kasım 2026 12:31 (TSİ)", "giriş yap ve hesabını korumak istediğini onayla", "işletmede kalır"} {
			if !strings.Contains(m.Text, s) {
				t.Errorf("mail lacks %q:\n%s", s, m.Text)
			}
		}
	})

	t.Run(hsrc+"sahiplik devri ortağın kimliğiyle RPC'ye gider", func(t *testing.T) {
		f := handlerFixture(t)
		f.request(t, owner, map[string]any{"org_id": orgA, "transfer_to": partner}, http.StatusOK, "")
		if f.membership(t, orgA, partner).GetString("role") != "owner" || f.membership(t, orgA, owner).GetString("role") != "partner" {
			t.Fatal("ownership not transferred")
		}
		if got := f.requests(t, owner)[0].GetString("kind"); got != deletion.KindAccount {
			t.Fatalf("kind %q", got)
		}
	})

	t.Run(hsrc+"devir hedefi uygun değilse 422 alır, oturumlar kapanmaz", func(t *testing.T) {
		f := handlerFixture(t)
		f.confirm(t, owner)
		mails := f.app.TestMailer.TotalSend()
		out := f.post(t, owner, "request", map[string]any{"org_id": orgA, "transfer_to": worker},
			http.StatusUnprocessableEntity, deletion.CodeInvalidTransferTarget)
		if string(out.body) != `{"status":422,"message":"Ownership can only go to an active partner of the organization.","data":{"code":"invalid_transfer_target"}}` {
			t.Fatalf("body %s", out.body)
		}
		sessionOpen(t, f, f.tokens[owner])
		if f.app.TestMailer.TotalSend() != mails {
			t.Fatal("e-mail sent")
		}
	})

	t.Run(hsrc+"status bekleyen talebi ya da null döner, talebi iptal etmez", func(t *testing.T) {
		f := handlerFixture(t)
		if out := f.post(t, worker, "status", nil, http.StatusOK, ""); string(out.body) != `{"request":null}` {
			t.Fatalf("body %s", out.body)
		}
		f.request(t, worker, map[string]any{}, http.StatusOK, "")
		tok := f.signIn(t, worker)
		for range 2 {
			got := requestOf(t, f.post(t, worker, "status", nil, http.StatusOK, ""))
			if got["status"] != deletion.StatusPending || got["scheduled_for"] == nil {
				t.Fatalf("status %v", got)
			}
		}
		sessionOpen(t, f, tok)
		if f.requests(t, worker)[0].GetString("status") != deletion.StatusPending {
			t.Fatal("status cancelled the request")
		}
	})

	t.Run(hsrc+"bekleyen talep tekrar istenirse e-posta yinelenmez, oturumlar yine kapanır", func(t *testing.T) {
		f := handlerFixture(t)
		f.request(t, worker, map[string]any{}, http.StatusOK, "")
		tok := f.signIn(t, worker)
		f.confirm(t, worker)
		mails := f.app.TestMailer.TotalSend()
		out := f.post(t, worker, "request", map[string]any{}, http.StatusOK, "")
		if out.object(t)["already_pending"] != true || f.app.TestMailer.TotalSend() != mails {
			t.Fatalf("body %s, %d e-mails", out.body, f.app.TestMailer.TotalSend()-mails)
		}
		sessionClosed(t, f, tok)
	})

	t.Run(hsrc+"devir yapılmadan owner'ın talebi 409 ile işletmeleri döner", func(t *testing.T) {
		f := handlerFixture(t)
		f.confirm(t, owner)
		mails := f.app.TestMailer.TotalSend()
		out := f.post(t, owner, "request", map[string]any{}, http.StatusConflict, deletion.CodeOwnerMustTransfer)
		if !strings.Contains(string(out.body), `"data":{"code":"owner_must_transfer","org_ids":["`+orgA+`"]}`) {
			t.Fatalf("body %s", out.body)
		}
		sessionOpen(t, f, f.tokens[owner])
		if f.app.TestMailer.TotalSend() != mails {
			t.Fatal("e-mail sent")
		}
	})

	t.Run(hsrc+"sık tekrarlanan talep 429 alır", func(t *testing.T) {
		f := handlerFixture(t)
		for i := range deletion.RequestLimit {
			f.insert(t, deletion.RequestsCollection, "", map[string]any{
				"user_id": worker, "kind": "hesap", "channel": "uygulama", "status": "iptal",
				"requested_at":  stampAt(f.clock.Add(-deletion.RequestWindow).Add(time.Duration(i+1) * 2 * time.Minute)),
				"scheduled_for": stampAt(f.clock.Add(deletion.GracePeriod)),
				"cancelled_at":  stampAt(f.clock),
				"delete_org_ids": []string{}, "user_hash": deletion.Hash(worker),
			})
		}
		f.request(t, worker, map[string]any{}, http.StatusTooManyRequests, deletion.CodeRateLimited)
		sessionOpen(t, f, f.tokens[worker])
		// Ek: pencere dışına çıkan talep sayılmaz.
		f.advance(time.Minute)
		f.post(t, worker, "request", map[string]any{}, http.StatusOK, "")
	})

	t.Run(hsrc+"geçersiz girdi 400 alır", func(t *testing.T) {
		f := handlerFixture(t)
		f.confirm(t, owner)
		for _, b := range []any{
			map[string]any{"delete_organization": true},
			map[string]any{"org_id": "bozuk"},
			map[string]any{"org_id": strings.ToUpper(orgA)},
			map[string]any{"org_id": 42},
			map[string]any{"channel": "sms"},
			map[string]any{"channel": 1},
			map[string]any{"delete_organization": "evet"},
			map[string]any{"transfer_to": partner},
			map[string]any{"org_id": orgA, "transfer_to": "bozuk"},
			map[string]any{"org_id": orgA, "transfer_to": partner, "delete_organization": true},
			map[string]any{"org_id": orgA, "transfer_to": owner},
			"[]",
			"{bozuk",
		} {
			f.post(t, owner, "request", b, http.StatusBadRequest, deletion.CodeBadRequest)
		}
		f.post(t, owner, "bilinmeyen", map[string]any{}, http.StatusBadRequest, deletion.CodeBadRequest)
		if n := f.count(t, deletion.RequestsCollection, nil); n != 0 {
			t.Fatalf("%d requests", n)
		}
		if ok, _ := deletion.CodeVerified(f.app, owner); !ok {
			t.Fatal("the code was used")
		}
	})

	t.Run(hsrc+"iptal yalnız JWT'nin kullanıcısının talebini iptal eder", func(t *testing.T) {
		f := handlerFixture(t)
		f.request(t, worker, map[string]any{}, http.StatusOK, "")
		f.request(t, partner, map[string]any{}, http.StatusOK, "")
		f.signIn(t, worker)
		out := f.post(t, worker, "cancel", map[string]any{"user_id": partner}, http.StatusOK, "")
		if string(out.body) != `{"cancelled":true}` {
			t.Fatalf("body %s", out.body)
		}
		if f.requests(t, worker)[0].GetString("status") != deletion.StatusCancelled ||
			f.requests(t, partner)[0].GetString("status") != deletion.StatusPending {
			t.Fatal("wrong request cancelled")
		}
	})
}

func TestHandlerCode(t *testing.T) {
	t.Run(hsrc+"doğrulanmış kod yoksa talep açılmaz, oturumlar kapanmaz", func(t *testing.T) {
		f := handlerFixture(t)
		out := f.post(t, worker, "request", map[string]any{}, http.StatusForbidden, deletion.CodeCodeRequired)
		if string(out.body) != `{"status":403,"message":"Confirm the deletion with the code sent by e-mail first.","data":{"code":"code_required"}}` {
			t.Fatalf("body %s", out.body)
		}
		sessionOpen(t, f, f.tokens[worker])
		nothingWritten(t, f)
	})

	t.Run(hsrc+"reddedilen talepte kod tüketilmez", func(t *testing.T) {
		f := handlerFixture(t)
		f.request(t, owner, map[string]any{}, http.StatusConflict, deletion.CodeOwnerMustTransfer)
		if ok, _ := deletion.CodeVerified(f.app, owner); !ok {
			t.Fatal("the code was used")
		}
	})

	t.Run(hsrc+"kod silme e-postasıyla gider, giriş kodu demez", func(t *testing.T) {
		f := handlerFixture(t)
		out := f.post(t, worker, "send_code", nil, http.StatusOK, "")
		if string(out.body) != `{"sent":true}` {
			t.Fatalf("body %s", out.body)
		}
		m := f.app.TestMailer.LastMessage()
		s := f.app.Settings().Meta
		if len(m.To) != 1 || m.To[0].Address != "worker@test.local" || m.From.Address != s.SenderAddress || m.From.Name != s.SenderName {
			t.Fatalf("mail %v → %v", m.From, m.To)
		}
		if m.Subject != "Mobil Arıcı hesap silme kodun" || strings.Contains(strings.ToLower(m.Text), "giriş kod") || m.HTML != "" {
			t.Fatalf("mail %q\n%s", m.Subject, m.Text)
		}
		code := codeInText.FindStringSubmatch(m.Text)
		if code == nil || codeRow(t, f, worker).GetString("code_hash") != deletion.Hash(worker+":"+code[1]) {
			t.Fatalf("code not in the mail or not stored:\n%s", m.Text)
		}
	})

	t.Run(hsrc+"sık kod isteği 429 alır, e-posta gitmez", func(t *testing.T) {
		f := handlerFixture(t)
		f.sendCode(t, worker)
		mails := f.app.TestMailer.TotalSend()
		f.post(t, worker, "send_code", nil, http.StatusTooManyRequests, deletion.CodeRateLimited)
		if f.app.TestMailer.TotalSend() != mails {
			t.Fatal("e-mail sent")
		}
	})

	t.Run(hsrc+"kod doğrulama: doğru, yanlış, kilitli, biçimsiz", func(t *testing.T) {
		f := handlerFixture(t)
		code := f.sendCode(t, worker)
		wrong := "000000"
		if code == wrong {
			wrong = "111111"
		}
		if out := f.post(t, worker, "verify_code", map[string]any{"code": code}, http.StatusOK, ""); string(out.body) != `{"verified":true}` {
			t.Fatalf("body %s", out.body)
		}
		f.post(t, worker, "verify_code", map[string]any{"code": wrong}, http.StatusBadRequest, deletion.CodeInvalidCode)
		f.advance(deletion.CodeTTL)
		f.post(t, worker, "verify_code", map[string]any{"code": code}, http.StatusBadRequest, deletion.CodeInvalidCode)
		r := codeRow(t, f, worker)
		r.Set("attempts", deletion.CodeMaxAttempts)
		f.save(t, r)
		f.post(t, worker, "verify_code", map[string]any{"code": code}, http.StatusTooManyRequests, deletion.CodeTooManyAttempts)

		r.Set("attempts", 0)
		r.Set("expires_at", stampAt(f.clock.Add(deletion.CodeTTL)))
		f.save(t, r)
		for _, bad := range []any{"12ab", "1234567", 123456, nil} {
			f.post(t, worker, "verify_code", map[string]any{"code": bad}, http.StatusBadRequest, deletion.CodeInvalidCode)
		}
		if got := codeRow(t, f, worker).GetInt("attempts"); got != 0 {
			t.Fatalf("malformed codes counted: attempts %d", got)
		}
	})
}

// Ek: e-posta kapısı ve gönderim hatası.
func TestHandlerMail(t *testing.T) {
	t.Run("SMTP yokken kod yazılmaz, 503 mail_unavailable", func(t *testing.T) {
		f := newFixtureWith(t, config.Config{Env: config.EnvProd}, member{orgA, worker, "owner"})
		f.post(t, worker, "send_code", nil, http.StatusServiceUnavailable, deletion.CodeMailUnavailable)
		nothingWritten(t, f)
	})

	t.Run("kod e-postası gönderilemezse 502 mail_failed (kod kalır, sınıra sayılır)", func(t *testing.T) {
		f := handlerFixture(t)
		f.app.OnMailerSend().BindFunc(func(*core.MailerEvent) error { return errors.New("smtp down") })
		f.post(t, worker, "send_code", nil, http.StatusBadGateway, deletion.CodeMailFailed)
		if codeRow(t, f, worker) == nil {
			t.Fatal("no code row")
		}
		f.post(t, worker, "send_code", nil, http.StatusTooManyRequests, deletion.CodeRateLimited)
	})

	t.Run("talep e-postası gönderilemezse talep yine yazılır", func(t *testing.T) {
		f := handlerFixture(t)
		f.confirm(t, worker)
		f.app.OnMailerSend().BindFunc(func(*core.MailerEvent) error { return errors.New("smtp down") })
		f.post(t, worker, "request", map[string]any{}, http.StatusOK, "")
		if len(f.requests(t, worker)) != 1 {
			t.Fatal("no request")
		}
	})

	t.Run("dil kullanıcının locale'inden", func(t *testing.T) {
		f := handlerFixture(t)
		u, _ := f.app.FindRecordById("users", worker)
		u.Set("locale", "de")
		f.save(t, u)
		f.request(t, worker, map[string]any{}, http.StatusOK, "")
		m := f.app.TestMailer.LastMessage()
		if m.Subject != "Dein Mobil-Arıcı-Konto wird gelöscht" || !strings.Contains(m.Text, "UTC") {
			t.Fatalf("mail %q\n%s", m.Subject, m.Text)
		}
	})
}

// Ek: talep, devir ve yan etkiler tek transaction'da; sonradan bir adım
// düşerse hiçbiri kalmaz.
func TestRequestIsOneTransaction(t *testing.T) {
	f := handlerFixture(t)
	f.deviceToken(t, owner, "token-owner")
	f.invite(t, orgA, "AAAAAA", owner)
	f.confirm(t, owner)
	tok := f.tokens[owner]
	// Saving the user (the last step) fails.
	f.app.OnRecordUpdate("users").BindFunc(func(*core.RecordEvent) error { return errors.New("disk full") })
	f.post(t, owner, "request", map[string]any{"org_id": orgA, "transfer_to": partner}, http.StatusInternalServerError, "server")

	if len(f.requests(t, owner)) != 0 || f.membership(t, orgA, owner).GetString("role") != "owner" ||
		f.membership(t, orgA, owner).GetString("deletion_scheduled_for") != "" ||
		f.count(t, "device_tokens", dbx.HashExp{"user_id": owner}) != 1 || !f.inviteLive(t, "AAAAAA") {
		t.Fatal("a step stayed after the rollback")
	}
	if ok, _ := deletion.CodeVerified(f.app, owner); !ok {
		t.Fatal("the code was used")
	}
	sessionOpen(t, f, tok)
}
