-- Mağaza ekran görüntüleri: yerel demo işletmeyi Almancaya çevirir. YALNIZ
-- YEREL DB'de, `seed demo`'dan hemen sonra
-- (`tool/store_screenshots.py --lang de` kendisi çalıştırır). Para birimi
-- EUR, tutarlar yaklaşık euro karşılığı (1 USD ≈ 0,92 EUR). Uygulamada
-- arılık "Stand", kovan "Volk".

-- SQLite (PocketBase'in `pb_data/data.db`'si); tek transaction.

begin;

update organizations
set name = 'Demo-Imkerei', currency = 'EUR', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where id = '01900000-0000-7000-8000-00000000de00';

with v (name_tr, name_de, water_de, notes_de) as (values
  ('Yayla Arılığı', 'Bergstand', 'Bach, 200 m',
   'Im August für die Waldtracht hochgewandert.'),
  ('Kestane Arılığı', 'Kastanienstand', 'Quelle', ''),
  ('Köy Arılığı', 'Dorfstand', 'Wassertank',
   'Überwinterungsstand; hier ziehen wir Königinnen.')
)
update apiaries as a
set name = v.name_de, water_source = v.water_de, notes = v.notes_de,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where a.org_id = '01900000-0000-7000-8000-00000000de00' and a.name = v.name_tr;

update queens
set breed = case breed when 'Kafkas' then 'Kaukasische'
                       when 'Anadolu' then 'Anatolische' else breed end,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where org_id = '01900000-0000-7000-8000-00000000de00';

with v (tr, de) as (values
  ('Kışlık şurup kontrolü', 'Winterfutter prüfen'),
  ('5 numaralı kovanda ana arı kontrolü', 'Königin in Volk 5 prüfen'),
  ('Şeritleri çıkar', 'Streifen entfernen'),
  ('Kovan altlıklarını temizle', 'Bodenbretter reinigen')
)
update tasks as t
set title = v.de, updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where t.org_id = '01900000-0000-7000-8000-00000000de00' and t.title = v.tr;

with v (tr, de, eur) as (values
  ('Çam balı, 162 kg', 'Kiefernhonig, 162 kg', 1120),
  ('Kestane balı, 96 kg', 'Kastanienhonig, 96 kg', 770),
  ('Şeker, 200 kg', 'Zucker, 200 kg', 140),
  ('Bayvarol, 2 kutu', 'Bayvarol, 2 Packungen', 33),
  ('Yaylaya nakliye', 'Wanderung zum Bergstand', 225),
  ('Kestane arılığı yer kirası', 'Standmiete Kastanienstand', 115)
)
update transactions as x
set description = v.de, amount = v.eur, currency = 'EUR', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where x.org_id = '01900000-0000-7000-8000-00000000de00' and x.description = v.tr;

commit;
