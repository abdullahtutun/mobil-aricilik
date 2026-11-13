-- Mağaza ekran görüntüleri: yerel demo işletmeyi Hintçeye çevirir. YALNIZ
-- YEREL DB'de, `seed demo`'dan hemen sonra
-- (`tool/store_screenshots.py --lang hi` kendisi çalıştırır). Para birimi
-- INR, tutarlar yaklaşık rupi karşılığı (1 USD ≈ 88 INR). Uygulamada
-- arılık "फार्म".

-- SQLite (PocketBase'in `pb_data/data.db`'si); tek transaction.

begin;

update organizations
set name = 'डेमो मधुमक्खी फार्म', currency = 'INR', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where id = '01900000-0000-7000-8000-00000000de00';

with v (name_tr, name_hi, water_hi, notes_hi) as (values
  ('Yayla Arılığı', 'पहाड़ी फार्म', 'झरना, 200 मी',
   'अगस्त में चीड़ के शहद के लिए लाए।'),
  ('Kestane Arılığı', 'चेस्टनट फार्म', 'सोता', ''),
  ('Köy Arılığı', 'गाँव फार्म', 'पानी की टंकी',
   'सर्दियों का ठिकाना; रानी पालन यहीं होता है।')
)
update apiaries as a
set name = v.name_hi, water_source = v.water_hi, notes = v.notes_hi,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where a.org_id = '01900000-0000-7000-8000-00000000de00' and a.name = v.name_tr;

update queens
set breed = case breed when 'Kafkas' then 'कॉकेशियन'
                       when 'Anadolu' then 'अनातोलियन' else breed end,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where org_id = '01900000-0000-7000-8000-00000000de00';

with v (tr, hi) as (values
  ('Kışlık şurup kontrolü', 'सर्दियों का शरबत जाँचें'),
  ('5 numaralı kovanda ana arı kontrolü', 'छत्ता 5 की रानी जाँचें'),
  ('Şeritleri çıkar', 'पट्टियाँ हटाएँ'),
  ('Kovan altlıklarını temizle', 'छत्तों के तल साफ़ करें')
)
update tasks as t
set title = v.hi, updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where t.org_id = '01900000-0000-7000-8000-00000000de00' and t.title = v.tr;

with v (tr, hi, inr) as (values
  ('Çam balı, 162 kg', 'चीड़ का शहद, 162 किलो', 107000),
  ('Kestane balı, 96 kg', 'चेस्टनट शहद, 96 किलो', 74000),
  ('Şeker, 200 kg', 'चीनी, 200 किलो', 13600),
  ('Bayvarol, 2 kutu', 'बायवारोल, 2 डिब्बे', 3200),
  ('Yaylaya nakliye', 'पहाड़ तक ढुलाई', 21500),
  ('Kestane arılığı yer kirası', 'चेस्टनट फार्म का किराया', 11000)
)
update transactions as x
set description = v.hi, amount = v.inr, currency = 'INR', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where x.org_id = '01900000-0000-7000-8000-00000000de00' and x.description = v.tr;

commit;
