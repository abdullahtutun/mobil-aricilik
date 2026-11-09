#!/usr/bin/env bash
# Downloads the newest PocketBase backup of one server to this Mac (P1.4, K-15).
#
# Usage:
#   export PB_URL=https://arici-api.tutunsoft.com
#   export PB_SUPERUSER_EMAIL=...        # from the password manager
#   export PB_SUPERUSER_PASSWORD=...     # never typed into a file or prompt
#   server/ops/pull_backup.sh
#
# Optional: BACKUP_ROOT (default ~/Yedekler/mobil-arici).
#
# Writes <BACKUP_ROOT>/pb-<env>/<key> and <key>.sha256, where <env> comes
# from GET /api/app/info. Deletes copies there older than 8 weeks. Only reads
# from the server (it also asks for a short-lived file token). Secrets go to
# curl through a 0600 config file, never through arguments or the output.
#
# PocketBase v0.40.6 endpoints (apis/backup.go, apis/file.go, record_auth.go):
#   POST /api/collections/_superusers/auth-with-password  -> {token}
#   GET  /api/backups                                     -> [{key,size,modified}]
#   POST /api/files/token                                 -> {token}
#   GET  /api/backups/{key}?token=<file token>            -> zip
set -euo pipefail

die() {
  echo "pull_backup: $*" >&2
  exit 1
}

for cmd in curl jq shasum unzip find; do
  command -v "$cmd" >/dev/null || die "$cmd not found"
done
for name in PB_URL PB_SUPERUSER_EMAIL PB_SUPERUSER_PASSWORD; do
  [[ -n "${!name:-}" ]] || die "$name is not set in this shell"
done

base="${PB_URL%/}"
[[ "$base" == https://* || "$base" == http://127.0.0.1* || "$base" == http://localhost* ]] ||
  die "PB_URL must be https:// (or a local http address)"
root="${BACKUP_ROOT:-$HOME/Yedekler/mobil-arici}"

work="$(mktemp -d "${TMPDIR:-/tmp}/arici-pull.XXXXXX")"
trap 'rm -rf "$work"' EXIT
umask 077
auth_cfg="$work/auth.cfg"

# Which server is this? Decides the target folder.
env_name="$(curl -fsS --max-time 20 "$base/api/app/info" | jq -r '.env // empty')"
[[ "$env_name" == dev || "$env_name" == prod ]] ||
  die "GET /api/app/info did not return env dev or prod (got '${env_name}')"
dest="$root/pb-$env_name"
mkdir -p "$dest"
echo "server: $base (env=$env_name)"

# Superuser login. The body is built from the environment inside jq and fed
# through stdin, so neither value appears in `ps` or in this output.
token="$(
  jq -n '{identity: env.PB_SUPERUSER_EMAIL, password: env.PB_SUPERUSER_PASSWORD}' |
    curl -fsS --max-time 30 -H 'Content-Type: application/json' --data-binary @- \
      "$base/api/collections/_superusers/auth-with-password" |
    jq -r '.token // empty'
)" || die "superuser login failed (check PB_URL, e-mail and password)"
[[ -n "$token" ]] || die "superuser login returned no token"
printf 'header = "Authorization: %s"\n' "$token" >"$auth_cfg"
unset token

# Newest backup by modification time.
list="$(curl -fsS --max-time 30 -K "$auth_cfg" "$base/api/backups")" ||
  die "GET /api/backups failed"
newest="$(jq -c 'sort_by(.modified) | last // empty' <<<"$list")"
[[ -n "$newest" ]] || die "the server has no backups yet (panel: Settings > Backups)"
key="$(jq -r '.key' <<<"$newest")"
size="$(jq -r '.size' <<<"$newest")"
modified="$(jq -r '.modified' <<<"$newest")"
[[ "$key" =~ ^[A-Za-z0-9@._-]+\.zip$ ]] || die "unexpected backup key"
echo "newest: $key ($size bytes, $modified)"

target="$dest/$key"
if [[ -f "$target" && -f "$target.sha256" ]]; then
  echo "already here: $target"
else
  file_token="$(curl -fsS --max-time 30 -K "$auth_cfg" -X POST "$base/api/files/token" |
    jq -r '.token // empty')" || die "POST /api/files/token failed"
  [[ -n "$file_token" ]] || die "no file token"

  # The file token goes in the config file too, not on the command line.
  dl_cfg="$work/download.cfg"
  printf 'url = "%s/api/backups/%s?token=%s"\n' "$base" "$key" "$file_token" >"$dl_cfg"
  unset file_token

  part="$target.part"
  curl -fsS --max-time 3600 -K "$dl_cfg" -o "$part" || {
    rm -f "$part"
    die "download failed"
  }
  rm -f "$dl_cfg"

  got_size="$(wc -c <"$part" | tr -d ' ')"
  [[ "$got_size" == "$size" ]] || {
    rm -f "$part"
    die "size mismatch: got $got_size, server said $size"
  }
  unzip -tq "$part" >/dev/null || {
    rm -f "$part"
    die "downloaded file is not a valid zip"
  }
  mv "$part" "$target"
  (cd "$dest" && shasum -a 256 "$key" >"$key.sha256")
  echo "saved: $target"
fi
echo "sha256: $(cut -d' ' -f1 "$target.sha256")"

# Keep 8 weeks of copies (by download time).
old="$(find "$dest" -maxdepth 1 -type f \( -name '*.zip' -o -name '*.zip.sha256' -o -name '*.zip.part' \) -mtime +56 -print)"
if [[ -n "$old" ]]; then
  echo "removing copies older than 8 weeks:"
  echo "$old" | sed 's/^/  /'
  echo "$old" | while IFS= read -r f; do rm -f "$f"; done
fi

echo "copies in $dest: $(find "$dest" -maxdepth 1 -type f -name '*.zip' | wc -l | tr -d ' ')"
