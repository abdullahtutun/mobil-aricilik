package deletion

import (
	"crypto/rand"
	"crypto/sha256"
	"database/sql"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"math/big"
	"net/http"
	"regexp"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// CodesCollection holds one deletion code per user, as a digest
// (private.deletion_codes, 20261115120000).
const CodesCollection = "deletion_codes"

// The deletion code's rules (20261115120000_deletion_code_and_leaving_member).
const (
	// CodeTTL is how long a sent code is valid.
	CodeTTL = 10 * time.Minute
	// CodeMaxAttempts wrong codes lock the code; a new one must be asked.
	CodeMaxAttempts = 5
	// CodeResendInterval is the shortest time between two codes.
	CodeResendInterval = 60 * time.Second
	// CodeHourlyLimit codes may be sent per CodeWindow.
	CodeHourlyLimit = 5
	CodeWindow      = time.Hour
	// CodeVerifiedFor is how long a verified code lets a request through.
	CodeVerifiedFor = 15 * time.Minute
)

// Results of verifying a code (account_deletion_verify_code).
const (
	VerifyOK       = "ok"
	VerifyInvalid  = "invalid"
	VerifyExpired  = "expired"
	VerifyTooMany  = "too_many"
	codeDigits     = 6
	codeUpperBound = 1_000_000
)

var codeFormat = regexp.MustCompile(`^[0-9]{6}$`)

// Hash is private.deletion_hash: the hex SHA-256 of value.
func Hash(value string) string {
	sum := sha256.Sum256([]byte(value))
	return hex.EncodeToString(sum[:])
}

// codeHash is private.deletion_code_hash: tied to the user, the plain code
// is never stored.
func codeHash(userID, code string) string { return Hash(userID + ":" + code) }

// newCode is a uniformly random 6-digit code (Supabase took 32 random bits
// mod 10⁶).
func newCode() string {
	n, err := rand.Int(rand.Reader, big.NewInt(codeUpperBound))
	if err != nil {
		panic(err) // crypto/rand never fails on supported platforms
	}
	return fmt.Sprintf("%0*d", codeDigits, n.Int64())
}

// findCode returns the user's code row, nil if there is none.
func findCode(app core.App, userID string) (*core.Record, error) {
	r := &core.Record{}
	err := app.RecordQuery(CodesCollection).
		AndWhere(dbx.HashExp{"user_id": userID}).
		Limit(1).
		One(r)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return r, nil
}

// SendCodeResponse is the answer of send_code.
type SendCodeResponse struct {
	Sent bool `json:"sent"`
}

// sendCode is handler.ts send_code: a new code (account_deletion_send_code)
// e-mailed to the account; a code is not stored if it cannot be written,
// and is kept (counting toward the limits) if the e-mail fails, as in
// Supabase.
func sendCode(e *core.RequestEvent) (any, error) {
	user := e.Auth
	if user.Email() == "" {
		return nil, fail(http.StatusBadRequest, "no_email", "The account has no e-mail address.")
	}
	code, err := IssueCode(e.App, user.Id)
	if err != nil {
		return nil, err
	}
	if err := sendMail(e.App, user.Email(), CodeMail(code, MailLocale(user.GetString("locale")))); err != nil {
		e.App.Logger().Error("account deletion code e-mail not sent", "error", err, "userId", user.Id)
		return nil, errMailFailed
	}
	return SendCodeResponse{Sent: true}, nil
}

// IssueCode is account_deletion_send_code: it stores a new code's digest
// for the user, valid for [CodeTTL], and returns the plain code. The
// previous code stops working. More often than [CodeResendInterval], or more
// than [CodeHourlyLimit] in a [CodeWindow], is refused with rate_limited.
func IssueCode(app core.App, userID string) (string, error) {
	var code string
	err := app.RunInTransaction(func(txApp core.App) error {
		t := now()
		row, err := findCode(txApp, userID)
		if err != nil {
			return err
		}
		inWindow := false
		if row != nil {
			sent := parseTime(row.GetString("sent_at"))
			windowStart := parseTime(row.GetString("window_started_at"))
			inWindow = windowStart.After(t.Add(-CodeWindow))
			if sent.After(t.Add(-CodeResendInterval)) ||
				(inWindow && row.GetInt("sent_in_window") >= CodeHourlyLimit) {
				return errRateLimited
			}
		} else {
			codes, err := txApp.FindCachedCollectionByNameOrId(CodesCollection)
			if err != nil {
				return err
			}
			row = core.NewRecord(codes)
			row.Set("user_id", userID)
		}

		code = newCode()
		row.Set("code_hash", codeHash(userID, code))
		row.Set("expires_at", pattern.FormatTimestamp(t.Add(CodeTTL)))
		row.Set("attempts", 0)
		row.Set("verified_at", "")
		row.Set("sent_at", pattern.FormatTimestamp(t))
		if inWindow {
			row.Set("sent_in_window", row.GetInt("sent_in_window")+1)
		} else {
			row.Set("window_started_at", pattern.FormatTimestamp(t))
			row.Set("sent_in_window", 1)
		}
		return txApp.Save(row)
	})
	if err != nil {
		return "", err
	}
	return code, nil
}

// VerifyResponse is the answer of verify_code.
type VerifyResponse struct {
	Verified bool `json:"verified"`
}

// verifyCode is handler.ts verify_code {code}.
func verifyCode(e *core.RequestEvent, b body) (any, error) {
	var code string
	if json.Unmarshal(b["code"], &code) != nil || !codeFormat.MatchString(code) {
		return nil, errInvalidCode
	}
	result, err := CheckCode(e.App, e.Auth.Id, code)
	if err != nil {
		return nil, err
	}
	switch result {
	case VerifyOK:
		return VerifyResponse{Verified: true}, nil
	case VerifyTooMany:
		return nil, errTooMany
	default:
		return nil, errInvalidCode
	}
}

// CheckCode is account_deletion_verify_code: ok, invalid, expired or
// too_many. Every wrong code counts; after [CodeMaxAttempts] the code is
// locked, a right one included.
func CheckCode(app core.App, userID, code string) (string, error) {
	result := VerifyInvalid
	err := app.RunInTransaction(func(txApp core.App) error {
		t := now()
		row, err := findCode(txApp, userID)
		if err != nil || row == nil {
			return err
		}
		attempts := row.GetInt("attempts")
		switch {
		case attempts >= CodeMaxAttempts:
			result = VerifyTooMany
			return nil
		case !parseTime(row.GetString("expires_at")).After(t):
			result = VerifyExpired
			return nil
		case row.GetString("code_hash") != codeHash(userID, code):
			row.Set("attempts", attempts+1)
			if attempts+1 >= CodeMaxAttempts {
				result = VerifyTooMany
			}
			return txApp.Save(row)
		}
		row.Set("verified_at", pattern.FormatTimestamp(t))
		result = VerifyOK
		return txApp.Save(row)
	})
	return result, err
}

// CodeVerified is account_deletion_code_verified: the user verified a code
// within the last [CodeVerifiedFor].
func CodeVerified(app core.App, userID string) (bool, error) {
	row, err := findCode(app, userID)
	if err != nil || row == nil {
		return false, err
	}
	verified := row.GetString("verified_at")
	return verified != "" && parseTime(verified).After(now().Add(-CodeVerifiedFor)), nil
}

// consumeCode is account_deletion_consume_code: once the request is
// written the code cannot be used again.
func consumeCode(app core.App, userID string) error {
	row, err := findCode(app, userID)
	if err != nil || row == nil {
		return err
	}
	return app.Delete(row)
}

// parseTime reads a K-5 time; an unreadable one is the zero time.
func parseTime(s string) time.Time {
	t, err := time.Parse(time.RFC3339Nano, s)
	if err != nil {
		return time.Time{}
	}
	return t
}
