-- Offline harita il paketlerinden vazgeçildi: telefon arılık çevresini
-- doğrudan OpenFreeMap'ten indiriyor. `20261109120000_map_packs_bucket.sql`
-- ile açılan `map-packs` bucket'ı kaldırılır.
--
-- Supabase storage tablolarından doğrudan silmeyi `storage.protect_delete`
-- ile engeller (yetim dosya kalmasın diye). Bucket boşsa yetim dosya
-- olmaz; koruma bu işlem için `storage.allow_delete_query` ile kapatılır.
-- Bucket'ta dosya varsa migration hiçbir şey silmeden durur; önce Storage
-- API ile boşaltılmalı.

do $$
begin
  if exists (select 1 from storage.objects where bucket_id = 'map-packs') then
    raise exception 'map-packs bucket''ı boş değil; önce Storage API ile boşaltın';
  end if;
end;
$$;

set local storage.allow_delete_query = 'true';

delete from storage.buckets where id = 'map-packs';
