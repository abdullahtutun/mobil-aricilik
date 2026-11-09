-- Mağaza ekran görüntüleri: yerel demo işletmeyi Almancaya çevirir. YALNIZ
-- YEREL DB'de, `supabase/admin/demo_account.sql`'den hemen sonra
-- (`tool/store_screenshots.py --lang de` kendisi çalıştırır). Para birimi
-- EUR, tutarlar yaklaşık euro karşılığı (1 USD ≈ 0,92 EUR). Uygulamada
-- arılık "Stand", kovan "Volk".

do $$
declare
  org constant uuid := '01900000-0000-7000-8000-00000000de00';
begin
  update public.organizations
  set name = 'Demo-Imkerei', currency = 'EUR', updated_at = now()
  where id = org;

  update public.apiaries a
  set name = v.name_de, water_source = v.water_de, notes = v.notes_de,
      updated_at = now()
  from (values
    ('Yayla Arılığı', 'Bergstand', 'Bach, 200 m',
     'Im August für die Waldtracht hochgewandert.'),
    ('Kestane Arılığı', 'Kastanienstand', 'Quelle', null),
    ('Köy Arılığı', 'Dorfstand', 'Wassertank',
     'Überwinterungsstand; hier ziehen wir Königinnen.')
  ) as v (name_tr, name_de, water_de, notes_de)
  where a.org_id = org and a.name = v.name_tr;

  update public.queens
  set breed = case breed when 'Kafkas' then 'Kaukasische'
                         when 'Anadolu' then 'Anatolische' else breed end,
      updated_at = now()
  where org_id = org;

  update public.tasks t
  set title = v.de, updated_at = now()
  from (values
    ('Kışlık şurup kontrolü', 'Winterfutter prüfen'),
    ('5 numaralı kovanda ana arı kontrolü', 'Königin in Volk 5 prüfen'),
    ('Şeritleri çıkar', 'Streifen entfernen'),
    ('Kovan altlıklarını temizle', 'Bodenbretter reinigen')
  ) as v (tr, de)
  where t.org_id = org and t.title = v.tr;

  update public.transactions x
  set description = v.de, amount = v.eur, currency = 'EUR', updated_at = now()
  from (values
    ('Çam balı, 162 kg', 'Kiefernhonig, 162 kg', 1120),
    ('Kestane balı, 96 kg', 'Kastanienhonig, 96 kg', 770),
    ('Şeker, 200 kg', 'Zucker, 200 kg', 140),
    ('Bayvarol, 2 kutu', 'Bayvarol, 2 Packungen', 33),
    ('Yaylaya nakliye', 'Wanderung zum Bergstand', 225),
    ('Kestane arılığı yer kirası', 'Standmiete Kastanienstand', 115)
  ) as v (tr, de, eur)
  where x.org_id = org and x.description = v.tr;
end;
$$;
