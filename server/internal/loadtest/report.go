package loadtest

import (
	"errors"
	"fmt"
	"io"
	"math"
	"slices"
	"sort"
	"strings"
	"sync"
	"time"
)

// Operations measured, in report order.
const (
	OpCreateOrg = "create_org"
	OpPush      = "push"      // one packet
	OpPullPage  = "pull_page" // one page of one table
	OpFullPull  = "full_pull" // every table from 0, one account
	OpUpload    = "upload"    // one file
)

var opOrder = []string{OpCreateOrg, OpPush, OpPullPage, OpFullPull, OpUpload}

// Stat is one operation's numbers.
type Stat struct {
	Count  int     `json:"count"`
	Errors int     `json:"errors"`
	P50Ms  float64 `json:"p50_ms"`
	P95Ms  float64 `json:"p95_ms"`
	MaxMs  float64 `json:"max_ms"`
}

// Report is what a run measured.
type Report struct {
	Run           string          `json:"run"`
	Server        string          `json:"server"`
	Version       string          `json:"version"`
	Accounts      int             `json:"accounts"`
	Records       int             `json:"records_per_account"`
	Concurrency   int             `json:"concurrency"`
	PacketSize    int             `json:"packet_size"`
	FileBytes     int             `json:"file_bytes"`
	Started       time.Time       `json:"started"`
	Duration      time.Duration   `json:"-"`
	DurationSec   float64         `json:"duration_s"`
	Requests      int             `json:"requests"`
	Failed        int             `json:"failed_requests"`
	ErrorRate     float64         `json:"error_rate"`
	RowsPushed    int             `json:"rows_pushed"`
	RowsRejected  int             `json:"rows_rejected"`
	RowsPulled    int             `json:"rows_pulled"`
	Files         int             `json:"files_uploaded"`
	Busy          int             `json:"busy_503"`
	Ops           map[string]Stat `json:"operations"`
	ErrorSamples  []string        `json:"error_samples"`
	Cleanup       *CleanupResult  `json:"cleanup"`
	CleanupError  string          `json:"cleanup_error,omitempty"`
	RateLimitsOff bool            `json:"rate_limits_turned_off"`
}

// maxErrorSamples is how many distinct error messages a report keeps.
const maxErrorSamples = 10

// recorder collects timings from many goroutines.
type recorder struct {
	mu        sync.Mutex
	durations map[string][]time.Duration
	errors    map[string]int
	samples   map[string]int
	busy      int
	pushed    int
	rejected  int
	pulled    int
	files     int
}

func newRecorder() *recorder {
	return &recorder{
		durations: map[string][]time.Duration{},
		errors:    map[string]int{},
		samples:   map[string]int{},
	}
}

// add records one operation; err nil is a success.
func (r *recorder) add(op string, d time.Duration, err error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.durations[op] = append(r.durations[op], d)
	if err == nil {
		return
	}
	r.errors[op]++
	var he *httpError
	if asHTTP(err, &he) && he.Status == 503 {
		r.busy++
	}
	r.sampleLocked(op + ": " + err.Error())
}

// note keeps an error message that is not a failed request (rejected rows).
func (r *recorder) note(msg string) {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.sampleLocked(msg)
}

func (r *recorder) sampleLocked(msg string) {
	if _, seen := r.samples[msg]; seen || len(r.samples) < maxErrorSamples {
		r.samples[msg]++
	}
}

func (r *recorder) count(pushed, rejected, pulled, files int) {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.pushed += pushed
	r.rejected += rejected
	r.pulled += pulled
	r.files += files
}

// fill writes the numbers into rep. full_pull is not a request of its own:
// it counts in the operations but not in requests.
func (r *recorder) fill(rep *Report) {
	r.mu.Lock()
	defer r.mu.Unlock()
	rep.Ops = map[string]Stat{}
	for op, ds := range r.durations {
		rep.Ops[op] = stat(ds, r.errors[op])
		if op != OpFullPull {
			rep.Requests += len(ds)
			rep.Failed += r.errors[op]
		}
	}
	if rep.Requests > 0 {
		rep.ErrorRate = float64(rep.Failed) / float64(rep.Requests)
	}
	rep.RowsPushed, rep.RowsRejected, rep.RowsPulled, rep.Files, rep.Busy = r.pushed, r.rejected, r.pulled, r.files, r.busy
	for msg, n := range r.samples {
		rep.ErrorSamples = append(rep.ErrorSamples, fmt.Sprintf("%dx %s", n, msg))
	}
	sort.Strings(rep.ErrorSamples)
}

func stat(ds []time.Duration, errs int) Stat {
	s := slices.Clone(ds)
	slices.Sort(s)
	return Stat{
		Count:  len(s),
		Errors: errs,
		P50Ms:  ms(percentile(s, 50)),
		P95Ms:  ms(percentile(s, 95)),
		MaxMs:  ms(percentile(s, 100)),
	}
}

// percentile is the nearest-rank percentile of sorted durations.
func percentile(sorted []time.Duration, p float64) time.Duration {
	if len(sorted) == 0 {
		return 0
	}
	rank := int(math.Ceil(p / 100 * float64(len(sorted))))
	return sorted[max(rank, 1)-1]
}

func ms(d time.Duration) float64 {
	return math.Round(float64(d)/float64(time.Millisecond)*10) / 10
}

// Write prints the report for a terminal.
func (rep *Report) Write(w io.Writer) {
	fmt.Fprintf(w, "\nLoad test %s against %s (version %s)\n", rep.Run, rep.Server, rep.Version)
	fmt.Fprintf(w, "Scenario: %d accounts x %d records, %d at a time, packets of %d, files of %d bytes\n",
		rep.Accounts, rep.Records, rep.Concurrency, rep.PacketSize, rep.FileBytes)
	fmt.Fprintf(w, "Duration: %.1f s  Requests: %d  Failed: %d  Error rate: %.2f%%  503 busy: %d\n",
		rep.DurationSec, rep.Requests, rep.Failed, rep.ErrorRate*100, rep.Busy)
	fmt.Fprintf(w, "Rows pushed: %d  rejected: %d  pulled: %d  Files: %d\n",
		rep.RowsPushed, rep.RowsRejected, rep.RowsPulled, rep.Files)
	if rep.RateLimitsOff {
		fmt.Fprintln(w, "Rate limiter: off during the run, turned back on")
	}
	fmt.Fprintf(w, "\n%-10s %7s %7s %10s %10s %10s\n", "operation", "count", "errors", "p50 ms", "p95 ms", "max ms")
	for _, op := range opOrder {
		s, ok := rep.Ops[op]
		if !ok {
			continue
		}
		fmt.Fprintf(w, "%-10s %7d %7d %10.1f %10.1f %10.1f\n", op, s.Count, s.Errors, s.P50Ms, s.P95Ms, s.MaxMs)
	}
	if len(rep.ErrorSamples) > 0 {
		fmt.Fprintln(w, "\nErrors:")
		for _, e := range rep.ErrorSamples {
			fmt.Fprintln(w, "  "+e)
		}
	}
	switch {
	case rep.CleanupError != "":
		fmt.Fprintf(w, "\nCleanup FAILED: %s\nRun again: loadtest -cleanup %s\n", rep.CleanupError, rep.Run)
	case rep.Cleanup != nil:
		fmt.Fprintf(w, "\nCleanup: %d organizations, %d accounts removed\n", rep.Cleanup.Organizations, rep.Cleanup.Users)
	}
	fmt.Fprintln(w, strings.Repeat("-", 60))
}

func asHTTP(err error, target **httpError) bool { return errors.As(err, target) }
