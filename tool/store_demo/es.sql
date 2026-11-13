-- Mağaza ekran görüntüleri: yerel demo işletmeyi İspanyolcaya (es-419)
-- çevirir. YALNIZ YEREL DB'de, `seed demo`'dan hemen
-- sonra (`tool/store_screenshots.py --lang es` kendisi çalıştırır). Para
-- birimi MXN (Latin Amerika'nın en büyük pazarı), tutarlar yaklaşık peso
-- karşılığı (1 USD ≈ 18 MXN).

-- SQLite (PocketBase'in `pb_data/data.db`'si); tek transaction.

begin;

update organizations
set name = 'Apícola Demo', currency = 'MXN', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where id = '01900000-0000-7000-8000-00000000de00';

with v (name_tr, name_es, water_es, notes_es) as (values
  ('Yayla Arılığı', 'Colmenar de la Sierra', 'Arroyo, 200 m',
   'Subimos en agosto para la miel de pino.'),
  ('Kestane Arılığı', 'Colmenar del Castaño', 'Manantial', ''),
  ('Köy Arılığı', 'Colmenar del Pueblo', 'Tanque de agua',
   'Invernada; aquí criamos reinas.')
)
update apiaries as a
set name = v.name_es, water_source = v.water_es, notes = v.notes_es,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where a.org_id = '01900000-0000-7000-8000-00000000de00' and a.name = v.name_tr;

update queens
set breed = case breed when 'Kafkas' then 'Caucásica'
                       when 'Anadolu' then 'Anatólica' else breed end,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where org_id = '01900000-0000-7000-8000-00000000de00';

with v (tr, es) as (values
  ('Kışlık şurup kontrolü', 'Revisar el jarabe de invierno'),
  ('5 numaralı kovanda ana arı kontrolü', 'Revisar la reina de la colmena 5'),
  ('Şeritleri çıkar', 'Retirar las tiras'),
  ('Kovan altlıklarını temizle', 'Limpiar los pisos de las colmenas')
)
update tasks as t
set title = v.es, updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where t.org_id = '01900000-0000-7000-8000-00000000de00' and t.title = v.tr;

with v (tr, es, mxn) as (values
  ('Çam balı, 162 kg', 'Miel de pino, 162 kg', 22000),
  ('Kestane balı, 96 kg', 'Miel de castaño, 96 kg', 15100),
  ('Şeker, 200 kg', 'Azúcar, 200 kg', 2800),
  ('Bayvarol, 2 kutu', 'Bayvarol, 2 cajas', 650),
  ('Yaylaya nakliye', 'Flete a la sierra', 4400),
  ('Kestane arılığı yer kirası', 'Renta del Colmenar del Castaño', 2250)
)
update transactions as x
set description = v.es, amount = v.mxn, currency = 'MXN', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where x.org_id = '01900000-0000-7000-8000-00000000de00' and x.description = v.tr;

commit;
