package deletion_test

// supabase/tests/database/account_deletion_transfer.test.sql: handing the
// ownership to a partner and asking for the pending request
// (20261114120000). 1111 owner of A, 2222 partner, 3333 worker, 5555 a
// second partner whose own deletion is pending, 9999 not in A.

import (
	"net/http"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/pocketbase/dbx"
)

func TestAccountDeletionTransferSQL(t *testing.T) {
	const src = "account_deletion_transfer.test.sql/"
	f := newFixture(t,
		member{orgA, owner, "owner"},
		member{orgA, partner, "partner"},
		member{orgA, worker, "worker"},
		member{orgA, leaving, "partner"},
	)
	f.row(t, "apiaries", "a1000000-0000-0000-0000-000000000001", orgA, nil)
	seqBefore := map[string]int{}
	for _, u := range []string{owner, partner} {
		seqBefore[u] = f.membership(t, orgA, u).GetInt("server_seq")
	}

	step(t, src+"ikinci ortak kendi hesabını silmek ister", func(t *testing.T) {
		f.request(t, leaving, map[string]any{"org_id": orgA}, http.StatusOK, "")
	})
	step(t, src+"bekleyen talebi yoksa null", func(t *testing.T) {
		out := f.post(t, owner, "status", nil, http.StatusOK, "")
		if string(out.body) != `{"request":null}` {
			t.Fatalf("body %s", out.body)
		}
	})

	f.confirm(t, owner)
	transfer := func(to string, extra map[string]any) map[string]any {
		b := map[string]any{"org_id": orgA, "transfer_to": to}
		for k, v := range extra {
			b[k] = v
		}
		return b
	}
	step(t, src+"worker'a devredilmez (yalnız ortağa)", func(t *testing.T) {
		f.post(t, owner, "request", transfer(worker, nil), http.StatusUnprocessableEntity, deletion.CodeInvalidTransferTarget)
	})
	step(t, src+"işletmede olmayana devredilmez", func(t *testing.T) {
		f.post(t, owner, "request", transfer(outsider, nil), http.StatusUnprocessableEntity, deletion.CodeInvalidTransferTarget)
	})
	step(t, src+"kendi silme talebi bekleyen ortağa devredilmez", func(t *testing.T) {
		f.post(t, owner, "request", transfer(leaving, nil), http.StatusUnprocessableEntity, deletion.CodeInvalidTransferTarget)
	})
	step(t, src+"devir ile işletmeyi silmek birlikte seçilemez", func(t *testing.T) {
		f.post(t, owner, "request", transfer(partner, map[string]any{"delete_organization": true}),
			http.StatusBadRequest, deletion.CodeBadRequest)
	})
	step(t, src+"owner olmayan sahipliği devredemez", func(t *testing.T) {
		f.request(t, partner, transfer(leaving, nil), http.StatusForbidden, deletion.CodeForbidden)
	})
	step(t, src+"reddedilen devirde roller değişmez", func(t *testing.T) {
		if got := f.membership(t, orgA, owner).GetString("role"); got != "owner" {
			t.Fatalf("owner's role %q", got)
		}
		if got := f.membership(t, orgA, partner).GetString("role"); got != "partner" {
			t.Fatalf("partner's role %q", got)
		}
		if n := len(f.requests(t, owner)); n != 0 {
			t.Fatalf("%d requests of the owner", n)
		}
	})

	var out response
	step(t, src+"devirde yalnız hesap silinir", func(t *testing.T) {
		// The owner's code is still verified: refused requests do not use it.
		out = f.post(t, owner, "request", transfer(partner, nil), http.StatusOK, "")
		if got := requestOf(t, out)["kind"]; got != deletion.KindAccount {
			t.Fatalf("kind %v (%s)", got, out.body)
		}
	})
	step(t, src+"devirde silinecek işletme kaydı yok", func(t *testing.T) {
		counts, _ := out.object(t)["counts"].(map[string]any)
		if counts["hives"] != 0.0 || counts["apiaries"] != 0.0 {
			t.Fatalf("counts %v", counts)
		}
	})
	step(t, src+"ortak owner olur, eski owner partner olur", func(t *testing.T) {
		want := map[string]string{owner: "partner", partner: "owner", worker: "worker", leaving: "partner"}
		for u, role := range want {
			if got := f.membership(t, orgA, u).GetString("role"); got != role {
				t.Errorf("%s: role %q, want %q", u, got, role)
			}
		}
		if n := f.count(t, "memberships", dbx.HashExp{"org_id": orgA, "deleted_at": ""}); n != 4 {
			t.Errorf("%d live memberships", n)
		}
	})
	step(t, src+"rol değişikliği diğer cihazlara senkronla ulaşır", func(t *testing.T) {
		for _, u := range []string{owner, partner} {
			if got := f.membership(t, orgA, u).GetInt("server_seq"); got <= seqBefore[u] {
				t.Errorf("%s: server_seq %d, before %d", u, got, seqBefore[u])
			}
		}
	})
	step(t, src+"işletme kalır", func(t *testing.T) {
		if _, err := f.app.FindRecordById("organizations", orgA); err != nil {
			t.Fatal(err)
		}
	})
	step(t, src+"bekleyen talep sorulabilir", func(t *testing.T) {
		f.signIn(t, owner)
		got := requestOf(t, f.post(t, owner, "status", nil, http.StatusOK, ""))
		if got["kind"] != deletion.KindAccount || got["status"] != deletion.StatusPending {
			t.Fatalf("request %v", got)
		}
	})
	step(t, src+"oturumlu kullanıcı bekleyen talep fonksiyonunu çağıramaz (status yalnız kendi talebini döner)", func(t *testing.T) {
		out := f.post(t, worker, "status", nil, http.StatusOK, "")
		if string(out.body) != `{"request":null}` {
			t.Fatalf("worker sees %s", out.body)
		}
	})
}
