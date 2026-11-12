package seed

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"os"
	"strings"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/pocketbase/pocketbase/core"
	"github.com/spf13/cobra"
	"golang.org/x/term"
)

// PasswordReader reads the demo password. The default reads it from the
// terminal without echo (asking twice), or one line from a non-terminal
// stdin; tests replace it.
type PasswordReader func(cmd *cobra.Command) (string, error)

// NewCommand returns `seed` with its subcommands, run in the server's
// container terminal (`/pb/arici seed …`):
//
//	seed demo-user --email demo@tutunsoft.com
//	seed demo [--dry-run] [--date YYYY-MM-DD] [--force-reset]
//	seed verify-ref --expect ref.json   (or --expect - for stdin)
//
// read nil is [TerminalPassword].
func NewCommand(app core.App, read PasswordReader) *cobra.Command {
	if read == nil {
		read = TerminalPassword
	}
	seed := &cobra.Command{
		Use:   "seed",
		Short: "Demo account and reference data tools (P8.1)",
	}

	var email string
	demoUser := &cobra.Command{
		Use:          "demo-user",
		Short:        "Open the demo account, or set its password (asked on the terminal)",
		Args:         cobra.NoArgs,
		SilenceUsage: true,
		RunE: func(cmd *cobra.Command, _ []string) error {
			password, err := read(cmd)
			if err != nil {
				return err
			}
			created, err := DemoUser(app, email, password)
			if err != nil {
				return err
			}
			if created {
				fmt.Fprintf(cmd.OutOrStdout(), "Opened %s (locale %s, verified).\n", auth.DemoEmail, demoUserLocale)
			} else {
				fmt.Fprintf(cmd.OutOrStdout(), "%s existed; its password was set.\n", auth.DemoEmail)
			}
			return nil
		},
	}
	demoUser.Flags().StringVar(&email, "email", auth.DemoEmail, "the demo account's e-mail")

	var opts DemoOptions
	demo := &cobra.Command{
		Use:          "demo",
		Short:        "Write the demo organization of the demo account (idempotent)",
		Args:         cobra.NoArgs,
		SilenceUsage: true,
		RunE: func(cmd *cobra.Command, _ []string) error {
			report, err := Demo(app, opts)
			if err != nil {
				return err
			}
			fmt.Fprint(cmd.OutOrStdout(), report.String())
			return nil
		},
	}
	demo.Flags().BoolVar(&opts.DryRun, "dry-run", false, "count the rows per table, write nothing")
	demo.Flags().StringVar(&opts.Date, "date", "", "reference day YYYY-MM-DD (default: now)")
	demo.Flags().BoolVar(&opts.ForceReset, "force-reset", false, "delete the demo organization (only it) and write it again")

	var expectPath string
	verify := &cobra.Command{
		Use:          "verify-ref",
		Short:        "Compare ref_drugs and ref_support_periods with an expected JSON",
		Args:         cobra.NoArgs,
		SilenceUsage: true,
		RunE: func(cmd *cobra.Command, _ []string) error {
			var data []byte
			var err error
			if expectPath == "-" {
				data, err = io.ReadAll(cmd.InOrStdin())
			} else {
				data, err = os.ReadFile(expectPath)
			}
			if err != nil {
				return err
			}
			report, err := VerifyRef(app, data)
			if err != nil {
				return err
			}
			fmt.Fprint(cmd.OutOrStdout(), report.String())
			if !report.OK() {
				return errors.New("reference data differs")
			}
			return nil
		},
	}
	verify.Flags().StringVar(&expectPath, "expect", "", "expected counts and samples (JSON file, - for stdin)")
	_ = verify.MarkFlagRequired("expect")

	seed.AddCommand(demoUser, demo, verify)
	return seed
}

// TerminalPassword reads the password without echo, twice, when stdin is a
// terminal; otherwise one line of stdin.
func TerminalPassword(cmd *cobra.Command) (string, error) {
	fd := int(os.Stdin.Fd())
	if !term.IsTerminal(fd) {
		line, err := bufio.NewReader(cmd.InOrStdin()).ReadString('\n')
		if err != nil && !(errors.Is(err, io.EOF) && line != "") {
			return "", fmt.Errorf("read the password from stdin: %w", err)
		}
		return strings.TrimRight(line, "\r\n"), nil
	}
	out := cmd.ErrOrStderr()
	fmt.Fprint(out, "Demo password (6 digits): ")
	first, err := term.ReadPassword(fd)
	fmt.Fprintln(out)
	if err != nil {
		return "", err
	}
	fmt.Fprint(out, "Again: ")
	second, err := term.ReadPassword(fd)
	fmt.Fprintln(out)
	if err != nil {
		return "", err
	}
	if string(first) != string(second) {
		return "", errors.New("the passwords differ")
	}
	return string(first), nil
}
