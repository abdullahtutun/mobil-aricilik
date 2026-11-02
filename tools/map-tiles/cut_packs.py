#!/usr/bin/env python3
"""OpenFreeMap dünya MBTiles dosyasından bölge harita paketleri keser.

    python3 tools/map-tiles/cut_packs.py \\
        --source ~/maps/planet.mbtiles \\
        --regions tools/map-tiles/regions.example.json \\
        --minzoom 6 --maxzoom 14 --version 20261029

Her bölge için `out/<sürüm>/<id>.mbtiles` dosyasını keser, boyutunu ve
SHA-256'sını hesaplar, `out/catalog.json`'u yazar. `--estimate` dosya
yazmadan bölge başına karo sayısını ve yaklaşık boyutu verir. `--upload`
paketleri ve kataloğu public `map-packs` bucket'ına yükler
(`SUPABASE_URL` ve `SUPABASE_SERVICE_ROLE_KEY` gerekir): önce paketler,
en son katalog, böylece katalog hiçbir zaman olmayan bir paketi göstermez.

Yalnız Python standart kütüphanesi kullanılır. Ayrıntılar README.md'de.
"""

from __future__ import annotations

import argparse
import base64
import datetime as dt
import hashlib
import json
import math
import os
import re
import sqlite3
import sys
import urllib.error
import urllib.request
from pathlib import Path

CATALOG_FORMAT = 1
BUCKET = "map-packs"
ATTRIBUTION = (
    '<a href="https://openfreemap.org" target="_blank">OpenFreeMap</a> '
    '<a href="https://www.openmaptiles.org/" target="_blank">&copy; OpenMapTiles</a> '
    'Data from <a href="https://www.openstreetmap.org/copyright" '
    'target="_blank">OpenStreetMap</a>'
)
# Web Mercator'ın kapsadığı enlem sınırı.
MAX_LAT = 85.0511287798
# Supabase resumable (TUS) yüklemesi 6 MB'lık parçalar ister.
TUS_CHUNK = 6 * 1024 * 1024
ID_PATTERN = re.compile(r"^[a-z0-9][a-z0-9_-]*$")
VERSION_PATTERN = re.compile(r"^[A-Za-z0-9._-]+$")


def fail(message: str) -> None:
    print(message, file=sys.stderr)
    sys.exit(1)


# ---------------------------------------------------------------------------
# Karo hesabı
# ---------------------------------------------------------------------------


def lon_to_x(lon: float, zoom: int) -> int:
    n = 1 << zoom
    return min(n - 1, max(0, int((lon + 180.0) / 360.0 * n)))


def lat_to_y(lat: float, zoom: int) -> int:
    """XYZ satırı (kuzey 0)."""
    n = 1 << zoom
    lat = max(-MAX_LAT, min(MAX_LAT, lat))
    rad = math.radians(lat)
    y = (1.0 - math.asinh(math.tan(rad)) / math.pi) / 2.0 * n
    return min(n - 1, max(0, int(y)))


def tile_ranges(bbox: list[float], minzoom: int, maxzoom: int):
    """Her zoom için (z, x0, x1, tms_y0, tms_y1).

    MBTiles satırları TMS düzeninde (güney 0) tutar; XYZ satırı çevrilir.
    """
    west, south, east, north = bbox
    for z in range(minzoom, maxzoom + 1):
        x0, x1 = lon_to_x(west, z), lon_to_x(east, z)
        y_top, y_bottom = lat_to_y(north, z), lat_to_y(south, z)
        n = 1 << z
        yield z, x0, x1, n - 1 - y_bottom, n - 1 - y_top


# ---------------------------------------------------------------------------
# Girdi
# ---------------------------------------------------------------------------


def load_regions(path: Path) -> list[dict]:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        fail(f"{path} okunamadı: {error}")
    regions = data.get("regions") if isinstance(data, dict) else data
    if not isinstance(regions, list) or not regions:
        fail(f"{path}: 'regions' listesi boş ya da yok.")
    seen = set()
    for region in regions:
        rid = region.get("id")
        if not isinstance(rid, str) or not ID_PATTERN.match(rid):
            fail(f"Geçersiz bölge kimliği: {rid!r} (küçük harf, rakam, - ve _).")
        if rid in seen:
            fail(f"Bölge kimliği iki kez geçiyor: {rid}")
        seen.add(rid)
        bbox = region.get("bbox")
        if (
            not isinstance(bbox, list)
            or len(bbox) != 4
            or not all(isinstance(v, (int, float)) for v in bbox)
        ):
            fail(f"{rid}: bbox [batı, güney, doğu, kuzey] olmalı.")
        west, south, east, north = bbox
        if not (-180 <= west < east <= 180 and -90 <= south < north <= 90):
            fail(
                f"{rid}: bbox sınırları geçersiz {bbox} "
                "(batı < doğu, güney < kuzey; tarih çizgisini aşan kutu desteklenmez)."
            )
        if "name" not in region:
            fail(f"{rid}: 'name' gerekli (metin ya da {{'tr': ..., 'en': ...}}).")
    return regions


def open_source(path: Path) -> sqlite3.Connection:
    if not path.is_file():
        fail(f"Kaynak bulunamadı: {path}")
    db = sqlite3.connect(f"file:{path}?mode=ro", uri=True)
    try:
        db.execute("select 1 from tiles limit 1")
        db.execute("select name, value from metadata limit 1")
    except sqlite3.Error as error:
        fail(f"{path} bir MBTiles dosyası değil: {error}")
    return db


def source_metadata(db: sqlite3.Connection) -> dict[str, str]:
    return {name: value for name, value in db.execute("select name, value from metadata")}


# ---------------------------------------------------------------------------
# Kesme
# ---------------------------------------------------------------------------

TILE_QUERY = (
    "select tile_column, tile_row, tile_data from tiles "
    "where zoom_level = ? and tile_column between ? and ? "
    "and tile_row between ? and ?"
)
ESTIMATE_QUERY = (
    "select count(*), coalesce(sum(length(tile_data)), 0) from tiles "
    "where zoom_level = ? and tile_column between ? and ? "
    "and tile_row between ? and ?"
)


def estimate(db: sqlite3.Connection, bbox, minzoom, maxzoom) -> tuple[int, int]:
    tiles = size = 0
    for z, x0, x1, y0, y1 in tile_ranges(bbox, minzoom, maxzoom):
        count, total = db.execute(ESTIMATE_QUERY, (z, x0, x1, y0, y1)).fetchone()
        tiles += count
        size += total
    return tiles, size


def cut(
    db: sqlite3.Connection,
    meta: dict[str, str],
    region: dict,
    minzoom: int,
    maxzoom: int,
    target: Path,
) -> int:
    """Bölgeyi `target`'a yazar, karo sayısını döner."""
    bbox = region["bbox"]
    temp = target.with_suffix(".mbtiles.part")
    temp.unlink(missing_ok=True)
    out = sqlite3.connect(temp)
    out.execute("pragma journal_mode = off")
    out.execute("pragma synchronous = off")
    out.execute("create table metadata (name text primary key, value text)")
    out.execute(
        "create table tiles (zoom_level integer, tile_column integer, "
        "tile_row integer, tile_data blob)"
    )

    name = region["name"]
    display = name if isinstance(name, str) else name.get("en") or next(iter(name.values()))
    west, south, east, north = bbox
    center_zoom = min(maxzoom, max(minzoom, 8))
    metadata = {
        # Kaynağın şema bilgisi (format, vector_layers içeren json vb.) korunur.
        **meta,
        "name": f"{display} ({region['id']})",
        "description": f"Mobil Arıcı offline harita paketi: {display}",
        "bounds": f"{west},{south},{east},{north}",
        "center": f"{(west + east) / 2},{(south + north) / 2},{center_zoom}",
        "minzoom": str(minzoom),
        "maxzoom": str(maxzoom),
        "attribution": ATTRIBUTION,
        "type": "baselayer",
    }
    out.executemany("insert into metadata values (?, ?)", metadata.items())

    count = 0
    for z, x0, x1, y0, y1 in tile_ranges(bbox, minzoom, maxzoom):
        rows = db.execute(TILE_QUERY, (z, x0, x1, y0, y1))
        while batch := rows.fetchmany(2000):
            out.executemany(
                "insert into tiles values (?, ?, ?, ?)",
                ((z, x, y, data) for x, y, data in batch),
            )
            count += len(batch)
    out.execute(
        "create unique index tile_index on tiles (zoom_level, tile_column, tile_row)"
    )
    out.commit()
    out.close()
    temp.replace(target)
    return count


def sha256_of(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as file:
        while chunk := file.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def human(size: int) -> str:
    return f"{size / 1024 / 1024:.1f} MB"


# ---------------------------------------------------------------------------
# Yükleme
# ---------------------------------------------------------------------------


def _request(method: str, url: str, headers: dict, body: bytes | None = None):
    request = urllib.request.Request(url, data=body, method=method, headers=headers)
    try:
        return urllib.request.urlopen(request, timeout=300)
    except urllib.error.HTTPError as error:
        fail(f"{method} {url}: {error.code} {error.read().decode(errors='replace')}")
    except urllib.error.URLError as error:
        fail(f"{method} {url}: {error.reason}")


def upload_small(base: str, key: str, path: str, body: bytes, *, cache: str) -> None:
    """Küçük dosya (katalog): tek istekle, üzerine yazarak."""
    _request(
        "POST",
        f"{base}/storage/v1/object/{BUCKET}/{path}",
        {
            "Authorization": f"Bearer {key}",
            "apikey": key,
            "Content-Type": "application/json",
            "Cache-Control": cache,
            "x-upsert": "true",
        },
        body,
    )
    print(f"{path} yüklendi")


def upload_resumable(base: str, key: str, path: str, file: Path) -> None:
    """Büyük dosya: TUS ile 6 MB'lık parçalar.

    Yarım kalan yüklemeyi yeniden çalıştırabilmek için üzerine yazar; yol
    sürümlü olduğundan yayımlanmış bir sürüm farklı içerikle yeniden
    kesilmemelidir (CDN bir yıl önbellekte tutar).
    """

    def b64(value: str) -> str:
        return base64.b64encode(value.encode()).decode()

    size = file.stat().st_size
    auth = {
        "Authorization": f"Bearer {key}",
        "apikey": key,
        "Tus-Resumable": "1.0.0",
        "x-upsert": "true",
    }
    metadata = ",".join(
        f"{k} {b64(v)}"
        for k, v in {
            "bucketName": BUCKET,
            "objectName": path,
            "contentType": "application/x-sqlite3",
            "cacheControl": "31536000",
        }.items()
    )
    response = _request(
        "POST",
        f"{base}/storage/v1/upload/resumable",
        {**auth, "Upload-Length": str(size), "Upload-Metadata": metadata},
    )
    location = response.headers["Location"]
    if location.startswith("/"):
        location = base + location

    offset = 0
    with file.open("rb") as source:
        while offset < size:
            chunk = source.read(TUS_CHUNK)
            response = _request(
                "PATCH",
                location,
                {
                    **auth,
                    "Upload-Offset": str(offset),
                    "Content-Type": "application/offset+octet-stream",
                },
                chunk,
            )
            offset = int(response.headers["Upload-Offset"])
            print(f"\r{path}: {human(offset)} / {human(size)}", end="", flush=True)
    print(f"\r{path} yüklendi ({human(size)})")


def public_url(base: str, path: str) -> str:
    return f"{base}/storage/v1/object/public/{BUCKET}/{path}"


# ---------------------------------------------------------------------------


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--source", type=Path, required=True, help="dünya MBTiles dosyası")
    parser.add_argument("--regions", type=Path, required=True, help="bölge bbox listesi (JSON)")
    parser.add_argument("--minzoom", type=int, default=6)
    parser.add_argument("--maxzoom", type=int, default=14)
    parser.add_argument("--version", help="paket sürümü, ör. kaynak tarihi 20261029")
    parser.add_argument("--out", type=Path, default=Path("tools/map-tiles/out"))
    parser.add_argument("--only", help="yalnız bu bölgeler (virgülle kimlikler)")
    parser.add_argument("--estimate", action="store_true", help="kesmeden boyut tahmini")
    parser.add_argument("--upload", action="store_true", help="map-packs bucket'ına yükle")
    args = parser.parse_args()

    if not 0 <= args.minzoom <= args.maxzoom <= 14:
        fail("Zoom aralığı 0 ≤ minzoom ≤ maxzoom ≤ 14 olmalı (OpenFreeMap 14'e kadar).")
    regions = load_regions(args.regions)
    if args.only:
        wanted = set(args.only.split(","))
        missing = wanted - {r["id"] for r in regions}
        if missing:
            fail(f"Bölge listesinde yok: {', '.join(sorted(missing))}")
        regions = [r for r in regions if r["id"] in wanted]

    db = open_source(args.source.expanduser())
    meta = source_metadata(db)
    if meta.get("format") not in (None, "pbf"):
        print(f"Uyarı: kaynak biçimi '{meta.get('format')}', 'pbf' bekleniyordu.")
    source_max = int(meta.get("maxzoom", 14))
    if args.maxzoom > source_max:
        fail(f"Kaynak en çok {source_max}. zooma kadar karo içeriyor.")

    if args.estimate:
        total = 0
        for region in regions:
            tiles, size = estimate(db, region["bbox"], args.minzoom, args.maxzoom)
            total += size
            print(f"{region['id']:<16} {tiles:>10} karo  ~{human(size)}")
        print(f"Toplam ~{human(total)} (zoom {args.minzoom}–{args.maxzoom})")
        return

    if not args.version or not VERSION_PATTERN.match(args.version):
        fail("--version gerekli (harf, rakam, . _ -), ör. kaynak tarihi 20261029.")
    base = os.environ.get("SUPABASE_URL", "").rstrip("/")
    key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY", "")
    if args.upload and not (base and key):
        fail("--upload için SUPABASE_URL ve SUPABASE_SERVICE_ROLE_KEY gerekli.")

    pack_dir = args.out / args.version
    pack_dir.mkdir(parents=True, exist_ok=True)
    packs = []
    for region in regions:
        target = pack_dir / f"{region['id']}.mbtiles"
        print(f"{region['id']}: kesiliyor…", end="", flush=True)
        tiles = cut(db, meta, region, args.minzoom, args.maxzoom, target)
        size = target.stat().st_size
        print(f"\r{region['id']:<16} {tiles:>10} karo  {human(size)}")
        packs.append(
            {
                "id": region["id"],
                "name": region["name"],
                "bbox": region["bbox"],
                "minzoom": args.minzoom,
                "maxzoom": args.maxzoom,
                "path": f"{args.version}/{region['id']}.mbtiles",
                "bytes": size,
                "tiles": tiles,
                "sha256": sha256_of(target),
            }
        )
    db.close()

    # --only ile kesilenler, aynı sürümün önceki kataloğundaki paketlerle birleşir.
    catalog_path = args.out / "catalog.json"
    if args.only and catalog_path.is_file():
        previous = json.loads(catalog_path.read_text(encoding="utf-8"))
        if previous.get("version") == args.version:
            cut_ids = {p["id"] for p in packs}
            packs = [p for p in previous.get("packs", []) if p["id"] not in cut_ids] + packs
            packs.sort(key=lambda p: p["id"])

    catalog = {
        "format": CATALOG_FORMAT,
        "version": args.version,
        "generated_at": dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds"),
        "source": {
            "name": "OpenFreeMap",
            "file": args.source.name,
            "planetiler_version": meta.get("planetiler:version"),
            "osm_date": meta.get("planetiler:osm:osmosisreplicationtime"),
        },
        "tile_format": meta.get("format", "pbf"),
        "attribution": "© OpenFreeMap © OpenMapTiles © OpenStreetMap contributors",
        "license": "Map data © OpenStreetMap contributors, ODbL 1.0; schema © OpenMapTiles, CC-BY 4.0",
        "packs": packs,
    }
    if base:
        for pack in packs:
            pack["url"] = public_url(base, pack["path"])
    catalog_bytes = json.dumps(catalog, ensure_ascii=False, indent=2).encode("utf-8")
    catalog_path.write_bytes(catalog_bytes)
    total = sum(p["bytes"] for p in packs)
    print(f"{len(packs)} paket, toplam {human(total)}; katalog: {catalog_path}")

    if not args.upload:
        return
    for pack in packs:
        if not args.only or pack["id"] in wanted:
            upload_resumable(base, key, pack["path"], args.out / pack["path"])
    upload_small(base, key, "catalog.json", catalog_bytes, cache="max-age=300")


if __name__ == "__main__":
    main()
