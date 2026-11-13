#!/usr/bin/env bash
# Supabase'in tam yedeği (P0.2, docs/pocketbase-gecis.md).
#
# Kullanım:
#   SUPABASE_URL=https://<ref>.supabase.co SUPABASE_SERVICE_ROLE_KEY=... \
#     archive/backup_supabase.sh ~/Yedekler/mobil-arici/supabase-YYYY-MM-DD
#
# Ön koşul: Supabase CLI giriş yapmış ve proje bağlı (`supabase link`),
# Docker çalışıyor (db dump pg_dump'ı konteynerde çalıştırır), curl, jq, shasum.
#
# Yazdıkları (hedef klasörde):
#   schema.sql, data.sql, roles.sql   supabase db dump --linked
#   storage/<bucket>/<yol>            Storage nesneleri, yollarıyla aynı yapıda
#   manifest.txt                      tablo başına satır sayısı, bucket başına
#                                     dosya sayısı ve bayt, dosya listesi
#   SHA256SUMS                        bütün dosyaların SHA-256 özetleri
#
# Betik yalnız okur; Supabase'de hiçbir şey değiştirmez. Gizli değerler yalnız
# ortam değişkeninden okunur; komut satırına, dosyaya ya da loga yazılmaz.
# macOS'un bash 3.2'siyle uyumludur.

set -euo pipefail

die() {
  printf 'HATA: %s\n' "$*" >&2
  exit 1
}

log() {
  printf '==> %s\n' "$*" >&2
}

[[ $# -eq 1 ]] || die "kullanım: $0 <hedef-klasör>"

: "${SUPABASE_URL:?SUPABASE_URL ortam değişkeni gerekli}"
: "${SUPABASE_SERVICE_ROLE_KEY:?SUPABASE_SERVICE_ROLE_KEY ortam değişkeni gerekli}"
SUPABASE_URL="${SUPABASE_URL%/}"

for cmd in supabase docker curl jq shasum; do
  command -v "$cmd" >/dev/null 2>&1 || die "'$cmd' bulunamadı"
done
docker info >/dev/null 2>&1 || die "Docker çalışmıyor (supabase db dump için gerekli)"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd "$script_dir/.." && pwd -P)"
[[ -f "$repo_root/archive/supabase/.temp/project-ref" ]] ||
  die "proje bağlı değil: önce 'cd archive && supabase link --project-ref <ref>'"
project_ref="$(<"$repo_root/archive/supabase/.temp/project-ref")"
[[ "$SUPABASE_URL" == "https://$project_ref.supabase.co" ]] ||
  die "SUPABASE_URL bağlı projeyle ($project_ref) uyuşmuyor"

# --- Hedef klasör: repo dışında ve boş olmalı --------------------------------

target="$1"
created=0
if [[ -e "$target" ]]; then
  [[ -d "$target" ]] || die "hedef bir klasör değil: $target"
  [[ -z "$(ls -A "$target")" ]] || die "hedef klasör boş değil: $target"
else
  mkdir -p "$target"
  created=1
fi
target="$(cd "$target" && pwd -P)"
case "$target/" in
  "$repo_root"/*)
    ((created == 0)) || rmdir "$target" 2>/dev/null || true
    die "hedef klasör repo içinde: $target" ;;
esac
umask 077

# --- Storage REST yardımcıları ------------------------------------------------

# Anahtar curl'e stdin'den yapılandırma olarak verilir; `ps` çıktısında görünmez
# (printf bash'in yerleşik komutudur, ayrı süreç açmaz).
# Eski service_role anahtarı bir JWT'dir (eyJ...) ve Authorization'da da gider.
# Yeni gizli anahtar (sb_secret_...) JWT değildir; Authorization'da gönderilirse
# Storage reddeder, yalnız apikey başlığında gider ve ağ geçidi onu çevirir.
storage_curl() {
  {
    printf 'header = "apikey: %s"\n' "$SUPABASE_SERVICE_ROLE_KEY"
    case "$SUPABASE_SERVICE_ROLE_KEY" in
      eyJ*) printf 'header = "Authorization: Bearer %s"\n' "$SUPABASE_SERVICE_ROLE_KEY" ;;
    esac
  } | curl --config - --silent --show-error --fail-with-body --retry 3 "$@"
}

# Storage'dan JSON alır; hata olursa HTTP yanıtını (anahtarsız) gösterip durur.
storage_json() {
  local what="$1" out
  shift
  out="$(storage_curl "$@")" ||
    die "Storage isteği başarısız ($what): ${out:-yanıt yok}"
  jq -e 'type == "array"' >/dev/null 2>&1 <<<"$out" ||
    die "Storage beklenmeyen yanıt verdi ($what): $out"
  printf '%s' "$out"
}

urlencode_path() {
  jq -rn --arg p "$1" '$p | split("/") | map(@uri) | join("/")'
}

page_size=1000

# Bir önekin altındaki bütün dosyaları "yol<TAB>bayt" satırları olarak basar.
# Klasörler (id'si null olan girdiler) özyinelemeli gezilir; her düzey sayfalıdır.
list_objects() {
  local bucket="$1" prefix="$2" offset=0 body page count
  while :; do
    body="$(jq -cn --arg p "$prefix" --argjson l "$page_size" --argjson o "$offset" \
      '{prefix: $p, limit: $l, offset: $o, sortBy: {column: "name", order: "asc"}}')"
    page="$(storage_json "liste $bucket/$prefix" -X POST \
      -H 'Content-Type: application/json' \
      --data "$body" "$SUPABASE_URL/storage/v1/object/list/$bucket")" || exit 1
    count="$(jq 'length' <<<"$page")"
    jq -r --arg p "$prefix" \
      '.[] | select(.id != null)
           | "\(if $p == "" then "" else $p + "/" end)\(.name)\t\(.metadata.size // 0)"' \
      <<<"$page"
    while IFS= read -r folder; do
      [[ -n "$folder" ]] || continue
      if [[ -z "$prefix" ]]; then
        list_objects "$bucket" "$folder"
      else
        list_objects "$bucket" "$prefix/$folder"
      fi
    done < <(jq -r '.[] | select(.id == null) | .name' <<<"$page")
    ((count < page_size)) && break
    offset=$((offset + page_size))
  done
}

# --- 1. Veritabanı dökümü -----------------------------------------------------

cd "$repo_root/archive"  # supabase CLI ./supabase klasörünü arar
log "Şema dökülüyor (schema.sql)"
supabase db dump --linked -f "$target/schema.sql"
log "Veri dökülüyor (data.sql)"
supabase db dump --linked --data-only -f "$target/data.sql"
log "Roller dökülüyor (roles.sql)"
supabase db dump --linked --role-only -f "$target/roles.sql"

# --- 2. Tablo başına satır sayısı ---------------------------------------------

# data.sql'in kapsadığı şemalar: db dump'ın dışarıda bıraktığı iç şemalar hariç.
log "Tablo satırları sayılıyor"
count_sql="select table_schema || '.' || table_name as tbl,
  (xpath('/row/c/text()', query_to_xml(
    format('select count(*) as c from %I.%I', table_schema, table_name),
    false, true, '')))[1]::text::bigint as n
from information_schema.tables
where table_type = 'BASE TABLE'
  and table_schema not like 'pg\\_%'
  and table_schema not like '\\_%'
  and table_schema not like 'timescaledb\\_%'
  and table_schema not in ('information_schema', 'graphql', 'graphql_public',
    'pgsodium', 'pgsodium_masks', 'pgtle', 'repack', 'tiger', 'tiger_data',
    'topology', 'vault', 'etl', 'extensions', 'pgbouncer', 'realtime',
    'supabase_migrations')
order by 1"
table_counts="$(supabase db query --linked --output-format json "$count_sql" |
  jq -r '.rows[] | "\(.tbl)\t\(.n)"')" ||
  die "tablo sayımı başarısız (supabase db query --linked)"
[[ -n "$table_counts" ]] || die "tablo sayımı boş döndü"

# --- 3. Storage ---------------------------------------------------------------

log "Bucket listesi alınıyor"
buckets="$(storage_json "bucket listesi" "$SUPABASE_URL/storage/v1/bucket" |
  jq -r '.[].id' | sort)" || exit 1
bucket_summary=""
object_list=""
mkdir -p "$target/storage"
while IFS= read -r bucket; do
  [[ -n "$bucket" ]] || continue
  log "Bucket: $bucket"
  mkdir -p "$target/storage/$bucket"
  files=0
  bytes=0
  objects="$(list_objects "$bucket" "")"
  while IFS=$'\t' read -r path size; do
    [[ -n "$path" ]] || continue
    case "/$path/" in
      */../* | */./*) die "güvensiz nesne yolu: $bucket/$path" ;;
    esac
    dest="$target/storage/$bucket/$path"
    mkdir -p "$(dirname "$dest")"
    if ! storage_curl -o "$dest" \
      "$SUPABASE_URL/storage/v1/object/authenticated/$bucket/$(urlencode_path "$path")"; then
      err="$(head -c 500 "$dest" 2>/dev/null || true)"
      rm -f "$dest"
      die "indirme başarısız ($bucket/$path): ${err:-yanıt yok}"
    fi
    actual="$(wc -c <"$dest" | tr -d ' ')"
    files=$((files + 1))
    bytes=$((bytes + actual))
    object_list+="$bucket/$path"$'\t'"$actual"$'\n'
    [[ "$size" == "$actual" ]] ||
      log "uyarı: $bucket/$path boyutu listede $size, inen $actual"
  done <<<"$objects"
  bucket_summary+="$bucket"$'\t'"$files"$'\t'"$bytes"$'\n'
done <<<"$buckets"

# --- 4. Manifest ve özetler ---------------------------------------------------

log "manifest.txt yazılıyor"
{
  printf 'Mobil Arıcı Supabase yedeği\n'
  printf 'proje: %s\n' "$project_ref"
  printf 'tarih: %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  printf 'supabase cli: %s\n' "$(supabase --version 2>/dev/null | head -n 1)"
  printf '\n## Tablolar (select count(*))\n'
  printf '%s\n' "$table_counts" | awk -F'\t' '{ printf "%-50s %10s\n", $1, $2 }'
  printf '\n## Bucket'"'"'lar (dosya, bayt)\n'
  printf '%s' "$bucket_summary" | awk -F'\t' '{ printf "%-30s %8s %14s\n", $1, $2, $3 }'
  printf '\n## Storage dosyaları (bucket/yol, bayt)\n'
  printf '%s' "$object_list" | awk -F'\t' '{ printf "%s\t%s\n", $1, $2 }'
  printf '\n## Yedek dosyaları (yol, bayt)\n'
  (cd "$target" && find . -type f ! -name manifest.txt ! -name SHA256SUMS |
    LC_ALL=C sort | while IFS= read -r f; do
      printf '%s\t%s\n' "${f#./}" "$(wc -c <"$f" | tr -d ' ')"
    done)
} >"$target/manifest.txt"

log "SHA256SUMS yazılıyor"
(cd "$target" && find . -type f ! -name SHA256SUMS | LC_ALL=C sort |
  sed 's|^\./||' | tr '\n' '\0' | xargs -0 shasum -a 256 >SHA256SUMS)

log "Bitti: $target"
log "Doğrulama: (cd \"$target\" && shasum -a 256 -c SHA256SUMS)"
