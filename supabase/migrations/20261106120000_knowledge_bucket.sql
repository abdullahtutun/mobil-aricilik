-- Bilgi bankası içerik paketleri: uygulama güncellemesi olmadan yeni
-- makale. Bucket'ta `manifest.json` (format, version, path, sha256) ve
-- sürümlü paket (`knowledge-v<N>.json`) durur. Uygulama manifestteki sürüm
-- elindekinden büyükse paketi indirir, SHA-256'sını doğrular ve yerelde
-- saklar. Yükleme `tool/publish_knowledge.dart` ile service role
-- anahtarıyla yapılır (RLS'yi aşar).

-- ---------------------------------------------------------------------------
-- Storage: knowledge bucket'ı
-- ---------------------------------------------------------------------------
-- Özel bucket; yalnız JSON, 10 MB. İçerik işletmeye bağlı değil: girişli
-- herkes okur. İstemci yazamaz: ekleme, güncelleme ve silme politikası yok.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('knowledge', 'knowledge', false, 10485760, array['application/json']);

create policy "Girişli kullanıcı bilgi bankası paketlerini okur"
on storage.objects for select
to authenticated
using (bucket_id = 'knowledge');
