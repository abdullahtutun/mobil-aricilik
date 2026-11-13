package lotpage_test

import (
	"io"
	"net/http"
	"net/http/httptest"
	"reflect"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/lotpage"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"github.com/pocketbase/pocketbase/tools/filesystem"
	"github.com/pocketbase/pocketbase/ui"
)

// The rows of supabase/tests/database/lot_publish.test.sql: organization A
// with a registration and AKS number, an apiary with a location, two
// active, one dead and one deleted hive, two harvests, lot ab01 published
// and ab02 not, an older analysis with a PDF report and a newer one without.
const (
	owner   = "11111111-1111-1111-1111-111111111111"
	orgA    = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
	orgB    = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
	apiary  = "a1000000-0000-0000-0000-000000000001"
	lot     = "ab000000-0000-0000-0000-000000000001"
	hidden  = "ab000000-0000-0000-0000-000000000002"
	missing = "ab000000-0000-0000-0000-0000000000ff"
	doc     = "a8000000-0000-0000-0000-000000000001"
	docFile = "f0000000-0000-0000-0000-000000000001"
	docPath = orgA + "/" + doc + "/" + docFile + ".pdf"

	testTime = "2026-10-01T00:00:00.000000Z"

	// Personal data that must never reach the page.
	registrationNo = "TR-123"
	aksNo          = "AKS-9"
	apiaryName     = "Kızılçam"
	ownerEmail     = "owner@test.local"
	customerPhone  = "+90 532 000 00 00"
	customerAddr   = "Atatürk Caddesi 5"
)

var pdfBytes = []byte("%PDF-1.4\n1 0 obj<<>>endobj\ntrailer<<>>\n%%EOF\n")

type fixture struct {
	t   *testing.T
	app *tests.TestApp
}

func newFixture(t *testing.T) *fixture {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, config.Config{Env: config.EnvDev}, "test")
	f := &fixture{t: t, app: app}

	u := core.NewRecord(f.collection("users"))
	u.Id = owner
	u.SetEmail(ownerEmail)
	u.SetPassword("1234567890")
	f.save(u)

	f.insert("organizations", orgA, map[string]any{
		"name": "Yılmaz Arıcılık", "country_code": "TR", "currency": "TRY",
		"operation_type": "migratory", "tr_registration_no": registrationNo, "tr_aks_no": aksNo,
		"created_by": owner,
	})
	f.insert("organizations", orgB, map[string]any{
		"name": "Başka", "country_code": "TR", "currency": "TRY", "operation_type": "migratory",
	})
	f.insert("apiaries", apiary, map[string]any{
		"org_id": orgA, "name": apiaryName, "latitude": 37.1, "longitude": 28.4,
	})
	for i, h := range []struct{ status, deletedAt string }{
		{"active", ""}, {"active", ""}, {"dead", ""}, {"active", testTime},
	} {
		f.insert("hives", "a3000000-0000-0000-0000-00000000000"+string(rune('1'+i)), map[string]any{
			"org_id": orgA, "number": string(rune('1' + i)), "type": "langstroth",
			"apiary_id": apiary, "status": h.status, "deleted_at": h.deletedAt, "box_count": 1,
		})
	}
	// Another organization's active hive is not counted.
	f.insert("hives", "a3000000-0000-0000-0000-0000000000b1", map[string]any{
		"org_id": orgB, "number": "1", "type": "langstroth", "apiary_id": apiary, "status": "active", "box_count": 1,
	})
	f.insert("customers", "c1000000-0000-0000-0000-000000000001", map[string]any{
		"org_id": orgA, "name": "Müşteri", "phone": customerPhone, "address": customerAddr,
	})
	f.insert("harvests", "a7000000-0000-0000-0000-000000000001", map[string]any{
		"org_id": orgA, "apiary_id": apiary, "harvested_at": "2026-09-12T08:00:00.000000Z",
		"honey_kind": "pine", "unit": "super", "unit_count": 24, "net_kg": 574,
	})
	f.insert("harvests", "a7000000-0000-0000-0000-000000000002", map[string]any{
		"org_id": orgA, "apiary_id": apiary, "harvested_at": "2026-10-02T08:00:00.000000Z",
		"honey_kind": "pine", "unit": "super", "unit_count": 4, "net_kg": 80,
	})
	f.insert("lots", lot, map[string]any{
		"org_id": orgA, "year": 2026, "seq": 7, "honey_kind": "pine", "origin": "Ula, Muğla",
		"moisture": 17.2, "status": "open", "published": true, "public_producer": true,
		"public_origin": true, "public_lab": true, "public_report": true, "created_by": owner,
	})
	f.insert("lots", hidden, map[string]any{
		"org_id": orgA, "year": 2026, "seq": 8, "honey_kind": "pine", "status": "open",
		"published": false, "public_producer": true, "public_origin": true, "public_lab": true,
		"public_report": true,
	})
	for i, h := range []string{"a7000000-0000-0000-0000-000000000002", "a7000000-0000-0000-0000-000000000001"} {
		f.insert("lot_harvests", "ac000000-0000-0000-0000-00000000000"+string(rune('1'+i)), map[string]any{
			"org_id": orgA, "lot_id": lot, "harvest_id": h,
		})
	}
	f.insert("documents", doc, map[string]any{
		"org_id": orgA, "type": "analysis_report", "name": "Analiz raporu", "file_kind": "pdf",
		"storage_path": docPath, "byte_size": len(pdfBytes),
	})
	f.insert("lab_results", "af000000-0000-0000-0000-000000000001", map[string]any{
		"org_id": orgA, "lot_id": lot, "tested_on": "2026-10-01", "hmf": 30, "diastase": 9,
		"moisture": 18, "residue": "detected", "document_id": doc,
	})
	f.insert("lab_results", "af000000-0000-0000-0000-000000000002", map[string]any{
		"org_id": orgA, "lot_id": lot, "tested_on": "2026-10-20", "hmf": 12.5, "diastase": 14,
		"moisture": 17.2, "residue": "none",
	})
	f.upload(docFile, docPath, pdfBytes)
	return f
}

func (f *fixture) collection(name string) *core.Collection {
	f.t.Helper()
	c, err := f.app.FindCachedCollectionByNameOrId(name)
	if err != nil {
		f.t.Fatal(err)
	}
	return c
}

func (f *fixture) save(r *core.Record) {
	f.t.Helper()
	if err := f.app.Save(r); err != nil {
		f.t.Fatalf("save %s %s: %v", r.Collection().Name, r.Id, err)
	}
}

func (f *fixture) insert(collection, id string, fields map[string]any) {
	f.t.Helper()
	r := core.NewRecord(f.collection(collection))
	r.Id = id
	r.Set("created_at", testTime)
	r.Set("updated_at", testTime)
	for k, v := range fields {
		r.Set(k, v)
	}
	f.save(r)
}

func (f *fixture) update(collection, id string, fields map[string]any) {
	f.t.Helper()
	r, err := f.app.FindRecordById(collection, id)
	if err != nil {
		f.t.Fatal(err)
	}
	for k, v := range fields {
		r.Set(k, v)
	}
	f.save(r)
}

// upload stores a document file as the app's upload would.
func (f *fixture) upload(id, path string, content []byte) {
	f.t.Helper()
	file, err := filesystem.NewFileFromBytes(content, id+".pdf")
	if err != nil {
		f.t.Fatal(err)
	}
	r := core.NewRecord(f.collection("document_files"))
	r.Id = id
	r.Set("org_id", orgA)
	r.Set("path", path)
	r.Set("file", file)
	f.save(r)
}

func (f *fixture) load(id string) *lotpage.Page {
	f.t.Helper()
	p, err := lotpage.Load(f.app, id)
	if err != nil {
		f.t.Fatal(err)
	}
	return p
}

func (f *fixture) copies() []*core.Record {
	f.t.Helper()
	rs, err := f.app.FindAllRecords("public_lot_files")
	if err != nil {
		f.t.Fatal(err)
	}
	return rs
}

type response struct {
	status int
	header http.Header
	body   string
}

// request sends one request through the app's router, built as
// apis.Serve builds it: the dashboard's /_/ route first, then the OnServe
// hooks (ours among them). Unlike tests.ApiScenario it accepts any status.
func (f *fixture) request(method, url, acceptLanguage string) response {
	f.t.Helper()
	router, err := apis.NewRouter(f.app)
	if err != nil {
		f.t.Fatal(err)
	}
	router.GET("/_/{path...}", apis.Static(ui.DistDirFS, false))
	var out response
	se := &core.ServeEvent{App: f.app, Router: router}
	err = f.app.OnServe().Trigger(se, func(e *core.ServeEvent) error {
		// BuildMux panics on routes that overlap ambiguously.
		mux, err := e.Router.BuildMux()
		if err != nil {
			return err
		}
		rec := httptest.NewRecorder()
		req := httptest.NewRequest(method, url, nil)
		if acceptLanguage != "" {
			req.Header.Set("Accept-Language", acceptLanguage)
		}
		mux.ServeHTTP(rec, req)
		res := rec.Result()
		b, _ := io.ReadAll(res.Body)
		out = response{status: res.StatusCode, header: res.Header, body: string(b)}
		return nil
	})
	if err != nil {
		f.t.Fatal(err)
	}
	return out
}

func ptr(v float64) *float64 { return &v }

// ---------------------------------------------------------------------------
// Data: lot_publish.test.sql, the page part
// ---------------------------------------------------------------------------

func TestLoad(t *testing.T) {
	f := newFixture(t)

	got := f.load(lot)
	want := &lotpage.Page{
		Number:       "2026-07",
		HoneyKind:    "pine",
		Producer:     &lotpage.Producer{Name: "Yılmaz Arıcılık", HiveCount: 2},
		Origin:       "Ula, Muğla",
		HarvestMonth: "2026-09",
		Lab: &lotpage.Lab{
			TestedOn: "2026-10-20", HMF: ptr(12.5), Diastase: ptr(14), Moisture: ptr(17.2), Residue: "none",
		},
		Report: &lotpage.Report{DocumentID: doc, FileKind: "pdf", StoragePath: docPath},
	}
	if got == nil {
		t.Fatal("published lot: nil")
	}
	// orgID is unexported; compare the exported fields.
	got2 := *got
	if !reflect.DeepEqual(exported(got2), exported(*want)) {
		t.Errorf("published lot: number, honey kind, organization and active hives, origin and first harvest month, latest analysis, latest report\n got %+v\nwant %+v", describe(got), describe(want))
	}

	if p := f.load(hidden); p != nil {
		t.Errorf("unpublished lot: %+v", p)
	}
	if p := f.load(missing); p != nil {
		t.Errorf("missing lot: %+v", p)
	}

	f.update("lots", lot, map[string]any{
		"public_producer": false, "public_origin": false, "public_lab": false, "public_report": false,
	})
	if p := f.load(lot); p == nil || !reflect.DeepEqual(exported(*p), exported(lotpage.Page{Number: "2026-07", HoneyKind: "pine"})) {
		t.Errorf("unchosen fields are left out: %+v", describe(p))
	}

	f.update("lots", lot, map[string]any{"deleted_at": testTime})
	if p := f.load(lot); p != nil {
		t.Errorf("deleted lot: %+v", p)
	}
	f.update("lots", lot, map[string]any{"deleted_at": ""})

	f.update("organizations", orgA, map[string]any{"deleted_at": testTime})
	if p := f.load(lot); p != nil {
		t.Errorf("lot of a deleted organization: %+v", p)
	}
}

// A deleted document, analysis or harvest link is skipped; rows of another
// organization are never read.
func TestLoadSkipsDeletedAndForeignRows(t *testing.T) {
	f := newFixture(t)
	f.update("documents", doc, map[string]any{"deleted_at": testTime})
	if p := f.load(lot); p.Report != nil {
		t.Errorf("deleted document: report %+v", p.Report)
	}
	f.update("documents", doc, map[string]any{"deleted_at": ""})

	f.update("lab_results", "af000000-0000-0000-0000-000000000002", map[string]any{"deleted_at": testTime})
	if p := f.load(lot); p.Lab == nil || p.Lab.TestedOn != "2026-10-01" || p.Report == nil {
		t.Errorf("deleted newer analysis: lab %+v report %+v", p.Lab, p.Report)
	}

	f.update("lot_harvests", "ac000000-0000-0000-0000-000000000002", map[string]any{"deleted_at": testTime})
	if p := f.load(lot); p.HarvestMonth != "2026-10" {
		t.Errorf("deleted harvest link: month %q", p.HarvestMonth)
	}

	// An analysis of organization B pointing at A's lot.
	f.insert("lab_results", "af000000-0000-0000-0000-0000000000b1", map[string]any{
		"org_id": orgB, "lot_id": lot, "tested_on": "2026-12-01", "hmf": 99, "residue": "detected",
	})
	if p := f.load(lot); p.Lab == nil || p.Lab.TestedOn == "2026-12-01" {
		t.Errorf("another organization's analysis: lab %+v", p.Lab)
	}
}

type pageFields struct {
	Number, HoneyKind, Origin, HarvestMonth string
	Producer                                *lotpage.Producer
	Lab                                     *lotpage.Lab
	Report                                  *lotpage.Report
}

func exported(p lotpage.Page) pageFields {
	return pageFields{p.Number, p.HoneyKind, p.Origin, p.HarvestMonth, p.Producer, p.Lab, p.Report}
}

func describe(p *lotpage.Page) any {
	if p == nil {
		return nil
	}
	return exported(*p)
}

// ---------------------------------------------------------------------------
// HTML
// ---------------------------------------------------------------------------

func checkHTMLHeaders(t *testing.T, r response) {
	t.Helper()
	if got := r.header.Get("Content-Type"); got != "text/html; charset=utf-8" {
		t.Errorf("Content-Type = %q", got)
	}
	if got := r.header.Get("Cache-Control"); got != "public, max-age=60" {
		t.Errorf("Cache-Control = %q", got)
	}
	if got := r.header.Get("Content-Security-Policy"); !strings.Contains(got, "default-src 'none'") {
		t.Errorf("Content-Security-Policy = %q", got)
	}
}

func TestPageTurkish(t *testing.T) {
	f := newFixture(t)
	r := f.request(http.MethodGet, "/l/"+lot, "tr-TR,tr;q=0.9,en;q=0.8")
	if r.status != 200 {
		t.Fatalf("status %d: %s", r.status, r.body)
	}
	checkHTMLHeaders(t, r)
	for _, want := range []string{
		`<html lang="tr" dir="ltr">`,
		"<title>Lot 2026-07 · Çam balı</title>",
		`<p class="lot">Lot 2026-07</p>`,
		"<h1>Çam balı</h1>",
		`<p class="sub">Ula, Muğla · Eylül 2026</p>`,
		`<div class="avatar" aria-hidden="true">YA</div>`,
		"<b>Yılmaz Arıcılık</b><span>2 kovan</span>",
		"<h2>Laboratuvar analizi</h2>",
		"<span>Nem</span><b>%17,2</b>",
		"<span>HMF</span><b>12,5 mg/kg</b>",
		"<span>Diastaz sayısı</span><b>14</b>",
		"<span>İlaç kalıntısı</span><b>Tespit edilmedi</b>",
		`<a class="button" href="/l/` + lot + `/report">Analiz raporunu aç (PDF)</a>`,
		"prefers-color-scheme:dark",
	} {
		if !strings.Contains(r.body, want) {
			t.Errorf("page lacks %q", want)
		}
	}
	// No proline was measured.
	if strings.Contains(r.body, "Prolin") {
		t.Error("an unmeasured value is shown")
	}
}

// Personal data never reaches the page, whatever the owner chose; nor the
// report's storage path, ids other than the lot's, or outside resources.
func TestPageHasNoPersonalData(t *testing.T) {
	f := newFixture(t)
	r := f.request(http.MethodGet, "/l/"+lot, "tr")
	if r.status != 200 {
		t.Fatalf("status %d", r.status)
	}
	for _, leak := range []string{
		registrationNo, aksNo, apiaryName, "37.1", "28.4", "37,1", "28,4", ownerEmail,
		customerPhone, customerAddr, owner, orgA, doc, docFile, docPath,
		"<script", "src=", "http://", "https://", "@import", "url(",
	} {
		if strings.Contains(r.body, leak) {
			t.Errorf("page contains %q", leak)
		}
	}
}

func TestPageLanguages(t *testing.T) {
	f := newFixture(t)
	cases := []struct{ header, lang, dir, want string }{
		{"", "en", "ltr", `<p class="sub">Ula, Muğla · September 2026</p>`},
		{"ja,de-DE;q=0.8", "de", "ltr", "<b>Yılmaz Arıcılık</b><span>2 Völker</span>"},
		{"fa-IR", "fa", "rtl", "<span>رطوبت</span><b>%17.2</b>"},
		{"ru", "ru", "ltr", "сентябрь 2026 г."},
		{"xx", "en", "ltr", "<h1>Pine honey</h1>"},
	}
	for _, c := range cases {
		r := f.request(http.MethodGet, "/l/"+lot, c.header)
		if !strings.Contains(r.body, `<html lang="`+c.lang+`" dir="`+c.dir+`">`) {
			t.Errorf("Accept-Language %q: not %s/%s", c.header, c.lang, c.dir)
		}
		if !strings.Contains(r.body, c.want) {
			t.Errorf("Accept-Language %q: lacks %q", c.header, c.want)
		}
	}
}

func TestPageUnchosenFields(t *testing.T) {
	f := newFixture(t)
	f.update("lots", lot, map[string]any{
		"public_producer": false, "public_origin": false, "public_lab": false, "public_report": false,
	})
	r := f.request(http.MethodGet, "/l/"+lot, "tr")
	if r.status != 200 {
		t.Fatalf("status %d", r.status)
	}
	for _, absent := range []string{"Yılmaz", "kovan", "Ula", "Eylül", "Laboratuvar", "%17,2", "/report", `class="sub"`} {
		if strings.Contains(r.body, absent) {
			t.Errorf("unchosen field shown: %q", absent)
		}
	}
	if !strings.Contains(r.body, "<h1>Çam balı</h1>") || !strings.Contains(r.body, "Lot 2026-07") {
		t.Error("number and honey kind are always shown")
	}
}

func TestNotFound(t *testing.T) {
	f := newFixture(t)
	for _, url := range []string{
		"/l/" + hidden,
		"/l/" + missing,
		"/l/not-a-uuid",
		"/l/" + hidden + "/report",
		"/l/" + missing + "/report",
	} {
		r := f.request(http.MethodGet, url, "tr")
		if r.status != 404 {
			t.Errorf("%s: status %d", url, r.status)
			continue
		}
		checkHTMLHeaders(t, r)
		if !strings.Contains(r.body, "<h1>Bu lot yayımda değil</h1>") {
			t.Errorf("%s: not the not-found page", url)
		}
	}

	r := f.request(http.MethodHead, "/l/"+missing, "")
	if r.status != 404 || r.body != "" {
		t.Errorf("HEAD missing: status %d body %q", r.status, r.body)
	}
	checkHTMLHeaders(t, r)
}

func TestHead(t *testing.T) {
	f := newFixture(t)
	r := f.request(http.MethodHead, "/l/"+lot, "")
	if r.status != 200 || r.body != "" {
		t.Errorf("HEAD page: status %d body %q", r.status, r.body)
	}
	checkHTMLHeaders(t, r)

	r = f.request(http.MethodHead, "/l/"+lot+"/report", "")
	if r.status != 200 || r.body != "" || r.header.Get("Content-Type") != "application/pdf" {
		t.Errorf("HEAD report: status %d type %q body %q", r.status, r.header.Get("Content-Type"), r.body)
	}
}

// An upper-case id is the same lot (the Edge Function lower-cased it).
func TestUpperCaseID(t *testing.T) {
	f := newFixture(t)
	if r := f.request(http.MethodGet, "/l/"+strings.ToUpper(lot), "tr"); r.status != 200 {
		t.Errorf("status %d", r.status)
	}
}

// ---------------------------------------------------------------------------
// Report
// ---------------------------------------------------------------------------

func TestReportCopyAndRevocation(t *testing.T) {
	f := newFixture(t)
	report := "/l/" + lot + "/report"

	if n := len(f.copies()); n != 0 {
		t.Fatalf("copies before the first request: %d", n)
	}
	r := f.request(http.MethodGet, report, "")
	if r.status != 200 || r.body != string(pdfBytes) {
		t.Fatalf("first request: status %d body %q", r.status, r.body)
	}
	if got := r.header.Get("Content-Type"); got != "application/pdf" {
		t.Errorf("Content-Type = %q", got)
	}
	if got := r.header.Get("Cache-Control"); got != "public, max-age=60" {
		t.Errorf("Cache-Control = %q", got)
	}
	cs := f.copies()
	if len(cs) != 1 {
		t.Fatalf("copies after the first request: %d", len(cs))
	}
	c := cs[0]
	if c.Id != doc || c.GetString("path") != lot+"/"+doc+".pdf" || c.GetString("org_id") != orgA {
		t.Errorf("copy: id %s path %s org %s", c.Id, c.GetString("path"), c.GetString("org_id"))
	}

	// Served from the copy: the source may go, the copy stays.
	src, err := f.app.FindRecordById("document_files", docFile)
	if err != nil {
		t.Fatal(err)
	}
	if err := f.app.Delete(src); err != nil {
		t.Fatal(err)
	}
	if r := f.request(http.MethodGet, report, ""); r.status != 200 || r.body != string(pdfBytes) {
		t.Errorf("from the copy: status %d", r.status)
	}
	if n := len(f.copies()); n != 1 {
		t.Errorf("copies after the second request: %d", n)
	}

	// The owner turns the report off: the next request deletes the copy.
	f.update("lots", lot, map[string]any{"public_report": false})
	if r := f.request(http.MethodGet, report, "tr"); r.status != 404 || !strings.Contains(r.body, "Bu lot yayımda değil") {
		t.Errorf("report off: status %d", r.status)
	}
	if n := len(f.copies()); n != 0 {
		t.Errorf("copies after the report was turned off: %d", n)
	}
	page := f.request(http.MethodGet, "/l/"+lot, "tr")
	if page.status != 200 || strings.Contains(page.body, "/report") {
		t.Errorf("page with the report off: status %d, link shown %v", page.status, strings.Contains(page.body, "/report"))
	}
}

func TestReportRevokedWhenUnpublished(t *testing.T) {
	f := newFixture(t)
	report := "/l/" + lot + "/report"
	if r := f.request(http.MethodGet, report, ""); r.status != 200 {
		t.Fatalf("published: status %d", r.status)
	}

	f.update("lots", lot, map[string]any{"published": false})
	// The page request alone deletes the copies.
	if r := f.request(http.MethodGet, "/l/"+lot, ""); r.status != 404 {
		t.Errorf("unpublished page: status %d", r.status)
	}
	if n := len(f.copies()); n != 0 {
		t.Errorf("copies after unpublishing: %d", n)
	}
	if r := f.request(http.MethodGet, report, ""); r.status != 404 || r.body == string(pdfBytes) {
		t.Errorf("unpublished report: status %d", r.status)
	}

	// Published again: copied again from the source.
	f.update("lots", lot, map[string]any{"published": true})
	if r := f.request(http.MethodGet, report, ""); r.status != 200 || r.body != string(pdfBytes) {
		t.Errorf("republished report: status %d", r.status)
	}

	f.update("lots", lot, map[string]any{"deleted_at": testTime})
	if r := f.request(http.MethodGet, report, ""); r.status != 404 {
		t.Errorf("deleted lot's report: status %d", r.status)
	}
	if n := len(f.copies()); n != 0 {
		t.Errorf("copies after deleting the lot: %d", n)
	}
}

// A newer analysis with another report replaces the old copy.
func TestReportReplaced(t *testing.T) {
	f := newFixture(t)
	report := "/l/" + lot + "/report"
	f.request(http.MethodGet, report, "")

	const doc2, file2 = "a8000000-0000-0000-0000-000000000002", "f0000000-0000-0000-0000-000000000002"
	path2 := orgA + "/" + doc2 + "/" + file2 + ".pdf"
	newer := []byte("%PDF-1.4\n% newer\n%%EOF\n")
	f.insert("documents", doc2, map[string]any{
		"org_id": orgA, "type": "analysis_report", "name": "Yeni rapor", "file_kind": "pdf",
		"storage_path": path2, "byte_size": len(newer),
	})
	f.upload(file2, path2, newer)
	f.insert("lab_results", "af000000-0000-0000-0000-000000000003", map[string]any{
		"org_id": orgA, "lot_id": lot, "tested_on": "2026-11-01", "document_id": doc2,
	})

	if r := f.request(http.MethodGet, report, ""); r.status != 200 || r.body != string(newer) {
		t.Errorf("newer report: status %d body %q", r.status, r.body)
	}
	cs := f.copies()
	if len(cs) != 1 || cs[0].Id != doc2 {
		t.Errorf("copies: %d", len(cs))
	}
}

// A report whose file was never uploaded is 404, and nothing is copied.
func TestReportWithoutUpload(t *testing.T) {
	f := newFixture(t)
	src, err := f.app.FindRecordById("document_files", docFile)
	if err != nil {
		t.Fatal(err)
	}
	if err := f.app.Delete(src); err != nil {
		t.Fatal(err)
	}
	if r := f.request(http.MethodGet, "/l/"+lot+"/report", "tr"); r.status != 404 {
		t.Errorf("status %d", r.status)
	}
	if n := len(f.copies()); n != 0 {
		t.Errorf("copies: %d", n)
	}
}

// public_lot_files stays closed to the record API (P6.1): only this
// package reads it.
func TestCopiesAreNotPublic(t *testing.T) {
	f := newFixture(t)
	f.request(http.MethodGet, "/l/"+lot+"/report", "")
	c := f.collection("public_lot_files")
	if c.ListRule != nil || c.ViewRule != nil || c.CreateRule != nil || c.UpdateRule != nil || c.DeleteRule != nil {
		t.Error("public_lot_files has an API rule")
	}
	if r := f.request(http.MethodGet, "/api/collections/public_lot_files/records", ""); r.status == 200 && strings.Contains(r.body, doc) {
		t.Error("the copy is listed through the record API")
	}
	if r := f.request(http.MethodGet, "/api/files/public_lot_files/"+doc+"/"+f.copies()[0].GetString("file"), ""); r.status == 200 {
		t.Error("the copy is downloadable through the files API")
	}
}

// ---------------------------------------------------------------------------
// Routes
// ---------------------------------------------------------------------------

// The page lives at /l/, outside PocketBase's /api/ and /_/: both still
// answer as before.
func TestRoutesDoNotShadowPocketBase(t *testing.T) {
	f := newFixture(t)
	if !strings.HasPrefix(lotpage.RoutePrefix, "/") ||
		strings.HasPrefix(lotpage.RoutePrefix, "/api/") || strings.HasPrefix(lotpage.RoutePrefix, "/_/") {
		t.Fatalf("RoutePrefix %q collides", lotpage.RoutePrefix)
	}
	if r := f.request(http.MethodGet, "/api/health", ""); r.status != 200 || !strings.Contains(r.body, `"code":200`) {
		t.Errorf("/api/health: status %d %s", r.status, r.body)
	}
	if r := f.request(http.MethodGet, "/_/", ""); r.status != 200 || !strings.Contains(r.header.Get("Content-Type"), "text/html") {
		t.Errorf("/_/: status %d %s", r.status, r.header.Get("Content-Type"))
	}
	// An unknown API path is still PocketBase's JSON 404, not the lot page.
	if r := f.request(http.MethodGet, "/api/l/"+lot, ""); r.status != 404 || strings.Contains(r.body, "<html") {
		t.Errorf("/api/l/: status %d", r.status)
	}
}
