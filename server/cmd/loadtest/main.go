// Command loadtest is the P9.3 load and RAM test against the DEV server.
//
//	export PB_SUPERUSER_EMAIL=...      # the dev server's superuser
//	export PB_SUPERUSER_PASSWORD=...
//	cd server && go run ./cmd/loadtest -url https://arici-api-dev.tutunsoft.com
//
// Defaults are the P9.3 scenario: 50 accounts x 2000 records, 10 at a
// time, packets of 100, a 1 MiB photo after every 5th packet, then a full
// pull. The tool refuses the production host and any server whose
// /api/app/info does not say env "dev". It opens loadtest-<run>-<n>@example.com
// accounts, turns the rate limiter off for the run and back on, and at the
// end removes its accounts and organizations (also after Ctrl-C).
//
//	go run ./cmd/loadtest -url ... -cleanup <run>   # finish a failed cleanup
//	go run ./cmd/loadtest -url ... -cleanup all     # every load test account
//
// Exit codes: 0 run without errors, 1 errors in the run or cleanup, 2 the
// run could not start (usage, refused server, login).
package main

import (
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/loadtest"
)

func main() {
	os.Exit(run())
}

func run() int {
	cfg := loadtest.Config{Log: os.Stderr}
	flag.StringVar(&cfg.URL, "url", "", "dev server address, e.g. https://arici-api-dev.tutunsoft.com (required)")
	flag.IntVar(&cfg.Accounts, "users", 50, "virtual users, each with its own organization")
	flag.IntVar(&cfg.Records, "records", 2000, "records each user pushes")
	flag.IntVar(&cfg.Concurrency, "concurrency", 10, "users at a time")
	flag.IntVar(&cfg.PacketSize, "packet", 100, "changes per push (1..100)")
	flag.IntVar(&cfg.PageSize, "page", 500, "rows per pull page (1..1000)")
	flag.IntVar(&cfg.FileEvery, "file-every", 5, "upload a file after every n-th packet")
	flag.IntVar(&cfg.FileBytes, "file-bytes", 1<<20, "size of each uploaded file")
	timeout := flag.Duration("timeout", 60*time.Second, "timeout of each request")
	jsonOut := flag.String("json", "", "also write the report as JSON to this file")
	cleanup := flag.String("cleanup", "", "only remove the accounts of this run id (or \"all\") and exit")
	flag.Parse()
	cfg.RequestTimeout = *timeout
	cfg.SuperuserEmail = os.Getenv("PB_SUPERUSER_EMAIL")
	cfg.SuperuserPassword = os.Getenv("PB_SUPERUSER_PASSWORD")

	if cfg.URL == "" || flag.NArg() > 0 {
		flag.Usage()
		return 2
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	if *cleanup != "" {
		run := *cleanup
		if run == "all" {
			run = ""
		}
		res, err := loadtest.Cleanup(ctx, cfg, run)
		if err != nil {
			fmt.Fprintln(os.Stderr, "loadtest:", err)
			return 2
		}
		fmt.Printf("Cleanup: %d organizations, %d accounts removed\n", res.Organizations, res.Users)
		return 0
	}

	rep, err := loadtest.Run(ctx, cfg)
	if rep == nil {
		fmt.Fprintln(os.Stderr, "loadtest:", err)
		return 2
	}
	rep.Write(os.Stdout)
	if *jsonOut != "" {
		data, jerr := json.MarshalIndent(rep, "", "  ")
		if jerr == nil {
			jerr = os.WriteFile(*jsonOut, append(data, '\n'), 0o644)
		}
		if jerr != nil {
			fmt.Fprintln(os.Stderr, "loadtest: writing the JSON report:", jerr)
		}
	}
	switch {
	case errors.Is(err, context.Canceled):
		fmt.Fprintln(os.Stderr, "loadtest: interrupted; the numbers are partial")
		return 1
	case err != nil:
		fmt.Fprintln(os.Stderr, "loadtest:", err)
		return 1
	case rep.Failed > 0 || rep.RowsRejected > 0 || rep.CleanupError != "":
		return 1
	}
	return 0
}
