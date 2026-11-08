-- Mağaza ekran görüntüleri: yerel demo işletmeyi Rusçaya çevirir. YALNIZ
-- YEREL DB'de, `supabase/admin/demo_account.sql`'den hemen sonra
-- (`tool/store_screenshots.py --lang ru` kendisi çalıştırır). Para birimi
-- RUB, tutarlar yaklaşık ruble karşılığı (1 TRY ≈ 2,2 RUB).

do $$
declare
  org constant uuid := '01900000-0000-7000-8000-00000000de00';
begin
  update public.organizations
  set name = 'Демо пасека', currency = 'RUB', updated_at = now()
  where id = org;

  update public.apiaries a
  set name = v.name_ru, water_source = v.water_ru, notes = v.notes_ru,
      updated_at = now()
  from (values
    ('Yayla Arılığı', 'Горная пасека', 'Ручей, 200 м',
     'Привезли в августе к сезону соснового мёда.'),
    ('Kestane Arılığı', 'Каштановая пасека', 'Родник', null),
    ('Köy Arılığı', 'Деревенская пасека', 'Бак с водой',
     'Зимовник; здесь выводим маток.')
  ) as v (name_tr, name_ru, water_ru, notes_ru)
  where a.org_id = org and a.name = v.name_tr;

  update public.queens
  set breed = case breed when 'Kafkas' then 'Кавказская'
                         when 'Anadolu' then 'Анатолийская' else breed end,
      updated_at = now()
  where org_id = org;

  update public.tasks t
  set title = v.ru, updated_at = now()
  from (values
    ('Kışlık şurup kontrolü', 'Проверить зимний сироп'),
    ('5 numaralı kovanda ana arı kontrolü', 'Проверить матку в улье 5'),
    ('Şeritleri çıkar', 'Снять полоски'),
    ('Kovan altlıklarını temizle', 'Почистить донья ульев')
  ) as v (tr, ru)
  where t.org_id = org and t.title = v.tr;

  update public.transactions x
  set description = v.ru, amount = v.rub, currency = 'RUB', updated_at = now()
  from (values
    ('Çam balı, 162 kg', 'Сосновый мёд, 162 кг', 107000),
    ('Kestane balı, 96 kg', 'Каштановый мёд, 96 кг', 74000),
    ('Şeker, 200 kg', 'Сахар, 200 кг', 13600),
    ('Bayvarol, 2 kutu', 'Байварол, 2 упаковки', 3200),
    ('Yaylaya nakliye', 'Перевозка на горную точку', 21500),
    ('Kestane arılığı yer kirası', 'Аренда точки, Каштановая пасека', 11000)
  ) as v (tr, ru, rub)
  where x.org_id = org and x.description = v.tr;
end;
$$;
