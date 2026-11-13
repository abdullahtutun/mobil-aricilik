// Package fcm sends push notifications through FCM HTTP v1 (P5.6): the Go
// port of supabase/functions/notify/fcm.ts.
//
// The Firebase service account JSON comes base64 encoded in
// FCM_SERVICE_ACCOUNT_B64 (K-10). Its private key signs an RS256 JWT that
// Google's OAuth endpoint trades for an access token; the token is cached
// until shortly before it expires. Neither the key nor the access token is
// ever logged.
package fcm

import (
	"bytes"
	"context"
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"encoding/pem"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"
)

const (
	// TokenURL is Google's OAuth 2.0 token endpoint.
	TokenURL = "https://oauth2.googleapis.com/token"
	// SendBaseURL is the FCM HTTP v1 root; the project path follows.
	SendBaseURL = "https://fcm.googleapis.com"
	// Scope is the OAuth scope of FCM sends.
	Scope = "https://www.googleapis.com/auth/firebase.messaging"

	// jwtLifetime is the assertion's lifetime; Google allows at most an
	// hour.
	jwtLifetime = time.Hour
	// refreshMargin renews the cached access token this long before it
	// expires, so a send never carries a token that runs out in flight.
	refreshMargin = 5 * time.Minute
	// requestTimeout bounds one OAuth or FCM request.
	requestTimeout = 10 * time.Second
	// maxBodyBytes caps a response body read.
	maxBodyBytes = 1 << 20
)

// ServiceAccount is the part of the service account JSON the sender needs.
type ServiceAccount struct {
	ClientEmail string `json:"client_email"`
	PrivateKey  string `json:"private_key"`
	ProjectID   string `json:"project_id"`
}

// ParseServiceAccountB64 decodes FCM_SERVICE_ACCOUNT_B64. The error never
// quotes the value.
func ParseServiceAccountB64(value string) (ServiceAccount, error) {
	raw, err := base64.StdEncoding.DecodeString(strings.TrimSpace(value))
	if err != nil {
		return ServiceAccount{}, errors.New("fcm: FCM_SERVICE_ACCOUNT_B64 is not base64")
	}
	var a ServiceAccount
	if json.Unmarshal(raw, &a) != nil {
		return ServiceAccount{}, errors.New("fcm: FCM_SERVICE_ACCOUNT_B64 is not a JSON object")
	}
	if a.ClientEmail == "" || a.PrivateKey == "" || a.ProjectID == "" {
		return ServiceAccount{}, errors.New("fcm: the service account needs client_email, private_key and project_id")
	}
	return a, nil
}

// parsePrivateKey reads the account's PEM key: PKCS#8 as Google issues
// it, PKCS#1 also accepted.
func parsePrivateKey(pemText string) (*rsa.PrivateKey, error) {
	block, _ := pem.Decode([]byte(pemText))
	if block == nil {
		return nil, errors.New("fcm: private_key is not PEM")
	}
	if key, err := x509.ParsePKCS8PrivateKey(block.Bytes); err == nil {
		rsaKey, ok := key.(*rsa.PrivateKey)
		if !ok {
			return nil, errors.New("fcm: private_key is not an RSA key")
		}
		return rsaKey, nil
	}
	key, err := x509.ParsePKCS1PrivateKey(block.Bytes)
	if err != nil {
		return nil, errors.New("fcm: private_key cannot be parsed")
	}
	return key, nil
}

// Options configure a [Client]; the zero value talks to Google.
type Options struct {
	// TokenURL is the OAuth endpoint; [TokenURL] when empty.
	TokenURL string
	// SendBaseURL is the FCM root; [SendBaseURL] when empty.
	SendBaseURL string
	// HTTPClient makes the requests; a plain client when nil.
	HTTPClient *http.Client
	// Now is the clock; time.Now when nil.
	Now func() time.Time
}

// Client signs, caches the access token and sends. Safe for concurrent
// use.
type Client struct {
	account ServiceAccount
	key     *rsa.PrivateKey
	opts    Options

	mu      sync.Mutex
	access  string
	expires time.Time
}

// New parses the account's key.
func New(account ServiceAccount, opts Options) (*Client, error) {
	key, err := parsePrivateKey(account.PrivateKey)
	if err != nil {
		return nil, err
	}
	if opts.TokenURL == "" {
		opts.TokenURL = TokenURL
	}
	if opts.SendBaseURL == "" {
		opts.SendBaseURL = SendBaseURL
	}
	if opts.HTTPClient == nil {
		opts.HTTPClient = &http.Client{}
	}
	if opts.Now == nil {
		opts.Now = time.Now
	}
	return &Client{account: account, key: key, opts: opts}, nil
}

// ProjectID is the Firebase project the client sends to.
func (c *Client) ProjectID() string { return c.account.ProjectID }

func base64URL(b []byte) string { return base64.RawURLEncoding.EncodeToString(b) }

// SignJWT is the OAuth assertion: header.claims.signature, RS256, issued at
// now and valid for an hour, as in fcm.ts.
func SignJWT(account ServiceAccount, key *rsa.PrivateKey, tokenURL string, now time.Time) (string, error) {
	header, _ := json.Marshal(map[string]string{"alg": "RS256", "typ": "JWT"})
	claims, _ := json.Marshal(map[string]any{
		"iss":   account.ClientEmail,
		"scope": Scope,
		"aud":   tokenURL,
		"iat":   now.Unix(),
		"exp":   now.Add(jwtLifetime).Unix(),
	})
	signing := base64URL(header) + "." + base64URL(claims)
	digest := sha256.Sum256([]byte(signing))
	sig, err := rsa.SignPKCS1v15(rand.Reader, key, crypto.SHA256, digest[:])
	if err != nil {
		return "", err
	}
	return signing + "." + base64URL(sig), nil
}

// AccessToken returns the cached access token, or asks Google for a new one
// when there is none or it expires within [refreshMargin].
func (c *Client) AccessToken(ctx context.Context) (string, error) {
	c.mu.Lock()
	defer c.mu.Unlock()
	now := c.opts.Now()
	if c.access != "" && now.Add(refreshMargin).Before(c.expires) {
		return c.access, nil
	}
	// Google's token endpoint is the assertion's audience, as fcm.ts.
	assertion, err := SignJWT(c.account, c.key, TokenURL, now)
	if err != nil {
		return "", err
	}
	form := url.Values{
		"grant_type": {"urn:ietf:params:oauth:grant-type:jwt-bearer"},
		"assertion":  {assertion},
	}.Encode()
	ctx, cancel := context.WithTimeout(ctx, requestTimeout)
	defer cancel()
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.opts.TokenURL, strings.NewReader(form))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	res, err := c.opts.HTTPClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("fcm: oauth: %w", err)
	}
	defer res.Body.Close()
	body, _ := io.ReadAll(io.LimitReader(res.Body, maxBodyBytes))
	if res.StatusCode != http.StatusOK {
		// Google's error body names the problem, never the key.
		return "", fmt.Errorf("fcm: oauth %d: %s", res.StatusCode, body)
	}
	var out struct {
		AccessToken string `json:"access_token"`
		ExpiresIn   int64  `json:"expires_in"`
	}
	if json.Unmarshal(body, &out) != nil || out.AccessToken == "" {
		return "", errors.New("fcm: oauth answered without access_token")
	}
	if out.ExpiresIn <= 0 {
		out.ExpiresIn = int64(jwtLifetime / time.Second)
	}
	c.access = out.AccessToken
	c.expires = now.Add(time.Duration(out.ExpiresIn) * time.Second)
	return c.access, nil
}

// forget drops the cached access token, after FCM refused it.
func (c *Client) forget(access string) {
	c.mu.Lock()
	defer c.mu.Unlock()
	if c.access == access {
		c.access = ""
	}
}

// Message is one notification.
type Message struct {
	Title string
	Body  string
	// Data reaches the app; data.task_id opens the task.
	Data map[string]string
}

// Result is the outcome of one send.
type Result int

const (
	// Sent: FCM accepted the message.
	Sent Result = iota
	// InvalidToken: the token is no longer registered; the caller deletes
	// it.
	InvalidToken
	// Failed: any other error; the token is kept.
	Failed
)

func (r Result) String() string {
	switch r {
	case Sent:
		return "sent"
	case InvalidToken:
		return "invalid_token"
	default:
		return "failed"
	}
}

// Send delivers msg to one device token. The error describes a Failed
// send for the log; it never carries the access token.
func (c *Client) Send(ctx context.Context, token string, msg Message) (Result, error) {
	access, err := c.AccessToken(ctx)
	if err != nil {
		return Failed, err
	}
	data := msg.Data
	if data == nil {
		data = map[string]string{}
	}
	payload, err := json.Marshal(map[string]any{
		"message": map[string]any{
			"token":        token,
			"notification": map[string]string{"title": msg.Title, "body": msg.Body},
			"data":         data,
			"android":      map[string]string{"priority": "high"},
			"apns":         map[string]any{"payload": map[string]any{"aps": map[string]string{"sound": "default"}}},
		},
	})
	if err != nil {
		return Failed, err
	}
	ctx, cancel := context.WithTimeout(ctx, requestTimeout)
	defer cancel()
	endpoint := strings.TrimRight(c.opts.SendBaseURL, "/") + "/v1/projects/" + url.PathEscape(c.account.ProjectID) + "/messages:send"
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, bytes.NewReader(payload))
	if err != nil {
		return Failed, err
	}
	req.Header.Set("Authorization", "Bearer "+access)
	req.Header.Set("Content-Type", "application/json")
	res, err := c.opts.HTTPClient.Do(req)
	if err != nil {
		return Failed, fmt.Errorf("fcm: send: %w", err)
	}
	defer res.Body.Close()
	body, _ := io.ReadAll(io.LimitReader(res.Body, maxBodyBytes))
	return classify(res.StatusCode, body), sendError(res.StatusCode, body, c, access)
}

// classify reads FCM's answer: fcm.ts's rules (404, or 400 naming the
// token as INVALID_ARGUMENT) plus the UNREGISTERED error code FCM v1 sends
// for a token whose app was removed.
func classify(status int, body []byte) Result {
	switch {
	case status >= 200 && status < 300:
		return Sent
	case status == http.StatusNotFound:
		return InvalidToken
	}
	text := string(body)
	if strings.Contains(text, "UNREGISTERED") {
		return InvalidToken
	}
	if status == http.StatusBadRequest && strings.Contains(text, "INVALID_ARGUMENT") && strings.Contains(text, "token") {
		return InvalidToken
	}
	return Failed
}

func sendError(status int, body []byte, c *Client, access string) error {
	if status >= 200 && status < 300 {
		return nil
	}
	if status == http.StatusUnauthorized {
		// The cached token was revoked or expired early: ask for a new
		// one next time.
		c.forget(access)
	}
	return fmt.Errorf("fcm: send %d: %s", status, body)
}
