package loadtest

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"
)

// client talks to one server; token is the caller's (a superuser's or an
// account's impersonate token). Tokens never appear in errors.
type client struct {
	base  string
	http  *http.Client
	token string
}

// as returns the same server with another caller.
func (c *client) as(token string) *client {
	return &client{base: c.base, http: c.http, token: token}
}

// httpError is a non-2xx answer: the status and the server's message and
// data.code (never the request).
type httpError struct {
	Method, Path string
	Status       int
	Code         string
	Message      string
}

func (e *httpError) Error() string {
	s := fmt.Sprintf("%s %s: HTTP %d", e.Method, e.Path, e.Status)
	if e.Code != "" {
		s += " " + e.Code
	}
	if e.Message != "" {
		s += ": " + e.Message
	}
	return s
}

// do sends a request and decodes a 2xx JSON answer into out (when not nil).
func (c *client) do(ctx context.Context, method, path, contentType string, body io.Reader, out any) error {
	req, err := http.NewRequestWithContext(ctx, method, c.base+path, body)
	if err != nil {
		return err
	}
	if contentType != "" {
		req.Header.Set("Content-Type", contentType)
	}
	if c.token != "" {
		req.Header.Set("Authorization", c.token)
	}
	res, err := c.http.Do(req)
	if err != nil {
		// url.Error repeats the URL; the query holds no secret.
		return err
	}
	defer res.Body.Close()
	data, err := io.ReadAll(io.LimitReader(res.Body, 64<<20))
	if err != nil {
		return err
	}
	if res.StatusCode/100 != 2 {
		he := &httpError{Method: method, Path: strings.SplitN(path, "?", 2)[0], Status: res.StatusCode}
		var apiErr struct {
			Message string `json:"message"`
			Data    struct {
				Code string `json:"code"`
			} `json:"data"`
		}
		if json.Unmarshal(data, &apiErr) == nil {
			he.Message = apiErr.Message
			he.Code = apiErr.Data.Code
		}
		return he
	}
	if out == nil {
		return nil
	}
	return json.Unmarshal(data, out)
}

func (c *client) postJSON(ctx context.Context, path string, in, out any) error {
	body, err := json.Marshal(in)
	if err != nil {
		return err
	}
	return c.do(ctx, http.MethodPost, path, "application/json", bytes.NewReader(body), out)
}

// info is GET /api/app/info.
func (c *client) info(ctx context.Context) (env, version string, err error) {
	var out struct {
		Env     string `json:"env"`
		Version string `json:"version"`
	}
	err = c.do(ctx, http.MethodGet, "/api/app/info", "", nil, &out)
	return out.Env, out.Version, err
}

// superuserLogin returns a superuser token.
func (c *client) superuserLogin(ctx context.Context, email, password string) (string, error) {
	var out struct {
		Token string `json:"token"`
	}
	err := c.postJSON(ctx, "/api/collections/_superusers/auth-with-password",
		map[string]string{"identity": email, "password": password}, &out)
	if err != nil {
		var he *httpError
		if asHTTP(err, &he) {
			// Never echo the identity back.
			return "", fmt.Errorf("superuser login failed: HTTP %d", he.Status)
		}
		return "", fmt.Errorf("superuser login failed: %w", err)
	}
	if out.Token == "" {
		return "", fmt.Errorf("superuser login returned no token")
	}
	return out.Token, nil
}

// rateLimitsEnabled reads the rate limiter switch (superuser).
func (c *client) rateLimitsEnabled(ctx context.Context) (bool, error) {
	var out struct {
		RateLimits struct {
			Enabled bool `json:"enabled"`
		} `json:"rateLimits"`
	}
	err := c.do(ctx, http.MethodGet, "/api/settings", "", nil, &out)
	return out.RateLimits.Enabled, err
}

// setRateLimits turns the rate limiter on or off, rules untouched
// (superuser).
func (c *client) setRateLimits(ctx context.Context, enabled bool) error {
	body, _ := json.Marshal(map[string]any{"rateLimits": map[string]bool{"enabled": enabled}})
	return c.do(ctx, http.MethodPatch, "/api/settings", "application/json", bytes.NewReader(body), nil)
}

// createAccount opens a verified account with a password nobody knows and
// returns its id (superuser), like server/ops/test_users.sh.
func (c *client) createAccount(ctx context.Context, email, password string) (string, error) {
	var out struct {
		ID string `json:"id"`
	}
	err := c.postJSON(ctx, "/api/collections/users/records", map[string]any{
		"email": email, "password": password, "passwordConfirm": password,
		"verified": true, "locale": "tr",
	}, &out)
	if err == nil && out.ID == "" {
		err = fmt.Errorf("creating %s returned no id", email)
	}
	return out.ID, err
}

// impersonate returns an auth token of the account (superuser).
func (c *client) impersonate(ctx context.Context, userID string, d time.Duration) (string, error) {
	var out struct {
		Token string `json:"token"`
	}
	err := c.postJSON(ctx, "/api/collections/users/impersonate/"+url.PathEscape(userID),
		map[string]int{"duration": int(d.Seconds())}, &out)
	if err == nil && out.Token == "" {
		err = fmt.Errorf("impersonate returned no token")
	}
	return out.Token, err
}

// cleanup calls [CleanupRoute] (superuser).
func (c *client) cleanup(ctx context.Context, run string) (CleanupResult, error) {
	var out CleanupResult
	err := c.postJSON(ctx, CleanupRoute, map[string]string{"run": run}, &out)
	return out, err
}

// createOrganization founds an organization (account).
func (c *client) createOrganization(ctx context.Context, id, name string) error {
	return c.postJSON(ctx, "/api/app/organizations", map[string]any{
		"id": id, "name": name, "country_code": "TR", "currency": "TRY",
	}, nil)
}

// pushResult is one result of a push answer.
type pushResult struct {
	Status  string `json:"status"`
	Reason  string `json:"reason"`
	Message string `json:"message"`
}

// push sends one packet (account).
func (c *client) push(ctx context.Context, changes []change, now time.Time) ([]pushResult, error) {
	var out struct {
		Results []pushResult `json:"results"`
	}
	err := c.postJSON(ctx, "/api/sync/push", map[string]any{
		"changes":        changes,
		"client_time":    now.UTC().Format(time.RFC3339Nano),
		"schema_version": SchemaVersion,
	}, &out)
	return out.Results, err
}

// pullPage pulls one page of a table (account).
func (c *client) pullPage(ctx context.Context, table string, since int64, size int) (rows int, next int64, more bool, err error) {
	var out struct {
		Rows    []json.RawMessage `json:"rows"`
		NextSeq int64             `json:"next_seq"`
		HasMore bool              `json:"has_more"`
	}
	q := url.Values{
		"table":     {table},
		"since_seq": {strconv.FormatInt(since, 10)},
		"page_size": {strconv.Itoa(size)},
	}
	err = c.do(ctx, http.MethodGet, "/api/sync/pull?"+q.Encode(), "", nil, &out)
	return len(out.Rows), out.NextSeq, out.HasMore, err
}

// upload stores a photo in media_files, as the app's media queue does
// (account).
func (c *client) upload(ctx context.Context, id, orgID, path string, content []byte) error {
	var buf bytes.Buffer
	w := multipart.NewWriter(&buf)
	for k, v := range map[string]string{"id": id, "org_id": orgID, "path": path} {
		if err := w.WriteField(k, v); err != nil {
			return err
		}
	}
	part, err := w.CreateFormFile("file", id+".jpg")
	if err != nil {
		return err
	}
	if _, err := part.Write(content); err != nil {
		return err
	}
	if err := w.Close(); err != nil {
		return err
	}
	return c.do(ctx, http.MethodPost, "/api/collections/media_files/records", w.FormDataContentType(), &buf, nil)
}
