// Package lotpage is the public page of a published lot (P5.10, K-14): the
// Go port of the lot-page Edge Function (supabase/functions/lot-page) and of
// public.lot_public_page (20261102180000). No session is needed.
//
//   - GET /l/{id}: the page, HTML in the browser's language
//     (Accept-Language, English otherwise), light and dark. 404 with an
//     HTML page when the lot is not published, deleted or does not exist.
//   - GET /l/{id}/report: the latest analysis report (PDF or JPEG). 404
//     when the report field is not chosen.
//
// HEAD is answered like GET (net/http's mux routes HEAD to GET and drops
// the body). Both answers may be cached for 60 s, so unpublishing shows
// within a minute.
//
// The report is copied on its first request from document_files to
// public_lot_files as `<lot_id>/<document_id>.pdf|jpg` and served from
// there. Every request reads the publication again: when the lot leaves
// publication or its report field is turned off, the copies are deleted by
// the next request and never served again. public_lot_files has no API
// rules; only this package reads and writes it.
//
// The routes live outside /api/ and /_/ (PocketBase's API and dashboard);
// TestRoutesDoNotShadowPocketBase checks that both still answer.
package lotpage

import (
	"database/sql"
	"errors"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

const (
	// RoutePrefix is the page's path without the lot id.
	RoutePrefix = "/l/"

	copies  = "public_lot_files"
	sources = "document_files"

	cacheControl = "public, max-age=60"
	// Nothing outside the page loads: inline CSS, data: images only.
	pageCSP = "default-src 'none'; style-src 'unsafe-inline'; img-src data:; base-uri 'none'; form-action 'none'"
)

// Register binds the two routes.
func Register(app core.App) {
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.GET(RoutePrefix+"{id}", func(e *core.RequestEvent) error { return handle(e, false) })
		se.Router.GET(RoutePrefix+"{id}/report", func(e *core.RequestEvent) error { return handle(e, true) })
		return se.Next()
	})
}

func handle(e *core.RequestEvent, wantsReport bool) error {
	lang := auth.PickAcceptLanguage(e.Request.Header.Get("Accept-Language"))
	lotID := strings.ToLower(e.Request.PathValue("id"))
	if !pattern.IsUUID(lotID) {
		return writeHTML(e, http.StatusNotFound, RenderNotFound(lang))
	}

	page, err := Load(e.App, lotID)
	if err != nil {
		return e.InternalServerError("", err)
	}
	if page == nil || page.Report == nil {
		// The copies of a lot that left publication or turned its report
		// off. A failure only leaves them for the next request: they are
		// never served without a live publication.
		if err := removeCopies(e.App, lotID, ""); err != nil {
			e.App.Logger().Error("lot page: removing report copies failed", "lot_id", lotID, "error", err)
		}
		if page == nil || wantsReport {
			return writeHTML(e, http.StatusNotFound, RenderNotFound(lang))
		}
	}
	if wantsReport {
		return serveReport(e, lotID, page, lang)
	}
	return writeHTML(e, http.StatusOK, RenderPage(page, lang, RoutePrefix+lotID+"/report"))
}

func writeHTML(e *core.RequestEvent, status int, body []byte) error {
	h := e.Response.Header()
	h.Set("Content-Type", "text/html; charset=utf-8")
	h.Set("Cache-Control", cacheControl)
	h.Set("X-Content-Type-Options", "nosniff")
	h.Set("Referrer-Policy", "no-referrer")
	h.Set("Content-Security-Policy", pageCSP)
	// The language picks the page.
	h.Add("Vary", "Accept-Language")
	h.Set("Content-Length", strconv.Itoa(len(body)))
	e.Response.WriteHeader(status)
	if e.Request.Method == http.MethodHead {
		return nil
	}
	_, err := e.Response.Write(body)
	return err
}

// copyPath is the report copy's public_lot_files path.
func copyPath(lotID string, r *Report) (path, contentType string) {
	if r.FileKind == "pdf" {
		return lotID + "/" + r.DocumentID + ".pdf", "application/pdf"
	}
	return lotID + "/" + r.DocumentID + ".jpg", "image/jpeg"
}

func serveReport(e *core.RequestEvent, lotID string, page *Page, lang string) error {
	r := page.Report
	path, contentType := copyPath(lotID, r)
	record, err := reportCopy(e.App, lotID, page.orgID, r, path)
	if err != nil {
		return e.InternalServerError("", err)
	}
	if record == nil {
		// The document has no uploaded file (yet).
		return writeHTML(e, http.StatusNotFound, RenderNotFound(lang))
	}

	fsys, err := e.App.NewFilesystem()
	if err != nil {
		return e.InternalServerError("", err)
	}
	defer fsys.Close()
	reader, err := fsys.GetReader(record.BaseFilesPath() + "/" + record.GetString("file"))
	if err != nil {
		return e.InternalServerError("", err)
	}
	defer reader.Close()

	h := e.Response.Header()
	h.Set("Content-Type", contentType)
	h.Set("Content-Disposition", `inline; filename="`+r.DocumentID+path[strings.LastIndexByte(path, '.'):]+`"`)
	h.Set("Cache-Control", cacheControl)
	h.Set("X-Content-Type-Options", "nosniff")
	h.Set("Referrer-Policy", "no-referrer")
	// ServeContent answers HEAD and Range requests (PDF viewers ask for
	// ranges); no Last-Modified, the copy's time says nothing.
	http.ServeContent(e.Response, e.Request, "", time.Time{}, reader)
	return nil
}

// reportCopy returns the report's public_lot_files record, copying it from
// document_files first when there is none. nil when the source file is
// missing.
func reportCopy(app core.App, lotID, orgID string, r *Report, path string) (*core.Record, error) {
	if rec, err := findCopy(app, path); rec != nil || err != nil {
		return rec, err
	}

	source, err := app.FindFirstRecordByData(sources, "path", r.StoragePath)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	name := source.GetString("file")
	if name == "" || source.GetString("org_id") != orgID {
		return nil, nil
	}

	coll, err := app.FindCachedCollectionByNameOrId(copies)
	if err != nil {
		return nil, err
	}
	fsys, err := app.NewFilesystem()
	if err != nil {
		return nil, err
	}
	defer fsys.Close()
	// Streamed from the source on save, never held in memory whole.
	file, err := fsys.GetReuploadableFile(source.BaseFilesPath()+"/"+name, false)
	if err != nil {
		return nil, err
	}

	// The copy's id is the document's id (K-13: the path's last UUID). A
	// document reported for two lots has one copy at a time: the other
	// lot's copy is moved here, and back on that lot's next request.
	if other, err := app.FindRecordById(copies, r.DocumentID); err == nil {
		if err := app.Delete(other); err != nil {
			return nil, err
		}
	} else if !errors.Is(err, sql.ErrNoRows) {
		return nil, err
	}

	rec := core.NewRecord(coll)
	rec.Id = r.DocumentID
	rec.Set("org_id", orgID)
	rec.Set("path", path)
	rec.Set("file", file)
	if err := app.Save(rec); err != nil {
		// A request alongside may have made the same copy.
		if again, findErr := findCopy(app, path); again != nil {
			return again, nil
		} else if findErr != nil {
			return nil, findErr
		}
		return nil, err
	}
	if err := removeCopies(app, lotID, path); err != nil {
		app.Logger().Error("lot page: removing old report copies failed", "lot_id", lotID, "error", err)
	}
	return rec, nil
}

func findCopy(app core.App, path string) (*core.Record, error) {
	rec, err := app.FindFirstRecordByData(copies, "path", path)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	return rec, err
}

// removeCopies deletes the lot's copies (`<lot_id>/…`) other than keep,
// files included.
func removeCopies(app core.App, lotID, keep string) error {
	var stale []*core.Record
	err := app.RecordQuery(copies).
		AndWhere(dbx.Like("path", lotID+"/").Match(false, true)).
		AndWhere(dbx.NewExp("path != {:keep}", dbx.Params{"keep": keep})).
		All(&stale)
	if err != nil {
		return err
	}
	var errs []error
	for _, r := range stale {
		errs = append(errs, app.Delete(r))
	}
	return errors.Join(errs...)
}
