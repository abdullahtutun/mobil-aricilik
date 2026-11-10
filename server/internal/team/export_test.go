package team

import (
	"encoding/json"
	"time"

	"github.com/pocketbase/pocketbase/core"
)

// SetNow replaces the clock until the returned function restores it.
func SetNow(f func() time.Time) (restore func()) {
	old := now
	now = f
	return func() { now = old }
}

// SetGenerateCode replaces the code source until restore.
func SetGenerateCode(f func() string) (restore func()) {
	old := generateCode
	generateCode = f
	return func() { generateCode = old }
}

// Redeem is the redeem action without the route's rate limit.
func Redeem(app core.App, userID, code string) (any, error) {
	raw, _ := json.Marshal(code)
	return redeem(app, userID, map[string]json.RawMessage{"code": raw})
}

// FailureCode is the data.code of a refusal, "" for other errors.
func FailureCode(err error) string {
	if f, ok := err.(*failure); ok {
		return f.code
	}
	return ""
}

// Limiter exposes the sliding window for tests.
type Limiter = limiter

// NewLimiter is newLimiter.
func NewLimiter(limit int, window time.Duration) *Limiter { return newLimiter(limit, window) }

// Allow is allow.
func (l *limiter) Allow(key string, t time.Time) bool { return l.allow(key, t) }

// Keys is the number of keys held.
func (l *limiter) Keys() int { return len(l.hits) }
