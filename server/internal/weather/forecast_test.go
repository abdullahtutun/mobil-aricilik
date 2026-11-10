package weather_test

import (
	"encoding/json"
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/weather"
)

func TestForecastDays(t *testing.T) {
	for in, want := range map[string]int{
		"":                     weather.DefaultForecastDays,
		"x":                    weather.DefaultForecastDays,
		"0":                    weather.DefaultForecastDays,
		"-3":                   weather.DefaultForecastDays,
		"3":                    3,
		" 5":                   5,
		"10d":                  10,
		"14":                   14,
		"30":                   14,
		"1e3":                  1,
		"+":                    weather.DefaultForecastDays,
		"99999999999999999999": 14,
	} {
		if got := weather.ForecastDays(in); got != want {
			t.Errorf("ForecastDays(%q) = %d, want %d", in, got, want)
		}
	}
}

func TestCellOf_matchesToFixed(t *testing.T) {
	for _, c := range []struct {
		lat, lon float64
		want     string
	}{
		{37.111, 28.394, "37.11,28.39"},
		{37.1149, 28.3851, "37.11,28.39"},
		{39.92, 32.85, "39.92,32.85"},
		{-33.8688, 151.2093, "-33.87,151.21"},
		// Exact binary ties: toFixed takes the larger magnitude.
		{0.125, -0.125, "0.13,-0.13"},
		{1.375, -179.625, "1.38,-179.63"},
		// -0 prints as 0; a tiny negative keeps its sign, as in JS.
		{-0.0, -0.001, "0.00,-0.00"},
		{90, -180, "90.00,-180.00"},
	} {
		if got := weather.CellOf(c.lat, c.lon); got != c.want {
			t.Errorf("CellOf(%v, %v) = %q, want %q", c.lat, c.lon, got, c.want)
		}
	}
}

// istanbulNow is the instant of providerBody's local time 2026-11-10 13:07
// in Istanbul (UTC+3).
var istanbulNow = time.Date(2026, 11, 10, 10, 7, 0, 0, time.UTC)

// providerBody is a WeatherAPI forecast.json body for a cell: two days of
// two hours each, Istanbul time. Values that the TypeScript nulls (strings,
// missing fields) are mixed in.
func providerBody(cell string, temp float64) string {
	local := istanbulNow.Unix()
	day1 := time.Date(2026, 11, 10, 0, 0, 0, 0, time.UTC).Unix()
	day2 := day1 + 86400
	return fmt.Sprintf(`{
  "location": {"name": "Muğla", "region": "Muğla", "country": "Turkey",
    "lat": %s, "tz_id": "Europe/Istanbul",
    "localtime_epoch": %d, "localtime": "2026-11-10 13:07"},
  "current": {"last_updated_epoch": %d, "temp_c": %v, "feelslike_c": -0.0,
    "humidity": 71, "wind_kph": 12.6, "precip_mm": 0.1,
    "condition": {"code": 1003, "text": "Partly cloudy"}},
  "forecast": {"forecastday": [
    {"date": "2026-11-10", "date_epoch": %d,
     "day": {"maxtemp_c": 18.4, "mintemp_c": 9.1, "totalprecip_mm": 0.5,
       "maxwind_kph": 20.2, "daily_chance_of_rain": 40, "daily_chance_of_snow": 0,
       "condition": {"code": 1063}},
     "hour": [
       {"time_epoch": %d, "temp_c": 12.5, "wind_kph": 8, "precip_mm": 0,
        "chance_of_rain": 10, "chance_of_snow": 30, "condition": {"code": 1000}},
       {"time_epoch": %d, "temp_c": "n/a", "precip_mm": 0.2,
        "chance_of_rain": 55, "condition": {"code": 1063}}
     ]},
    {"date": "2026-11-11", "date_epoch": %d,
     "day": {"maxtemp_c": 16, "mintemp_c": 7.5, "totalprecip_mm": 2.1,
       "maxwind_kph": 25, "daily_chance_of_snow": 5},
     "hour": [
       {"time_epoch": %d, "temp_c": 9, "wind_kph": 15, "precip_mm": 1.2,
        "condition": {"code": 1183}}
     ]}
  ]}
}`, `"`+cell+`"`, local, local-120, temp, day1, day1-3*3600, day1-2*3600, day2, day2-3*3600)
}

func TestParseForecast(t *testing.T) {
	f, err := weather.ParseForecast([]byte(providerBody("37.11,28.39", 14.2)))
	if err != nil {
		t.Fatal(err)
	}
	got, err := json.Marshal(f)
	if err != nil {
		t.Fatal(err)
	}
	day1 := time.Date(2026, 11, 10, 0, 0, 0, 0, time.UTC).Unix()
	local := istanbulNow.Unix()
	want := fmt.Sprintf(`{"format":2,"place":"Muğla","region":"Muğla",`+
		`"timezone":"Europe/Istanbul","utc_offset_seconds":10800,`+
		`"current":{"time":%d,"temperature_c":14.2,"feels_like_c":0,"humidity":71,`+
		`"wind_kmh":12.6,"precipitation_mm":0.1,"condition_code":1003},`+
		`"hourly":{"time":[%d,%d,%d],"temperature_c":[12.5,null,9],"wind_kmh":[8,null,15],`+
		`"precipitation_mm":[0,0.2,1.2],"precipitation_probability":[30,55,null],`+
		`"condition_code":[1000,1063,1183]},`+
		`"daily":{"time":[%d,%d],"condition_code":[1063,null],"temperature_max_c":[18.4,16],`+
		`"temperature_min_c":[9.1,7.5],"precipitation_mm":[0.5,2.1],`+
		`"precipitation_probability_max":[40,5],"wind_max_kmh":[20.2,25]}}`,
		local-120, day1-3*3600, day1-2*3600, day1+86400-3*3600,
		day1-10800, day1+86400-10800)
	if string(got) != want {
		t.Errorf("forecast\n got %s\nwant %s", got, want)
	}
}

func TestParseForecast_currentTimeFallsBackToLocaltime(t *testing.T) {
	body := strings.Replace(providerBody("1.00,1.00", 1), `"last_updated_epoch"`, `"x"`, 1)
	f, err := weather.ParseForecast([]byte(body))
	if err != nil {
		t.Fatal(err)
	}
	if got, want := string(f.Current.Time), fmt.Sprint(istanbulNow.Unix()); got != want {
		t.Errorf("current.time = %s, want %s", got, want)
	}
}

func TestParseForecast_negativeOffset(t *testing.T) {
	// New York, UTC−5: local 05:07 at 10:07 UTC, plus a few seconds of
	// drift that the quarter-hour rounding removes.
	body := `{"location":{"tz_id":"America/New_York","localtime":"2026-11-10 05:07",
	  "localtime_epoch":` + fmt.Sprint(istanbulNow.Unix()+20) + `},
	  "forecast":{"forecastday":[]}}`
	f, err := weather.ParseForecast([]byte(body))
	if err != nil {
		t.Fatal(err)
	}
	if f.UTCOffsetSeconds != -5*3600 {
		t.Errorf("offset = %v, want -18000", f.UTCOffsetSeconds)
	}
	if f.Place != nil || f.Region != nil {
		t.Errorf("place/region = %v/%v, want null", f.Place, f.Region)
	}
	got, _ := json.Marshal(f.Hourly)
	if !strings.Contains(string(got), `"time":[]`) {
		t.Errorf("empty hourly must be [] not null: %s", got)
	}
}

func TestParseForecast_rejectsBodyWithoutLocation(t *testing.T) {
	for _, body := range []string{`{}`, `not json`, `{"location":{"localtime":"x","localtime_epoch":1,"tz_id":"UTC"},"forecast":{}}`} {
		if _, err := weather.ParseForecast([]byte(body)); err == nil {
			t.Errorf("ParseForecast(%s) = nil error", body)
		}
	}
}
