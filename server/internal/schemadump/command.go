package schemadump

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/cobra"
)

// NewCommand returns `schema dump`: it writes [Fresh] to --out
// (default schema/collections.json, run from server/).
func NewCommand() *cobra.Command {
	schema := &cobra.Command{
		Use:   "schema",
		Short: "Collection schema tools",
	}

	var out string
	dump := &cobra.Command{
		Use:          "dump",
		Short:        "Write the schema of the Go migrations to " + File,
		Args:         cobra.NoArgs,
		SilenceUsage: true,
		RunE: func(cmd *cobra.Command, _ []string) error {
			b, err := Fresh()
			if err != nil {
				return err
			}
			if err := os.MkdirAll(filepath.Dir(out), 0o755); err != nil {
				return err
			}
			if err := os.WriteFile(out, b, 0o644); err != nil {
				return err
			}
			fmt.Fprintf(cmd.OutOrStdout(), "Wrote %s\n", out)
			return nil
		},
	}
	dump.Flags().StringVar(&out, "out", File, "output file")

	schema.AddCommand(dump)
	return schema
}
