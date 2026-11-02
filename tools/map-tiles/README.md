# Offline harita bölge paketleri

OpenFreeMap'in yayımladığı dünya MBTiles dosyasından il/bölge paketleri keser,
boyutlarını ve SHA-256'larını hesaplar, bir katalog üretir ve hepsini Supabase
Storage'daki public `map-packs` bucket'ına yükler. Uygulama paketleri kendi
depomuzdan indirir; OpenFreeMap'in ücretsiz genel sunucusuna toplu indirme yükü
binmez (bkz. `docs/teknik.md`, Harita).

Betik geliştiricinin bilgisayarında elle çalışır; uygulamanın parçası değildir.

## Araç seçimi

- **Python 3, yalnız standart kütüphane** (`sqlite3`, `urllib`, `hashlib`).
  macOS'ta hazır gelir; `pip install` yok.
- **Kesme doğrudan SQL ile.** MBTiles bir SQLite dosyasıdır: her zoom için
  bbox'ın karo aralığı (x, TMS y) hesaplanır ve satırlar yeni bir MBTiles'a
  kopyalanır. Karolar yeniden kodlanmaz, olduğu gibi (gzip'li PBF) taşınır.
  OpenFreeMap dosyası planetiler'ın tekilleştirilmiş düzeninde
  (`tiles_shallow` + `tiles_data`, üstünde `tiles` görünümü) gelir; betik
  `tiles` görünümünü okuduğu için iki düzende de çalışır. Çıktı en yaygın
  düz `tiles` tablosudur.
- Neden başka araç değil: `tilelive-copy` Node ve yerel eklenti ister,
  `tile-join` (tippecanoe) derleme ister, `mbutil` dizin/dosya üzerinden gider
  ve bbox'la kesmez. İşimiz yalnız bbox + zoom ile satır seçmek; bu SQL'le
  birkaç satır.
- **Yükleme Supabase'in resumable (TUS) uç noktasıyla**, 6 MB'lık parçalarla.
  İl paketleri yüzlerce MB olabilir; tek istekli yükleme bu boyutta kopabilir.

## Kurulum

1. Dünya dosyasını indir. Sürümler `https://btrfs.openfreemap.com/files.txt`
   listesinde; OpenFreeMap son 4 haftalık çalışmayı ve son 6 ayın ilkini tutar.

   ```sh
   curl -s https://btrfs.openfreemap.com/files.txt | grep 'planet/.*/tiles.mbtiles'
   curl -L -o ~/maps/planet.mbtiles \
     https://btrfs.openfreemap.com/areas/planet/<sürüm>/tiles.mbtiles
   ```

   Dosya ~90 GB, 0–14 zoom. Dışa takılı diskte durabilir.

2. Bölge listesini hazırla (`regions.example.json` örnek; bbox'lar
   yaklaşık):

   ```json
   { "regions": [
     { "id": "tr-35", "name": { "tr": "İzmir", "en": "Izmir" },
       "bbox": [26.2, 37.8, 28.5, 39.4] }
   ] }
   ```

   `id` küçük harf, rakam, `-`, `_` (dosya adı olur). `bbox` =
   `[batı, güney, doğu, kuzey]`, WGS84 derece. `name` metin ya da dil →
   metin. Tarih çizgisini aşan kutu desteklenmez.

## Kullanım

```sh
# 1) Boyut tahmini (dosya yazmaz)
python3 tools/map-tiles/cut_packs.py --source ~/maps/planet.mbtiles \
  --regions regions.json --minzoom 6 --maxzoom 14 --estimate

# 2) Kes + katalog (tools/map-tiles/out/, git'e girmez)
python3 tools/map-tiles/cut_packs.py --source ~/maps/planet.mbtiles \
  --regions regions.json --minzoom 6 --maxzoom 14 --version 20261029

# 3) Kes + yükle
SUPABASE_URL=https://jcddnelaboueazhordfz.supabase.co \
SUPABASE_SERVICE_ROLE_KEY=... \
python3 tools/map-tiles/cut_packs.py --source ~/maps/planet.mbtiles \
  --regions regions.json --minzoom 6 --maxzoom 14 --version 20261029 --upload
```

- `--version`: paket sürümü; kaynak dünya dosyasının tarihi önerilir. Paketler
  `<sürüm>/<id>.mbtiles` yoluna gider ve bir yıl önbellekte tutulur. Yeni
  veriyle kesilen paket **yeni sürümle** yüklenmeli; yayımlanmış bir sürüm
  farklı içerikle yeniden yüklenirse CDN eskisini vermeye devam edebilir.
- `--only tr-35,tr-48`: yalnız bu bölgeleri keser; aynı sürümün `out/` içindeki
  önceki kataloğuyla birleştirir ve yalnız bunları yükler.
- Yükleme sırası: önce paketler, en son `catalog.json` (5 dk önbellek).
  Katalog hiçbir zaman yüklenmemiş bir paketi göstermez. Yarım kalan yükleme
  aynı komutla yeniden çalıştırılabilir (üzerine yazar).
- Zoom aralığı 0–14 (OpenFreeMap 14'te durur; uygulama daha yakını büyüterek
  çizer). Her zoom bir öncekinin ~4 katı yer tutar; 14 en pahalısıdır.

## Katalog (`catalog.json`)

```json
{
  "format": 1,
  "version": "20261029",
  "generated_at": "2026-11-02T20:00:00+00:00",
  "source": { "name": "OpenFreeMap", "file": "planet.mbtiles", "planetiler_version": "…", "osm_date": "…" },
  "tile_format": "pbf",
  "attribution": "© OpenFreeMap © OpenMapTiles © OpenStreetMap contributors",
  "license": "Map data © OpenStreetMap contributors, ODbL 1.0; schema © OpenMapTiles, CC-BY 4.0",
  "packs": [
    { "id": "tr-35", "name": { "tr": "İzmir", "en": "Izmir" },
      "bbox": [26.2, 37.8, 28.5, 39.4], "minzoom": 6, "maxzoom": 14,
      "path": "20261029/tr-35.mbtiles", "url": "https://…/storage/v1/object/public/map-packs/20261029/tr-35.mbtiles",
      "bytes": 123456789, "tiles": 54321, "sha256": "…" }
  ]
}
```

`bytes` indirilecek dosyanın tam boyutudur (uygulama "indirmeden önce boyutu
göster" için kullanır), `sha256` indirmeden sonra doğrulama içindir.

## Bucket

`supabase/migrations/20261109120000_map_packs_bucket.sql`: public, yalnız
`application/x-sqlite3` ve `application/json`, dosya boyutu sınırı projenin
genel sınırından gelir. İstemci yazamaz (politika yok); yükleme service role
anahtarıyla yapılır. Genel sınır Supabase panelinde Storage > Settings'tedir;
Free planda dosya başına 50 MB'tır, büyük il paketleri için Pro plan ve daha
yüksek sınır gerekir.

## Lisans ve atıf

- **Harita verisi:** © OpenStreetMap katkıcıları,
  [ODbL 1.0](https://opendatacommons.org/licenses/odbl/). Kesilen paketler OSM
  verisinden türetilmiş veridir; aynı lisansla dağıtılır ve atıf zorunludur.
- **Karo şeması:** [OpenMapTiles](https://openmaptiles.org/) — şema/tasarım
  CC-BY 4.0, kod BSD-3. Atıf zorunlu: "© OpenMapTiles".
- **OpenFreeMap:** karoları üreten proje, MIT lisanslı. Atfı istenir ama
  zorunlu değil; uygulama yine de gösterir.
- Her paketin `metadata.attribution` alanına ve kataloğa atıf yazılır.
  Uygulama offline haritada da online görünümdeki atfı
  (`apiariesMapAttribution`: "© OpenFreeMap © OpenMapTiles © OpenStreetMap
  katkıcıları") her zaman göstermelidir. OSM bağlantısı:
  <https://www.openstreetmap.org/copyright>.
