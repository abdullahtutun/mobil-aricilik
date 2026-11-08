-- Mağaza ekran görüntüleri: yerel demo işletmeyi Ukraynacaya çevirir. YALNIZ
-- YEREL DB'de, `supabase/admin/demo_account.sql`'den hemen sonra
-- (`tool/store_screenshots.py --lang uk` kendisi çalıştırır). Para birimi
-- UAH, tutarlar yaklaşık hryvnia karşılığı (1 USD ≈ 41 UAH).

do $$
declare
  org constant uuid := '01900000-0000-7000-8000-00000000de00';
begin
  update public.organizations
  set name = 'Демо пасіка', currency = 'UAH', updated_at = now()
  where id = org;

  update public.apiaries a
  set name = v.name_uk, water_source = v.water_uk, notes = v.notes_uk,
      updated_at = now()
  from (values
    ('Yayla Arılığı', 'Гірська пасіка', 'Струмок, 200 м',
     'Привезли в серпні на сосновий мед.'),
    ('Kestane Arılığı', 'Каштанова пасіка', 'Джерело', null),
    ('Köy Arılığı', 'Сільська пасіка', 'Бак з водою',
     'Зимівник; тут виводимо маток.')
  ) as v (name_tr, name_uk, water_uk, notes_uk)
  where a.org_id = org and a.name = v.name_tr;

  update public.queens
  set breed = case breed when 'Kafkas' then 'Кавказька'
                         when 'Anadolu' then 'Анатолійська' else breed end,
      updated_at = now()
  where org_id = org;

  update public.tasks t
  set title = v.uk, updated_at = now()
  from (values
    ('Kışlık şurup kontrolü', 'Перевірити зимовий сироп'),
    ('5 numaralı kovanda ana arı kontrolü', 'Перевірити матку у вулику 5'),
    ('Şeritleri çıkar', 'Зняти смужки'),
    ('Kovan altlıklarını temizle', 'Почистити дна вуликів')
  ) as v (tr, uk)
  where t.org_id = org and t.title = v.tr;

  update public.transactions x
  set description = v.uk, amount = v.uah, currency = 'UAH', updated_at = now()
  from (values
    ('Çam balı, 162 kg', 'Сосновий мед, 162 кг', 50000),
    ('Kestane balı, 96 kg', 'Каштановий мед, 96 кг', 34500),
    ('Şeker, 200 kg', 'Цукор, 200 кг', 6400),
    ('Bayvarol, 2 kutu', 'Байварол, 2 упаковки', 1500),
    ('Yaylaya nakliye', 'Перевезення в гори', 10000),
    ('Kestane arılığı yer kirası', 'Оренда точки, Каштанова пасіка', 5100)
  ) as v (tr, uk, uah)
  where x.org_id = org and x.description = v.tr;
end;
$$;
