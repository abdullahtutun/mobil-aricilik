-- Mağaza ekran görüntüleri: yerel demo işletmeyi Farsçaya çevirir. YALNIZ
-- YEREL DB'de, `supabase/admin/demo_account.sql`'den hemen sonra
-- (`tool/store_screenshots.py --lang fa` kendisi çalıştırır). Para birimi
-- IRR, tutarlar yaklaşık riyal karşılığı (1 USD ≈ 1.000.000 IRR).

do $$
declare
  org constant uuid := '01900000-0000-7000-8000-00000000de00';
begin
  update public.organizations
  set name = 'زنبورستان نمونه', currency = 'IRR', updated_at = now()
  where id = org;

  update public.apiaries a
  set name = v.name_fa, water_source = v.water_fa, notes = v.notes_fa,
      updated_at = now()
  from (values
    ('Yayla Arılığı', 'زنبورستان کوهستان', 'جوی آب، ۲۰۰ متر',
     'مرداد برای عسل کاج به کوهستان آوردیم.'),
    ('Kestane Arılığı', 'زنبورستان شاه‌بلوط', 'چشمه', null),
    ('Köy Arılığı', 'زنبورستان روستا', 'منبع آب',
     'محل زمستان‌گذرانی؛ ملکه‌پروری اینجاست.')
  ) as v (name_tr, name_fa, water_fa, notes_fa)
  where a.org_id = org and a.name = v.name_tr;

  update public.queens
  set breed = case breed when 'Kafkas' then 'قفقازی'
                         when 'Anadolu' then 'آناتولی' else breed end,
      updated_at = now()
  where org_id = org;

  update public.tasks t
  set title = v.fa, updated_at = now()
  from (values
    ('Kışlık şurup kontrolü', 'بررسی شربت زمستانی'),
    ('5 numaralı kovanda ana arı kontrolü', 'بررسی ملکهٔ کندوی ۵'),
    ('Şeritleri çıkar', 'برداشتن نوارها'),
    ('Kovan altlıklarını temizle', 'تمیز کردن کف کندوها')
  ) as v (tr, fa)
  where t.org_id = org and t.title = v.tr;

  update public.transactions x
  set description = v.fa, amount = v.irr, currency = 'IRR', updated_at = now()
  from (values
    ('Çam balı, 162 kg', 'عسل کاج، ۱۶۲ کیلو', 1220000000),
    ('Kestane balı, 96 kg', 'عسل شاه‌بلوط، ۹۶ کیلو', 840000000),
    ('Şeker, 200 kg', 'شکر، ۲۰۰ کیلو', 155000000),
    ('Bayvarol, 2 kutu', 'بایوارول، ۲ جعبه', 36000000),
    ('Yaylaya nakliye', 'حمل به کوهستان', 245000000),
    ('Kestane arılığı yer kirası', 'اجارهٔ زمین زنبورستان شاه‌بلوط', 125000000)
  ) as v (tr, fa, irr)
  where x.org_id = org and x.description = v.tr;
end;
$$;
