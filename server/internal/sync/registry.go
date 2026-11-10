// Package sync holds the sync machinery: the list of synced collections, the
// server_seq counter and (from P5) the push and pull routes (K-7).
package sync

// Kind tells push how a collection is written. The values are the `kind`
// strings of Supabase's private.sync_push_change.
type Kind string

const (
	// KindState rows are updated in place; last writer wins on updated_at.
	KindState Kind = "state"
	// KindEvent rows are only inserted (and soft-deleted once).
	KindEvent Kind = "event"
	// KindOrganization is organizations: created only by the create route
	// (P5.4); push updates it for owners and partners.
	KindOrganization Kind = "organization"
	// KindOwnMembership is memberships: written only by the team routes;
	// push answers the member's own row with "not applied".
	KindOwnMembership Kind = "own_membership"
	// KindReference rows are read-only for clients (ref_*).
	KindReference Kind = "reference"
)

// Table is one synced collection.
type Table struct {
	Name string
	Kind Kind
}

// Tables lists every synced collection, in pull order: the order of
// SyncService.pullTables in lib/core/sync/sync_service.dart. Only these
// collections get a server_seq (seq.go) and are served by push and pull.
// Each P2 step appends its collections.
var Tables = []Table{
	{Name: "organizations", Kind: KindOrganization},
	{Name: "memberships", Kind: KindOwnMembership},
	{Name: "apiaries", Kind: KindState},
	{Name: "queens", Kind: KindState},
	{Name: "hives", Kind: KindState},
	{Name: "hive_location_history", Kind: KindEvent},
	{Name: "hive_status_events", Kind: KindEvent},
	{Name: "inspections", Kind: KindEvent},
	{Name: "media", Kind: KindEvent},
	{Name: "mite_counts", Kind: KindEvent},
	{Name: "ref_drugs", Kind: KindReference},
	{Name: "drugs", Kind: KindState},
	{Name: "treatments", Kind: KindEvent},
	{Name: "feedings", Kind: KindEvent},
}

// Names returns the collection names of [Tables], in pull order.
func Names() []string {
	names := make([]string, len(Tables))
	for i, t := range Tables {
		names[i] = t.Name
	}
	return names
}

// Lookup returns the table named name.
func Lookup(name string) (Table, bool) {
	for _, t := range Tables {
		if t.Name == name {
			return t, true
		}
	}
	return Table{}, false
}
