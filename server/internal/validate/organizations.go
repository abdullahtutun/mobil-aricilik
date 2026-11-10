package validate

import (
	"fmt"
	"regexp"

	"github.com/pocketbase/pocketbase/tools/types"
)

// MaxAksHiveCount is the upper bound of organizations.tr_aks_hive_count
// (20261105120000; maxAksHiveCount in the client).
const MaxAksHiveCount = 100000

// OrganizationsTrAksHiveCountCheck is organizations_tr_aks_hive_count_check
// (20261105120000): null, or an integer between 0 and [MaxAksHiveCount].
func OrganizationsTrAksHiveCountCheck(raw types.JSONRaw) error {
	if err := NullableInt(raw, 0, MaxAksHiveCount); err != nil {
		return fmt.Errorf("tr_aks_hive_count: %w", err)
	}
	return nil
}

// OrganizationsLogoPathCheck is organizations_logo_path_check
// (20261112120000): empty, or `<id>/<36 chars of [0-9a-f-]>.jpg` where the
// folder is the organization's own id.
func OrganizationsLogoPathCheck(id, logoPath string) error {
	if logoPath == "" {
		return nil
	}
	re := regexp.MustCompile("^" + regexp.QuoteMeta(id) + `/[0-9a-f-]{36}\.jpg$`)
	if !re.MatchString(logoPath) {
		return fmt.Errorf("logo_path must be %s/<uuid>.jpg", id)
	}
	return nil
}
