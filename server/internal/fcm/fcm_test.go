package fcm_test

import (
	"context"
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"encoding/pem"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/fcm"
)

// testKey is a throwaway key; generated once, 2048 bits like Google's.
var testKey = sync.OnceValue(func() *rsa.PrivateKey {
	k, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		panic(err)
	}
	return k
})

func pkcs8PEM(t *testing.T, k *rsa.PrivateKey) string {
	t.Helper()
	der, err := x509.MarshalPKCS8PrivateKey(k)
	if err != nil {
		t.Fatal(err)
	}
	return string(pem.EncodeToMemory(&pem.Block{Type: "PRIVATE KEY", Bytes: der}))
}

func account(t *testing.T) fcm.ServiceAccount {
	return fcm.ServiceAccount{
		ClientEmail: "push@arici-test.iam.gserviceaccount.com",
		PrivateKey:  pkcs8PEM(t, testKey()),
		ProjectID:   "arici-test",
	}
}

// verifyJWT checks the RS256 signature with the public key and returns the
// header and claims.
func verifyJWT(t *testing.T, jwt string) (map[string]any, map[string]any) {
	t.Helper()
	parts := strings.Split(jwt, ".")
	if len(parts) != 3 {
		t.Fatalf("jwt has %d parts", len(parts))
	}
	sig, err := base64.RawURLEncoding.DecodeString(parts[2])
	if err != nil {
		t.Fatalf("signature is not base64url: %v", err)
	}
	digest := sha256.Sum256([]byte(parts[0] + "." + parts[1]))
	if err := rsa.VerifyPKCS1v15(&testKey().PublicKey, crypto.SHA256, digest[:], sig); err != nil {
		t.Fatalf("signature does not verify: %v", err)
	}
	decode := func(s string) map[string]any {
		raw, err := base64.RawURLEncoding.DecodeString(s)
		if err != nil {
			t.Fatalf("segment is not base64url: %v", err)
		}
		var m map[string]any
		if err := json.Unmarshal(raw, &m); err != nil {
			t.Fatal(err)
		}
		return m
	}
	return decode(parts[0]), decode(parts[1])
}

func TestParseServiceAccountB64(t *testing.T) {
	a := account(t)
	raw, _ := json.Marshal(map[string]string{
		"type": "service_account", "client_email": a.ClientEmail, "private_key": a.PrivateKey,
		"project_id": a.ProjectID, "private_key_id": "x",
	})
	got, err := fcm.ParseServiceAccountB64(" " + base64.StdEncoding.EncodeToString(raw) + "\n")
	if err != nil || got != a {
		t.Fatalf("got %+v, %v", got, err)
	}

	secret := base64.StdEncoding.EncodeToString([]byte(`{"client_email":"x","project_id":"p","private_key":"SECRET"}`))
	for name, value := range map[string]string{
		"not base64":     "%%%SECRET",
		"not JSON":       base64.StdEncoding.EncodeToString([]byte("SECRET")),
		"no private key": base64.StdEncoding.EncodeToString([]byte(`{"client_email":"x","project_id":"SECRET"}`)),
	} {
		_, err := fcm.ParseServiceAccountB64(value)
		if err == nil || strings.Contains(err.Error(), "SECRET") {
			t.Errorf("%s: err = %v", name, err)
		}
	}
	// A parsable account whose key is not PEM fails in New, without the key.
	a2, err := fcm.ParseServiceAccountB64(secret)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := fcm.New(a2, fcm.Options{}); err == nil || strings.Contains(err.Error(), "SECRET") {
		t.Errorf("New with a bad key: %v", err)
	}
}

func TestPKCS1KeyAccepted(t *testing.T) {
	a := account(t)
	a.PrivateKey = string(pem.EncodeToMemory(&pem.Block{Type: "RSA PRIVATE KEY", Bytes: x509.MarshalPKCS1PrivateKey(testKey())}))
	if _, err := fcm.New(a, fcm.Options{}); err != nil {
		t.Fatal(err)
	}
}

func TestSignJWT(t *testing.T) {
	a := account(t)
	now := time.Date(2026, 11, 10, 9, 0, 0, 0, time.UTC)
	jwt, err := fcm.SignJWT(a, testKey(), fcm.TokenURL, now)
	if err != nil {
		t.Fatal(err)
	}
	header, claims := verifyJWT(t, jwt)
	if header["alg"] != "RS256" || header["typ"] != "JWT" {
		t.Errorf("header = %v", header)
	}
	want := map[string]any{
		"iss":   a.ClientEmail,
		"scope": "https://www.googleapis.com/auth/firebase.messaging",
		"aud":   "https://oauth2.googleapis.com/token",
		"iat":   float64(now.Unix()),
		"exp":   float64(now.Add(time.Hour).Unix()),
	}
	for k, v := range want {
		if claims[k] != v {
			t.Errorf("claim %s = %v, want %v", k, claims[k], v)
		}
	}
	if len(claims) != len(want) {
		t.Errorf("claims = %v", claims)
	}
}

// google is a fake OAuth + FCM server.
type google struct {
	server     *httptest.Server
	oauthHits  atomic.Int64
	oauthFail  atomic.Bool
	accessSeq  atomic.Int64
	mu         sync.Mutex
	sends      []sent
	answer     func(token string) (int, string)
	expiresIn  int64
	lastAccess atomic.Value
}

type sent struct {
	Path, Auth string
	Body       map[string]any
}

func newGoogle(t *testing.T) *google {
	t.Helper()
	g := &google{expiresIn: 3599}
	g.answer = func(string) (int, string) { return 200, `{"name":"projects/arici-test/messages/1"}` }
	g.server = httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.URL.Path == "/token":
			g.oauthHits.Add(1)
			if err := r.ParseForm(); err != nil {
				t.Error(err)
			}
			if ct := r.Header.Get("Content-Type"); ct != "application/x-www-form-urlencoded" {
				t.Errorf("oauth content type %q", ct)
			}
			if gt := r.PostForm.Get("grant_type"); gt != "urn:ietf:params:oauth:grant-type:jwt-bearer" {
				t.Errorf("grant_type %q", gt)
			}
			_, claims := verifyJWT(t, r.PostForm.Get("assertion"))
			if claims["iss"] != "push@arici-test.iam.gserviceaccount.com" {
				t.Errorf("assertion iss %v", claims["iss"])
			}
			if g.oauthFail.Load() {
				w.WriteHeader(http.StatusBadRequest)
				_, _ = io.WriteString(w, `{"error":"invalid_grant"}`)
				return
			}
			access := "ya29.access-" + string(rune('0'+g.accessSeq.Add(1)))
			_ = json.NewEncoder(w).Encode(map[string]any{"access_token": access, "expires_in": g.expiresIn, "token_type": "Bearer"})
		case strings.HasSuffix(r.URL.Path, "/messages:send"):
			var body map[string]any
			_ = json.NewDecoder(r.Body).Decode(&body)
			g.mu.Lock()
			g.sends = append(g.sends, sent{Path: r.URL.Path, Auth: r.Header.Get("Authorization"), Body: body})
			g.mu.Unlock()
			token, _ := body["message"].(map[string]any)["token"].(string)
			status, text := g.answer(token)
			w.WriteHeader(status)
			_, _ = io.WriteString(w, text)
		default:
			t.Errorf("unexpected %s", r.URL)
			w.WriteHeader(http.StatusNotFound)
		}
	}))
	t.Cleanup(g.server.Close)
	return g
}

func (g *google) client(t *testing.T, now func() time.Time) *fcm.Client {
	t.Helper()
	c, err := fcm.New(account(t), fcm.Options{TokenURL: g.server.URL + "/token", SendBaseURL: g.server.URL, Now: now})
	if err != nil {
		t.Fatal(err)
	}
	return c
}

func TestAccessTokenCached(t *testing.T) {
	g := newGoogle(t)
	now := time.Date(2026, 11, 10, 9, 0, 0, 0, time.UTC)
	c := g.client(t, func() time.Time { return now })
	ctx := context.Background()

	a1, err := c.AccessToken(ctx)
	if err != nil {
		t.Fatal(err)
	}
	now = now.Add(50 * time.Minute)
	a2, _ := c.AccessToken(ctx)
	if a1 != a2 || g.oauthHits.Load() != 1 {
		t.Errorf("within the hour: %q %q, %d OAuth calls", a1, a2, g.oauthHits.Load())
	}
	// Less than five minutes left: renewed.
	now = now.Add(5 * time.Minute)
	a3, _ := c.AccessToken(ctx)
	if a3 == a1 || g.oauthHits.Load() != 2 {
		t.Errorf("near expiry: %q, %d OAuth calls", a3, g.oauthHits.Load())
	}
}

func TestAccessTokenError(t *testing.T) {
	g := newGoogle(t)
	g.oauthFail.Store(true)
	c := g.client(t, nil)
	if _, err := c.AccessToken(context.Background()); err == nil || !strings.Contains(err.Error(), "invalid_grant") {
		t.Fatalf("err = %v", err)
	}
	res, err := c.Send(context.Background(), "tok", fcm.Message{Title: "t", Body: "b"})
	if res != fcm.Failed || err == nil {
		t.Errorf("send without OAuth: %v %v", res, err)
	}
	if len(g.sends) != 0 {
		t.Error("nothing reaches FCM without an access token")
	}
}

func TestSend(t *testing.T) {
	g := newGoogle(t)
	c := g.client(t, nil)
	res, err := c.Send(context.Background(), "device-1", fcm.Message{
		Title: "Sana yeni görev atandı", Body: "Kontrol",
		Data: map[string]string{"type": "task", "task_id": "t1"},
	})
	if res != fcm.Sent || err != nil {
		t.Fatalf("send: %v %v", res, err)
	}
	s := g.sends[0]
	if s.Path != "/v1/projects/arici-test/messages:send" || s.Auth != "Bearer ya29.access-1" {
		t.Errorf("request %s %q", s.Path, s.Auth)
	}
	got, _ := json.Marshal(s.Body)
	want := `{"message":{"android":{"priority":"high"},"apns":{"payload":{"aps":{"sound":"default"}}},` +
		`"data":{"task_id":"t1","type":"task"},"notification":{"body":"Kontrol","title":"Sana yeni görev atandı"},"token":"device-1"}}`
	if string(got) != want {
		t.Errorf("body\n got %s\nwant %s", got, want)
	}
}

func TestSendResults(t *testing.T) {
	g := newGoogle(t)
	answers := map[string]struct {
		status int
		body   string
	}{
		"ok":           {200, `{}`},
		"gone":         {404, `{"error":{"code":404,"status":"NOT_FOUND","details":[{"errorCode":"UNREGISTERED"}]}}`},
		"unregistered": {400, `{"error":{"status":"INVALID_ARGUMENT","details":[{"errorCode":"UNREGISTERED"}]}}`},
		"bad-token":    {400, `{"error":{"status":"INVALID_ARGUMENT","message":"The registration token is not a valid FCM registration token"}}`},
		"bad-payload":  {400, `{"error":{"status":"INVALID_ARGUMENT","message":"Invalid value at 'message.data'"}}`},
		"busy":         {503, `{"error":{"status":"UNAVAILABLE"}}`},
		"quota":        {429, `{"error":{"status":"RESOURCE_EXHAUSTED"}}`},
	}
	g.answer = func(token string) (int, string) { a := answers[token]; return a.status, a.body }
	c := g.client(t, nil)
	want := map[string]fcm.Result{
		"ok": fcm.Sent, "gone": fcm.InvalidToken, "unregistered": fcm.InvalidToken,
		"bad-token": fcm.InvalidToken, "bad-payload": fcm.Failed, "busy": fcm.Failed, "quota": fcm.Failed,
	}
	for token, w := range want {
		res, err := c.Send(context.Background(), token, fcm.Message{})
		if res != w {
			t.Errorf("%s: %v, want %v", token, res, w)
		}
		if (err == nil) != (res == fcm.Sent) {
			t.Errorf("%s: err = %v", token, err)
		}
	}
}

func TestUnauthorizedDropsCachedToken(t *testing.T) {
	g := newGoogle(t)
	var refuse atomic.Bool
	refuse.Store(true)
	g.answer = func(string) (int, string) {
		if refuse.Swap(false) {
			return 401, `{"error":{"status":"UNAUTHENTICATED"}}`
		}
		return 200, `{}`
	}
	c := g.client(t, nil)
	if res, _ := c.Send(context.Background(), "a", fcm.Message{}); res != fcm.Failed {
		t.Fatalf("401: %v", res)
	}
	if res, _ := c.Send(context.Background(), "a", fcm.Message{}); res != fcm.Sent {
		t.Fatalf("after 401: %v", res)
	}
	if g.oauthHits.Load() != 2 || g.sends[1].Auth != "Bearer ya29.access-2" {
		t.Errorf("a refused token is renewed: %d OAuth calls, %q", g.oauthHits.Load(), g.sends[1].Auth)
	}
}

func TestSendBaseURLUnreachable(t *testing.T) {
	g := newGoogle(t)
	c, err := fcm.New(account(t), fcm.Options{TokenURL: g.server.URL + "/token", SendBaseURL: "http://127.0.0.1:1"})
	if err != nil {
		t.Fatal(err)
	}
	res, err := c.Send(context.Background(), "a", fcm.Message{})
	if res != fcm.Failed || err == nil {
		t.Fatalf("%v %v", res, err)
	}
	if strings.Contains(err.Error(), "ya29") {
		t.Errorf("the access token is in the error: %v", err)
	}
}
