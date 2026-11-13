package sync

import "slices"

// SupportedSchemaVersions are the Drift schema versions (schemaVersion in
// lib/core/db/app_database.dart) whose pushes the server accepts; any other
// version gets 426 upgrade_required and nothing is written. The app is not
// released, so only the current version is listed (K-11); Supabase's
// sync_push accepted 1–26. versions_test.go checks that the Drift version is
// in the list.
var SupportedSchemaVersions = []int{26}

// SchemaVersionSupported reports whether a push of version v is accepted.
func SchemaVersionSupported(v int) bool {
	return slices.Contains(SupportedSchemaVersions, v)
}
