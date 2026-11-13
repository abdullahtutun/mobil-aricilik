// Package loadtest is the P9.3 load test: the client that cmd/loadtest runs
// against the dev server (Run) and the server's dev-only cleanup route
// (Register) that removes what a run left behind.
package loadtest

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"regexp"
	"strings"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

// CleanupRoute removes the accounts and organizations of load test runs:
//
//	POST /api/app/dev/loadtest/cleanup  {"run": "<run id>" | ""}
//	→ {"users": n, "organizations": m}
//
// It exists only on a server with APP_ENV=dev and only for superusers.
const CleanupRoute = "/api/app/dev/loadtest/cleanup"

// EmailPrefix starts the e-mail of every load test account:
// loadtest-<run>-<n>@example.com.
const EmailPrefix = "loadtest-"

// EmailDomain ends it; example.com never receives mail.
const EmailDomain = "@example.com"

// runPattern is a run id: the tool makes <UTC time>-<6 hex>.
var runPattern = regexp.MustCompile(`^[0-9a-z]+(-[0-9a-z]+)*$`)

// accountPattern is a load test account's e-mail, whatever the run.
var accountPattern = regexp.MustCompile(`^loadtest-[0-9a-z]+(-[0-9a-z]+)*-[0-9]+@example\.com$`)

// IsAccount reports whether email is a load test account.
func IsAccount(email string) bool { return accountPattern.MatchString(email) }

// Email is the n-th account of a run.
func Email(run string, n int) string {
	return fmt.Sprintf("%s%s-%d%s", EmailPrefix, run, n, EmailDomain)
}

// CleanupResult is the body of a cleanup answer.
type CleanupResult struct {
	Users         int `json:"users"`
	Organizations int `json:"organizations"`
}

// Register binds [CleanupRoute] when env is dev; elsewhere nothing is bound
// and the path is a 404.
func Register(app core.App, env string) {
	if env != config.EnvDev {
		return
	}
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.POST(CleanupRoute, handleCleanup).Bind(apis.RequireSuperuserAuth())
		return se.Next()
	})
}

func handleCleanup(e *core.RequestEvent) error {
	var body struct {
		Run string `json:"run"`
	}
	if err := json.NewDecoder(e.Request.Body).Decode(&body); err != nil {
		return e.BadRequestError("The body must be a JSON object.", nil)
	}
	if body.Run != "" && !runPattern.MatchString(body.Run) {
		return e.BadRequestError("run must be lower-case letters, digits and dashes.", nil)
	}
	res, err := RemoveRun(e.App, config.EnvDev, body.Run)
	if err != nil {
		return e.InternalServerError("", err)
	}
	return e.JSON(http.StatusOK, res)
}

// ErrNotDev refuses a cleanup outside APP_ENV=dev.
var ErrNotDev = errors.New("loadtest: cleanup runs only with APP_ENV=dev")

// RemoveRun removes for good the load test accounts of run (every run when
// run is empty) and the organizations they founded, with the permanent
// deletion of an account (files first, then every row of the
// organization). An organization with a member outside the load test
// accounts stays, and so does its founder. Organizations go before their
// users, so a cleanup that stops halfway is finished by running it again.
func RemoveRun(app core.App, env, run string) (CleanupResult, error) {
	var res CleanupResult
	if env != config.EnvDev {
		return res, ErrNotDev
	}
	users, err := accounts(app, run)
	if err != nil || len(users) == 0 {
		return res, err
	}
	isAccount := map[string]bool{}
	for _, u := range users {
		isAccount[u.Id] = true
	}

	kept := map[string]bool{}
	for _, u := range users {
		var orgIDs []string
		err := app.DB().Select("id").From("organizations").
			Where(dbx.HashExp{"created_by": u.Id}).
			Column(&orgIDs)
		if err != nil {
			return res, err
		}
		for _, orgID := range orgIDs {
			own, err := onlyAccounts(app, orgID, isAccount)
			if err != nil {
				return res, err
			}
			if !own {
				kept[u.Id] = true
				continue
			}
			if err := deletion.DeleteOrganization(app, orgID); err != nil {
				return res, fmt.Errorf("organization %s: %w", orgID, err)
			}
			res.Organizations++
		}
	}
	for _, u := range users {
		if kept[u.Id] {
			continue
		}
		// The users delete hook retires what is left (memberships in
		// organizations of others, created_by).
		if err := app.Delete(u); err != nil {
			return res, fmt.Errorf("user %s: %w", u.Id, err)
		}
		res.Users++
	}
	return res, nil
}

// accounts are the users whose e-mail is a load test account of run.
func accounts(app core.App, run string) ([]*core.Record, error) {
	prefix := EmailPrefix
	if run != "" {
		prefix += run + "-"
	}
	var candidates []*core.Record
	err := app.RecordQuery(auth.UsersCollection).
		AndWhere(dbx.Like("email", prefix).Match(false, true)).
		All(&candidates)
	if err != nil && !errors.Is(err, sql.ErrNoRows) {
		return nil, err
	}
	users := candidates[:0]
	for _, u := range candidates {
		email := u.Email()
		if IsAccount(email) && strings.HasPrefix(email, prefix) {
			users = append(users, u)
		}
	}
	return users, nil
}

// onlyAccounts reports whether every membership of the organization, live
// or removed, is a load test account's.
func onlyAccounts(app core.App, orgID string, isAccount map[string]bool) (bool, error) {
	var members []string
	err := app.DB().Select("user_id").From("memberships").
		Where(dbx.HashExp{"org_id": orgID}).
		Column(&members)
	if err != nil {
		return false, err
	}
	for _, m := range members {
		if !isAccount[m] {
			return false, nil
		}
	}
	return true, nil
}
