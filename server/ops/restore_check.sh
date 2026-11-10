#!/usr/bin/env bash
# Proves a downloaded PocketBase backup can be restored (P1.4, K-15).
#
# Usage:
#   export PB_ENCRYPTION_KEY=...   # the key of the server the zip came from
#   server/ops/restore_check.sh ~/Yedekler/mobil-arici/pb-prod/<key>.zip
#
# Optional: RESTORE_PORT (default 18090), ARICI_BIN (a prebuilt `arici`;
# default: built from this checkout with `go build`).
#
# Unzips into a temporary pb_data, starts our own server binary on
# 127.0.0.1 with only PB_ENCRYPTION_KEY in its environment, reports
# GET /api/health and the collection count, then stops it and deletes the
# copy. The zip itself is never modified. The settings in a backup are
# encrypted, so a wrong or missing key makes the start fail: that also
# checks the key kept in the password manager.
set -euo pipefail

die() {
  echo "restore_check: $*" >&2
  exit 1
}

[[ $# -eq 1 ]] || die "usage: $0 <backup.zip>"
zip="$1"
[[ -f "$zip" ]] || die "no such file: $zip"
[[ -n "${PB_ENCRYPTION_KEY:-}" ]] || die "PB_ENCRYPTION_KEY is not set in this shell (key of the zip's server)"
for cmd in curl unzip sqlite3; do
  command -v "$cmd" >/dev/null || die "$cmd not found"
done

server_dir="$(cd "$(dirname "$0")/.." && pwd)"
port="${RESTORE_PORT:-18090}"
addr="127.0.0.1:$port"

if curl -s -o /dev/null --max-time 2 "http://$addr/api/health"; then
  die "something already listens on $addr (set RESTORE_PORT)"
fi

work="$(mktemp -d "${TMPDIR:-/tmp}/arici-restore.XXXXXX")"
pid=""
cleanup() {
  if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
  fi
  rm -rf "$work"
}
trap cleanup EXIT
umask 077

if [[ -f "$zip.sha256" ]]; then
  (cd "$(dirname "$zip")" && shasum -a 256 -c "$(basename "$zip").sha256" >/dev/null) ||
    die "SHA-256 does not match $zip.sha256"
  echo "sha256: ok"
fi

data="$work/pb_data"
mkdir -p "$data"
unzip -q "$zip" -d "$data" || die "unzip failed"
[[ -f "$data/data.db" ]] || die "zip has no data.db at its root"

if [[ -n "${ARICI_BIN:-}" ]]; then
  bin="$ARICI_BIN"
  [[ -x "$bin" ]] || die "ARICI_BIN is not executable"
else
  command -v go >/dev/null || die "go not found (or set ARICI_BIN)"
  bin="$work/arici"
  commit="$(git -C "$server_dir" rev-parse --short HEAD 2>/dev/null || echo unknown)"
  (cd "$server_dir" && CGO_ENABLED=0 go build -trimpath \
    -ldflags "-X main.version=$commit" -o "$bin" .) || die "go build failed"
  echo "binary: built from $commit"
fi

# Clean environment: no BACKUPS_*/SMTP_* from this shell reach the copy.
# The key is inherited, not passed as an argument, so it never shows in `ps`.
export PB_ENCRYPTION_KEY
(
  for v in $(compgen -e); do
    case "$v" in
      PATH | PB_ENCRYPTION_KEY) ;;
      *) unset "$v" 2>/dev/null || true ;;
    esac
  done
  export HOME="$work"
  exec "$bin" serve --dir "$data" --http "$addr"
) >"$work/serve.log" 2>&1 &
pid=$!

health=""
for _ in $(seq 1 60); do
  if ! kill -0 "$pid" 2>/dev/null; then
    break
  fi
  health="$(curl -s -o /dev/null -w '%{http_code}' --max-time 2 "http://$addr/api/health" || true)"
  [[ "$health" == 200 ]] && break
  sleep 0.5
done

if [[ "$health" != 200 ]]; then
  echo "health: FAILED (${health:-no answer})" >&2
  echo "--- server log (last 20 lines) ---" >&2
  tail -n 20 "$work/serve.log" >&2 || true
  exit 1
fi
echo "health: ok"

kill "$pid"
wait "$pid" 2>/dev/null || true
pid=""

# Not -readonly: the server left the copy in WAL mode, and a read-only
# connection cannot create the -shm file it then needs (SQLITE_CANTOPEN).
# This is the temporary copy; the zip is untouched.
counts="$(sqlite3 "$data/data.db" \
  "select count(*), coalesce(sum(system), 0) from _collections;")"
total="${counts%%|*}"
system="${counts##*|}"
echo "collections: $total (system $system, app $((total - system)))"
echo "restore check passed: $(basename "$zip")"
