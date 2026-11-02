-- Offline harita bölge paketleri. OpenFreeMap'in dünya MBTiles dosyasından
-- `tools/map-tiles/cut_packs.py` ile kesilir. Bucket'ta `catalog.json` ve
-- sürümlü paketler (`<sürüm>/<bölge>.mbtiles`) durur. Yükleme betikle,
-- service role anahtarıyla yapılır (RLS'yi aşar).

-- ---------------------------------------------------------------------------
-- Storage: map-packs bucket'ı
-- ---------------------------------------------------------------------------
-- Public bucket: paketler OSM verisi, işletmeye bağlı değil; giriş olmadan
-- CDN'den indirilebilir. Yalnız MBTiles (SQLite) ve katalog JSON'u. Boyut
-- sınırı projenin genel sınırından gelir (il paketleri yüzlerce MB olabilir).
-- İstemci yazamaz: ekleme, güncelleme ve silme politikası yok.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'map-packs',
  'map-packs',
  true,
  null,
  array['application/x-sqlite3', 'application/json']
);
