-- Mağaza ekran görüntüleri: yerel PocketBase'deki demo işletmenin metinlerini
-- İngilizceye çevirir. YALNIZ YEREL DB'de, `seed demo`
-- yazıldıktan sonra çalıştırılır; prod'daki inceleme hesabı Türkçe kalır.
--
-- Arılıklar Türkiye'deki yerlerinde kalır (harita ve hava durumu gerçek
-- yerleri gösterir); para birimi USD, tutarlar yaklaşık dolar karşılığı.

-- SQLite (PocketBase'in `pb_data/data.db`'si); tek transaction.

begin;

update organizations
set name = 'Demo Honey Farm', currency = 'USD', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where id = '01900000-0000-7000-8000-00000000de00';

with v (name_tr, name_en, water_en, notes_en) as (values
  ('Yayla Arılığı', 'Highland Apiary', 'Stream, 200 m',
   'Brought up in August for the pine honey season.'),
  ('Kestane Arılığı', 'Chestnut Apiary', 'Spring', ''),
  ('Köy Arılığı', 'Village Apiary', 'Water tank',
   'Winter yard; queen rearing happens here.')
)
update apiaries as a
set name = v.name_en, water_source = v.water_en, notes = v.notes_en,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where a.org_id = '01900000-0000-7000-8000-00000000de00' and a.name = v.name_tr;

update queens
set breed = case breed when 'Kafkas' then 'Caucasian'
                       when 'Anadolu' then 'Anatolian' else breed end,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where org_id = '01900000-0000-7000-8000-00000000de00';

with v (tr, en) as (values
  ('Kışlık şurup kontrolü', 'Check winter syrup'),
  ('5 numaralı kovanda ana arı kontrolü', 'Check the queen in hive 5'),
  ('Şeritleri çıkar', 'Remove the strips'),
  ('Kovan altlıklarını temizle', 'Clean the bottom boards')
)
update tasks as t
set title = v.en, updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where t.org_id = '01900000-0000-7000-8000-00000000de00' and t.title = v.tr;

-- Finans hareketleri yalnız eklenen kayıt; yerel ekran görüntüsü için
-- doğrudan düzeltilir. Tutarlar ~40 TRY = 1 USD.
with v (tr, en, usd) as (values
  ('Çam balı, 162 kg', 'Pine honey, 162 kg', 1220),
  ('Kestane balı, 96 kg', 'Chestnut honey, 96 kg', 840),
  ('Şeker, 200 kg', 'Sugar, 200 kg', 155),
  ('Bayvarol, 2 kutu', 'Bayvarol, 2 boxes', 36),
  ('Yaylaya nakliye', 'Trucking to the highland', 245),
  ('Kestane arılığı yer kirası', 'Chestnut apiary site rent', 125)
)
update transactions as x
set description = v.en, amount = v.usd, currency = 'USD', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where x.org_id = '01900000-0000-7000-8000-00000000de00' and x.description = v.tr;

commit;
