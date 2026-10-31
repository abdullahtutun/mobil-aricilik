-- TR referans ilaç listesi: Tarım ve Orman Bakanlığı onaylı ürün
-- bilgilerinden 7 varroa şeridi.
--
-- İlk migration'daki iki örnek TR satırı ("Amitraz şerit", "Oksalik asit
-- damlatma") yumuşak silinir; eski uygulamalar ref_drug_id ile onlara
-- bağlı kalır. Silme ve yeni satırlar telefona sync_pull ile iner.
--
-- Ürün bilgisi (endikasyon, kullanım, dönemler, uyarılar) uygulamada
-- assets/drugs/ilaclar.json içinde, ref_drug_id ile bu satırlara bağlı.
-- Bekleme süresi yalnız bilgide açıkça gün olarak yazıyorsa dolu; diğerleri
-- boş, kullanıcı etiketten girer.

update public.ref_drugs
set deleted_at = now(), updated_at = now()
where id in (
  '01900000-0000-7000-8000-000000000101',
  '01900000-0000-7000-8000-000000000102'
);

insert into public.ref_drugs (id, country_code, name_tr, name_en, active_ingredient, dose_unit, withdrawal_days) values
  ('01900000-0000-7000-8000-000000000201', 'TR', 'Bayvarol Kovan İçi Şerit', 'Bayvarol in-hive strip', 'flumethrin', 'strip', 0),
  ('01900000-0000-7000-8000-000000000202', 'TR', 'BEERAZ Arı Kovanı Şeridi', 'BEERAZ hive strip', 'amitraz', 'strip', null),
  ('01900000-0000-7000-8000-000000000203', 'TR', 'BEEVARFLU Arı Kovanı Şeridi', 'BEEVARFLU hive strip', 'flumethrin', 'strip', 0),
  ('01900000-0000-7000-8000-000000000204', 'TR', 'CheckMite Kovan İçi Şerit', 'CheckMite in-hive strip', 'coumaphos', 'strip', 0),
  ('01900000-0000-7000-8000-000000000205', 'TR', 'FUMBEE Kovan İçi Şerit', 'FUMBEE in-hive strip', 'flumethrin', 'strip', null),
  ('01900000-0000-7000-8000-000000000206', 'TR', 'PolyVar Yellow Kovan Şeridi', 'PolyVar Yellow hive strip', 'flumethrin', 'strip', 0),
  ('01900000-0000-7000-8000-000000000207', 'TR', 'VARODUR Arı Kovanı Şeridi', 'VARODUR hive strip', 'flumethrin', 'strip', 0);
