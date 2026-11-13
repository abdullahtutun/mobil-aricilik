-- Mağaza ekran görüntüleri: yerel demo işletmeyi Portekizceye (pt-BR)
-- çevirir. YALNIZ YEREL DB'de, `seed demo`'dan hemen
-- sonra (`tool/store_screenshots.py --lang pt` kendisi çalıştırır). Para
-- birimi BRL, tutarlar yaklaşık real karşılığı (1 USD ≈ 5,5 BRL).

-- SQLite (PocketBase'in `pb_data/data.db`'si); tek transaction.

begin;

update organizations
set name = 'Apiário Demo', currency = 'BRL', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where id = '01900000-0000-7000-8000-00000000de00';

with v (name_tr, name_pt, water_pt, notes_pt) as (values
  ('Yayla Arılığı', 'Apiário da Serra', 'Riacho, 200 m',
   'Subimos em agosto para o mel de pinheiro.'),
  ('Kestane Arılığı', 'Apiário da Castanheira', 'Nascente', ''),
  ('Köy Arılığı', 'Apiário do Sítio', 'Caixa d''água',
   'Inverno; aqui criamos rainhas.')
)
update apiaries as a
set name = v.name_pt, water_source = v.water_pt, notes = v.notes_pt,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where a.org_id = '01900000-0000-7000-8000-00000000de00' and a.name = v.name_tr;

update queens
set breed = case breed when 'Kafkas' then 'Caucasiana'
                       when 'Anadolu' then 'Anatoliana' else breed end,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where org_id = '01900000-0000-7000-8000-00000000de00';

with v (tr, pt) as (values
  ('Kışlık şurup kontrolü', 'Conferir o xarope de inverno'),
  ('5 numaralı kovanda ana arı kontrolü', 'Conferir a rainha da colmeia 5'),
  ('Şeritleri çıkar', 'Retirar as tiras'),
  ('Kovan altlıklarını temizle', 'Limpar os fundos das colmeias')
)
update tasks as t
set title = v.pt, updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where t.org_id = '01900000-0000-7000-8000-00000000de00' and t.title = v.tr;

with v (tr, pt, brl) as (values
  ('Çam balı, 162 kg', 'Mel de pinheiro, 162 kg', 6700),
  ('Kestane balı, 96 kg', 'Mel de castanheira, 96 kg', 4600),
  ('Şeker, 200 kg', 'Açúcar, 200 kg', 850),
  ('Bayvarol, 2 kutu', 'Bayvarol, 2 caixas', 200),
  ('Yaylaya nakliye', 'Frete para a serra', 1350),
  ('Kestane arılığı yer kirası', 'Aluguel do Apiário da Castanheira', 690)
)
update transactions as x
set description = v.pt, amount = v.brl, currency = 'BRL', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where x.org_id = '01900000-0000-7000-8000-00000000de00' and x.description = v.tr;

commit;
