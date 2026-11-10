package team

import (
	"sync"
	"time"
)

// Redeem attempts a user may make per window. PocketBase's own limiter
// (internal/bootstrap/ratelimits.go) counts per IP, which many phones share
// behind a carrier NAT; this one counts per account.
const (
	RedeemLimit  = 10
	RedeemWindow = time.Minute
)

// limiter is a sliding window per key, in memory: a restart forgets it,
// which costs an attacker at most one more window.
type limiter struct {
	mu     sync.Mutex
	limit  int
	window time.Duration
	hits   map[string][]time.Time
}

func newLimiter(limit int, window time.Duration) *limiter {
	return &limiter{limit: limit, window: window, hits: map[string][]time.Time{}}
}

// sweepAbove: when this many keys are held, idle ones are dropped.
const sweepAbove = 1024

// allow records an attempt of key at t and reports whether it is within the
// limit. A refused attempt is not recorded.
func (l *limiter) allow(key string, t time.Time) bool {
	l.mu.Lock()
	defer l.mu.Unlock()
	if len(l.hits) > sweepAbove {
		for k, times := range l.hits {
			if len(recent(times, t, l.window)) == 0 {
				delete(l.hits, k)
			}
		}
	}
	times := recent(l.hits[key], t, l.window)
	if len(times) >= l.limit {
		l.hits[key] = times
		return false
	}
	l.hits[key] = append(times, t)
	return true
}

// recent drops the times at or before t - window; times are in order.
func recent(times []time.Time, t time.Time, window time.Duration) []time.Time {
	cut := t.Add(-window)
	i := 0
	for i < len(times) && !times[i].After(cut) {
		i++
	}
	return times[i:]
}
