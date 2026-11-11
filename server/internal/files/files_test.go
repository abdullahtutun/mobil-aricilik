package files_test

import (
	"bytes"
	"encoding/json"
	"fmt"
	"image"
	"image/jpeg"
	"io"
	"mime/multipart"
	"net/http"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/files"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"github.com/pocketbase/pocketbase/tools/filesystem"
)

// Supabase's storage policy tests: media_rls, documents_rls,
// transactions_rls (receipts), feedback_analytics (screenshot) and
// business_profile (logo).

const (
	owner    = "0195f2a4-a000-7000-8000-0000000000a1"
	partner  = "0195f2a4-a000-7000-8000-0000000000a2"
	worker   = "0195f2a4-a000-7000-8000-0000000000a3"
	viewer   = "0195f2a4-a000-7000-8000-0000000000a4"
	removed  = "0195f2a4-a000-7000-8000-0000000000a5" // was owner of orgA
	memberE  = "0195f2a4-a000-7000-8000-0000000000e1" // worker of orgE
	stranger = "0195f2a4-a000-7000-8000-000000000099"

	orgA = "0195f2a4-0a0a-7000-8000-00000000000a"
	orgE = "0195f2a4-0e0e-7000-8000-00000000000e"

	parent = "0195f2a4-b000-7000-8000-000000000001" // inspection, document, transaction

	testTime = "2026-11-10T10:15:30.123456Z"
)

// The pinned answers. alreadyUploaded is what the client (P7.4) takes as
// "already uploaded": 400 with data.id.code validation_pk_invalid. A refused
// create rule is 400 with empty data.
const (
	alreadyUploaded = `{"data":{"id":{"code":"validation_pk_invalid","message":"The record primary key is invalid or already exists."}},"message":"Failed to create record.","status":400}`
	ruleRefused     = `{"data":{},"message":"Failed to create record.","status":400}`
	forbidden       = `"status":403`
	notFound        = `"status":404`
	none            = `"totalItems":0`
	one             = `"totalItems":1`
)

type fixture struct {
	app   *tests.TestApp
	users map[string]*core.Record
	n     int // id counter for fresh UUIDs
}

func newFixture(t *testing.T) *fixture {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, config.Config{Env: config.EnvDev}, "test")

	f := &fixture{app: app, users: map[string]*core.Record{}}
	users, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	for _, id := range []string{owner, partner, worker, viewer, removed, memberE, stranger} {
		u := core.NewRecord(users)
		u.Id = id
		u.SetEmail(id[len(id)-2:] + "@example.com")
		u.SetPassword("1234567890")
		f.save(t, u)
		f.users[id] = u
	}
	memberships, err := app.FindCollectionByNameOrId("memberships")
	if err != nil {
		t.Fatal(err)
	}
	for i, m := range []struct{ org, user, role, deletedAt string }{
		{orgA, owner, "owner", ""},
		{orgA, partner, "partner", ""},
		{orgA, worker, "worker", ""},
		{orgA, viewer, "viewer", ""},
		{orgA, removed, "owner", testTime},
		{orgE, memberE, "worker", ""},
	} {
		r := core.NewRecord(memberships)
		r.Id = fmt.Sprintf("0195f2a4-c000-7000-8000-%012d", i+1)
		r.Set("org_id", m.org)
		r.Set("user_id", m.user)
		r.Set("role", m.role)
		r.Set("created_at", testTime)
		r.Set("updated_at", testTime)
		r.Set("deleted_at", m.deletedAt)
		f.save(t, r)
	}
	return f
}

func (f *fixture) save(t *testing.T, r *core.Record) {
	t.Helper()
	if err := f.app.Save(r); err != nil {
		t.Fatalf("%s %s: %v", r.Collection().Name, r.Id, err)
	}
}

// newID returns a fresh UUID for a file record.
func (f *fixture) newID() string {
	f.n++
	return fmt.Sprintf("0195f2a4-f000-7000-8000-%012d", f.n)
}

func (f *fixture) authToken(t *testing.T, user string) string {
	t.Helper()
	tok, err := f.users[user].NewAuthToken()
	if err != nil {
		t.Fatal(err)
	}
	return tok
}

func (f *fixture) fileToken(t *testing.T, user string) string {
	t.Helper()
	tok, err := f.users[user].NewFileToken()
	if err != nil {
		t.Fatal(err)
	}
	return tok
}

// File contents. PocketBase detects the type from the bytes.
var (
	jpegBytes = func() []byte {
		var b bytes.Buffer
		if err := jpeg.Encode(&b, image.NewRGBA(image.Rect(0, 0, 200, 200)), nil); err != nil {
			panic(err)
		}
		return b.Bytes()
	}()
	pdfBytes = []byte("%PDF-1.4\n1 0 obj << >> endobj\ntrailer << >>\n%%EOF\n")
	// AAC voice notes: iOS writes the "M4A " brand (audio/x-m4a), Android's
	// MediaRecorder "isom" (video/mp4).
	m4aIOS     = ftyp("M4A ")
	m4aAndroid = ftyp("isom")
	textBytes  = []byte("not a picture")
)

func ftyp(brand string) []byte {
	b := []byte{0, 0, 0, 0x18}
	b = append(b, "ftyp"+brand+"\x00\x00\x00\x00"+brand+"isom"...)
	return append(b, make([]byte, 64)...)
}

// padded is content of exactly size bytes starting with head.
func padded(head []byte, size int) []byte {
	out := make([]byte, size)
	copy(out, head)
	return out
}

// upload is a multipart create of one file record; id "" leaves it out.
type upload struct {
	collection, id, org, path, name string
	content                         []byte
}

func (f *fixture) create(t *testing.T, user string, u upload, s tests.ApiScenario) tests.ApiScenario {
	t.Helper()
	var body bytes.Buffer
	w := multipart.NewWriter(&body)
	for k, v := range map[string]string{"id": u.id, "org_id": u.org, "path": u.path} {
		if v != "" {
			_ = w.WriteField(k, v)
		}
	}
	name := u.name
	if name == "" {
		name = u.path[strings.LastIndexByte(u.path, '/')+1:]
	}
	part, err := w.CreateFormFile("file", name)
	if err != nil {
		t.Fatal(err)
	}
	_, _ = part.Write(u.content)
	_ = w.Close()

	s.Method = http.MethodPost
	s.URL = "/api/collections/" + u.collection + "/records"
	s.Body = &body
	s.Headers = map[string]string{"Content-Type": w.FormDataContentType()}
	if user != "" {
		s.Headers["Authorization"] = f.authToken(t, user)
	}
	return f.scenario(s)
}

func (f *fixture) get(t *testing.T, user, url string, s tests.ApiScenario) tests.ApiScenario {
	t.Helper()
	s.Method = http.MethodGet
	s.URL = url
	if user != "" {
		s.Headers = map[string]string{"Authorization": f.authToken(t, user)}
	}
	return f.scenario(s)
}

// scenario fills in the shared app and, when the scenario names none, the
// content its status implies (ApiScenario otherwise expects an empty body).
func (f *fixture) scenario(s tests.ApiScenario) tests.ApiScenario {
	s.TestAppFactory = func(testing.TB) *tests.TestApp { return f.app }
	s.DisableTestAppCleanup = true
	if len(s.ExpectedContent) == 0 {
		switch {
		case s.ExpectedStatus == 404:
			s.ExpectedContent = []string{notFound}
		case s.ExpectedStatus == 403:
			s.ExpectedContent = []string{forbidden}
		case s.ExpectedStatus == 200 && strings.HasPrefix(s.URL, "/api/files/"):
			s.ExpectedContent = []string{string(jpegBytes[:3])}
		case s.ExpectedStatus == 200:
			s.ExpectedContent = []string{`"collectionName":"`}
		}
	}
	return s
}

// stored saves a file record directly, as server code would.
func (f *fixture) stored(t *testing.T, collection, org, path string, content []byte) *core.Record {
	t.Helper()
	c, err := f.app.FindCollectionByNameOrId(collection)
	if err != nil {
		t.Fatal(err)
	}
	last := path[strings.LastIndexByte(path, '/')+1:]
	file, err := filesystem.NewFileFromBytes(content, last)
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Id = last[:strings.IndexByte(last, '.')]
	r.Set("org_id", org)
	r.Set("path", path)
	r.Set("file", file)
	f.save(t, r)
	return r
}

func p3(org, id, ext string) string { return org + "/" + parent + "/" + id + "." + ext }
func p2(org, id, ext string) string { return org + "/" + id + "." + ext }

func codeOf(field, code string) string {
	return fmt.Sprintf(`"%s":{"code":"%s"`, field, code)
}

func TestMediaFiles(t *testing.T) {
	f := newFixture(t)
	const c = "media_files"
	dup := f.newID()
	ok := func(name string) tests.ApiScenario {
		return tests.ApiScenario{Name: name, ExpectedStatus: 200, ExpectedEvents: map[string]int{"OnRecordCreateRequest": 1}}
	}
	refused := func(name string) tests.ApiScenario {
		return tests.ApiScenario{Name: name, ExpectedStatus: 400, ExpectedContent: []string{ruleRefused}}
	}
	invalid := func(name, field, code string) tests.ApiScenario {
		return tests.ApiScenario{Name: name, ExpectedStatus: 400, ExpectedContent: []string{codeOf(field, code)}}
	}

	var scenarios []tests.ApiScenario
	for _, user := range []string{owner, partner, worker} {
		id := f.newID()
		scenarios = append(scenarios, f.create(t, user, upload{collection: c, id: id, org: orgA, path: p3(orgA, id, "jpg"), content: jpegBytes}, ok(user+" uploads a photo")))
	}
	id1, id2, id3, id4, id5, id6, id7, id8, id9, id10 := f.newID(), f.newID(), f.newID(), f.newID(), f.newID(), f.newID(), f.newID(), f.newID(), f.newID(), f.newID()
	scenarios = append(scenarios,
		f.create(t, worker, upload{collection: c, id: id1, org: orgA, path: p3(orgA, id1, "m4a"), content: m4aIOS}, ok("iOS voice note")),
		f.create(t, worker, upload{collection: c, id: id2, org: orgA, path: p3(orgA, id2, "m4a"), content: m4aAndroid}, ok("Android voice note")),
		f.create(t, viewer, upload{collection: c, id: id3, org: orgA, path: p3(orgA, id3, "jpg"), content: jpegBytes}, refused("viewer does not upload")),
		f.create(t, removed, upload{collection: c, id: id3, org: orgA, path: p3(orgA, id3, "jpg"), content: jpegBytes}, refused("removed member does not upload")),
		f.create(t, stranger, upload{collection: c, id: id3, org: orgA, path: p3(orgA, id3, "jpg"), content: jpegBytes}, refused("stranger does not upload")),
		f.create(t, "", upload{collection: c, id: id3, org: orgA, path: p3(orgA, id3, "jpg"), content: jpegBytes}, refused("anonymous does not upload")),
		f.create(t, memberE, upload{collection: c, id: id3, org: orgA, path: p3(orgA, id3, "jpg"), content: jpegBytes}, refused("another organization's member does not upload")),
		// memberE names their own organization but writes into orgA's path.
		f.create(t, memberE, upload{collection: c, id: id3, org: orgE, path: p3(orgA, id3, "jpg"), content: jpegBytes}, invalid("path of another organization", "org_id", files.CodeOrgMismatch)),
		f.create(t, worker, upload{collection: c, id: id4, org: orgA, path: orgA + "/" + id4 + ".jpg", content: jpegBytes}, invalid("wrong path shape", "path", files.CodePathInvalid)),
		f.create(t, worker, upload{collection: c, id: id4, org: orgA, path: p3(orgA, id4, "pdf"), content: pdfBytes}, invalid("wrong extension", "path", files.CodePathInvalid)),
		f.create(t, worker, upload{collection: c, id: id4, org: orgA, path: p3(orgA, id5, "jpg"), content: jpegBytes}, invalid("id is not the last UUID", "id", files.CodeIDMismatch)),
		f.create(t, worker, upload{collection: c, org: orgA, path: p3(orgA, id6, "jpg"), content: jpegBytes}, invalid("missing id gets a UUIDv7, not the path's", "id", files.CodeIDMismatch)),
		f.create(t, worker, upload{collection: c, id: id7, org: orgA, path: p3(orgA, id7, "jpg"), content: textBytes}, invalid("not a JPEG", "file", "validation_invalid_mime_type")),
		f.create(t, worker, upload{collection: c, id: id8, org: orgA, path: p3(orgA, id8, "jpg"), content: padded(jpegBytes, 10*files.MiB+1)}, invalid("over 10 MiB", "file", "validation_file_size_limit")),
		f.create(t, worker, upload{collection: c, id: id9, org: orgA, path: p3(orgA, id9, "jpg"), content: padded(jpegBytes, 10*files.MiB)}, ok("exactly 10 MiB")),
		f.create(t, worker, upload{collection: c, id: dup, org: orgA, path: p3(orgA, dup, "jpg"), content: jpegBytes}, ok("first upload")),
		f.create(t, worker, upload{collection: c, id: dup, org: orgA, path: p3(orgA, dup, "jpg"), content: jpegBytes}, tests.ApiScenario{
			Name: "second upload with the same id: already uploaded", ExpectedStatus: 400, ExpectedContent: []string{alreadyUploaded},
		}),
		f.create(t, owner, upload{collection: c, id: dup, org: orgA, path: p3(orgA, dup, "jpg"), content: jpegBytes}, tests.ApiScenario{
			Name: "same answer for another writer of the organization", ExpectedStatus: 400, ExpectedContent: []string{alreadyUploaded},
		}),
		// A stranger cannot learn that the id exists.
		f.create(t, stranger, upload{collection: c, id: dup, org: orgA, path: p3(orgA, dup, "jpg"), content: jpegBytes}, refused("stranger re-upload is refused, not already uploaded")),
		f.create(t, memberE, upload{collection: c, id: id10, org: orgE, path: p3(orgE, id10, "jpg"), content: jpegBytes}, ok("memberE uploads to their own organization")),
	)
	for _, s := range scenarios {
		s.Test(t)
	}

	list := "/api/collections/" + c + "/records"
	for _, s := range []tests.ApiScenario{
		f.get(t, viewer, list+"?filter=(org_id='"+orgA+"')&perPage=1", tests.ApiScenario{
			Name: "viewer reads the organization's media", ExpectedStatus: 200, ExpectedContent: []string{`"totalItems":7`},
		}),
		f.get(t, memberE, list, tests.ApiScenario{
			Name: "another organization's member sees only their own", ExpectedStatus: 200, ExpectedContent: []string{one, id10},
			NotExpectedContent: []string{orgA},
		}),
		f.get(t, removed, list, tests.ApiScenario{Name: "removed member sees nothing", ExpectedStatus: 200, ExpectedContent: []string{none}}),
		f.get(t, "", list, tests.ApiScenario{Name: "anonymous sees nothing", ExpectedStatus: 200, ExpectedContent: []string{none}}),
		f.get(t, viewer, list+"/"+dup, tests.ApiScenario{Name: "viewer views one", ExpectedStatus: 200, ExpectedContent: []string{`"path":"` + p3(orgA, dup, "jpg") + `"`}}),
		f.get(t, memberE, list+"/"+dup, tests.ApiScenario{Name: "outsider does not view", ExpectedStatus: 404, ExpectedContent: []string{notFound}}),
		f.scenario(tests.ApiScenario{
			Name: "nobody updates", Method: http.MethodPatch, URL: list + "/" + dup,
			Body: strings.NewReader(`{}`), Headers: map[string]string{"Content-Type": "application/json", "Authorization": f.authToken(t, owner)},
			ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
		f.scenario(tests.ApiScenario{
			Name: "nobody deletes", Method: http.MethodDelete, URL: list + "/" + dup,
			Headers:        map[string]string{"Authorization": f.authToken(t, owner)},
			ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
	} {
		s.Test(t)
	}
}

func TestProtectedDownload(t *testing.T) {
	f := newFixture(t)
	id := f.newID()
	r := f.stored(t, "media_files", orgA, p3(orgA, id, "jpg"), jpegBytes)
	url := "/api/files/media_files/" + id + "/" + r.GetString("file")

	for _, s := range []tests.ApiScenario{
		f.scenario(tests.ApiScenario{Name: "no token", Method: http.MethodGet, URL: url, ExpectedStatus: 404, ExpectedContent: []string{notFound}}),
		f.scenario(tests.ApiScenario{
			Name: "an auth token in the header is not a file token", Method: http.MethodGet, URL: url,
			Headers: map[string]string{"Authorization": f.authToken(t, viewer)}, ExpectedStatus: 404, ExpectedContent: []string{notFound},
		}),
		f.scenario(tests.ApiScenario{
			Name: "an auth token as ?token is not a file token", Method: http.MethodGet, URL: url + "?token=" + f.authToken(t, viewer),
			ExpectedStatus: 404, ExpectedContent: []string{notFound},
		}),
		f.scenario(tests.ApiScenario{
			Name: "outsider's file token", Method: http.MethodGet, URL: url + "?token=" + f.fileToken(t, memberE),
			ExpectedStatus: 404, ExpectedContent: []string{notFound},
		}),
		f.scenario(tests.ApiScenario{
			Name: "removed member's file token", Method: http.MethodGet, URL: url + "?token=" + f.fileToken(t, removed),
			ExpectedStatus: 404, ExpectedContent: []string{notFound},
		}),
		f.scenario(tests.ApiScenario{
			Name: "member's file token", Method: http.MethodGet, URL: url + "?token=" + f.fileToken(t, viewer),
			ExpectedStatus: 200, ExpectedContent: []string{string(jpegBytes[:4])},
		}),
		f.scenario(tests.ApiScenario{
			Name: "no thumbnail is made", Method: http.MethodGet, URL: url + "?thumb=100x100&token=" + f.fileToken(t, viewer),
			ExpectedStatus: 200, ExpectedContent: []string{string(jpegBytes[:4])},
			AfterTestFunc: func(t testing.TB, app *tests.TestApp, _ *http.Response) {
				fsys, err := app.NewFilesystem()
				if err != nil {
					t.Fatal(err)
				}
				defer fsys.Close()
				name := r.GetString("file")
				thumb := r.BaseFilesPath() + "/thumbs_" + name + "/100x100_" + name
				if ok, _ := fsys.Exists(thumb); ok {
					t.Errorf("thumbnail %s was created", thumb)
				}
			},
		}),
	} {
		s.Test(t)
	}

	// The file token the client asks for (P7.4) works the same way.
	tokenScenario := f.scenario(tests.ApiScenario{
		Name: "file token route", Method: http.MethodPost, URL: "/api/files/token",
		Headers:        map[string]string{"Authorization": f.authToken(t, viewer)},
		ExpectedStatus: 200, ExpectedContent: []string{`"token":"`},
		AfterTestFunc: func(t testing.TB, _ *tests.TestApp, res *http.Response) {
			var body struct{ Token string }
			raw, _ := io.ReadAll(res.Body)
			if err := json.Unmarshal(raw, &body); err != nil || body.Token == "" {
				t.Fatalf("token body %s: %v", raw, err)
			}
		},
	})
	tokenScenario.Test(t)
}

func TestDocumentFiles(t *testing.T) {
	f := newFixture(t)
	const c = "document_files"
	ids := make([]string, 6)
	for i := range ids {
		ids[i] = f.newID()
	}
	for _, s := range []tests.ApiScenario{
		f.create(t, worker, upload{collection: c, id: ids[0], org: orgA, path: p3(orgA, ids[0], "pdf"), content: pdfBytes}, tests.ApiScenario{Name: "worker uploads a PDF", ExpectedStatus: 200}),
		f.create(t, worker, upload{collection: c, id: ids[1], org: orgA, path: p3(orgA, ids[1], "jpg"), content: jpegBytes}, tests.ApiScenario{Name: "worker uploads a photo", ExpectedStatus: 200}),
		f.create(t, viewer, upload{collection: c, id: ids[2], org: orgA, path: p3(orgA, ids[2], "pdf"), content: pdfBytes}, tests.ApiScenario{Name: "viewer does not upload", ExpectedStatus: 400, ExpectedContent: []string{ruleRefused}}),
		f.create(t, worker, upload{collection: c, id: ids[3], org: orgA, path: p3(orgA, ids[3], "m4a"), content: m4aIOS}, tests.ApiScenario{Name: "no audio", ExpectedStatus: 400, ExpectedContent: []string{codeOf("path", files.CodePathInvalid)}}),
		f.create(t, worker, upload{collection: c, id: ids[3], org: orgA, path: p3(orgA, ids[3], "pdf"), content: m4aIOS}, tests.ApiScenario{Name: "audio named .pdf", ExpectedStatus: 400, ExpectedContent: []string{codeOf("file", "validation_invalid_mime_type")}}),
		f.create(t, worker, upload{collection: c, id: ids[4], org: orgA, path: p3(orgA, ids[4], "pdf"), content: padded(pdfBytes, 20*files.MiB)}, tests.ApiScenario{Name: "exactly 20 MiB", ExpectedStatus: 200}),
		f.create(t, worker, upload{collection: c, id: ids[5], org: orgA, path: p3(orgA, ids[5], "pdf"), content: padded(pdfBytes, 20*files.MiB+1)}, tests.ApiScenario{Name: "over 20 MiB", ExpectedStatus: 400, ExpectedContent: []string{codeOf("file", "validation_file_size_limit")}}),
		f.get(t, viewer, "/api/collections/"+c+"/records/"+ids[0], tests.ApiScenario{Name: "viewer reads", ExpectedStatus: 200}),
		f.get(t, memberE, "/api/collections/"+c+"/records/"+ids[0], tests.ApiScenario{Name: "outsider does not read", ExpectedStatus: 404}),
	} {
		s.Test(t)
	}
}

func TestReceiptFiles(t *testing.T) {
	f := newFixture(t)
	const c = "receipt_files"
	stored := f.stored(t, c, orgA, p3(orgA, f.newID(), "jpg"), jpegBytes)
	url := "/api/files/" + c + "/" + stored.Id + "/" + stored.GetString("file")
	id1, id2, id3 := f.newID(), f.newID(), f.newID()
	list := "/api/collections/" + c + "/records"

	for _, s := range []tests.ApiScenario{
		f.create(t, partner, upload{collection: c, id: id1, org: orgA, path: p3(orgA, id1, "jpg"), content: jpegBytes}, tests.ApiScenario{Name: "partner uploads", ExpectedStatus: 200}),
		f.create(t, owner, upload{collection: c, id: id2, org: orgA, path: p3(orgA, id2, "jpg"), content: jpegBytes}, tests.ApiScenario{Name: "owner uploads", ExpectedStatus: 200}),
		f.create(t, worker, upload{collection: c, id: id3, org: orgA, path: p3(orgA, id3, "jpg"), content: jpegBytes}, tests.ApiScenario{Name: "worker does not upload", ExpectedStatus: 400, ExpectedContent: []string{ruleRefused}}),
		f.create(t, owner, upload{collection: c, id: id3, org: orgA, path: p3(orgA, id3, "pdf"), content: pdfBytes}, tests.ApiScenario{Name: "no PDF receipts", ExpectedStatus: 400, ExpectedContent: []string{codeOf("path", files.CodePathInvalid)}}),
		f.get(t, worker, list, tests.ApiScenario{Name: "worker lists no receipts", ExpectedStatus: 200, ExpectedContent: []string{none}}),
		f.get(t, viewer, list, tests.ApiScenario{Name: "viewer lists no receipts", ExpectedStatus: 200, ExpectedContent: []string{none}}),
		f.get(t, worker, list+"/"+stored.Id, tests.ApiScenario{Name: "worker does not view a receipt", ExpectedStatus: 404}),
		f.get(t, partner, list, tests.ApiScenario{Name: "partner lists receipts", ExpectedStatus: 200, ExpectedContent: []string{`"totalItems":3`}}),
		f.scenario(tests.ApiScenario{Name: "worker's file token", Method: http.MethodGet, URL: url + "?token=" + f.fileToken(t, worker), ExpectedStatus: 404}),
		f.scenario(tests.ApiScenario{Name: "owner's file token", Method: http.MethodGet, URL: url + "?token=" + f.fileToken(t, owner), ExpectedStatus: 200}),
	} {
		s.Test(t)
	}
}

func TestFeedbackFiles(t *testing.T) {
	f := newFixture(t)
	const c = "feedback_files"
	id1, id2, id3, id4 := f.newID(), f.newID(), f.newID(), f.newID()
	list := "/api/collections/" + c + "/records"
	for _, s := range []tests.ApiScenario{
		f.create(t, viewer, upload{collection: c, id: id1, org: orgA, path: p2(orgA, id1, "jpg"), content: jpegBytes}, tests.ApiScenario{Name: "viewer sends a screenshot", ExpectedStatus: 200}),
		f.create(t, stranger, upload{collection: c, id: id2, org: orgA, path: p2(orgA, id2, "jpg"), content: jpegBytes}, tests.ApiScenario{Name: "stranger does not", ExpectedStatus: 400, ExpectedContent: []string{ruleRefused}}),
		f.create(t, removed, upload{collection: c, id: id2, org: orgA, path: p2(orgA, id2, "jpg"), content: jpegBytes}, tests.ApiScenario{Name: "removed member does not", ExpectedStatus: 400, ExpectedContent: []string{ruleRefused}}),
		f.create(t, viewer, upload{collection: c, id: id3, org: orgA, path: p2(orgA, id3, "jpg"), content: padded(jpegBytes, 5*files.MiB+1)}, tests.ApiScenario{Name: "over 5 MiB", ExpectedStatus: 400, ExpectedContent: []string{codeOf("file", "validation_file_size_limit")}}),
		f.create(t, viewer, upload{collection: c, id: id4, org: orgA, path: p3(orgA, id4, "jpg"), content: jpegBytes}, tests.ApiScenario{Name: "three-part path", ExpectedStatus: 400, ExpectedContent: []string{codeOf("path", files.CodePathInvalid)}}),
		f.get(t, viewer, list, tests.ApiScenario{Name: "nobody lists screenshots", ExpectedStatus: 403, ExpectedContent: []string{forbidden}}),
		f.get(t, owner, list+"/"+id1, tests.ApiScenario{Name: "nobody views one", ExpectedStatus: 403, ExpectedContent: []string{forbidden}}),
	} {
		s.Test(t)
	}
}

func TestOrgLogoFiles(t *testing.T) {
	f := newFixture(t)
	const c = "org_logo_files"
	id1, id2, id3, id4 := f.newID(), f.newID(), f.newID(), f.newID()
	list := "/api/collections/" + c + "/records"
	for _, s := range []tests.ApiScenario{
		f.create(t, partner, upload{collection: c, id: id1, org: orgA, path: p2(orgA, id1, "jpg"), content: jpegBytes}, tests.ApiScenario{Name: "partner uploads the logo", ExpectedStatus: 200}),
		f.create(t, worker, upload{collection: c, id: id2, org: orgA, path: p2(orgA, id2, "jpg"), content: jpegBytes}, tests.ApiScenario{Name: "worker does not", ExpectedStatus: 400, ExpectedContent: []string{ruleRefused}}),
		f.create(t, owner, upload{collection: c, id: id3, org: orgA, path: p2(orgA, id3, "jpg"), content: padded(jpegBytes, 2*files.MiB+1)}, tests.ApiScenario{Name: "over 2 MiB", ExpectedStatus: 400, ExpectedContent: []string{codeOf("file", "validation_file_size_limit")}}),
		f.create(t, owner, upload{collection: c, id: id4, org: orgA, path: p2(orgA, id4, "jpg"), content: pdfBytes}, tests.ApiScenario{Name: "PDF named .jpg", ExpectedStatus: 400, ExpectedContent: []string{codeOf("file", "validation_invalid_mime_type")}}),
		f.get(t, viewer, list+"/"+id1, tests.ApiScenario{Name: "viewer sees the logo", ExpectedStatus: 200}),
		f.get(t, memberE, list+"/"+id1, tests.ApiScenario{Name: "outsider does not", ExpectedStatus: 404}),
	} {
		s.Test(t)
	}
}

func TestPublicLotFiles(t *testing.T) {
	f := newFixture(t)
	const c = "public_lot_files"
	lot, doc := f.newID(), f.newID()
	// Server code (P5.10) writes it; org_id is the lot's organization, the
	// path starts with the lot.
	stored := f.stored(t, c, orgA, p2(lot, doc, "pdf"), pdfBytes)
	url := "/api/files/" + c + "/" + stored.Id + "/" + stored.GetString("file")
	other := f.newID()
	for _, s := range []tests.ApiScenario{
		f.create(t, owner, upload{collection: c, id: other, org: orgA, path: p2(lot, other, "pdf"), content: pdfBytes}, tests.ApiScenario{Name: "owner does not write", ExpectedStatus: 403, ExpectedContent: []string{forbidden}}),
		f.get(t, owner, "/api/collections/"+c+"/records", tests.ApiScenario{Name: "owner does not list", ExpectedStatus: 403}),
		f.scenario(tests.ApiScenario{Name: "no file token opens it", Method: http.MethodGet, URL: url + "?token=" + f.fileToken(t, owner), ExpectedStatus: 404}),
		f.scenario(tests.ApiScenario{Name: "anonymous", Method: http.MethodGet, URL: url, ExpectedStatus: 404}),
	} {
		s.Test(t)
	}
}

// The path check runs on every save, server code included.
func TestCheckPathOnServerSave(t *testing.T) {
	f := newFixture(t)
	c, err := f.app.FindCollectionByNameOrId("media_files")
	if err != nil {
		t.Fatal(err)
	}
	id := f.newID()
	file, err := filesystem.NewFileFromBytes(jpegBytes, "x.jpg")
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Id = id
	r.Set("org_id", orgE)
	r.Set("path", p3(orgA, id, "jpg"))
	r.Set("file", file)
	if err := f.app.Save(r); err == nil || !strings.Contains(err.Error(), "org_id") {
		t.Fatalf("save with another organization's path: %v", err)
	}
}

func TestCheckPath(t *testing.T) {
	media, _ := files.SpecFor("media_files")
	lots, _ := files.SpecFor("public_lot_files")
	id := "0195f2a4-f000-7000-8000-000000000001"
	if errs := files.CheckPath(media, id, orgA, p3(orgA, id, "jpg")); errs != nil {
		t.Errorf("valid media path: %v", errs)
	}
	if errs := files.CheckPath(lots, id, orgA, p2(orgE, id, "pdf")); errs != nil {
		t.Errorf("public-lots path starts with the lot, not the organization: %v", errs)
	}
	errs := files.CheckPath(media, parent, orgE, p3(orgA, id, "jpg"))
	if errs["id"] == nil || errs["org_id"] == nil {
		t.Errorf("both mismatches expected: %v", errs)
	}
}
