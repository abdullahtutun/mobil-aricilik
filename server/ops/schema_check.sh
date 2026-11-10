#!/usr/bin/env bash
# Live schema drift check (P2.8, K-3): the running server's collections must
# equal server/schema/collections.json in this checkout.
#
# Usage:
#   export PB_SUPERUSER_EMAIL=...        # from the password manager
#   export PB_SUPERUSER_PASSWORD=...     # never typed into a file or prompt
#   server/ops/schema_check.sh https://arici-api-dev.tutunsoft.com
#
# Compares GET /api/app/schema-hash (superusers only; SHA-256 of the live
# dump) with `shasum -a 256` of the committed dump. Exit 0 when equal, 1 on
# drift (a dashboard change, or a deploy that is not this checkout), 2 on
# usage or connection errors. Only reads from the server. Secrets go to curl
# through stdin and a 0600 config file, never through arguments or output.
set -euo pipefail

die() {
  echo "schema_check: $*" >&2
  exit 2
}

[[ $# -eq 1 ]] || die "usage: $0 <server url>"
for cmd in curl jq shasum; do
  command -v "$cmd" >/dev/null || die "$cmd not found"
done
for name in PB_SUPERUSER_EMAIL PB_SUPERUSER_PASSWORD; do
  [[ -n "${!name:-}" ]] || die "$name is not set in this shell"
done

base="${1%/}"
[[ "$base" == https://* || "$base" == http://127.0.0.1* || "$base" == http://localhost* ]] ||
  die "the url must be https:// (or a local http address)"

dump="$(cd "$(dirname "$0")/.." && pwd)/schema/collections.json"
[[ -f "$dump" ]] || die "no $dump"
want="$(shasum -a 256 "$dump" | cut -d' ' -f1)"

work="$(mktemp -d "${TMPDIR:-/tmp}/arici-schema.XXXXXX")"
trap 'rm -rf "$work"' EXIT
umask 077
auth_cfg="$work/auth.cfg"

info="$(curl -fsS --max-time 20 "$base/api/app/info")" || die "GET /api/app/info failed"
echo "server: $base (env=$(jq -r '.env // ""' <<<"$info"), version=$(jq -r '.version // ""' <<<"$info"))"

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

got="$(curl -fsS --max-time 30 -K "$auth_cfg" "$base/api/app/schema-hash" | jq -r '.sha256 // empty')" ||
  die "GET /api/app/schema-hash failed (is this deploy older than P2.8?)"
[[ "$got" =~ ^[0-9a-f]{64}$ ]] || die "unexpected schema-hash answer"

echo "repo: $want"
echo "live: $got"
if [[ "$got" == "$want" ]]; then
  echo "schema_check: equal"
else
  echo "schema_check: DRIFT. The live schema differs from server/schema/collections.json." >&2
  echo "  Deployed commit differs from this checkout, or someone changed the schema in the dashboard (K-3)." >&2
  exit 1
fi
