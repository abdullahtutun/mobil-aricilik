-- TR referans ilaç listesine 4 amitraz ürünü: Rulamit, Rulamit-Va,
-- Vamitrat-Va (şerit) ve Varroset (tütsü kağıdı; tek seferlik yakıldığı
-- için birimi doz).
--
-- Bu ürünlerin yalnız adı ve etken maddesi biliniyor; bekleme süresi boş,
-- kullanıcı etiketten girer. assets/drugs/ilaclar.json'da da yalnız ad ve
-- etken madde var.

insert into public.ref_drugs (id, country_code, name_tr, name_en, active_ingredient, dose_unit) values
  ('01900000-0000-7000-8000-000000000208', 'TR', 'Rulamit', 'Rulamit', 'amitraz', 'strip'),
  ('01900000-0000-7000-8000-000000000209', 'TR', 'Rulamit-Va', 'Rulamit-Va', 'amitraz', 'strip'),
  ('01900000-0000-7000-8000-000000000210', 'TR', 'Vamitrat-Va', 'Vamitrat-Va', 'amitraz', 'strip'),
  ('01900000-0000-7000-8000-000000000211', 'TR', 'Varroset', 'Varroset', 'amitraz', 'dose');
