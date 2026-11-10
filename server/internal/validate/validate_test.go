package validate

import (
	"testing"

	"github.com/pocketbase/pocketbase/tools/types"
)

const org = "0195f2a4-1111-7000-8000-000000000001"

func TestOrganizationsTrAksHiveCountCheck(t *testing.T) {
	ok := []string{"", "null", "0", "1", "100000", "120.0"}
	bad := []string{"-1", "100001", "1.5", `"12"`, "[1]", "{}", "true", "nope"}
	for _, raw := range ok {
		if err := OrganizationsTrAksHiveCountCheck(types.JSONRaw(raw)); err != nil {
			t.Errorf("%q rejected: %v", raw, err)
		}
	}
	for _, raw := range bad {
		if err := OrganizationsTrAksHiveCountCheck(types.JSONRaw(raw)); err == nil {
			t.Errorf("%q accepted", raw)
		}
	}
	if err := OrganizationsTrAksHiveCountCheck(nil); err != nil {
		t.Errorf("nil rejected: %v", err)
	}
}

func TestOrganizationsLogoPathCheck(t *testing.T) {
	ok := []string{"", org + "/0195f2a4-4444-7000-8000-000000000004.jpg"}
	bad := []string{
		"0195f2a4-1111-7000-8000-000000000002/0195f2a4-4444-7000-8000-000000000004.jpg", // other organization
		org + "/0195f2a4-4444-7000-8000-000000000004.png",
		org + "/logo.jpg",
		org + "/0195f2a4-4444-7000-8000-000000000004.jpg/x",
		"x/" + org + "/0195f2a4-4444-7000-8000-000000000004.jpg",
	}
	for _, p := range ok {
		if err := OrganizationsLogoPathCheck(org, p); err != nil {
			t.Errorf("%q rejected: %v", p, err)
		}
	}
	for _, p := range bad {
		if err := OrganizationsLogoPathCheck(org, p); err == nil {
			t.Errorf("%q accepted", p)
		}
	}
}
