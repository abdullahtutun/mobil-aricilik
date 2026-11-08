-- Mağaza ekran görüntüleri: yerel Supabase'deki demo işletmenin metinlerini
-- İngilizceye çevirir. YALNIZ YEREL DB'de, `supabase/admin/demo_account.sql`
-- yüklendikten sonra çalıştırılır; prod'daki inceleme hesabı Türkçe kalır.
--
-- Arılıklar Türkiye'deki yerlerinde kalır (harita ve hava durumu gerçek
-- yerleri gösterir); para birimi USD, tutarlar yaklaşık dolar karşılığı.

do $$
declare
  org constant uuid := '01900000-0000-7000-8000-00000000de00';
begin
  update public.organizations
  set name = 'Demo Honey Farm', currency = 'USD', updated_at = now()
  where id = org;

  update public.apiaries a
  set name = v.name_en, water_source = v.water_en, notes = v.notes_en,
      updated_at = now()
  from (values
    ('Yayla Arılığı', 'Highland Apiary', 'Stream, 200 m',
     'Brought up in August for the pine honey season.'),
    ('Kestane Arılığı', 'Chestnut Apiary', 'Spring', null),
    ('Köy Arılığı', 'Village Apiary', 'Water tank',
     'Winter yard; queen rearing happens here.')
  ) as v (name_tr, name_en, water_en, notes_en)
  where a.org_id = org and a.name = v.name_tr;

  update public.queens
  set breed = case breed when 'Kafkas' then 'Caucasian'
                         when 'Anadolu' then 'Anatolian' else breed end,
      updated_at = now()
  where org_id = org;

  update public.tasks t
  set title = v.en, updated_at = now()
  from (values
    ('Kışlık şurup kontrolü', 'Check winter syrup'),
    ('5 numaralı kovanda ana arı kontrolü', 'Check the queen in hive 5'),
    ('Şeritleri çıkar', 'Remove the strips'),
    ('Kovan altlıklarını temizle', 'Clean the bottom boards')
  ) as v (tr, en)
  where t.org_id = org and t.title = v.tr;

  -- Finans hareketleri yalnız eklenen kayıt; yerel ekran görüntüsü için
  -- doğrudan düzeltilir. Tutarlar ~40 TRY = 1 USD.
  update public.transactions x
  set description = v.en, amount = v.usd, currency = 'USD', updated_at = now()
  from (values
    ('Çam balı, 162 kg', 'Pine honey, 162 kg', 1220),
    ('Kestane balı, 96 kg', 'Chestnut honey, 96 kg', 840),
    ('Şeker, 200 kg', 'Sugar, 200 kg', 155),
    ('Bayvarol, 2 kutu', 'Bayvarol, 2 boxes', 36),
    ('Yaylaya nakliye', 'Trucking to the highland', 245),
    ('Kestane arılığı yer kirası', 'Chestnut apiary site rent', 125)
  ) as v (tr, en, usd)
  where x.org_id = org and x.description = v.tr;
end;
$$;
