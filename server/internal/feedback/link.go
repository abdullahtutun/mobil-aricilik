package feedback

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"errors"
	"net/url"
	"strconv"
	"strings"
	"time"
)

// LinkTTL is how long a screenshot link works: Supabase's signed URL lived
// 7 days (screenshotUrlSeconds).
const LinkTTL = 7 * 24 * time.Hour

// keyLabel separates this key from anything else derived from
// PB_ENCRYPTION_KEY; v1 lets a later change of the scheme void old links.
const keyLabel = "mobil-arici/feedback-shot/v1"

// Signer signs and checks screenshot links. Its key is derived from
// PB_ENCRYPTION_KEY, never the key itself: the raw key also encrypts the
// stored settings.
type Signer struct{ key []byte }

// NewSigner derives the link key; nil when the encryption key is empty
// (links are then left out of the mail and the route refuses every link).
func NewSigner(encryptionKey string) *Signer {
	if encryptionKey == "" {
		return nil
	}
	m := hmac.New(sha256.New, []byte(encryptionKey))
	m.Write([]byte(keyLabel))
	return &Signer{key: m.Sum(nil)}
}

func (s *Signer) sign(id string, exp int64) string {
	m := hmac.New(sha256.New, s.key)
	m.Write([]byte(id + "\n" + strconv.FormatInt(exp, 10)))
	return base64.RawURLEncoding.EncodeToString(m.Sum(nil))
}

// URL is the link to the screenshot of feedback id, valid until exp:
// <base>/api/app/feedback-shot/<id>?exp=<unix seconds>&sig=<HMAC>.
func (s *Signer) URL(base, id string, exp time.Time) string {
	e := exp.Unix()
	q := url.Values{"exp": {strconv.FormatInt(e, 10)}, "sig": {s.sign(id, e)}}
	return strings.TrimRight(base, "/") + RoutePrefix + url.PathEscape(id) + "?" + q.Encode()
}

// Link check errors; the route answers 403 to both.
var (
	ErrBadSignature = errors.New("feedback link: bad signature")
	ErrExpired      = errors.New("feedback link: expired")
)

// Verify checks a link's id, exp and sig at now. The signature is checked
// first, so an expired link says nothing about a forged one.
func (s *Signer) Verify(id, exp, sig string, now time.Time) error {
	if s == nil {
		return ErrBadSignature
	}
	e, err := strconv.ParseInt(exp, 10, 64)
	if err != nil || strconv.FormatInt(e, 10) != exp {
		return ErrBadSignature
	}
	if !hmac.Equal([]byte(sig), []byte(s.sign(id, e))) {
		return ErrBadSignature
	}
	if now.Unix() >= e {
		return ErrExpired
	}
	return nil
}
