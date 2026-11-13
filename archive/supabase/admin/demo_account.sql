-- Mağaza incelemesi (App Store, Google Play) için demo işletme ve örnek veri.
--
-- Önce demo kullanıcı açılır (Supabase paneli → Authentication → Add user,
-- ya da Admin API): e-posta `demo@tutunsoft.com`, parola mağaza formuna
-- yazılan 6 haneli sabit kod, e-posta onaylı. Uygulama bu adrese kod
-- göndermez, kodu parola olarak dener (`reviewDemoEmail`,
-- `lib/features/auth/domain/sign_in_rules.dart`). Parola bu dosyada yok.
--
-- Sonra bu betik SQL editöründe (postgres) çalıştırılır. Yeniden
-- çalıştırmak güvenli: demo işletme zaten varsa hiçbir şey yazmaz. Verinin
-- baştan kurulması için önce işletme yumuşak değil, elle silinmelidir.
-- Tarihler çalıştırıldığı güne göredir: muayeneler son iki ayda, görevler
-- önümüzdeki günlerde.

do $$
declare
  demo_email constant text := 'demo@tutunsoft.com';
  org constant uuid := '01900000-0000-7000-8000-00000000de00';
  uid uuid;
  apiary_ids uuid[];
  apiary uuid;
  hive uuid;
  queen uuid;
  group_id uuid;
  harvest uuid;
  treatment uuid;
  n integer := 0;
  a integer;
  now_ts constant timestamptz := date_trunc('hour', now());
begin
  select id into uid from auth.users where email = demo_email;
  if uid is null then
    raise exception 'Önce % kullanıcısını açın', demo_email;
  end if;
  if exists (select 1 from public.organizations where id = org) then
    raise notice 'Demo işletme zaten var; değişiklik yok';
    return;
  end if;

  insert into public.organizations (
    id, name, country_code, currency, hive_count_range, operation_type,
    avatar_color, created_by
  )
  values (
    org, 'Demo Arıcılık', 'TR', 'TRY', 'up_to_50', 'migratory', 'honey', uid
  );
  insert into public.memberships (id, org_id, user_id, role, created_by)
  values (gen_random_uuid(), org, uid, 'owner', uid);

  -- Arılıklar: Muğla çam balı, Ordu kestane, Bursa köy arılığı.
  with rows (name, lon, lat, alt, tenure, water, distance, notes) as (
    values
      ('Yayla Arılığı', 28.3636, 37.2153, 820, 'permitted'::public.apiary_land_tenure,
       'Dere, 200 m', 150, 'Çam balı sezonu için ağustosta getirildi.'),
      ('Kestane Arılığı', 37.8764, 40.9839, 540, 'rented'::public.apiary_land_tenure,
       'Çeşme', 40, null),
      ('Köy Arılığı', 29.0610, 40.1826, 310, 'owned'::public.apiary_land_tenure,
       'Su deposu', 10, 'Kışlak; ana arı yetiştirme burada.')
  ),
  inserted as (
    insert into public.apiaries (
      id, org_id, name, location, altitude_m, land_tenure, water_source,
      vehicle_distance_m, notes, created_by
    )
    select gen_random_uuid(), org, name,
      extensions.st_setsrid(extensions.st_makepoint(lon, lat), 4326)::extensions.geography,
      alt, tenure, water, distance, notes, uid
    from rows
    returning id, name
  )
  select array_agg(id order by array_position(
    array['Yayla Arılığı', 'Kestane Arılığı', 'Köy Arılığı'], name))
  into apiary_ids from inserted;

  -- Kovanlar: arılık başına 6, 5 ve 4; her birinin ana arısı ve ilk konum
  -- kaydı. Köy arılığının son kovanı varroadan sönmüş.
  foreach a in array array[1, 2, 3] loop
    apiary := apiary_ids[a];
    for i in 1 .. (array[6, 5, 4])[a] loop
      n := n + 1;
      queen := gen_random_uuid();
      hive := gen_random_uuid();
      insert into public.queens (
        id, org_id, year, mark_color, breed, source, mating_status,
        wing_clipped, created_by
      )
      values (
        queen, org,
        case when n % 3 = 0 then 2025 else 2026 end,
        case when n % 3 = 0 then 'blue' else 'white' end::public.queen_mark_color,
        case when n % 2 = 0 then 'Kafkas' else 'Anadolu' end,
        case when n % 4 = 0 then 'purchased' else 'own_rearing' end::public.queen_source,
        'mated', n % 5 = 0, uid
      );
      insert into public.hives (
        id, org_id, number, type, status, apiary_id, queen_id, box_count,
        frame_count, source, created_by
      )
      values (
        hive, org, n::text,
        case when n % 4 = 0 then 'dadant' else 'langstroth' end::public.hive_type,
        case when a = 3 and i = 4 then 'dead' else 'active' end::public.hive_status,
        apiary, case when a = 3 and i = 4 then null else queen end,
        case when n % 3 = 0 then 1 else 2 end, 10,
        case when n % 3 = 0 then 'split' else 'purchase' end::public.hive_source,
        uid
      );
      insert into public.hive_location_history (id, org_id, hive_id, apiary_id, moved_at, created_by)
      values (gen_random_uuid(), org, hive, apiary, now_ts - interval '90 days', uid);

      if a = 3 and i = 4 then
        insert into public.hive_status_events (
          id, org_id, hive_id, apiary_id, from_status, to_status, changed_at,
          loss_reason, created_by
        )
        values (
          gen_random_uuid(), org, hive, apiary, 'active', 'dead',
          now_ts - interval '12 days', 'varroa', uid
        );
        continue;
      end if;

      -- İki muayene: 40 ve 10 gün önce.
      insert into public.inspections (
        id, org_id, hive_id, apiary_id, inspected_at, queen_state, bee_frames,
        brood_frames, honey_frames, temperament, swarm_signs, queen_cells,
        disease_suspected, data, created_by
      )
      values
        (gen_random_uuid(), org, hive, apiary, now_ts - interval '40 days' + n * interval '7 minutes',
         'eggs', 8 + n % 3, 4 + n % 2, 3, 'calm', false, 'none', false,
         jsonb_build_object('actions', jsonb_build_array('super_removed')), uid),
        (gen_random_uuid(), org, hive, apiary, now_ts - interval '10 days' + n * interval '7 minutes',
         case when n = 5 then 'none' else 'seen' end::public.inspection_queen_state,
         6 + n % 3, 2 + n % 2, 4 + n % 2,
         case when n % 4 = 0 then 'nervous' else 'calm' end::public.inspection_temperament,
         false,
         case when n = 5 then 'emergency' else 'none' end::public.inspection_queen_cells,
         n = 8,
         jsonb_build_object('actions', jsonb_build_array('fed', 'entrance_reduced')), uid);

      -- Varroa sayımı: 20 gün önce, şeker yöntemi, 300 arı.
      insert into public.mite_counts (
        id, org_id, hive_id, apiary_id, counted_at, method, mites, sample_bees, created_by
      )
      values (
        gen_random_uuid(), org, hive, apiary, now_ts - interval '20 days',
        'sugar_roll', 2 + (n * 7) % 9, 300, uid
      );
    end loop;
  end loop;

  -- Besleme: arılık başına bir oturum, 2:1 şurup, 10 gün önce.
  foreach apiary in array apiary_ids loop
    group_id := gen_random_uuid();
    insert into public.feedings (
      id, org_id, hive_id, apiary_id, feeding_group_id, fed_at, kind, amount, created_by
    )
    select gen_random_uuid(), org, h.id, apiary, group_id,
      now_ts - interval '10 days', 'syrup_2_1', 3, uid
    from public.hives h
    where h.org_id = org and h.apiary_id = apiary and h.status = 'active';
  end loop;

  -- İlaçlama: köy arılığına Bayvarol şerit, 18 gün önce; şeritler 42 günde
  -- çıkarılır. Uygulama ilacı TR referans listesinden.
  group_id := gen_random_uuid();
  insert into public.treatments (
    id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
    active_ingredient, batch_no, dose, dose_unit, started_at,
    planned_removal_at, withdrawal_days, application_id, created_by
  )
  select gen_random_uuid(), org, h.id, h.apiary_id, r.id, r.name_tr,
    r.active_ingredient, 'BV-2026-114', 2, r.dose_unit,
    now_ts - interval '18 days', now_ts + interval '24 days',
    coalesce(r.withdrawal_days, 0), group_id, uid
  from public.hives h
  cross join public.ref_drugs r
  where h.org_id = org and h.apiary_id = apiary_ids[3] and h.status = 'active'
    and r.id = '01900000-0000-7000-8000-000000000201';

  -- Hasat: yayla arılığından çam balı, 55 gün önce.
  harvest := gen_random_uuid();
  insert into public.harvests (
    id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg, created_by
  )
  values (harvest, org, apiary_ids[1], now_ts - interval '55 days', 'pine', 'super', 11, 162.5, uid);
  insert into public.harvest_hives (id, org_id, harvest_id, hive_id, created_by)
  select gen_random_uuid(), org, harvest, h.id, uid
  from public.hives h where h.org_id = org and h.apiary_id = apiary_ids[1];

  -- Kestane balı, 70 gün önce.
  harvest := gen_random_uuid();
  insert into public.harvests (
    id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg, created_by
  )
  values (harvest, org, apiary_ids[2], now_ts - interval '70 days', 'chestnut', 'super', 8, 96, uid);
  insert into public.harvest_hives (id, org_id, harvest_id, hive_id, created_by)
  select gen_random_uuid(), org, harvest, h.id, uid
  from public.hives h where h.org_id = org and h.apiary_id = apiary_ids[2] and h.status = 'active';

  -- Görevler: biri gecikmiş, ikisi önümüzdeki günlerde, biri tamamlanmış.
  insert into public.tasks (id, org_id, title, due_at, apiary_id, hive_id, completed_at, source, created_by)
  values
    (gen_random_uuid(), org, 'Kışlık şurup kontrolü', now_ts - interval '2 days', apiary_ids[1], null, null, 'manual', uid),
    (gen_random_uuid(), org, '5 numaralı kovanda ana arı kontrolü', now_ts + interval '2 days', apiary_ids[1],
     (select id from public.hives where org_id = org and number = '5'), null, 'manual', uid),
    (gen_random_uuid(), org, 'Şeritleri çıkar', now_ts + interval '24 days', apiary_ids[3], null, null, 'manual', uid),
    (gen_random_uuid(), org, 'Kovan altlıklarını temizle', now_ts - interval '6 days', apiary_ids[2], null,
     now_ts - interval '5 days', 'manual', uid);

  -- Finans: bal satışı ve masraflar.
  insert into public.transactions (
    id, org_id, kind, category, amount, currency, occurred_on, description, apiary_id, created_by
  )
  values
    (gen_random_uuid(), org, 'income', 'honey', 48750, 'TRY', (now_ts - interval '45 days')::date, 'Çam balı, 162 kg', apiary_ids[1], uid),
    (gen_random_uuid(), org, 'income', 'honey', 33600, 'TRY', (now_ts - interval '60 days')::date, 'Kestane balı, 96 kg', apiary_ids[2], uid),
    (gen_random_uuid(), org, 'expense', 'feeding', 6200, 'TRY', (now_ts - interval '11 days')::date, 'Şeker, 200 kg', null, uid),
    (gen_random_uuid(), org, 'expense', 'treatment', 1450, 'TRY', (now_ts - interval '19 days')::date, 'Bayvarol, 2 kutu', apiary_ids[3], uid),
    (gen_random_uuid(), org, 'expense', 'fuel_transport', 9800, 'TRY', (now_ts - interval '85 days')::date, 'Yaylaya nakliye', apiary_ids[1], uid),
    (gen_random_uuid(), org, 'expense', 'land_rent', 5000, 'TRY', (now_ts - interval '80 days')::date, 'Kestane arılığı yer kirası', apiary_ids[2], uid);

  raise notice 'Demo işletme kuruldu: % kovan', n;
end;
$$;
