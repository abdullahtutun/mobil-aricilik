#!/usr/bin/env bash
# Test accounts for the two-device integration tests on a LOCAL PocketBase
# (P9.1). The server gets no test route and no password-login exception:
# the accounts are opened with the superuser over the normal record API and
# the tests sign in with PocketBase's own superuser-only impersonate tokens
# (POST /api/collections/users/impersonate/{id}).
#
# Usage:
#   export PB_SUPERUSER_EMAIL=...        # the local server's superuser
#   export PB_SUPERUSER_PASSWORD=...
#   server/ops/test_users.sh http://127.0.0.1:8090 [count] [out]
#
# count defaults to 40, out to build/p91_accounts.json (repo root). The
# output is a --dart-define-from-file file: BACKEND, PB_URL and
# PB_TEST_ACCOUNTS (a JSON list of {email, id, token, expired_token}).
# token lives 4 hours; expired_token lives 1 second, so it has expired by
# the time the tests run (offline start with an expired session).
#
# Impersonate tokens are not renewable: auth-refresh answers 200 with the
# same token. The script also turns the rate limiter off on this server
# until its next restart (the tests send far more than 300 requests per 10 s
# from one IP). Only 127.0.0.1/localhost addresses and servers without
# APP_ENV (never dev or prod) are accepted. Exit 0 on success, 2 on usage
# or connection errors. Secrets and tokens are never printed.
set -euo pipefail

die() {
  echo "test_users: $*" >&2
  exit 2
}

[[ $# -ge 1 && $# -le 3 ]] || die "usage: $0 <local server url> [count] [out]"
for cmd in curl jq openssl; do
  command -v "$cmd" >/dev/null || die "$cmd not found"
done
for name in PB_SUPERUSER_EMAIL PB_SUPERUSER_PASSWORD; do
  [[ -n "${!name:-}" ]] || die "$name is not set in this shell"
done

base="${1%/}"
[[ "$base" =~ ^http://(127\.0\.0\.1|localhost)(:[0-9]+)?$ ]] ||
  die "only a local server is accepted (http://127.0.0.1:<port> or http://localhost:<port>)"
count="${2:-40}"
[[ "$count" =~ ^[1-9][0-9]{0,2}$ ]] || die "count must be 1..999"
root="$(cd "$(dirname "$0")/../.." && pwd)"
out="${3:-$root/build/p91_accounts.json}"

work="$(mktemp -d "${TMPDIR:-/tmp}/arici-test-users.XXXXXX")"
trap 'rm -rf "$work"' EXIT
umask 077
auth_cfg="$work/auth.cfg"

info="$(curl -fsS --max-time 10 "$base/api/app/info")" || die "GET /api/app/info failed (is the server running?)"
env_name="$(jq -r '.env // ""' <<<"$info")"
[[ -z "$env_name" ]] || die "the server says APP_ENV=$env_name; test accounts are only for a local server"

# The login body is built from the environment inside jq and fed through
# stdin, so neither value appears in `ps` or in this output.
token="$(
  jq -n '{identity: env.PB_SUPERUSER_EMAIL, password: env.PB_SUPERUSER_PASSWORD}' |
    curl -fsS --max-time 30 -H 'Content-Type: application/json' --data-binary @- \
      "$base/api/collections/_superusers/auth-with-password" |
    jq -r '.token // empty'
)" || die "superuser login failed (check the url, e-mail and password)"
[[ -n "$token" ]] || die "superuser login returned no token"
printf 'header = "Authorization: %s"\n' "$token" >"$auth_cfg"
unset token

# post <path> <json body on stdin>
post() {
  curl -fsS --max-time 30 -K "$auth_cfg" -H 'Content-Type: application/json' \
    --data-binary @- "$base$1"
}

run="$(date -u +%Y%m%d%H%M%S)-$(openssl rand -hex 3)"
accounts="$work/accounts.jsonl"
: >"$accounts"
for ((i = 1; i <= count; i++)); do
  email="p91-$run-$i@example.com"
  # Nobody knows the password: password login stays closed for these
  # accounts (server/internal/auth/password.go); PocketBase only needs one.
  id="$(
    jq -n --arg email "$email" --arg pw "$(openssl rand -hex 24)" \
      '{email: $email, password: $pw, passwordConfirm: $pw, verified: true, locale: "tr"}' |
      post /api/collections/users/records | jq -r '.id // empty'
  )" || die "opening $email failed"
  [[ -n "$id" ]] || die "opening $email returned no id"
  valid="$(jq -n '{duration: 14400}' | post "/api/collections/users/impersonate/$id" | jq -r '.token // empty')" ||
    die "impersonating $email failed"
  expired="$(jq -n '{duration: 1}' | post "/api/collections/users/impersonate/$id" | jq -r '.token // empty')" ||
    die "impersonating $email failed"
  [[ -n "$valid" && -n "$expired" ]] || die "impersonate returned no token for $email"
  jq -cn --arg email "$email" --arg id "$id" --arg token "$valid" --arg expired "$expired" \
    '{email: $email, id: $id, token: $token, expired_token: $expired}' >>"$accounts"
done

# Two phones on one IP pull 35 tables per round: far above the per-IP
# `/api/` limit (internal/bootstrap/ratelimits.go). The limiter is turned
# off on this local server only until it restarts (bootstrap turns it back
# on with every start).
jq -n '{rateLimits: {enabled: false}}' |
  curl -fsS --max-time 30 -K "$auth_cfg" -X PATCH -H 'Content-Type: application/json' \
    --data-binary @- "$base/api/settings" >/dev/null ||
  die "turning the rate limiter off failed"

mkdir -p "$(dirname "$out")"
jq -s --arg url "$base" \
  '{BACKEND: "pocketbase", PB_URL: $url, PB_TEST_ACCOUNTS: (. | tojson)}' \
  "$accounts" >"$out"
chmod 600 "$out"
echo "test_users: $count accounts (p91-$run-*) written to $out"
