package weather

import (
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"net/url"
	"strconv"
	"strings"
	"time"
)

// DefaultForecastDays is the day count when WEATHERAPI_DAYS is unset or
// invalid.
const DefaultForecastDays = 7

// maxForecastDays is the most days WeatherAPI's forecast.json accepts.
const maxForecastDays = 14

// ForecastDays parses WEATHERAPI_DAYS like weather_api.ts's forecastDays
// (parseInt): leading digits count, below 1 or unparsable gives
// [DefaultForecastDays], above 14 is capped. WeatherAPI does not fail when a
// plan allows fewer days (Free 3, Starter 7, Pro+ 14); it returns what the
// plan allows and the app shows what comes.
func ForecastDays(value string) int {
	s := strings.TrimLeft(value, " \t\n\r\v\f")
	end := 0
	if end < len(s) && (s[end] == '+' || s[end] == '-') {
		end++
	}
	digits := end
	for end < len(s) && s[end] >= '0' && s[end] <= '9' {
		end++
	}
	if end == digits {
		return DefaultForecastDays
	}
	days, err := strconv.Atoi(s[:end])
	if err != nil {
		// Too many digits: a huge positive number is capped, a huge
		// negative one is below 1.
		if s[0] == '-' {
			return DefaultForecastDays
		}
		return maxForecastDays
	}
	if days < 1 {
		return DefaultForecastDays
	}
	return min(days, maxForecastDays)
}

// ForecastFormat is the version of the cached forecast's shape. A cached row
// in another format is treated as missing and never reaches the client.
const ForecastFormat = 2

// CellOf is the 0.01° (~1 km) cell of a location, "37.11,28.39": the cache
// key and the coordinate sent to WeatherAPI (q=lat,lon). Rounds like
// JavaScript's toFixed(2), which weather_api.ts used: an exact tie goes away
// from zero, and -0 prints as 0.
func CellOf(latitude, longitude float64) string {
	return toFixed2(latitude) + "," + toFixed2(longitude)
}

func toFixed2(x float64) string {
	if x == 0 {
		x = 0 // -0 → 0
	}
	sign := ""
	if x < 0 {
		sign = "-"
		x = -x
	}
	scaled := x * 100
	if fl := math.Floor(scaled); scaled-fl == 0.5 {
		// An exact binary tie (e.g. 0.125): toFixed takes the larger n,
		// FormatFloat would round half to even.
		n := int64(fl) + 1
		return fmt.Sprintf("%s%d.%02d", sign, n/100, n%100)
	}
	return sign + strconv.FormatFloat(x, 'f', 2, 64)
}

// forecastURL is the cell's request. The key is in the query string, so the
// URL is never logged.
func forecastURL(base, cell, key string, days int) string {
	q := url.Values{}
	q.Set("key", key)
	q.Set("q", cell)
	q.Set("days", strconv.Itoa(days))
	q.Set("aqi", "no")
	q.Set("alerts", "no")
	return base + "?" + q.Encode()
}

// Forecast is the bundle the app reads (weather_api.ts's Forecast). Field
// order follows the TypeScript object. Units are metric; condition codes
// are WeatherAPI's condition.code, untranslated.
type Forecast struct {
	Format           int     `json:"format"`
	Place            *string `json:"place"`
	Region           *string `json:"region"`
	Timezone         string  `json:"timezone"`
	UTCOffsetSeconds float64 `json:"utc_offset_seconds"`
	Current          Current `json:"current"`
	Hourly           Hourly  `json:"hourly"`
	Daily            Daily   `json:"daily"`
}

// Current is the provider's latest observation; Time is Unix seconds.
type Current struct {
	Time            json.RawMessage `json:"time"`
	TemperatureC    *float64        `json:"temperature_c"`
	FeelsLikeC      *float64        `json:"feels_like_c"`
	Humidity        *float64        `json:"humidity"`
	WindKmh         *float64        `json:"wind_kmh"`
	PrecipitationMm *float64        `json:"precipitation_mm"`
	ConditionCode   *float64        `json:"condition_code"`
}

// Hourly holds the hourly columns, all as long as Time.
type Hourly struct {
	Time                     []json.RawMessage `json:"time"`
	TemperatureC             []*float64        `json:"temperature_c"`
	WindKmh                  []*float64        `json:"wind_kmh"`
	PrecipitationMm          []*float64        `json:"precipitation_mm"`
	PrecipitationProbability []*float64        `json:"precipitation_probability"`
	ConditionCode            []*float64        `json:"condition_code"`
}

// Daily holds the daily columns, all as long as Time. Time is the local
// midnight of the apiary's time zone, in Unix seconds.
type Daily struct {
	Time                        []*float64 `json:"time"`
	ConditionCode               []*float64 `json:"condition_code"`
	TemperatureMaxC             []*float64 `json:"temperature_max_c"`
	TemperatureMinC             []*float64 `json:"temperature_min_c"`
	PrecipitationMm             []*float64 `json:"precipitation_mm"`
	PrecipitationProbabilityMax []*float64 `json:"precipitation_probability_max"`
	WindMaxKmh                  []*float64 `json:"wind_max_kmh"`
}

type object = map[string]any

// num is weather_api.ts's num: a JSON number, else null. -0 becomes 0, as
// JSON.stringify writes it.
func num(v any) *float64 {
	f, ok := v.(float64)
	if !ok {
		return nil
	}
	if f == 0 {
		f = 0
	}
	return &f
}

// chance is the larger of the rain and snow probabilities.
func chance(rain, snow any) *float64 {
	r, s := num(rain), num(snow)
	switch {
	case r == nil:
		return s
	case s == nil:
		return r
	case *s > *r:
		return s
	}
	return r
}

func field(o object, key string) object {
	m, _ := o[key].(object)
	return m
}

// raw re-encodes a JSON value as it came (null when missing), like the
// TypeScript passed h.time_epoch through untouched.
func raw(v any) json.RawMessage {
	if v == nil {
		return json.RawMessage("null")
	}
	if f, ok := v.(float64); ok && f == 0 {
		return json.RawMessage("0")
	}
	b, err := json.Marshal(v)
	if err != nil {
		return json.RawMessage("null")
	}
	return b
}

// ParseForecast turns a WeatherAPI forecast.json body into [Forecast]. Hours
// are Unix seconds; a day is the apiary's local midnight (WeatherAPI gives
// date_epoch as UTC midnight; it is shifted by the offset derived from the
// local time). A body without location or forecast days is an error, where
// the TypeScript threw.
func ParseForecast(body []byte) (Forecast, error) {
	var root object
	if err := json.Unmarshal(body, &root); err != nil {
		return Forecast{}, fmt.Errorf("forecast body: %w", err)
	}
	location := field(root, "location")
	if location == nil {
		return Forecast{}, errors.New("forecast body has no location")
	}
	localtime, _ := location["localtime"].(string)
	localtimeEpoch, ok := location["localtime_epoch"].(float64)
	if !ok {
		return Forecast{}, errors.New("location has no localtime_epoch")
	}
	// "2026-10-26 15:09" is local time; read as UTC, its gap to the real
	// instant is the offset, rounded to a quarter hour.
	localAsUTC, err := time.Parse("2006-01-02 15:04", localtime)
	if err != nil {
		return Forecast{}, fmt.Errorf("location localtime: %w", err)
	}
	const quarter = 15 * 60
	// Math.round: halves go up, also for negatives.
	offset := math.Floor((float64(localAsUTC.Unix())-localtimeEpoch)/quarter+0.5) * quarter
	if offset == 0 {
		offset = 0
	}
	timezone, ok := location["tz_id"].(string)
	if !ok {
		return Forecast{}, errors.New("location has no tz_id")
	}
	forecast := field(root, "forecast")
	days, ok := forecast["forecastday"].([]any)
	if !ok {
		return Forecast{}, errors.New("forecast has no forecastday")
	}

	f := Forecast{
		Format:           ForecastFormat,
		Timezone:         timezone,
		UTCOffsetSeconds: offset,
		Hourly: Hourly{
			Time:                     []json.RawMessage{},
			TemperatureC:             []*float64{},
			WindKmh:                  []*float64{},
			PrecipitationMm:          []*float64{},
			PrecipitationProbability: []*float64{},
			ConditionCode:            []*float64{},
		},
		Daily: Daily{
			Time:                        []*float64{},
			ConditionCode:               []*float64{},
			TemperatureMaxC:             []*float64{},
			TemperatureMinC:             []*float64{},
			PrecipitationMm:             []*float64{},
			PrecipitationProbabilityMax: []*float64{},
			WindMaxKmh:                  []*float64{},
		},
	}
	if s, ok := location["name"].(string); ok {
		f.Place = &s
	}
	if s, ok := location["region"].(string); ok {
		f.Region = &s
	}

	current := field(root, "current")
	f.Current = Current{
		Time:            raw(location["localtime_epoch"]),
		TemperatureC:    num(current["temp_c"]),
		FeelsLikeC:      num(current["feelslike_c"]),
		Humidity:        num(current["humidity"]),
		WindKmh:         num(current["wind_kph"]),
		PrecipitationMm: num(current["precip_mm"]),
		ConditionCode:   num(field(current, "condition")["code"]),
	}
	if t := num(current["last_updated_epoch"]); t != nil {
		f.Current.Time = raw(*t)
	}

	for _, d := range days {
		dayObj, ok := d.(object)
		if !ok {
			return Forecast{}, errors.New("forecastday entry is not an object")
		}
		hours, _ := dayObj["hour"].([]any)
		for _, h := range hours {
			hour, _ := h.(object)
			f.Hourly.Time = append(f.Hourly.Time, raw(hour["time_epoch"]))
			f.Hourly.TemperatureC = append(f.Hourly.TemperatureC, num(hour["temp_c"]))
			f.Hourly.WindKmh = append(f.Hourly.WindKmh, num(hour["wind_kph"]))
			f.Hourly.PrecipitationMm = append(f.Hourly.PrecipitationMm, num(hour["precip_mm"]))
			f.Hourly.PrecipitationProbability = append(f.Hourly.PrecipitationProbability,
				chance(hour["chance_of_rain"], hour["chance_of_snow"]))
			f.Hourly.ConditionCode = append(f.Hourly.ConditionCode, num(field(hour, "condition")["code"]))
		}

		day := field(dayObj, "day")
		if day == nil {
			return Forecast{}, errors.New("forecastday has no day")
		}
		var dayTime *float64
		if epoch, ok := dayObj["date_epoch"].(float64); ok {
			dayTime = num(epoch - offset)
		}
		f.Daily.Time = append(f.Daily.Time, dayTime)
		f.Daily.ConditionCode = append(f.Daily.ConditionCode, num(field(day, "condition")["code"]))
		f.Daily.TemperatureMaxC = append(f.Daily.TemperatureMaxC, num(day["maxtemp_c"]))
		f.Daily.TemperatureMinC = append(f.Daily.TemperatureMinC, num(day["mintemp_c"]))
		f.Daily.PrecipitationMm = append(f.Daily.PrecipitationMm, num(day["totalprecip_mm"]))
		f.Daily.PrecipitationProbabilityMax = append(f.Daily.PrecipitationProbabilityMax,
			chance(day["daily_chance_of_rain"], day["daily_chance_of_snow"]))
		f.Daily.WindMaxKmh = append(f.Daily.WindMaxKmh, num(day["maxwind_kph"]))
	}
	return f, nil
}
