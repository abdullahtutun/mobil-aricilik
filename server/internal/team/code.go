package team

import (
	"crypto/rand"
	"strings"
	"unicode"
)

// The invite code (supabase/functions/invite/code.ts): 6 characters from an
// alphabet without the look-alikes 0/O, 1/I/L; the same set as the invites
// code pattern (migrations/1794300009, invites_code_check).
const (
	CodeAlphabet = "ABCDEFGHJKMNPQRSTUVWXYZ23456789"
	CodeLength   = 6
)

// GenerateCode returns a random code. 256 is not a multiple of 31, so bytes
// at or above the largest multiple are dropped to keep every character
// equally likely.
func GenerateCode() string {
	limit := byte(256 - 256%len(CodeAlphabet))
	code := make([]byte, 0, CodeLength)
	buf := make([]byte, 16)
	for len(code) < CodeLength {
		if _, err := rand.Read(buf); err != nil {
			panic(err) // crypto/rand never fails on supported platforms
		}
		for _, b := range buf {
			if b < limit && len(code) < CodeLength {
				code = append(code, CodeAlphabet[int(b)%len(CodeAlphabet)])
			}
		}
	}
	return string(code)
}

// NormalizeCode is what the user typed or pasted: white space and hyphens
// removed, letters upper-cased (code.ts uses /[\s-]/g and toUpperCase).
func NormalizeCode(input string) string {
	var b strings.Builder
	for _, r := range input {
		if r == '-' || unicode.IsSpace(r) {
			continue
		}
		b.WriteRune(r)
	}
	return strings.ToUpper(b.String())
}

// IsCode reports whether value is a well-formed code.
func IsCode(value string) bool {
	if len(value) != CodeLength {
		return false
	}
	for _, c := range value {
		if !strings.ContainsRune(CodeAlphabet, c) {
			return false
		}
	}
	return true
}

// IsInviteRole reports whether role may be given by an invite (and by
// set_role): partner, worker or viewer. An organization's owner is its
// founder only.
func IsInviteRole(role string) bool {
	return role == "partner" || role == "worker" || role == "viewer"
}
