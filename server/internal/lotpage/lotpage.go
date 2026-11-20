// Package lotpage is the public page of a published lot (P5.10, K-14): the
// Go port of the lot-page Edge Function (supabase/functions/lot-page) and of
// public.lot_public_page (20261102180000). No session is needed.
//
//   - GET /l/{id}: the page, HTML in the browser's language
//     (Accept-Language, English otherwise), light and dark. 404 with an
//     HTML page when the lot is not published, deleted or does not exist.
//   - GET /l/{id}/report: the latest analysis report (PDF or JPEG). 404
//     when the report field is not chosen or the report is not uploaded.
//   - GET and POST /api/app/lots/{id}/report (upload.go): the app asks
//     which report the page wants and uploads it.
//
// HEAD is answered like GET (net/http's mux routes HEAD to GET and drops
// the body). Both answers may be cached for 60 s, so unpublishing shows
// within a minute.
//
// Document files stay on the phone (2026-11-20): the phone that holds the
// report's file uploads it to public_lot_files as
// `<lot_id>/<copy id>.pdf|jpg` (copyOf), and the page serves it from there. The
// link shows only once the file is there. Every request reads the
// publication again: when the lot leaves publication or its report field is
// turned off, the copies are deleted by the next request and never served
// again. public_lot_files has no API rules; only this package reads and
// writes it.
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
	"github.com/google/uuid"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

const (
	// RoutePrefix is the page's path without the lot id.
	RoutePrefix = "/l/"

	copies = "public_lot_files"

	cacheControl = "public, max-age=60"
	// Nothing outside the page loads: inline CSS, data: images only.
	pageCSP = "default-src 'none'; style-src 'unsafe-inline'; img-src data:; base-uri 'none'; form-action 'none'"
)

// Register binds the page routes and the app's report route (upload.go).
func Register(app core.App) {
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.GET(RoutePrefix+"{id}", func(e *core.RequestEvent) error { return handle(e, false) })
		se.Router.GET(RoutePrefix+"{id}/report", func(e *core.RequestEvent) error { return handle(e, true) })
		registerUpload(se)
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
	var stored *core.Record
	if page.Report != nil {
		path := copyOf(lotID, page.Report).Path
		if stored, err = findCopy(e.App, path); err != nil {
			return e.InternalServerError("", err)
		}
		if err := removeCopies(e.App, lotID, path); err != nil {
			e.App.Logger().Error("lot page: removing old report copies failed", "lot_id", lotID, "error", err)
		}
	}
	if wantsReport {
		if stored == nil {
			// Not uploaded (yet) by the phone that holds the file.
			return writeHTML(e, http.StatusNotFound, RenderNotFound(lang))
		}
		return serveReport(e, lotID, page.Report, stored)
	}
	if stored == nil {
		// No link to a report that is not there.
		page.Report = nil
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

// reportCopy is where a lot's report lives in public_lot_files.
type reportCopy struct {
	// ID is a name-based UUID of the lot and the document, the last part
	// of Path (internal/files): one copy per lot, so a document reported
	// for two lots has two copies.
	ID, Path, ContentType string
}

func copyOf(lotID string, r *Report) reportCopy {
	id := uuid.NewSHA1(uuid.MustParse(lotID), []byte(r.DocumentID)).String()
	if r.FileKind == "pdf" {
		return reportCopy{id, lotID + "/" + id + ".pdf", "application/pdf"}
	}
	return reportCopy{id, lotID + "/" + id + ".jpg", "image/jpeg"}
}

func serveReport(e *core.RequestEvent, lotID string, r *Report, record *core.Record) error {
	c := copyOf(lotID, r)

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
	h.Set("Content-Type", c.ContentType)
	h.Set("Content-Disposition", `inline; filename="`+r.DocumentID+c.Path[strings.LastIndexByte(c.Path, '.'):]+`"`)
	h.Set("Cache-Control", cacheControl)
	h.Set("X-Content-Type-Options", "nosniff")
	h.Set("Referrer-Policy", "no-referrer")
	// ServeContent answers HEAD and Range requests (PDF viewers ask for
	// ranges); no Last-Modified, the copy's time says nothing.
	http.ServeContent(e.Response, e.Request, "", time.Time{}, reader)
	return nil
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
