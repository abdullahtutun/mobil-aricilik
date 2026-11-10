package weather_test

import (
	"bytes"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"slices"
	"sort"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/weather"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"

	"log/slog"
)

// testKey is a fake WEATHERAPI_KEY; it must never show up in the log.
const testKey = "sekret-key-0123456789"

const (
	owner    = "11111111-1111-1111-1111-111111111111"
	removed  = "66666666-6666-6666-6666-666666666666"
	outsider = "99999999-9999-9999-9999-999999999999"
	loner    = "77777777-7777-7777-7777-777777777777"

	orgA = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
	orgE = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee"

	testTime = "2026-11-10T10:15:30.123456Z"

	// Apiaries, in id order.
	apiaryNear1   = "a0000000-0000-0000-0000-000000000001" // 37.11,28.39
	apiaryNoLoc   = "a0000000-0000-0000-0000-000000000002" // no location
	apiaryNear2   = "a0000000-0000-0000-0000-000000000003" // 37.11,28.39 too
	apiaryDeleted = "a0000000-0000-0000-0000-000000000004" // deleted
	apiaryFar     = "a0000000-0000-0000-0000-000000000005" // 40.00,30.00
	apiaryOther   = "a0000000-0000-0000-0000-000000000009" // orgE, 39.92,32.85

	cellNear  = "37.11,28.39"
	cellFar   = "40.00,30.00"
	cellOther = "39.92,32.85"
)

// provider is a fake WeatherAPI.
type provider struct {
	server *httptest.Server
	mu     sync.Mutex
	hits   map[string]int
	// fail makes every request answer 500 with a body that echoes the key,
	// as a careless provider might.
	fail atomic.Bool
	// temp is the current temperature of the next answers.
	temp atomic.Int64
	// delay and the in-flight counters measure the concurrency.
	delay       time.Duration
	inFlight    atomic.Int64
	maxInFlight atomic.Int64
}

func newProvider(t *testing.T) *provider {
	t.Helper()
	p := &provider{hits: map[string]int{}}
	p.temp.Store(14)
	p.server = httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		n := p.inFlight.Add(1)
		defer p.inFlight.Add(-1)
		for {
			m := p.maxInFlight.Load()
			if n <= m || p.maxInFlight.CompareAndSwap(m, n) {
				break
			}
		}
		time.Sleep(p.delay)

		q := r.URL.Query()
		if q.Get("key") != testKey || q.Get("days") != "3" || q.Get("aqi") != "no" || q.Get("alerts") != "no" {
			t.Errorf("provider query = %v", q)
		}
		cell := q.Get("q")
		p.mu.Lock()
		p.hits[cell]++
		p.mu.Unlock()
		if p.fail.Load() {
			w.WriteHeader(http.StatusInternalServerError)
			_, _ = io.WriteString(w, `{"error":{"code":9999,"message":"Internal application error."}}`)
			return
		}
		_, _ = io.WriteString(w, providerBody(cell, float64(p.temp.Load())))
	}))
	t.Cleanup(p.server.Close)
	return p
}

func (p *provider) hitsFor(cell string) int {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.hits[cell]
}

func (p *provider) total() int {
	p.mu.Lock()
	defer p.mu.Unlock()
	n := 0
	for _, v := range p.hits {
		n += v
	}
	return n
}

// lockedBuffer is a log sink that the provider goroutines share.
type lockedBuffer struct {
	mu  sync.Mutex
	buf bytes.Buffer
}

func (b *lockedBuffer) Write(p []byte) (int, error) {
	b.mu.Lock()
	defer b.mu.Unlock()
	return b.buf.Write(p)
}

func (b *lockedBuffer) String() string {
	b.mu.Lock()
	defer b.mu.Unlock()
	return b.buf.String()
}

type fixture struct {
	app      *tests.TestApp
	provider *provider
	log      *lockedBuffer
	now      time.Time
	tokens   map[string]string
}

// newFixture: owner is in orgA, outsider owns orgE, removed's orgA
// membership is deleted, loner has none.
func newFixture(t *testing.T, key string, baseURL func(*provider) string) *fixture {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	ids.Register(app)
	appsync.RegisterSeq(app)

	f := &fixture{
		app:      app,
		provider: newProvider(t),
		log:      &lockedBuffer{},
		now:      istanbulNow,
		tokens:   map[string]string{},
	}
	url := f.provider.server.URL
	if baseURL != nil {
		url = baseURL(f.provider)
	}
	weather.Register(app, weather.Options{
		Key:     key,
		Days:    3,
		BaseURL: url,
		Logger:  slog.New(slog.NewTextHandler(f.log, nil)),
		Now:     func() time.Time { return f.now },
	})

	users, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	for _, id := range []string{owner, removed, outsider, loner} {
		u := core.NewRecord(users)
		u.Id = id
		u.SetEmail(id[:4] + "@test.local")
		u.SetPassword("1234567890")
		if err := app.Save(u); err != nil {
			t.Fatal(err)
		}
		tok, err := u.NewAuthToken()
		if err != nil {
			t.Fatal(err)
		}
		f.tokens[id] = tok
	}

	f.save(t, "memberships", map[string]any{"id": "c0000000-0000-0000-0000-000000000001", "org_id": orgA, "user_id": owner, "role": "owner"})
	f.save(t, "memberships", map[string]any{"id": "c0000000-0000-0000-0000-000000000006", "org_id": orgA, "user_id": removed, "role": "worker", "deleted_at": testTime})
	f.save(t, "memberships", map[string]any{"id": "c0000000-0000-0000-0000-000000000009", "org_id": orgE, "user_id": outsider, "role": "owner"})

	f.apiary(t, apiaryNear1, orgA, 37.111, 28.394, "")
	f.apiary(t, apiaryNoLoc, orgA, nil, nil, "")
	f.apiary(t, apiaryNear2, orgA, 37.1149, 28.3851, "")
	f.apiary(t, apiaryDeleted, orgA, 41.0, 29.0, testTime)
	f.apiary(t, apiaryFar, orgA, 40.0, 30.0, "")
	f.apiary(t, apiaryOther, orgE, 39.92, 32.85, "")
	return f
}

func (f *fixture) save(t *testing.T, collection string, values map[string]any) *core.Record {
	t.Helper()
	c, err := f.app.FindCachedCollectionByNameOrId(collection)
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	if id, ok := values["id"].(string); ok {
		r.Id = id
	}
	if c.Fields.GetByName("created_at") != nil {
		r.Set("created_at", testTime)
		r.Set("updated_at", testTime)
	}
	for k, v := range values {
		if k != "id" {
			r.Set(k, v)
		}
	}
	if err := f.app.Save(r); err != nil {
		t.Fatalf("%s %v: %v", collection, values, err)
	}
	return r
}

func (f *fixture) apiary(t *testing.T, id, org string, lat, lon any, deletedAt string) {
	t.Helper()
	f.save(t, "apiaries", map[string]any{
		"id": id, "org_id": org, "name": "Arılık " + id[len(id)-1:],
		"latitude": lat, "longitude": lon, "deleted_at": deletedAt,
	})
}

type response struct {
	status int
	body   []byte
}

func (f *fixture) call(t *testing.T, user string, wantStatus int) response {
	t.Helper()
	headers := map[string]string{}
	if user != "" {
		headers["Authorization"] = f.tokens[user]
	}
	var out response
	s := tests.ApiScenario{
		Name:                  "POST " + weather.Route,
		Method:                http.MethodPost,
		URL:                   weather.Route,
		Headers:               headers,
		ExpectedStatus:        wantStatus,
		ExpectedContent:       []string{""},
		TestAppFactory:        func(testing.TB) *tests.TestApp { return f.app },
		DisableTestAppCleanup: true,
		AfterTestFunc: func(t testing.TB, _ *tests.TestApp, res *http.Response) {
			b, err := io.ReadAll(res.Body)
			if err != nil {
				t.Fatal(err)
			}
			out = response{status: res.StatusCode, body: b}
		},
	}
	s.Test(t)
	return out
}

// bundle is the response, decoded loosely so that unknown or missing keys
// show.
type bundle struct {
	GeneratedAt string `json:"generated_at"`
	Forecasts   []struct {
		ApiaryID  string         `json:"apiary_id"`
		Cell      string         `json:"cell"`
		FetchedAt string         `json:"fetched_at"`
		Forecast  map[string]any `json:"forecast"`
	} `json:"forecasts"`
}

func (r response) bundle(t *testing.T) bundle {
	t.Helper()
	var b bundle
	if err := json.Unmarshal(r.body, &b); err != nil {
		t.Fatalf("body %s: %v", r.body, err)
	}
	return b
}

func (r response) errorCode(t *testing.T) string {
	t.Helper()
	var body struct {
		Data struct {
			Code string `json:"code"`
		} `json:"data"`
	}
	if err := json.Unmarshal(r.body, &body); err != nil {
		t.Fatalf("body %s: %v", r.body, err)
	}
	return body.Data.Code
}

func (f *fixture) assertKeyNotLogged(t *testing.T) {
	t.Helper()
	if s := f.log.String(); strings.Contains(s, testKey) {
		t.Errorf("the key is in the log:\n%s", s)
	}
}

func (f *fixture) cacheRows(t *testing.T) map[string]*core.Record {
	t.Helper()
	rows, err := f.app.FindAllRecords("weather_cache")
	if err != nil {
		t.Fatal(err)
	}
	out := map[string]*core.Record{}
	for _, r := range rows {
		out[r.GetString("cell")] = r
	}
	return out
}

func keys(m map[string]any) []string {
	out := make([]string, 0, len(m))
	for k := range m {
		out = append(out, k)
	}
	sort.Strings(out)
	return out
}

func TestWeather_needsSignIn(t *testing.T) {
	f := newFixture(t, testKey, nil)
	f.call(t, "", http.StatusUnauthorized)
	if f.provider.total() != 0 {
		t.Error("an anonymous call reached the provider")
	}
}

func TestWeather_withoutKeyIs503(t *testing.T) {
	f := newFixture(t, "", nil)
	r := f.call(t, owner, http.StatusServiceUnavailable)
	if code := r.errorCode(t); code != weather.CodeConfig {
		t.Errorf("code = %q, want %q", code, weather.CodeConfig)
	}
	if f.provider.total() != 0 {
		t.Error("the provider was called without a key")
	}
}

// TestWeather_bundleShape checks the body against the client model
// (lib/features/weather/domain/weather_bundle.dart, snake_case keys) and the
// Edge Function's response.
func TestWeather_bundleShape(t *testing.T) {
	f := newFixture(t, testKey, nil)
	r := f.call(t, owner, http.StatusOK)

	var top map[string]any
	if err := json.Unmarshal(r.body, &top); err != nil {
		t.Fatal(err)
	}
	if got := keys(top); !slices.Equal(got, []string{"forecasts", "generated_at"}) {
		t.Errorf("bundle keys = %v", got)
	}
	entry := top["forecasts"].([]any)[0].(map[string]any)
	if got := keys(entry); !slices.Equal(got, []string{"apiary_id", "cell", "fetched_at", "forecast"}) {
		t.Errorf("entry keys = %v", got)
	}
	forecast := entry["forecast"].(map[string]any)
	if got := keys(forecast); !slices.Equal(got, []string{
		"current", "daily", "format", "hourly", "place", "region", "timezone", "utc_offset_seconds",
	}) {
		t.Errorf("forecast keys = %v", got)
	}
	if got := keys(forecast["current"].(map[string]any)); !slices.Equal(got, []string{
		"condition_code", "feels_like_c", "humidity", "precipitation_mm", "temperature_c", "time", "wind_kmh",
	}) {
		t.Errorf("current keys = %v", got)
	}
	if got := keys(forecast["hourly"].(map[string]any)); !slices.Equal(got, []string{
		"condition_code", "precipitation_mm", "precipitation_probability", "temperature_c", "time", "wind_kmh",
	}) {
		t.Errorf("hourly keys = %v", got)
	}
	if got := keys(forecast["daily"].(map[string]any)); !slices.Equal(got, []string{
		"condition_code", "precipitation_mm", "precipitation_probability_max",
		"temperature_max_c", "temperature_min_c", "time", "wind_max_kmh",
	}) {
		t.Errorf("daily keys = %v", got)
	}

	b := r.bundle(t)
	if !pattern.IsTimestamp(b.GeneratedAt) || b.GeneratedAt != pattern.FormatTimestamp(f.now) {
		t.Errorf("generated_at = %q", b.GeneratedAt)
	}
	for _, fc := range b.Forecasts {
		if !pattern.IsTimestamp(fc.FetchedAt) {
			t.Errorf("fetched_at = %q", fc.FetchedAt)
		}
	}
}

func TestWeather_cachesCellsForAnHour(t *testing.T) {
	f := newFixture(t, testKey, nil)

	// First call: one request per cell, apiaries in id order; the one
	// without a location and the deleted one are skipped, orgE's apiary
	// does not come.
	b := f.call(t, owner, http.StatusOK).bundle(t)
	var got []string
	for _, fc := range b.Forecasts {
		got = append(got, fc.ApiaryID+"@"+fc.Cell)
	}
	want := []string{apiaryNear1 + "@" + cellNear, apiaryNear2 + "@" + cellNear, apiaryFar + "@" + cellFar}
	if !slices.Equal(got, want) {
		t.Fatalf("forecasts = %v, want %v", got, want)
	}
	if f.provider.hitsFor(cellNear) != 1 || f.provider.hitsFor(cellFar) != 1 || f.provider.total() != 2 {
		t.Fatalf("provider hits = %v", f.provider.hits)
	}
	first := pattern.FormatTimestamp(f.now)
	if b.Forecasts[0].FetchedAt != first || b.Forecasts[0].Forecast["format"] != float64(weather.ForecastFormat) {
		t.Errorf("first forecast = %+v", b.Forecasts[0])
	}
	cache := f.cacheRows(t)
	if len(cache) != 2 || cache[cellNear].GetString("fetched_at") != first {
		t.Fatalf("cache = %v", cache)
	}

	// Within the hour: from the cache, no request.
	f.now = f.now.Add(59 * time.Minute)
	f.provider.temp.Store(20)
	b = f.call(t, owner, http.StatusOK).bundle(t)
	if f.provider.total() != 2 {
		t.Errorf("a cached cell was fetched again: %v", f.provider.hits)
	}
	if b.Forecasts[0].FetchedAt != first {
		t.Errorf("fetched_at = %q, want the cached %q", b.Forecasts[0].FetchedAt, first)
	}
	cur := b.Forecasts[0].Forecast["current"].(map[string]any)
	if cur["temperature_c"] != float64(14) {
		t.Errorf("cached temperature = %v, want 14", cur["temperature_c"])
	}

	// Past the hour: fetched again and the cache row is replaced in place.
	f.now = f.now.Add(2 * time.Minute)
	b = f.call(t, owner, http.StatusOK).bundle(t)
	if f.provider.hitsFor(cellNear) != 2 || f.provider.hitsFor(cellFar) != 2 {
		t.Errorf("stale cells not fetched again: %v", f.provider.hits)
	}
	second := pattern.FormatTimestamp(f.now)
	cur = b.Forecasts[0].Forecast["current"].(map[string]any)
	if b.Forecasts[0].FetchedAt != second || cur["temperature_c"] != float64(20) {
		t.Errorf("refreshed forecast = %v at %s", cur["temperature_c"], b.Forecasts[0].FetchedAt)
	}
	after := f.cacheRows(t)
	if len(after) != 2 || after[cellNear].Id != cache[cellNear].Id || after[cellNear].GetString("fetched_at") != second {
		t.Errorf("cache after refresh = %v", after)
	}
	f.assertKeyNotLogged(t)
}

func TestWeather_providerErrorServesOldCache(t *testing.T) {
	f := newFixture(t, testKey, nil)
	f.call(t, owner, http.StatusOK)
	first := pattern.FormatTimestamp(f.now)

	f.now = f.now.Add(3 * time.Hour)
	f.provider.fail.Store(true)
	b := f.call(t, owner, http.StatusOK).bundle(t)
	if f.provider.total() != 4 {
		t.Errorf("stale cells were not tried: %v", f.provider.hits)
	}
	for _, fc := range b.Forecasts {
		if fc.FetchedAt != first {
			t.Errorf("%s fetched_at = %q, want the old %q", fc.ApiaryID, fc.FetchedAt, first)
		}
	}
	if s := f.log.String(); !strings.Contains(s, "WeatherAPI 500") {
		t.Errorf("the provider error is not logged:\n%s", s)
	}
	f.assertKeyNotLogged(t)
}

func TestWeather_providerErrorWithoutCacheIs502(t *testing.T) {
	f := newFixture(t, testKey, nil)
	f.provider.fail.Store(true)
	r := f.call(t, owner, http.StatusBadGateway)
	if code := r.errorCode(t); code != weather.CodeUpstream {
		t.Errorf("code = %q, want %q", code, weather.CodeUpstream)
	}
	if n := len(f.cacheRows(t)); n != 0 {
		t.Errorf("cache rows = %d, want 0", n)
	}
	f.assertKeyNotLogged(t)
}

// One cell cached, the other new: the new one fails, so 502 although the
// cached one could be served (the Edge Function's rule).
func TestWeather_newCellFailingIs502EvenWithOtherCellsCached(t *testing.T) {
	f := newFixture(t, testKey, nil)
	f.call(t, owner, http.StatusOK)
	f.apiary(t, "a0000000-0000-0000-0000-000000000006", orgA, 10.0, 10.0, "")
	f.provider.fail.Store(true)
	f.call(t, owner, http.StatusBadGateway)
	if f.provider.hitsFor("10.00,10.00") != 1 || f.provider.total() != 3 {
		t.Errorf("hits = %v, want only the new cell tried", f.provider.hits)
	}
}

// The provider cannot be reached: Go's *url.Error carries the URL, and with
// it the key; it must not reach the log.
func TestWeather_unreachableProviderDoesNotLogTheKey(t *testing.T) {
	f := newFixture(t, testKey, func(p *provider) string {
		p.server.Close()
		return p.server.URL
	})
	f.call(t, owner, http.StatusBadGateway)
	if s := f.log.String(); !strings.Contains(s, "weather fetch failed") {
		t.Errorf("the failure is not logged:\n%s", s)
	}
	f.assertKeyNotLogged(t)
}

func TestWeather_oldFormatCacheIsFetchedAgain(t *testing.T) {
	f := newFixture(t, testKey, nil)
	fresh := pattern.FormatTimestamp(f.now)
	f.save(t, "weather_cache", map[string]any{"cell": cellNear, "forecast": map[string]any{"format": 1, "hourly": map[string]any{}}, "fetched_at": fresh})
	b := f.call(t, owner, http.StatusOK).bundle(t)
	if f.provider.hitsFor(cellNear) != 1 {
		t.Errorf("old-format cell not fetched: %v", f.provider.hits)
	}
	if b.Forecasts[0].Forecast["format"] != float64(weather.ForecastFormat) {
		t.Errorf("format = %v", b.Forecasts[0].Forecast["format"])
	}
	rows, err := f.app.FindAllRecords("weather_cache", dbx.HashExp{"cell": cellNear})
	if err != nil || len(rows) != 1 {
		t.Fatalf("cache rows = %v, %v", rows, err)
	}

	// An old-format row is not a fallback either.
	f.provider.fail.Store(true)
	f.save(t, "weather_cache", map[string]any{"cell": "10.00,10.00", "forecast": map[string]any{"format": 1}, "fetched_at": fresh})
	f.apiary(t, "a0000000-0000-0000-0000-000000000006", orgA, 10.0, 10.0, "")
	f.call(t, owner, http.StatusBadGateway)
}

func TestWeather_onlyTheCallersOrganizations(t *testing.T) {
	f := newFixture(t, testKey, nil)

	b := f.call(t, outsider, http.StatusOK).bundle(t)
	if len(b.Forecasts) != 1 || b.Forecasts[0].ApiaryID != apiaryOther || b.Forecasts[0].Cell != cellOther {
		t.Errorf("outsider forecasts = %+v", b.Forecasts)
	}
	if f.provider.hitsFor(cellNear) != 0 {
		t.Error("orgA's cell was fetched for the outsider")
	}

	// A removed member and a user without an organization get an empty
	// bundle, without a provider call.
	before := f.provider.total()
	for _, u := range []string{removed, loner} {
		r := f.call(t, u, http.StatusOK)
		if !strings.Contains(string(r.body), `"forecasts":[]`) {
			t.Errorf("%s body = %s, want empty forecasts", u, r.body)
		}
	}
	if f.provider.total() != before {
		t.Error("an empty bundle called the provider")
	}
}

func TestWeather_atMostFiveRequestsAtATime(t *testing.T) {
	f := newFixture(t, testKey, nil)
	f.provider.delay = 50 * time.Millisecond
	for i := range 12 {
		f.apiary(t, "b0000000-0000-0000-0000-0000000000"+twoDigits(i), orgA, float64(i), float64(i), "")
	}
	b := f.call(t, owner, http.StatusOK).bundle(t)
	if len(b.Forecasts) != 15 {
		t.Errorf("forecasts = %d, want 15", len(b.Forecasts))
	}
	if m := f.provider.maxInFlight.Load(); m > weather.ParallelRequests || m < 2 {
		t.Errorf("max in flight = %d, want 2..%d", m, weather.ParallelRequests)
	}
}

func twoDigits(i int) string {
	return string(rune('0'+i/10)) + string(rune('0'+i%10))
}

func TestLocations(t *testing.T) {
	f := newFixture(t, testKey, nil)
	got, err := weather.Locations(f.app, owner)
	if err != nil {
		t.Fatal(err)
	}
	want := []weather.Location{
		{ApiaryID: apiaryNear1, Latitude: 37.111, Longitude: 28.394},
		{ApiaryID: apiaryNear2, Latitude: 37.1149, Longitude: 28.3851},
		{ApiaryID: apiaryFar, Latitude: 40, Longitude: 30},
	}
	if !slices.Equal(got, want) {
		t.Errorf("Locations = %v, want %v", got, want)
	}
	if got, _ := weather.Locations(f.app, ""); len(got) != 0 {
		t.Errorf("Locations(anon) = %v", got)
	}
}
