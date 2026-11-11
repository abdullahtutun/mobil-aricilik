package deletion_test

import (
	"bytes"
	"encoding/json"
	"errors"
	"image"
	"image/jpeg"
	"net/http"
	"strings"
	"sync/atomic"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/files"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/filesystem"
)

// Kaynaklar: handler_test.ts'in "Kalıcı silme (cron)" senaryoları ve
// account_deletion.test.sql'in "Cron: süresi dolanlar silinir" kısmı
// (P5.8'de taşınmayanlar). Testlerin adında kaynak.
const (
	psrc = "account_deletion.test.sql/"
	// The rows of the pgTAP file: A's records entered by the worker, B's
	// records of every kind.
	apiaryA    = "a1000000-0000-0000-0000-000000000001"
	hiveA      = "a2000000-0000-0000-0000-000000000001"
	inspA      = "a3000000-0000-0000-0000-000000000001"
	taskA      = "a4000000-0000-0000-0000-000000000001"
	ownTaskA   = "a4000000-0000-0000-0000-000000000002"
	feedbackA  = "a5000000-0000-0000-0000-000000000001"
	apiaryB    = "b1000000-0000-0000-0000-000000000001"
	hiveB      = "b2000000-0000-0000-0000-000000000001"
	inspB      = "b3000000-0000-0000-0000-000000000001"
	harvestB   = "b4000000-0000-0000-0000-000000000001"
	documentB  = "b5000000-0000-0000-0000-000000000001"
	docFileB   = "b5100000-0000-0000-0000-000000000001"
	mediaB     = "b6000000-0000-0000-0000-000000000001"
	lotB       = "b7000000-0000-0000-0000-000000000001"
	feedbackB  = "b8000000-0000-0000-0000-000000000001"
	mediaFileA = "a6000000-0000-0000-0000-000000000001"
)

var jpegBytes = func() []byte {
	var b bytes.Buffer
	if err := jpeg.Encode(&b, image.NewRGBA(image.Rect(0, 0, 8, 8)), nil); err != nil {
		panic(err)
	}
	return b.Bytes()
}()

// fileRecord saves a file record with a JPEG, as the upload does.
func (f *fixture) fileRecord(t *testing.T, collection, org, path string) *core.Record {
	t.Helper()
	last := path[strings.LastIndexByte(path, '/')+1:]
	file, err := filesystem.NewFileFromBytes(jpegBytes, last)
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(f.collection(t, collection))
	r.Id = last[:strings.IndexByte(last, '.')]
	r.Set(files.FieldOrgID, org)
	r.Set(files.FieldPath, path)
	r.Set(files.FieldFile, file)
	f.save(t, r)
	return r
}

// fileExists reports whether the record's stored file is on disk.
func (f *fixture) fileExists(t *testing.T, r *core.Record) bool {
	t.Helper()
	fsys, err := f.app.NewFilesystem()
	if err != nil {
		t.Fatal(err)
	}
	defer fsys.Close()
	ok, err := fsys.Exists(r.BaseFilesPath() + "/" + r.GetString(files.FieldFile))
	if err != nil {
		t.Fatal(err)
	}
	return ok
}

// feedback writes a feedback row with SQL (no e-mail hook).
func (f *fixture) feedback(t *testing.T, id, org, by string) {
	t.Helper()
	_, err := f.app.DB().Insert("feedback", dbx.Params{
		"id": id, "org_id": org, "kind": "bug", "message": "m",
		"screenshot_path": org + "/" + id + ".jpg", "created_at": testTime,
		"received_at": testTime, "created_by": by,
	}).Execute()
	if err != nil {
		t.Fatal(err)
	}
}

// orgRows is pg_temp.org_rows: the rows of every collection carrying the
// organization's org_id (deletion_requests aside), and the organization.
func (f *fixture) orgRows(t *testing.T, org string) int {
	t.Helper()
	cols, err := f.app.FindAllCollections()
	if err != nil {
		t.Fatal(err)
	}
	total := 0
	for _, c := range cols {
		if c.Name == deletion.RequestsCollection || c.Fields.GetByName("org_id") == nil {
			continue
		}
		total += f.count(t, c.Name, dbx.HashExp{"org_id": org})
	}
	return total + f.count(t, "organizations", dbx.HashExp{"id": org})
}

func (f *fixture) exists(t *testing.T, collection, id string) bool {
	t.Helper()
	return f.count(t, collection, dbx.HashExp{"id": id}) == 1
}

func (f *fixture) record(t *testing.T, collection, id string) *core.Record {
	t.Helper()
	r, err := f.app.FindRecordById(collection, id)
	if err != nil {
		t.Fatalf("%s %s: %v", collection, id, err)
	}
	return r
}

func (f *fixture) purge(t *testing.T, want deletion.PurgeResult) {
	t.Helper()
	got, err := deletion.PurgeDue(f.app)
	if err != nil {
		t.Fatal(err)
	}
	if got != want {
		t.Fatalf("purge = %+v, want %+v", got, want)
	}
}

func mustJSON(t *testing.T, v any) []byte {
	t.Helper()
	b, err := json.Marshal(v)
	if err != nil {
		t.Fatal(err)
	}
	return b
}

// due moves the clock past the request's date.
func (f *fixture) due() { f.advance(deletion.GracePeriod + time.Minute) }

// failing makes the hook refuse the next n calls (n < 0: all).
type failing struct{ left atomic.Int32 }

func (x *failing) hook(e *core.RecordEvent) error {
	if x.left.Load() != 0 {
		x.left.Add(-1)
		return errors.New("injected failure")
	}
	return e.Next()
}

// soloFixture is account_deletion.test.sql's B: the one-person
// organization with a record of every kind and its files, and A with a
// file of its own. The solo user asks for the deletion.
type soloFiles struct{ media, lotReport, feedbackShot, mediaA *core.Record }

func soloFixture(t *testing.T) (*fixture, soloFiles, string) {
	t.Helper()
	f := newFixture(t, member{orgA, owner, "owner"}, member{orgB, solo, "owner"})
	f.row(t, "apiaries", apiaryB, orgB, dbx.Params{"created_by": solo})
	f.row(t, "hives", hiveB, orgB, nil)
	f.row(t, "inspections", inspB, orgB, nil)
	f.row(t, "harvests", harvestB, orgB, nil)
	f.row(t, "documents", documentB, orgB, nil)
	f.row(t, "media", mediaB, orgB, dbx.Params{"kind": "photo"})
	f.row(t, "lots", lotB, orgB, dbx.Params{"published": true})
	f.row(t, "apiaries", apiaryA, orgA, dbx.Params{"created_by": owner})
	f.feedback(t, feedbackB, orgB, solo)
	f.deviceToken(t, solo, "token-solo")
	f.invite(t, orgB, "BBBBBB", solo)
	fs := soloFiles{
		media:        f.fileRecord(t, "media_files", orgB, orgB+"/"+hiveB+"/"+mediaB+".jpg"),
		lotReport:    f.fileRecord(t, "public_lot_files", orgB, lotB+"/"+docFileB+".jpg"),
		feedbackShot: f.fileRecord(t, "feedback_files", orgB, orgB+"/"+feedbackB+".jpg"),
		mediaA:       f.fileRecord(t, "media_files", orgA, orgA+"/"+hiveA+"/"+mediaFileA+".jpg"),
	}
	out := f.request(t, solo, map[string]any{}, http.StatusOK, "")
	return f, fs, requestOf(t, out)["id"].(string)
}

func TestPurgeCronJob(t *testing.T) {
	t.Run(psrc+"pg_cron her saat kalıcı silmeyi çalıştırır", func(t *testing.T) {
		f := newFixture(t)
		for _, j := range f.app.Cron().Jobs() {
			if j.Id() == deletion.PurgeCronJob {
				if j.Expression() != "17 * * * *" {
					t.Fatalf("expression %q", j.Expression())
				}
				return
			}
		}
		t.Fatal("job not registered")
	})
}

func TestPurgeNotDue(t *testing.T) {
	f, fs, id := soloFixture(t)
	before := f.orgRows(t, orgB)

	step(t, "erken cron hiçbir şey silmez", func(t *testing.T) {
		f.advance(deletion.GracePeriod - time.Minute)
		f.purge(t, deletion.PurgeResult{})
		if got := f.orgRows(t, orgB); got != before {
			t.Fatalf("org rows %d → %d", before, got)
		}
		r := f.record(t, deletion.RequestsCollection, id)
		if r.GetString("status") != deletion.StatusPending || r.GetString("purge_started_at") != "" || r.GetInt(deletion.FieldPurgeStep) != 0 {
			t.Fatalf("request touched: %v", r.PublicExport())
		}
		if !f.exists(t, "users", solo) || !f.fileExists(t, fs.media) || f.count(t, deletion.LogCollection, nil) != 0 {
			t.Fatal("something was deleted")
		}
		if _, err := deletion.PurgeRequest(f.app, id); err == nil {
			t.Fatal("PurgeRequest of a request not due succeeded")
		}
	})

	step(t, "iptal edilen talep süre dolunca da silinmez", func(t *testing.T) {
		f.signIn(t, solo)
		f.post(t, solo, "cancel", nil, http.StatusOK, "")
		f.due()
		f.purge(t, deletion.PurgeResult{})
		if got := f.orgRows(t, orgB); got != before || !f.exists(t, "users", solo) {
			t.Fatal("cancelled request purged")
		}
	})
}

func TestPurgeOrganizationAndAccount(t *testing.T) {
	f, fs, id := soloFixture(t)
	u := f.record(t, "users", solo)
	u.Set("locale", "en")
	f.save(t, u)
	f.due()
	mails := f.app.TestMailer.TotalSend()

	step(t, hsrc+"cron süresi dolanı sırayla siler: kayıtlar, dosyalar, en son kullanıcı", func(t *testing.T) {
		f.purge(t, deletion.PurgeResult{Completed: 1})
	})

	step(t, psrc+"işletmeye bağlı hiçbir satır kalmaz, işletme silinir", func(t *testing.T) {
		if n := f.orgRows(t, orgB); n != 0 {
			t.Fatalf("%d rows of B left", n)
		}
		if f.count(t, "invites", dbx.HashExp{"code": "BBBBBB"}) != 0 || f.count(t, "feedback", nil) != 0 {
			t.Fatal("invite or feedback of B left")
		}
	})

	step(t, psrc+"başka işletme etkilenmez", func(t *testing.T) {
		if !f.exists(t, "organizations", orgA) || !f.exists(t, "apiaries", apiaryA) || !f.exists(t, "media_files", mediaFileA) || !f.fileExists(t, fs.mediaA) {
			t.Fatal("A was touched")
		}
	})

	step(t, psrc+"işletmenin, yayımlanan lotun ve görüşün dosyaları silinir", func(t *testing.T) {
		for _, r := range []*core.Record{fs.media, fs.lotReport, fs.feedbackShot} {
			if f.exists(t, r.Collection().Name, r.Id) || f.fileExists(t, r) {
				t.Errorf("%s %s left", r.Collection().Name, r.Id)
			}
		}
	})

	step(t, "kullanıcı, cihaz token'ı ve silme kodu silinir", func(t *testing.T) {
		if f.exists(t, "users", solo) {
			t.Fatal("user left")
		}
		if f.count(t, "device_tokens", dbx.HashExp{"user_id": solo}) != 0 || f.count(t, deletion.CodesCollection, dbx.HashExp{"user_id": solo}) != 0 {
			t.Fatal("token or code left")
		}
	})

	r := f.record(t, deletion.RequestsCollection, id)
	step(t, psrc+"silme kaydı özet, tür ve kanalla yazılır", func(t *testing.T) {
		logs, err := f.app.FindAllRecords(deletion.LogCollection)
		if err != nil || len(logs) != 1 {
			t.Fatalf("logs %d, %v", len(logs), err)
		}
		l := logs[0]
		if l.GetString("request_id") != id || l.GetString("user_hash") != deletion.Hash(solo) ||
			l.GetString("kind") != deletion.KindAccountOrganization || l.GetString("channel") != deletion.ChannelApp ||
			l.GetString("requested_at") != r.GetString("requested_at") || l.GetDateTime("created").IsZero() {
			t.Fatalf("log %v", l.PublicExport())
		}
		if strings.Contains(string(mustJSON(t, l.PublicExport())), emails[solo]) {
			t.Fatal("log holds the e-mail")
		}
	})

	step(t, psrc+"talep tamamlanır, talepteki kullanıcı kimliği boşalır", func(t *testing.T) {
		if r.GetString("status") != deletion.StatusCompleted || r.GetString("completed_at") == "" ||
			r.GetInt(deletion.FieldPurgeStep) != deletion.StepCompleted || r.GetString("user_id") != "" {
			t.Fatalf("request %v", r.PublicExport())
		}
	})

	step(t, hsrc+"kısa onay e-postası kullanıcının dilinde", func(t *testing.T) {
		if got := f.app.TestMailer.TotalSend() - mails; got != 1 {
			t.Fatalf("%d e-mails", got)
		}
		m := f.app.TestMailer.LastMessage()
		if m.Subject != "Your Mobil Arıcı account has been deleted" || len(m.To) != 1 || m.To[0].Address != emails[solo] {
			t.Fatalf("mail %q to %v", m.Subject, m.To)
		}
	})

	step(t, psrc+"tamamlanan talep tekrar işlenmez", func(t *testing.T) {
		f.purge(t, deletion.PurgeResult{})
		done, err := deletion.PurgeRequest(f.app, id)
		if err != nil || done {
			t.Fatalf("PurgeRequest = %v, %v", done, err)
		}
		if f.count(t, deletion.LogCollection, nil) != 1 || f.app.TestMailer.TotalSend()-mails != 1 {
			t.Fatal("second log or e-mail")
		}
	})

	step(t, psrc+"silme kaydı üç yıl dolmadan silinemez, değiştirilemez", func(t *testing.T) {
		logs, err := f.app.FindAllRecords(deletion.LogCollection)
		if err != nil {
			t.Fatal(err)
		}
		if err := f.app.Delete(logs[0]); !errors.Is(err, deletion.ErrLogRetained) {
			t.Fatalf("delete: %v", err)
		}
		logs[0].Set("kind", deletion.KindAccount)
		if err := f.app.Save(logs[0]); !errors.Is(err, deletion.ErrLogImmutable) {
			t.Fatalf("update: %v", err)
		}
	})
}

// Ekipli işletmenin owner'ı işletmeyi silmeyi seçer: ekibin üyelikleri de
// işletmeyle gider; ekip üyelerinin hesapları kalır.
func TestPurgeChosenOrganizationWithTeam(t *testing.T) {
	f := newFixture(t, member{orgA, owner, "owner"}, member{orgA, worker, "worker"}, member{orgB, solo, "owner"})
	f.row(t, "apiaries", apiaryA, orgA, dbx.Params{"created_by": worker})
	f.request(t, owner, map[string]any{"org_id": orgA, "delete_organization": true}, http.StatusOK, "")
	f.due()
	f.purge(t, deletion.PurgeResult{Completed: 1})
	if n := f.orgRows(t, orgA); n != 0 {
		t.Fatalf("%d rows of A left", n)
	}
	if !f.exists(t, "users", worker) || f.exists(t, "users", owner) || f.orgRows(t, orgB) == 0 {
		t.Fatal("wrong accounts or organizations")
	}
}

func TestPurgeResumes(t *testing.T) {
	t.Run(hsrc+"kullanıcı silmesinde kesilen silme sonraki turda tamamlanır", func(t *testing.T) {
		f, fs, id := soloFixture(t)
		var fail failing
		fail.left.Store(1)
		f.app.OnRecordDelete("users").BindFunc(fail.hook)
		f.due()
		mails := f.app.TestMailer.TotalSend()

		f.purge(t, deletion.PurgeResult{Failed: 1})
		r := f.record(t, deletion.RequestsCollection, id)
		if r.GetString("status") != deletion.StatusPending || r.GetInt(deletion.FieldPurgeStep) != deletion.StepUserFiles {
			t.Fatalf("request %v", r.PublicExport())
		}
		if !f.exists(t, "users", solo) || f.app.TestMailer.TotalSend() != mails {
			t.Fatal("user gone or e-mail sent")
		}
		// The steps before are done and stay done.
		if f.orgRows(t, orgB) != 0 || f.fileExists(t, fs.media) || f.fileExists(t, fs.feedbackShot) {
			t.Fatal("first steps not committed")
		}

		f.purge(t, deletion.PurgeResult{Completed: 1})
		if f.exists(t, "users", solo) || f.record(t, deletion.RequestsCollection, id).GetString("status") != deletion.StatusCompleted {
			t.Fatal("not completed")
		}
		if f.app.TestMailer.TotalSend() != mails+1 || f.app.TestMailer.LastMessage().Subject != "Mobil Arıcı hesabın silindi" {
			t.Fatalf("mail %q", f.app.TestMailer.LastMessage().Subject)
		}
		f.purge(t, deletion.PurgeResult{})
	})

	t.Run(hsrc+"kullanıcı silindikten sonra kesilen silme kullanıcıyı yeniden aramadan tamamlanır", func(t *testing.T) {
		f, _, id := soloFixture(t)
		var fail failing
		fail.left.Store(1)
		f.app.OnRecordCreate(deletion.LogCollection).BindFunc(fail.hook)
		var deletes atomic.Int32
		f.app.OnRecordAfterDeleteSuccess("users").BindFunc(func(e *core.RecordEvent) error {
			deletes.Add(1)
			return e.Next()
		})
		f.due()

		f.purge(t, deletion.PurgeResult{Failed: 1})
		r := f.record(t, deletion.RequestsCollection, id)
		if f.exists(t, "users", solo) || r.GetInt(deletion.FieldPurgeStep) != deletion.StepAccount || r.GetString("status") != deletion.StatusPending {
			t.Fatalf("request %v", r.PublicExport())
		}

		f.purge(t, deletion.PurgeResult{Completed: 1})
		if deletes.Load() != 1 || f.count(t, deletion.LogCollection, nil) != 1 {
			t.Fatalf("user deleted %d times", deletes.Load())
		}
	})

	t.Run(hsrc+"silinemeyen dosya talebi tamamlatmaz", func(t *testing.T) {
		f, fs, id := soloFixture(t)
		var fail failing
		fail.left.Store(-1)
		f.app.OnRecordDelete("media_files").BindFunc(fail.hook)
		f.due()

		f.purge(t, deletion.PurgeResult{Failed: 1})
		r := f.record(t, deletion.RequestsCollection, id)
		if r.GetString("status") != deletion.StatusPending || r.GetInt(deletion.FieldPurgeStep) != 0 || r.GetString("purge_started_at") == "" {
			t.Fatalf("request %v", r.PublicExport())
		}
		if !f.exists(t, "users", solo) || !f.exists(t, "organizations", orgB) || !f.exists(t, "media_files", fs.media.Id) {
			t.Fatal("deletion went on past the file")
		}
		// Started: the user can no longer cancel.
		if ok, err := deletion.Cancel(f.app, solo); ok || err != nil {
			t.Fatalf("cancel = %v, %v", ok, err)
		}

		fail.left.Store(0)
		f.purge(t, deletion.PurgeResult{Completed: 1})
		if f.exists(t, "media_files", fs.media.Id) || f.orgRows(t, orgB) != 0 {
			t.Fatal("not completed")
		}
	})
}

// seqOf is a synced row's server_seq.
func (f *fixture) seqOf(t *testing.T, table, id string) int {
	t.Helper()
	return f.record(t, table, id).GetInt(appsync.FieldServerSeq)
}

// teamFixture is account_deletion.test.sql's A: the worker's records in an
// organization with a team, a task assigned to the worker and the worker's
// feedback with its screenshot.
func teamFixture(t *testing.T) (*fixture, *core.Record) {
	t.Helper()
	f := newFixture(t, member{orgA, owner, "owner"}, member{orgA, partner, "partner"}, member{orgA, worker, "worker"})
	f.row(t, "apiaries", apiaryA, orgA, dbx.Params{"created_by": worker, "updated_at": testTime})
	f.row(t, "hives", hiveA, orgA, dbx.Params{"created_by": worker, "updated_at": testTime})
	f.row(t, "inspections", inspA, orgA, dbx.Params{"created_by": worker, "updated_at": testTime})
	f.row(t, "tasks", taskA, orgA, dbx.Params{"created_by": owner, "assigned_to": worker, "updated_at": testTime})
	f.row(t, "tasks", ownTaskA, orgA, dbx.Params{"created_by": partner, "assigned_to": partner, "updated_at": testTime})
	f.feedback(t, feedbackA, orgA, worker)
	shot := f.fileRecord(t, "feedback_files", orgA, orgA+"/"+feedbackA+".jpg")
	f.deviceToken(t, worker, "token-worker")
	f.invite(t, orgA, "AAAAAA", partner)
	// f.row numbers its rows from 100001; the counter goes past them so
	// that a later save gets a higher number, as in a live database.
	_, err := f.app.DB().Update(appsync.MetaCollection, dbx.Params{appsync.FieldLastSeq: 200000},
		dbx.HashExp{"id": appsync.MetaID}).Execute()
	if err != nil {
		t.Fatal(err)
	}
	return f, shot
}

func TestPurgeTeamMember(t *testing.T) {
	f, shot := teamFixture(t)
	seqs := map[string]int{}
	for _, row := range [][2]string{{"apiaries", apiaryA}, {"hives", hiveA}, {"inspections", inspA}, {"tasks", taskA}, {"tasks", ownTaskA}} {
		seqs[row[1]] = f.seqOf(t, row[0], row[1])
	}
	f.request(t, worker, map[string]any{"org_id": orgA}, http.StatusOK, "")
	membership := f.membership(t, orgA, worker)
	f.due()
	f.purge(t, deletion.PurgeResult{Completed: 1})

	step(t, psrc+"üyenin girdiği kayıtlar kalır, ekleyeni silinmiş kullanıcı olur", func(t *testing.T) {
		for _, row := range [][2]string{{"apiaries", apiaryA}, {"hives", hiveA}, {"inspections", inspA}} {
			r := f.record(t, row[0], row[1])
			if r.GetString("created_by") != "" || r.GetString("updated_at") != testTime {
				t.Fatalf("%s %v", row[0], r.PublicExport())
			}
		}
		if !f.exists(t, "organizations", orgA) {
			t.Fatal("organization gone")
		}
	})

	step(t, psrc+"ekleyenin silinmesi diğer cihazlara senkronla ulaşır (yeni server_seq)", func(t *testing.T) {
		for _, row := range [][2]string{{"apiaries", apiaryA}, {"hives", hiveA}, {"inspections", inspA}, {"tasks", taskA}} {
			if got := f.seqOf(t, row[0], row[1]); got <= seqs[row[1]] {
				t.Errorf("%s seq %d → %d", row[0], seqs[row[1]], got)
			}
		}
		if f.seqOf(t, "tasks", ownTaskA) != seqs[ownTaskA] {
			t.Error("another member's task was renumbered")
		}
	})

	step(t, "üyeye atanan görev atanmamış olur", func(t *testing.T) {
		if r := f.record(t, "tasks", taskA); r.GetString("assigned_to") != "" || r.GetString("created_by") != owner {
			t.Fatalf("task %v", r.PublicExport())
		}
		if r := f.record(t, "tasks", ownTaskA); r.GetString("assigned_to") != partner || r.GetString("created_by") != partner {
			t.Fatal("another member's task changed")
		}
	})

	step(t, psrc+"üyelik yumuşak silinmiş olarak kalır (cihazlar çeker)", func(t *testing.T) {
		m := f.record(t, "memberships", membership.Id)
		if m.GetString("deleted_at") == "" || m.GetString("updated_at") <= membership.GetString("updated_at") ||
			m.GetInt(appsync.FieldServerSeq) <= membership.GetInt(appsync.FieldServerSeq) {
			t.Fatalf("membership %v", m.PublicExport())
		}
	})

	step(t, "ekip arkadaşının cihazına \"silinmiş kullanıcı\" (boş created_by) olarak iner", func(t *testing.T) {
		for _, table := range []string{"apiaries", "inspections"} {
			page, err := appsync.Pull(f.app, owner, table, 0, 100)
			if err != nil || len(page.Rows) != 1 {
				t.Fatalf("%s pull %v, %v", table, page, err)
			}
			if by, ok := page.Rows[0]["created_by"]; !ok || by != nil {
				t.Fatalf("%s created_by = %v", table, by)
			}
		}
		// From the cursor of a device that had pulled both tasks.
		page, err := appsync.Pull(f.app, owner, "tasks", int64(max(seqs[taskA], seqs[ownTaskA])), 100)
		if err != nil || len(page.Rows) != 1 || page.Rows[0]["assigned_to"] != nil {
			t.Fatalf("tasks pull %v, %v", page.Rows, err)
		}
	})

	step(t, "üyenin görüşü ve ekran görüntüsü silinir", func(t *testing.T) {
		if f.exists(t, "feedback", feedbackA) || f.exists(t, "feedback_files", shot.Id) || f.fileExists(t, shot) {
			t.Fatal("feedback left")
		}
	})

	step(t, "hesap gider, silme kaydı 'hesap' türüyle yazılır", func(t *testing.T) {
		if f.exists(t, "users", worker) || !f.exists(t, "users", owner) {
			t.Fatal("wrong accounts")
		}
		l, err := f.app.FindFirstRecordByData(deletion.LogCollection, "user_hash", deletion.Hash(worker))
		if err != nil || l.GetString("kind") != deletion.KindAccount {
			t.Fatalf("log %v", err)
		}
		if f.count(t, "invites", dbx.HashExp{"code": "AAAAAA"}) != 1 {
			t.Fatal("another member's invite gone")
		}
	})
}

// users silme hook'u: kullanıcı panelden ya da başka bir yoldan silinse de
// üyelik, created_by ve assigned_to aynı biçimde boşalır; bekleyen talep
// yalnız özetiyle kalır ve cron onu yine tamamlar.
func TestUserDeleteHook(t *testing.T) {
	f, _ := teamFixture(t)
	f.request(t, worker, map[string]any{"org_id": orgA}, http.StatusOK, "")
	f.invite(t, orgA, "WWWWWW", worker)
	f.deviceToken(t, worker, "token-again")
	before := f.seqOf(t, "apiaries", apiaryA)
	membership := f.membership(t, orgA, worker)

	if err := f.app.Delete(f.record(t, "users", worker)); err != nil {
		t.Fatal(err)
	}

	step(t, psrc+"üyelik yumuşak silinir, kayıtlar silinmiş kullanıcıya geçer", func(t *testing.T) {
		if f.record(t, "memberships", membership.Id).GetString("deleted_at") == "" {
			t.Fatal("membership live")
		}
		a := f.record(t, "apiaries", apiaryA)
		if a.GetString("created_by") != "" || a.GetInt(appsync.FieldServerSeq) <= before {
			t.Fatalf("apiary %v", a.PublicExport())
		}
		if f.record(t, "tasks", taskA).GetString("assigned_to") != "" {
			t.Fatal("task still assigned")
		}
	})

	step(t, "token, davet ve görüşün sahibi kalmaz; talep özetle kalır", func(t *testing.T) {
		if f.count(t, "device_tokens", dbx.HashExp{"user_id": worker}) != 0 || f.count(t, "invites", dbx.HashExp{"created_by": worker}) != 0 {
			t.Fatal("token or invite left")
		}
		if f.record(t, "feedback", feedbackA).GetString("created_by") != "" {
			t.Fatal("feedback still names the user")
		}
		rs, err := f.app.FindAllRecords(deletion.RequestsCollection)
		if err != nil || len(rs) != 1 || rs[0].GetString("user_id") != "" || rs[0].GetString("user_hash") != deletion.Hash(worker) {
			t.Fatalf("request %v", err)
		}
	})

	step(t, "cron talebi kullanıcısız tamamlar", func(t *testing.T) {
		mails := f.app.TestMailer.TotalSend()
		f.due()
		f.purge(t, deletion.PurgeResult{Completed: 1})
		if f.count(t, deletion.LogCollection, dbx.HashExp{"user_hash": deletion.Hash(worker)}) != 1 {
			t.Fatal("no log")
		}
		if f.app.TestMailer.TotalSend() != mails {
			t.Fatal("e-mail without an account")
		}
	})
}
