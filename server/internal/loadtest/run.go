package loadtest

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
)

// ProdHost is the production server (K-8); the tool never talks to it.
const ProdHost = "arici-api.tutunsoft.com"

// Config is one run. Zero numbers take the P9.3 scenario's defaults.
type Config struct {
	URL               string
	SuperuserEmail    string
	SuperuserPassword string

	Accounts    int // 50
	Records     int // 2000 per account
	Concurrency int // 10 accounts at a time
	PacketSize  int // 100, the app's batchSize
	PageSize    int // 500, the app's pullPageSize
	FileEvery   int // a file after every 5th packet
	FileBytes   int // 1 MiB

	// RequestTimeout bounds each request (60 s).
	RequestTimeout time.Duration
	// HTTP is the client (tests); nil makes one.
	HTTP *http.Client
	// Log gets progress lines; nil discards them.
	Log io.Writer
}

func (c *Config) defaults() {
	set := func(v *int, d int) {
		if *v <= 0 {
			*v = d
		}
	}
	set(&c.Accounts, 50)
	set(&c.Records, 2000)
	set(&c.Concurrency, 10)
	set(&c.PacketSize, appsync.MaxPushChanges)
	set(&c.PageSize, 500)
	set(&c.FileEvery, 5)
	set(&c.FileBytes, 1<<20)
	if c.RequestTimeout <= 0 {
		c.RequestTimeout = 60 * time.Second
	}
	if c.HTTP == nil {
		c.HTTP = &http.Client{Transport: &http.Transport{
			MaxIdleConnsPerHost: c.Concurrency * 2,
			IdleConnTimeout:     90 * time.Second,
		}}
	}
	if c.Log == nil {
		c.Log = io.Discard
	}
}

// Refusals before anything is written.
var (
	ErrProd       = errors.New("loadtest: refusing the production server")
	ErrServerEnv  = errors.New("loadtest: the server is not APP_ENV=dev")
	ErrBadURL     = errors.New("loadtest: the url must be http(s)://host[:port] with no path")
	ErrNoSecrets  = errors.New("loadtest: PB_SUPERUSER_EMAIL and PB_SUPERUSER_PASSWORD must be set in this shell")
	ErrNoCleanup  = errors.New("loadtest: the server has no cleanup route; deploy this version to dev first")
	ErrBadNumbers = errors.New("loadtest: packet size must be 1..100 and page size 1..1000")
)

// baseURL checks the address: no production host, no path.
func baseURL(raw string) (string, error) {
	u, err := url.Parse(strings.TrimRight(strings.TrimSpace(raw), "/"))
	if err != nil || (u.Scheme != "http" && u.Scheme != "https") || u.Host == "" ||
		u.Path != "" || u.RawQuery != "" || u.User != nil {
		return "", ErrBadURL
	}
	if strings.EqualFold(u.Hostname(), ProdHost) {
		return "", ErrProd
	}
	return u.Scheme + "://" + u.Host, nil
}

// session is a checked server with a superuser token.
type session struct {
	cfg     Config
	anon    *client
	su      *client
	version string
}

// open refuses production and anything but APP_ENV=dev, then signs the
// superuser in. Nothing is written.
func open(ctx context.Context, cfg Config) (*session, error) {
	base, err := baseURL(cfg.URL)
	if err != nil {
		return nil, err
	}
	if cfg.SuperuserEmail == "" || cfg.SuperuserPassword == "" {
		return nil, ErrNoSecrets
	}
	anon := &client{base: base, http: cfg.HTTP}
	env, version, err := anon.info(ctx)
	if err != nil {
		return nil, fmt.Errorf("GET /api/app/info: %w", err)
	}
	if env != config.EnvDev {
		return nil, fmt.Errorf("%w (it says env=%q)", ErrServerEnv, env)
	}
	token, err := anon.superuserLogin(ctx, cfg.SuperuserEmail, cfg.SuperuserPassword)
	if err != nil {
		return nil, err
	}
	return &session{cfg: cfg, anon: anon, su: anon.as(token), version: version}, nil
}

// cleanup runs [CleanupRoute]; a 404 means the route is not deployed.
func (s *session) cleanup(ctx context.Context, run string) (CleanupResult, error) {
	res, err := s.su.cleanup(ctx, run)
	var he *httpError
	if asHTTP(err, &he) && he.Status == http.StatusNotFound {
		return res, ErrNoCleanup
	}
	return res, err
}

// Cleanup removes the accounts and organizations of run (every load test
// run when run is empty) on its own: for a run whose cleanup failed.
func Cleanup(ctx context.Context, cfg Config, run string) (CleanupResult, error) {
	cfg.defaults()
	if run != "" && !runPattern.MatchString(run) {
		return CleanupResult{}, fmt.Errorf("loadtest: bad run id %q", run)
	}
	s, err := open(ctx, cfg)
	if err != nil {
		return CleanupResult{}, err
	}
	return s.cleanup(ctx, run)
}

// account is one virtual user.
type account struct {
	email string
	id    string
	org   string
	api   *client
}

// NewRunID is <UTC time>-<6 hex>, like test_users.sh's.
func NewRunID(now time.Time) string {
	b := make([]byte, 3)
	_, _ = rand.Read(b)
	return now.UTC().Format("20060102150405") + "-" + hex.EncodeToString(b)
}

// Run is the load test: it checks the server, opens cfg.Accounts accounts,
// lets cfg.Concurrency of them at a time found an organization, push
// cfg.Records rows in packets (a file after every cfg.FileEvery-th
// packet) and pull every table from the start, and then removes the
// accounts and their organizations whatever happened. The rate limiter is
// off during the run (every account comes from one IP) and back on after.
// An error means the run could not start or was cut short; the report then
// holds what was measured.
func Run(ctx context.Context, cfg Config) (*Report, error) {
	cfg.defaults()
	if cfg.PacketSize > appsync.MaxPushChanges || cfg.PageSize > appsync.MaxPageSize {
		return nil, ErrBadNumbers
	}
	s, err := open(ctx, cfg)
	if err != nil {
		return nil, err
	}
	run := NewRunID(time.Now())
	rep := &Report{
		Run: run, Server: s.anon.base, Version: s.version,
		Accounts: cfg.Accounts, Records: cfg.Records, Concurrency: cfg.Concurrency,
		PacketSize: cfg.PacketSize, FileBytes: cfg.FileBytes, Started: time.Now().UTC(),
	}
	// The route answers before anything is written: an empty cleanup of a
	// new run proves it is there and the superuser may call it.
	if _, err := s.cleanup(ctx, run); err != nil {
		return nil, err
	}
	fmt.Fprintf(cfg.Log, "run %s against %s (version %s)\n", run, s.anon.base, s.version)

	// From here on, whatever happens: limiter back on, accounts removed.
	// Both use their own context so that Ctrl-C still cleans up.
	limiterWasOn, err := s.su.rateLimitsEnabled(ctx)
	if err != nil {
		return nil, fmt.Errorf("reading the rate limiter: %w", err)
	}
	defer func() {
		cctx, cancel := context.WithTimeout(context.Background(), 10*time.Minute)
		defer cancel()
		if limiterWasOn {
			if err := s.su.setRateLimits(cctx, true); err != nil {
				rep.CleanupError = "turning the rate limiter back on: " + err.Error()
				fmt.Fprintln(cfg.Log, "WARNING: the rate limiter is still off; a restart turns it back on")
			}
		}
		fmt.Fprintln(cfg.Log, "cleaning up")
		res, err := s.cleanup(cctx, run)
		if err != nil {
			rep.CleanupError = strings.TrimPrefix(rep.CleanupError+"; ", "; ") + err.Error()
			return
		}
		rep.Cleanup = &res
	}()
	if limiterWasOn {
		if err := s.su.setRateLimits(ctx, false); err != nil {
			return rep, fmt.Errorf("turning the rate limiter off: %w", err)
		}
		rep.RateLimitsOff = true
	}

	accounts, err := s.openAccounts(ctx, run)
	if err != nil {
		return rep, err
	}
	file, err := fakeJPEG(cfg.FileBytes)
	if err != nil {
		return rep, err
	}

	fmt.Fprintf(cfg.Log, "%d accounts ready; load starts\n", len(accounts))
	rec := newRecorder()
	start := time.Now()
	jobs := make(chan *account)
	var wg sync.WaitGroup
	var done int
	var doneMu sync.Mutex
	for range cfg.Concurrency {
		wg.Go(func() {
			for a := range jobs {
				s.simulate(ctx, a, rec, file)
				doneMu.Lock()
				done++
				fmt.Fprintf(cfg.Log, "account %d/%d done\n", done, len(accounts))
				doneMu.Unlock()
			}
		})
	}
feed:
	for _, a := range accounts {
		select {
		case jobs <- a:
		case <-ctx.Done():
			break feed
		}
	}
	close(jobs)
	wg.Wait()
	rep.Duration = time.Since(start)
	rep.DurationSec = rep.Duration.Seconds()
	rec.fill(rep)
	return rep, ctx.Err()
}

// openAccounts creates the run's accounts with impersonate tokens,
// cfg.Concurrency at a time. Not measured.
func (s *session) openAccounts(ctx context.Context, run string) ([]*account, error) {
	out := make([]*account, s.cfg.Accounts)
	errs := make([]error, s.cfg.Accounts)
	sem := make(chan struct{}, s.cfg.Concurrency)
	var wg sync.WaitGroup
	for i := range out {
		wg.Go(func() {
			sem <- struct{}{}
			defer func() { <-sem }()
			email := Email(run, i+1)
			pw := make([]byte, 24)
			_, _ = rand.Read(pw)
			id, err := s.su.createAccount(ctx, email, hex.EncodeToString(pw))
			if err != nil {
				errs[i] = fmt.Errorf("opening %s: %w", email, err)
				return
			}
			token, err := s.su.impersonate(ctx, id, 4*time.Hour)
			if err != nil {
				errs[i] = fmt.Errorf("impersonating %s: %w", email, err)
				return
			}
			out[i] = &account{email: email, id: id, org: ids.New(), api: s.anon.as(token)}
		})
	}
	wg.Wait()
	return out, errors.Join(errs...)
}

// simulate is one account's session: found the organization, push every
// packet in order with a file now and then, then pull every table.
func (s *session) simulate(ctx context.Context, a *account, rec *recorder, file []byte) {
	cfg := s.cfg
	timed := func(op string, f func(ctx context.Context) error) error {
		rctx, cancel := context.WithTimeout(ctx, cfg.RequestTimeout)
		defer cancel()
		t := time.Now()
		err := f(rctx)
		if ctx.Err() == nil {
			rec.add(op, time.Since(t), err)
		}
		return err
	}

	err := timed(OpCreateOrg, func(ctx context.Context) error {
		return a.api.createOrganization(ctx, a.org, "Yük testi "+a.email)
	})
	if err != nil {
		return // nothing else can succeed without the organization
	}

	for i, packet := range packets(workload(a.org, a.id, cfg.Records, time.Now()), cfg.PacketSize) {
		if ctx.Err() != nil {
			return
		}
		var results []pushResult
		err := timed(OpPush, func(ctx context.Context) error {
			var err error
			results, err = a.api.push(ctx, packet, time.Now())
			return err
		})
		if err == nil {
			rejected := 0
			for _, r := range results {
				if r.Status != "ok" {
					rejected++
				}
			}
			rec.count(len(results)-rejected, rejected, 0, 0)
			if rejected > 0 {
				first := results[0]
				for _, r := range results {
					if r.Status != "ok" {
						first = r
						break
					}
				}
				rec.note(fmt.Sprintf("push: rows rejected: %s %s", first.Reason, first.Message))
			}
		}
		if (i+1)%cfg.FileEvery == 0 {
			// media path: <org>/<hive>/<media id>.jpg; the server checks
			// only the shape, org and id.
			id := ids.New()
			path := a.org + "/" + packet[0].ID + "/" + id + ".jpg"
			err := timed(OpUpload, func(ctx context.Context) error {
				return a.api.upload(ctx, id, a.org, path, file)
			})
			if err == nil {
				rec.count(0, 0, 0, 1)
			}
		}
	}

	full := time.Now()
	var fullErr error
	for _, table := range appsync.Names() {
		var since int64
		for {
			if ctx.Err() != nil {
				return
			}
			var n int
			var more bool
			err := timed(OpPullPage, func(ctx context.Context) error {
				var err error
				n, since, more, err = a.api.pullPage(ctx, table, since, cfg.PageSize)
				return err
			})
			if err != nil {
				fullErr = err
				break
			}
			rec.count(0, 0, n, 0)
			if !more {
				break
			}
		}
	}
	rec.add(OpFullPull, time.Since(full), fullErr)
}
