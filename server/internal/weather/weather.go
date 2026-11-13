// Package weather is POST /api/app/weather (P5.5): the Go port of the
// weather-bundle Edge Function (supabase/functions/weather-bundle/index.ts
// and weather_api.ts) and of the weather_locations() SQL function
// (20261026200000_weather).
//
// The caller's apiaries come from the server: the live (not deleted)
// apiaries with a location in the organizations the caller is a member of,
// the select policy of apiaries. The client sends no coordinates. Each
// 0.01° cell's WeatherAPI forecast is cached in weather_cache for an hour.
// A cell that cannot be fetched falls back to its old cache; when one has no
// data at all the answer is 502 and the app keeps showing the bundle it
// stored. The key is WEATHERAPI_KEY; without it the route answers 503. The
// key travels in the provider's query string, so neither the URL nor an
// error that carries it is ever logged.
//
// Body: { generated_at, forecasts: [{ apiary_id, cell, fetched_at,
// forecast }] }. The app shows the "Powered by WeatherAPI.com" credit.
package weather

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log/slog"
	"net/http"
	"net/url"
	"slices"
	"strings"
	"sync"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

// Route is the weather bundle route.
const Route = "/api/app/weather"

// ProviderURL is WeatherAPI's forecast endpoint.
const ProviderURL = "https://api.weatherapi.com/v1/forecast.json"

// Error codes in the JSON body's data.code.
const (
	// CodeConfig (503): WEATHERAPI_KEY is not set.
	CodeConfig = "config"
	// CodeUpstream (502): a cell has neither a fresh forecast nor an old
	// cache.
	CodeUpstream = "upstream"
)

const (
	// CacheTTL is how long a cell's forecast is served without asking
	// WeatherAPI again.
	CacheTTL = time.Hour
	// ParallelRequests is the most WeatherAPI requests at a time; the free
	// plan has no batch request, every cell is one call.
	ParallelRequests = 5
	// requestTimeout bounds one cell's request.
	requestTimeout = 10 * time.Second
	// maxBodyBytes caps a provider body; a 14-day forecast is a few
	// hundred KiB.
	maxBodyBytes = 8 << 20
	// cacheCollection is the server-only cache (P2.7).
	cacheCollection = "weather_cache"
)

// Options configure the route. Key empty means the feature is off.
type Options struct {
	// Key is WEATHERAPI_KEY. Never log it.
	Key string
	// Days is the requested forecast length ([ForecastDays]).
	Days int
	// BaseURL is the forecast endpoint; [ProviderURL] when empty. Tests
	// point it at an httptest server.
	BaseURL string
	// Client makes the provider requests; a plain client when nil.
	Client *http.Client
	// Logger receives the provider errors; the app logger when nil.
	Logger *slog.Logger
	// Now is the clock; time.Now when nil.
	Now func() time.Time
}

// Register binds the route; it needs a signed-in app user.
func Register(app core.App, opts Options) {
	if opts.BaseURL == "" {
		opts.BaseURL = ProviderURL
	}
	if opts.Client == nil {
		opts.Client = &http.Client{}
	}
	if opts.Now == nil {
		opts.Now = time.Now
	}
	if opts.Days < 1 {
		opts.Days = DefaultForecastDays
	}
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.POST(Route, opts.handle).Bind(apis.RequireAuth(auth.UsersCollection))
		return se.Next()
	})
}

// Bundle is the response body.
type Bundle struct {
	GeneratedAt string           `json:"generated_at"`
	Forecasts   []ApiaryForecast `json:"forecasts"`
}

// ApiaryForecast is one apiary's entry; apiaries in the same cell share the
// forecast.
type ApiaryForecast struct {
	ApiaryID  string          `json:"apiary_id"`
	Cell      string          `json:"cell"`
	FetchedAt string          `json:"fetched_at"`
	Forecast  json.RawMessage `json:"forecast"`
}

// Location is a row of weather_locations().
type Location struct {
	ApiaryID  string
	Latitude  float64
	Longitude float64
}

// cacheRow is a cell's forecast and when it was fetched.
type cacheRow struct {
	forecast  json.RawMessage
	fetchedAt string
}

func (o Options) logger(app core.App) *slog.Logger {
	if o.Logger != nil {
		return o.Logger
	}
	return app.Logger()
}

func (o Options) handle(e *core.RequestEvent) error {
	log := o.logger(e.App)
	if o.Key == "" {
		log.Error("WEATHERAPI_KEY is not set")
		return apiError(e, http.StatusServiceUnavailable, CodeConfig, "Weather is not configured.")
	}

	locations, err := Locations(e.App, e.Auth.Id)
	if err != nil {
		return e.InternalServerError("", err)
	}
	type apiaryCell struct{ apiaryID, cell string }
	apiaries := make([]apiaryCell, len(locations))
	var cells []string
	for i, l := range locations {
		apiaries[i] = apiaryCell{l.ApiaryID, CellOf(l.Latitude, l.Longitude)}
		if !slices.Contains(cells, apiaries[i].cell) {
			cells = append(cells, apiaries[i].cell)
		}
	}

	byCell, err := readCache(e.App, cells)
	if err != nil {
		// Like the Edge Function: a cache read error is logged and every
		// cell is fetched again.
		log.Error("weather cache read failed", "error", err)
		byCell = map[string]cacheRow{}
	}

	now := o.Now()
	var stale []string
	for _, cell := range cells {
		row, ok := byCell[cell]
		if !ok || isStale(row.fetchedAt, now) {
			stale = append(stale, cell)
		}
	}

	if len(stale) > 0 {
		fresh := o.fetchForecasts(e.Request.Context(), log, stale)
		for cell, row := range fresh {
			byCell[cell] = row
		}
		writeCache(e.App, log, fresh)
		for _, cell := range stale {
			if _, ok := byCell[cell]; !ok {
				// Without an old cache the bundle would be incomplete;
				// the client keeps what it has.
				return apiError(e, http.StatusBadGateway, CodeUpstream, "The weather provider is not available.")
			}
		}
	}

	bundle := Bundle{
		GeneratedAt: pattern.FormatTimestamp(now),
		Forecasts:   make([]ApiaryForecast, len(apiaries)),
	}
	for i, a := range apiaries {
		row := byCell[a.cell]
		bundle.Forecasts[i] = ApiaryForecast{
			ApiaryID:  a.apiaryID,
			Cell:      a.cell,
			FetchedAt: row.fetchedAt,
			Forecast:  row.forecast,
		}
	}
	return e.JSON(http.StatusOK, bundle)
}

// isStale reports whether a forecast fetched at fetchedAt is older than
// [CacheTTL]. An unreadable time counts as stale.
func isStale(fetchedAt string, now time.Time) bool {
	t, err := time.Parse(pattern.TimestampLayout, fetchedAt)
	return err != nil || now.Sub(t) > CacheTTL
}

// Locations is weather_locations(): the user's apiaries that are not deleted
// and have a location, in the organizations whose apiaries the user may
// read. Ordered by id (UUIDv7, so by creation); the SQL had no order.
func Locations(app core.App, userID string) ([]Location, error) {
	policy, err := authz.Lookup("apiaries")
	if err != nil {
		return nil, err
	}
	orgIDs, err := authz.OrgIDsForUser(app, userID, policy.Read...)
	if err != nil || len(orgIDs) == 0 {
		return nil, err
	}
	in := make([]any, len(orgIDs))
	for i, id := range orgIDs {
		in[i] = id
	}
	rows := []struct {
		ID        string `db:"id"`
		Latitude  sql.NullString `db:"latitude"`
		Longitude sql.NullString `db:"longitude"`
	}{}
	err = app.DB().
		Select("id", "latitude", "longitude").
		From("apiaries").
		Where(dbx.HashExp{"org_id": in, "deleted_at": ""}).
		OrderBy("id").
		All(&rows)
	if err != nil {
		return nil, err
	}
	out := []Location{}
	for _, r := range rows {
		lat, latOK := number(r.Latitude.String)
		lon, lonOK := number(r.Longitude.String)
		if latOK && lonOK {
			out = append(out, Location{ApiaryID: r.ID, Latitude: lat, Longitude: lon})
		}
	}
	return out, nil
}

// number reads a nullable JSON number column; empty and null are not set.
func number(raw string) (float64, bool) {
	var v *float64
	if strings.TrimSpace(raw) == "" || json.Unmarshal([]byte(raw), &v) != nil || v == nil {
		return 0, false
	}
	return *v, true
}

// readCache returns the cached rows of cells in the current
// [ForecastFormat]; a row in an old format is left out, so it is fetched
// again and never reaches the client.
func readCache(app core.App, cells []string) (map[string]cacheRow, error) {
	out := map[string]cacheRow{}
	if len(cells) == 0 {
		return out, nil
	}
	in := make([]any, len(cells))
	for i, c := range cells {
		in[i] = c
	}
	rows := []struct {
		Cell      string `db:"cell"`
		Forecast  string `db:"forecast"`
		FetchedAt string `db:"fetched_at"`
	}{}
	err := app.DB().
		Select("cell", "forecast", "fetched_at").
		From(cacheCollection).
		Where(dbx.HashExp{"cell": in}).
		All(&rows)
	if err != nil {
		return nil, err
	}
	for _, r := range rows {
		var head struct {
			Format int `json:"format"`
		}
		if json.Unmarshal([]byte(r.Forecast), &head) == nil && head.Format == ForecastFormat {
			out[r.Cell] = cacheRow{forecast: json.RawMessage(r.Forecast), fetchedAt: r.FetchedAt}
		}
	}
	return out, nil
}

// writeCache upserts the fresh rows by cell. Errors are logged; the
// response still carries the fresh forecasts.
func writeCache(app core.App, log *slog.Logger, rows map[string]cacheRow) {
	if len(rows) == 0 {
		return
	}
	collection, err := app.FindCachedCollectionByNameOrId(cacheCollection)
	if err != nil {
		log.Error("weather cache write failed", "error", err)
		return
	}
	for cell, row := range rows {
		record, err := app.FindFirstRecordByData(collection, "cell", cell)
		switch {
		case errors.Is(err, sql.ErrNoRows):
			record = core.NewRecord(collection)
			record.Set("cell", cell)
		case err != nil:
			log.Error("weather cache write failed", "cell", cell, "error", err)
			continue
		}
		record.Set("forecast", row.forecast)
		record.Set("fetched_at", row.fetchedAt)
		if err := app.Save(record); err != nil {
			log.Error("weather cache write failed", "cell", cell, "error", err)
		}
	}
}

// fetchForecasts asks WeatherAPI for each cell, at most [ParallelRequests]
// at a time. A cell that fails is logged and left out.
func (o Options) fetchForecasts(ctx context.Context, log *slog.Logger, cells []string) map[string]cacheRow {
	out := map[string]cacheRow{}
	var mu sync.Mutex
	queue := make(chan string, len(cells))
	for _, c := range cells {
		queue <- c
	}
	close(queue)

	var wg sync.WaitGroup
	for range min(ParallelRequests, len(cells)) {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for cell := range queue {
				forecast, err := o.fetchCell(ctx, cell)
				if err != nil {
					log.Error("weather fetch failed", "cell", cell, "error", o.redact(err))
					continue
				}
				fetchedAt := pattern.FormatTimestamp(o.Now())
				mu.Lock()
				out[cell] = cacheRow{forecast: forecast, fetchedAt: fetchedAt}
				mu.Unlock()
			}
		}()
	}
	wg.Wait()
	return out
}

// fetchCell is one cell's request, parsed and encoded for the cache.
func (o Options) fetchCell(ctx context.Context, cell string) (json.RawMessage, error) {
	ctx, cancel := context.WithTimeout(ctx, requestTimeout)
	defer cancel()
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, forecastURL(o.BaseURL, cell, o.Key, o.Days), nil)
	if err != nil {
		return nil, err
	}
	res, err := o.Client.Do(req)
	if err != nil {
		// A *url.Error carries the URL, and with it the key.
		var urlErr *url.Error
		if errors.As(err, &urlErr) {
			return nil, urlErr.Err
		}
		return nil, err
	}
	defer res.Body.Close()
	body, err := io.ReadAll(io.LimitReader(res.Body, maxBodyBytes))
	if err != nil {
		return nil, err
	}
	if res.StatusCode != http.StatusOK {
		// Only the status and the body are logged.
		return nil, fmt.Errorf("WeatherAPI %d: %s", res.StatusCode, body)
	}
	forecast, err := ParseForecast(body)
	if err != nil {
		return nil, err
	}
	return json.Marshal(forecast)
}

// redact removes the key from an error text, in case any layer echoed it.
func (o Options) redact(err error) string {
	msg := err.Error()
	if o.Key != "" {
		msg = strings.ReplaceAll(msg, o.Key, "[redacted]")
		msg = strings.ReplaceAll(msg, url.QueryEscape(o.Key), "[redacted]")
	}
	return msg
}

func apiError(e *core.RequestEvent, status int, code, message string) error {
	return e.JSON(status, auth.ErrorBody{Status: status, Message: message, Data: auth.ErrorData{Code: code}})
}
