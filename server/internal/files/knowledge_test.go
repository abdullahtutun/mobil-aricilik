package files_test

import (
	"bytes"
	"encoding/json"
	"mime/multipart"
	"net/http"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/files"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"github.com/pocketbase/pocketbase/tools/filesystem"
)

// knowledge_packs (P6.2): the Supabase knowledge bucket. Any signed-in user
// reads; only the superuser (tool/publish_knowledge.dart) writes.

const knowledgeList = "/api/collections/knowledge_packs/records"

// knowledgeJSON is a package-like JSON document of about size bytes. Real
// packages are hundreds of KB, past mimetype's 3 KB read limit.
func knowledgeJSON(size int) []byte {
	b, _ := json.Marshal(map[string]any{
		"format": 1, "version": 2,
		"files": map[string]string{"tr/a.md": strings.Repeat("arı ", size/5)},
	})
	return b
}

// multipartBody is a form with the given fields and, when content is not
// nil, one `file` part.
func multipartBody(t *testing.T, fields map[string]string, filename string, content []byte) (*bytes.Buffer, string) {
	t.Helper()
	var body bytes.Buffer
	w := multipart.NewWriter(&body)
	for k, v := range fields {
		_ = w.WriteField(k, v)
	}
	if content != nil {
		part, err := w.CreateFormFile("file", filename)
		if err != nil {
			t.Fatal(err)
		}
		_, _ = part.Write(content)
	}
	_ = w.Close()
	return &body, w.FormDataContentType()
}

func (f *fixture) superuserToken(t *testing.T) string {
	t.Helper()
	c, err := f.app.FindCollectionByNameOrId(core.CollectionNameSuperusers)
	if err != nil {
		t.Fatal(err)
	}
	su := core.NewRecord(c)
	su.SetEmail("admin@example.com")
	su.SetPassword("1234567890")
	f.save(t, su)
	tok, err := su.NewAuthToken()
	if err != nil {
		t.Fatal(err)
	}
	return tok
}

// storedPack saves a knowledge_packs record directly.
func (f *fixture) storedPack(t *testing.T, name string, content []byte) *core.Record {
	t.Helper()
	c, err := f.app.FindCollectionByNameOrId("knowledge_packs")
	if err != nil {
		t.Fatal(err)
	}
	file, err := filesystem.NewFileFromBytes(content, name)
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Set("name", name)
	r.Set("file", file)
	f.save(t, r)
	return r
}

func TestKnowledgePacksWrite(t *testing.T) {
	f := newFixture(t)
	super := f.superuserToken(t)
	existing := f.storedPack(t, "manifest.json", []byte(`{"version":1}`))

	write := func(method, url, token string, fields map[string]string, name string, content []byte, s tests.ApiScenario) tests.ApiScenario {
		body, contentType := multipartBody(t, fields, name, content)
		s.Method = method
		s.URL = url
		s.Body = body
		s.Headers = map[string]string{"Content-Type": contentType}
		if token != "" {
			s.Headers["Authorization"] = token
		}
		return f.scenario(s)
	}
	create := func(token, name string, content []byte, s tests.ApiScenario) tests.ApiScenario {
		return write(http.MethodPost, knowledgeList, token, map[string]string{"name": name}, name, content, s)
	}
	pack := knowledgeJSON(200 << 10)

	for _, s := range []tests.ApiScenario{
		create(super, "knowledge-v2.json", pack, tests.ApiScenario{
			Name: "superuser publishes a package", ExpectedStatus: 200,
			ExpectedContent: []string{`"name":"knowledge-v2.json"`, `"id":"`},
		}),
		create(super, "knowledge-v2.json", pack, tests.ApiScenario{
			Name: "same name twice", ExpectedStatus: 400, ExpectedContent: []string{codeOf("name", "validation_not_unique")},
		}),
		create(super, "knowledge-v0.json", pack, tests.ApiScenario{
			Name: "version 0", ExpectedStatus: 400, ExpectedContent: []string{codeOf("name", "validation_invalid_format")},
		}),
		create(super, "../manifest.json", pack, tests.ApiScenario{
			Name: "path in the name", ExpectedStatus: 400, ExpectedContent: []string{codeOf("name", "validation_invalid_format")},
		}),
		create(super, "knowledge-v3.json", jpegBytes, tests.ApiScenario{
			Name: "not JSON", ExpectedStatus: 400, ExpectedContent: []string{codeOf("file", "validation_invalid_mime_type")},
		}),
		create(super, "knowledge-v4.json", padded(pack, 10*files.MiB+1), tests.ApiScenario{
			Name: "over 10 MiB", ExpectedStatus: 400, ExpectedContent: []string{codeOf("file", "validation_file_size_limit")},
		}),
		create(f.authToken(t, owner), "knowledge-v5.json", pack, tests.ApiScenario{
			Name: "an owner does not publish", ExpectedStatus: 403,
		}),
		create("", "knowledge-v5.json", pack, tests.ApiScenario{
			Name: "anonymous does not publish", ExpectedStatus: 403,
		}),
		write(http.MethodPatch, knowledgeList+"/"+existing.Id, super, nil, "manifest.json", []byte(`{"version":2}`), tests.ApiScenario{
			Name: "superuser replaces the manifest file", ExpectedStatus: 200, ExpectedContent: []string{`"name":"manifest.json"`},
		}),
		write(http.MethodPatch, knowledgeList+"/"+existing.Id, f.authToken(t, owner), nil, "manifest.json", []byte(`{"version":9}`), tests.ApiScenario{
			Name: "an owner does not replace it", ExpectedStatus: 403,
		}),
		f.scenario(tests.ApiScenario{
			Name: "an owner does not delete", Method: http.MethodDelete, URL: knowledgeList + "/" + existing.Id,
			Headers: map[string]string{"Authorization": f.authToken(t, owner)}, ExpectedStatus: 403,
		}),
	} {
		s.Test(t)
	}

	got, err := f.app.FindFirstRecordByData("knowledge_packs", "name", "knowledge-v2.json")
	if err != nil {
		t.Fatal(err)
	}
	if !strings.HasPrefix(got.Id, "0") || got.Id[14] != '7' {
		t.Errorf("id %q is not a UUIDv7 (K-4)", got.Id)
	}
}

func TestKnowledgePacksRead(t *testing.T) {
	f := newFixture(t)
	manifest := f.storedPack(t, "manifest.json", []byte(`{"format":1,"version":2}`))
	fileURL := "/api/files/knowledge_packs/" + manifest.Id + "/" + manifest.GetString("file")

	for _, s := range []tests.ApiScenario{
		f.get(t, stranger, knowledgeList+"?filter=(name='manifest.json')", tests.ApiScenario{
			Name: "any signed-in user lists, member or not", ExpectedStatus: 200, ExpectedContent: []string{one, manifest.Id},
		}),
		f.get(t, viewer, knowledgeList+"/"+manifest.Id, tests.ApiScenario{
			Name: "a viewer views", ExpectedStatus: 200, ExpectedContent: []string{`"name":"manifest.json"`},
		}),
		f.get(t, "", knowledgeList, tests.ApiScenario{
			Name: "anonymous lists nothing", ExpectedStatus: 200, ExpectedContent: []string{none},
		}),
		f.get(t, "", knowledgeList+"/"+manifest.Id, tests.ApiScenario{
			Name: "anonymous does not view", ExpectedStatus: 404,
		}),
		// Not protected: the download needs no file token (the record is
		// found only through the rules above).
		f.get(t, "", fileURL, tests.ApiScenario{
			Name: "file downloads without a file token", ExpectedStatus: 200, ExpectedContent: []string{`"version":2`},
		}),
	} {
		s.Test(t)
	}
}
