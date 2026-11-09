-- Mağaza ekran görüntüleri: yerel demo işletmeyi Hintçeye çevirir. YALNIZ
-- YEREL DB'de, `supabase/admin/demo_account.sql`'den hemen sonra
-- (`tool/store_screenshots.py --lang hi` kendisi çalıştırır). Para birimi
-- INR, tutarlar yaklaşık rupi karşılığı (1 USD ≈ 88 INR). Uygulamada
-- arılık "फार्म".

do $$
declare
  org constant uuid := '01900000-0000-7000-8000-00000000de00';
begin
  update public.organizations
  set name = 'डेमो मधुमक्खी फार्म', currency = 'INR', updated_at = now()
  where id = org;

  update public.apiaries a
  set name = v.name_hi, water_source = v.water_hi, notes = v.notes_hi,
      updated_at = now()
  from (values
    ('Yayla Arılığı', 'पहाड़ी फार्म', 'झरना, 200 मी',
     'अगस्त में चीड़ के शहद के लिए लाए।'),
    ('Kestane Arılığı', 'चेस्टनट फार्म', 'सोता', null),
    ('Köy Arılığı', 'गाँव फार्म', 'पानी की टंकी',
     'सर्दियों का ठिकाना; रानी पालन यहीं होता है।')
  ) as v (name_tr, name_hi, water_hi, notes_hi)
  where a.org_id = org and a.name = v.name_tr;

  update public.queens
  set breed = case breed when 'Kafkas' then 'कॉकेशियन'
                         when 'Anadolu' then 'अनातोलियन' else breed end,
      updated_at = now()
  where org_id = org;

  update public.tasks t
  set title = v.hi, updated_at = now()
  from (values
    ('Kışlık şurup kontrolü', 'सर्दियों का शरबत जाँचें'),
    ('5 numaralı kovanda ana arı kontrolü', 'छत्ता 5 की रानी जाँचें'),
    ('Şeritleri çıkar', 'पट्टियाँ हटाएँ'),
    ('Kovan altlıklarını temizle', 'छत्तों के तल साफ़ करें')
  ) as v (tr, hi)
  where t.org_id = org and t.title = v.tr;

  update public.transactions x
  set description = v.hi, amount = v.inr, currency = 'INR', updated_at = now()
  from (values
    ('Çam balı, 162 kg', 'चीड़ का शहद, 162 किलो', 107000),
    ('Kestane balı, 96 kg', 'चेस्टनट शहद, 96 किलो', 74000),
    ('Şeker, 200 kg', 'चीनी, 200 किलो', 13600),
    ('Bayvarol, 2 kutu', 'बायवारोल, 2 डिब्बे', 3200),
    ('Yaylaya nakliye', 'पहाड़ तक ढुलाई', 21500),
    ('Kestane arılığı yer kirası', 'चेस्टनट फार्म का किराया', 11000)
  ) as v (tr, hi, inr)
  where x.org_id = org and x.description = v.tr;
end;
$$;
