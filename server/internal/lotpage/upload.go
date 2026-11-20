package lotpage

import (
	"database/sql"
	"errors"
	"net/http"
	"strings"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

// ReportRoutePrefix + "{id}/report" is the app's report route:
//
//   - GET: which report the lot page wants, `{"document_id": "<id>"|null,
//     "uploaded": bool}`. document_id is null when the lot is not published,
//     its report field is off or no analysis has a live document. Any member
//     of the lot's organization may ask.
//   - POST (multipart: document_id, file): stores the file as that report.
//     Owner, partner and worker; 409 not_current when document_id is not the
//     report the page wants (the phone's rows are behind). A report already
//     there is answered `{"uploaded": true}` without storing it again.
//
// Document files stay on the phone (2026-11-20), so the phone that holds
// the report's file uploads it: no other path brings a document file to the
// server.
const ReportRoutePrefix = "/api/app/lots/"

// Error codes in data.code.
const (
	CodeBadRequest = "bad_request"
	CodeNotFound   = "not_found"
	CodeForbidden  = "forbidden"
	CodeNotCurrent = "not_current"
)

// ReportStatus is the GET answer and the POST answer.
type ReportStatus struct {
	DocumentID *string `json:"document_id"`
	Uploaded   bool    `json:"uploaded"`
}

func registerUpload(se *core.ServeEvent) {
	requireAuth := apis.RequireAuth(auth.UsersCollection)
	se.Router.GET(ReportRoutePrefix+"{id}/report", handleReportStatus).Bind(requireAuth)
	se.Router.POST(ReportRoutePrefix+"{id}/report", handleReportUpload).Bind(requireAuth)
}

// lotFor returns the lot's organization when the user has one of roles in
// it; an error response otherwise. A lot the user cannot see is 404.
func lotFor(e *core.RequestEvent, roles ...authz.Role) (lotID string, done bool, err error) {
	lotID = strings.ToLower(e.Request.PathValue("id"))
	if !pattern.IsUUID(lotID) {
		return "", true, apiError(e, http.StatusNotFound, CodeNotFound, "No such lot.")
	}
	lot, err := e.App.FindRecordById("lots", lotID)
	if errors.Is(err, sql.ErrNoRows) {
		return "", true, apiError(e, http.StatusNotFound, CodeNotFound, "No such lot.")
	}
	if err != nil {
		return "", true, e.InternalServerError("", err)
	}
	orgID := lot.GetString("org_id")
	member, err := authz.IsMember(e.App, e.Auth.Id, orgID)
	if err != nil {
		return "", true, e.InternalServerError("", err)
	}
	if !member {
		return "", true, apiError(e, http.StatusNotFound, CodeNotFound, "No such lot.")
	}
	allowed, err := authz.HasRole(e.App, e.Auth.Id, orgID, roles...)
	if err != nil {
		return "", true, e.InternalServerError("", err)
	}
	if !allowed {
		return "", true, apiError(e, http.StatusForbidden, CodeForbidden, "This role cannot upload reports.")
	}
	return lotID, false, nil
}

func handleReportStatus(e *core.RequestEvent) error {
	lotID, done, err := lotFor(e, authz.AllRoles...)
	if done {
		return err
	}
	page, err := Load(e.App, lotID)
	if err != nil {
		return e.InternalServerError("", err)
	}
	if page == nil || page.Report == nil {
		return e.JSON(http.StatusOK, ReportStatus{})
	}
	stored, err := findCopy(e.App, copyOf(lotID, page.Report).Path)
	if err != nil {
		return e.InternalServerError("", err)
	}
	id := page.Report.DocumentID
	return e.JSON(http.StatusOK, ReportStatus{DocumentID: &id, Uploaded: stored != nil})
}

func handleReportUpload(e *core.RequestEvent) error {
	lotID, done, err := lotFor(e, authz.Writers...)
	if done {
		return err
	}
	documentID := strings.ToLower(e.Request.FormValue("document_id"))
	uploaded, err := e.FindUploadedFiles("file")
	if !pattern.IsUUID(documentID) || err != nil || len(uploaded) != 1 {
		return apiError(e, http.StatusBadRequest, CodeBadRequest, "document_id and one file are required.")
	}

	page, err := Load(e.App, lotID)
	if err != nil {
		return e.InternalServerError("", err)
	}
	if page == nil || page.Report == nil || page.Report.DocumentID != documentID {
		return apiError(e, http.StatusConflict, CodeNotCurrent, "This is not the report the lot page shows.")
	}
	c := copyOf(lotID, page.Report)
	status := ReportStatus{DocumentID: &documentID, Uploaded: true}
	if stored, err := findCopy(e.App, c.Path); err != nil {
		return e.InternalServerError("", err)
	} else if stored != nil {
		return e.JSON(http.StatusOK, status)
	}

	coll, err := e.App.FindCachedCollectionByNameOrId(copies)
	if err != nil {
		return e.InternalServerError("", err)
	}
	rec := core.NewRecord(coll)
	rec.Id = c.ID
	rec.Set("org_id", page.orgID)
	rec.Set("path", c.Path)
	rec.Set("file", uploaded[0])
	if err := e.App.Save(rec); err != nil {
		// A request alongside may have stored the same copy.
		if again, findErr := findCopy(e.App, c.Path); again != nil {
			return e.JSON(http.StatusOK, status)
		} else if findErr != nil {
			return e.InternalServerError("", findErr)
		}
		// The field's size and type limits (public_lot_files: 20 MiB,
		// JPEG or PDF).
		return apiError(e, http.StatusBadRequest, CodeBadRequest, "The file was refused: "+err.Error())
	}
	if err := removeCopies(e.App, lotID, c.Path); err != nil {
		e.App.Logger().Error("lot page: removing old report copies failed", "lot_id", lotID, "error", err)
	}
	return e.JSON(http.StatusOK, status)
}

func apiError(e *core.RequestEvent, status int, code, message string) error {
	return e.JSON(status, auth.ErrorBody{Status: status, Message: message, Data: auth.ErrorData{Code: code}})
}
