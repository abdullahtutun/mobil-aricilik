-- Hava sağlayıcısı Open-Meteo'dan WeatherAPI.com'a geçti. Tahminin biçimi
-- değişti (WMO `weather_code` yerine sağlayıcıdan bağımsız `condition`);
-- eski biçimdeki önbellek satırları istemciye gitmesin diye silinir.
-- Hücreler ilk çağrıda WeatherAPI'den yeniden dolar.

delete from public.weather_cache;

comment on table public.weather_cache is
  'weather-bundle Edge Function''ının WeatherAPI.com önbelleği; 0,01°''lik hücre başına son tahmin. Yalnız service_role.';
