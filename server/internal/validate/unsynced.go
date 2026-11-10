package validate

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/pocketbase/tools/types"
)

// Checks of the collections Supabase never synced (1794300009): invites
// (20261027140000), feedback and analytics_events (20261027120000),
// deletion_requests (20261113120000).

// InvitesCheck is invites_check: used_at and used_by are set together.
func InvitesCheck(usedAt, usedBy string) error {
	if (usedAt == "") != (usedBy == "") {
		return errors.New("used_at and used_by must be set together")
	}
	return nil
}

// FeedbackScreenshotPath is the shape of feedback.screenshot_path:
// `<org_id>/<id>.jpg`. The migration uses it as the field pattern;
// [FeedbackCheck] ties it to the row.
var FeedbackScreenshotPath = "^" + uuidPart + "/" + uuidPart + `\.jpg$`

// FeedbackCheck is feedback_check: screenshot_path is null or exactly
// `<org_id>/<id>.jpg`.
func FeedbackCheck(id, orgID, screenshotPath string) error {
	if screenshotPath == "" {
		return nil
	}
	if want := orgID + "/" + id + ".jpg"; screenshotPath != want {
		return fmt.Errorf("screenshot_path must be %s, got %s", want, screenshotPath)
	}
	return nil
}

// FeedbackMessageCheck is feedback_message_check: 1–4000 characters after
// trimming spaces.
func FeedbackMessageCheck(message string) error {
	return btrimLength("message", message, false, 1, 4000)
}

// MaxFeedbackDeviceInfo is the size limit of feedback.device_info as jsonb
// text (feedback_device_info_check).
const MaxFeedbackDeviceInfo = 2048

// FeedbackDeviceInfoCheck is feedback_device_info_check: null, or an object
// of at most [MaxFeedbackDeviceInfo] bytes as jsonb text.
func FeedbackDeviceInfoCheck(raw types.JSONRaw) error {
	if isJSONNull(raw) {
		return nil
	}
	return column("device_info", jsonbObject(raw, MaxFeedbackDeviceInfo))
}

// MaxAnalyticsProps is the size limit of analytics_events.props as jsonb
// text (analytics_events_props_check).
const MaxAnalyticsProps = 1024

// AnalyticsEventsPropsCheck is analytics_events_props_check: an object of at
// most [MaxAnalyticsProps] bytes as jsonb text. The column is `not null
// default '{}'`; push and the analytics route send the client's value, so a
// null is rejected like Postgres' not-null would.
func AnalyticsEventsPropsCheck(raw types.JSONRaw) error {
	return column("props", jsonbObject(raw, MaxAnalyticsProps))
}

// DeletionRequestsCheck is deletion_requests_check: scheduled_for is after
// requested_at. Both are K-5 text, whose string order is time order.
func DeletionRequestsCheck(requestedAt, scheduledFor string) error {
	if !(scheduledFor > requestedAt) {
		return fmt.Errorf("scheduled_for (%s) must be after requested_at (%s)", scheduledFor, requestedAt)
	}
	return nil
}

// DeletionRequestsCheck1 is deletion_requests_check1: status iptal exactly
// when cancelled_at is set.
func DeletionRequestsCheck1(status, cancelledAt string) error {
	if (status == "iptal") != (cancelledAt != "") {
		return fmt.Errorf("cancelled_at must be set exactly for status iptal, status is %q", status)
	}
	return nil
}

// DeletionRequestsCheck2 is deletion_requests_check2: status tamamlandi
// exactly when completed_at is set.
func DeletionRequestsCheck2(status, completedAt string) error {
	if (status == "tamamlandi") != (completedAt != "") {
		return fmt.Errorf("completed_at must be set exactly for status tamamlandi, status is %q", status)
	}
	return nil
}

// DeletionRequestsDeleteOrgIdsCheck is the uuid[] type of
// deletion_requests.delete_org_ids: a JSON array of UUIDs. The column is
// `not null default '{}'`, so null is rejected; the caller sends [].
func DeletionRequestsDeleteOrgIdsCheck(raw types.JSONRaw) error {
	_, err := deleteOrgIDs(raw)
	return err
}

// DeletionRequestsCheck3 is deletion_requests_check3: delete_org_ids is
// non-empty exactly for kind hesap_ve_isletme.
func DeletionRequestsCheck3(kind string, deleteOrgIDsRaw types.JSONRaw) error {
	ids, err := deleteOrgIDs(deleteOrgIDsRaw)
	if err != nil {
		return err
	}
	if (kind == "hesap_ve_isletme") != (len(ids) > 0) {
		return fmt.Errorf("delete_org_ids must be non-empty exactly for kind hesap_ve_isletme, kind is %q", kind)
	}
	return nil
}

func deleteOrgIDs(raw types.JSONRaw) ([]string, error) {
	if isJSONNull(raw) {
		return nil, errors.New("delete_org_ids: must be an array, got null")
	}
	var ids []string
	if err := json.Unmarshal(raw, &ids); err != nil {
		return nil, fmt.Errorf("delete_org_ids: must be an array of UUIDs: %w", err)
	}
	for _, id := range ids {
		if !pattern.IsUUID(id) {
			return nil, fmt.Errorf("delete_org_ids: %q is not a UUID", id)
		}
	}
	return ids, nil
}

func isJSONNull(raw types.JSONRaw) bool {
	trimmed := bytes.TrimSpace(raw)
	return len(trimmed) == 0 || string(trimmed) == "null"
}

// jsonbObject checks `jsonb_typeof(v) = 'object' and octet_length(v::text)
// <= limit`.
func jsonbObject(raw types.JSONRaw, limit int) error {
	dec := json.NewDecoder(bytes.NewReader(raw))
	dec.UseNumber()
	var decoded any
	if err := dec.Decode(&decoded); err != nil {
		return fmt.Errorf("not JSON: %w", err)
	}
	if _, ok := decoded.(map[string]any); !ok {
		return fmt.Errorf("must be an object, got %T", decoded)
	}
	n, err := jsonbTextLength(decoded)
	if err != nil {
		return err
	}
	if n > limit {
		return fmt.Errorf("larger than %d bytes as jsonb text, got %d", limit, n)
	}
	return nil
}

// jsonbTextLength is octet_length(v::text) of a decoded JSON value: jsonb
// prints `{"a": 1, "b": [1, 2]}`, a space after each colon and comma, and
// keeps one of duplicate keys (decoding already did). Strings are measured
// with Go's escaping without HTML escapes; numbers as sent. Postgres
// normalizes some number spellings (1E2 → 100) and escapes a few control
// characters differently, a few bytes either way; the client sends plain
// integers, decimals and ASCII names.
func jsonbTextLength(v any) (int, error) {
	switch v := v.(type) {
	case map[string]any:
		n := 2 // {}
		i := 0
		for k, item := range v {
			kn, err := jsonStringLength(k)
			if err != nil {
				return 0, err
			}
			in, err := jsonbTextLength(item)
			if err != nil {
				return 0, err
			}
			n += kn + len(": ") + in
			if i > 0 {
				n += len(", ")
			}
			i++
		}
		return n, nil
	case []any:
		n := 2 // []
		for i, item := range v {
			in, err := jsonbTextLength(item)
			if err != nil {
				return 0, err
			}
			n += in
			if i > 0 {
				n += len(", ")
			}
		}
		return n, nil
	case string:
		return jsonStringLength(v)
	case json.Number:
		return len(v), nil
	case bool:
		if v {
			return len("true"), nil
		}
		return len("false"), nil
	case nil:
		return len("null"), nil
	}
	return 0, fmt.Errorf("unexpected JSON value %T", v)
}

func jsonStringLength(s string) (int, error) {
	var buf bytes.Buffer
	enc := json.NewEncoder(&buf)
	enc.SetEscapeHTML(false)
	if err := enc.Encode(s); err != nil {
		return 0, err
	}
	return buf.Len() - 1, nil // Encode adds a newline.
}
