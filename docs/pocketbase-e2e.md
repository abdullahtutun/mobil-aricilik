# PocketBase dev uçtan uca kontrol listesi (P9.2)

Gerçek telefonlarla, gerçek dev sunucusuna (`https://arici-api-dev.tutunsoft.com`) karşı her özelliğin denenmesi. Plan: [pocketbase-gecis.md](pocketbase-gecis.md) P9.2. Adım, aşağıdaki 11 madde ☑ olunca biter.

İşaretler: ☐ denenmedi · ☑ geçti · ☒ başarısız (altına not ve düzeltme commit'i) · ◐ kısmen.

## Hazırlık

- [ ] Dev'de ortam değişkenleri tam: Coolify dev açılış logunda `missing` listesinde `mail`, `feedback`, `weather`, `push` yok (yalnız S3 yedek değişkenleri eksik olabilir).
- [ ] Dev sürümü bu dalın son commit'i: `curl https://arici-api-dev.tutunsoft.com/api/app/info` → `{"env":"dev","version":"<commit>"}`.
- [ ] İki telefon: A = Android, B = iPhone ya da ikinci Android. İkisine de dev derlemesi: `flutter run --flavor dev -t lib/main_dev.dart` (dev varsayılan olarak PocketBase'e bağlanır). Telefonlarda eski kurulum varsa silinip yeniden kurulur.
- [ ] Erişilebilir üç gerçek e-posta kutusu: `E1` (TR arayüz, sahip), `E2` (EN arayüz, ekip üyesi), `E3` (yalnız hesap silme için atılabilir hesap). Demo hesabı (`demo@tutunsoft.com`) ve 6 haneli kodu.
- [ ] PocketBase paneli (`/_/`) ve Coolify dev konteyner terminali açık.

Her maddeden sonra Coolify logunda `level=ERROR` aranır; çıkan satır maddenin notuna yazılır.

## 1. Giriş

- [x] **1a. TR e-posta.** Telefon A, arayüz Türkçe, `E1` ile "Kod gönder".
  - Beklenen: Birkaç saniyede noreply kutusundan Türkçe "giriş kodu" e-postası, 6 haneli kod. Kod girilince onboarding açılır.
- [x] **1b. EN e-posta.** Telefon B, arayüz İngilizce, `E2` ile.
  - Beklenen: E-posta İngilizce; kod girilince onboarding açılır.
- [x] **1c. Kodu sonra girme.** `E3` ile kod iste, uygulamayı görev yöneticisinden öldür, yeniden aç, aynı e-postayla kodu gir (yeni kod istemeden).
  - Beklenen: Uygulama kod ekranına ya da e-posta ekranına döner; aynı e-posta yazılınca eski kod kabul edilir (10 dk içinde). Yanlış kod hata mesajı verir, uygulama çökmez.

## 2. Kurulum, kovanlar, muayene

- [ ] **2a. Onboarding.** Telefon A (`E1`): işletme adı, ülke Türkiye, ilk arılık (konumla).
  - Beklenen: Bugün ekranı açılır; senkron ekranında bekleyen kayıt kalmaz.
- [ ] **2b. 20 toplu kovan.** Arılığa 1–20 numaralı kovanları toplu ekle.
  - Beklenen: Izgarada 20 kovan, doğal sırayla (1, 2, … 10 …); senkron birkaç saniyede biter, reddedilen yok.
- [ ] **2c. QR okut.** Bir kovanın etiketini yazdır ya da ekrandan göster, Okut ile tara.
  - Beklenen: Doğru kovanın kartı açılır.
- [ ] **2d. Muayene + foto + sesli not.** O kovana muayene: en az bir fotoğraf ve bir sesli not.
  - Beklenen: Muayene kaydı kovanın tünelinde; medya yüklemesi arka planda biter (senkron ekranında medya kuyruğu boşalır).
- [ ] **2e. İkinci telefonda görünme.** Telefon B'de `E1` ile giriş (ya da 4. maddeden sonra ekip üyesi olarak).
  - Beklenen: Arılık, 20 kovan ve muayene iner; fotoğraf açılır, sesli not çalar.

## 3. Çevrimdışı ve çakışma

- [x] **3a. Uçak modunda 10 kayıt.** Telefon A uçak modunda: karışık 10 kayıt (muayene, besleme, görev, gider …).
  - Beklenen: Her kayıt anında listede; senkron ekranında 10 (ya da daha fazla outbox satırı) bekliyor; hata yok.
- [x] **3b. Ağ gelince.** Uçak modu kapatılır.
  - Beklenen: Bir dakika içinde outbox boşalır; Telefon B'de 10 kayıt görünür.
- [x] **3c. Son yazan kazanır.** İki telefon uçak modunda; aynı kovanın durumunu A'da "zayıf", sonra B'de "ana arısız" yap (B ikinci). Önce A, sonra B ağa bağlanır.
  - Beklenen: İki telefonda da B'nin durumu kalır; reddedilen kayıt yok.

## 4. Ekip ve roller

- [x] **4a. Davet kodu.** A (sahip) worker rolüyle davet kodu üretir; B (`E2`) kodla katılır.
  - Beklenen: B işletmeyi açar, kayıtlar iner; A'nın ekip listesinde `E2` worker.
- [x] **4b. Worker finansı görmez.** B'de gelir/gider.
  - Beklenen: Finans sekmesi ya da girişi görünmez; doğrudan adresle bile veri gelmez. Muayene yazabilir ve A'ya iner.
- [x] **4c. Viewer yazamaz.** A, B'nin rolünü viewer yapar.
  - Beklenen: B'de rol bir senkron turunda değişir; ekleme butonları kapanır. Kapanmayan bir yerden yazılan kayıt senkron ekranında `forbidden` ile görünür ve A'ya ulaşmaz.
- [x] **4d. Rol değiştirme.** Viewer → worker → partner.
  - Beklenen: Her değişiklik B'ye iner; partner finansı görür.
- [x] **4e. Çıkarma.** A, B'yi işletmeden çıkarır.
  - Beklenen: B'de işletme kapanır ya da erişim kesilir; B'nin yazdığı kayıtlar A'da kalır.

## 5. Bildirim

- [ ] **5a. Atanan görev push'u.** B tekrar worker olarak ekipte; A bir görev oluşturup B'ye atar. B'de uygulama arka planda.
  - Beklenen: Birkaç saniyede B'ye push gelir, B'nin dilinde (EN).
- [ ] **5b. Bildirime dokunma.** B bildirime dokunur.
  - Beklenen: Uygulama açılır ve o görev açık gelir. Kendine atanan görevde push gelmez.

## 6. Dosyalar

- [x] **6a. Belge (PDF).** A'da Belgeler'e bir PDF yükle (20 MB altı).
  - Beklenen: Yükleme biter; B'de belge iner ve açılır.
- [x] **6b. Fiş.** A'da bir gidere fiş fotoğrafı ekle.
  - Beklenen: B'de (partner/owner) fiş açılır.
- [x] **6c. İşletme logosu.** A'da işletme logosu yükle.
  - Beklenen: B'de logo görünür; PDF çıktılarında logo var.

## 7. Hava ve bilgi bankası

- [x] **7a. Hava kartları.** Konumu olan arılıkta Bugün/arılık ekranı.
  - Beklenen: Günlük tahmin ve uçuş uygunluğu kartları dolu (WeatherAPI); ikinci açılışta önbellekten anında gelir. Logda weather hatası yok.
- [x] **7b. Bilgi bankası güncellemesi.** Dev'e `tool/publish_knowledge.dart --backend pocketbase` ile yeni sürüm yayımlanır, telefonda bilgi bankası açılır.
  - Beklenen: Yeni sürüm iner (makale değişikliği görünür), çevrimdışı da açılır.

## 8. Görüş bildir

- [ ] **8a. Ekran görüntülü görüş.** Ayarlar → Görüş bildir, ekran görüntüsü ekli gönder.
  - Beklenen: `FEEDBACK_TO_EMAIL` kutusuna e-posta; Reply-To gönderenin e-postası; gövdede `.../api/app/feedback-shot/<id>` linki.
- [ ] **8b. 7 günlük link.** Linki tarayıcıda aç.
  - Beklenen: Ekran görüntüsü açılır (girişsiz). Link 7 gün sonra 403 verir (testle kanıtlı; elle beklenmez). Değiştirilmiş link 403/404.

## 9. Lot sayfası

- [ ] **9a. Yayımla.** A'da bir hasat lotunu analiz raporuyla birlikte yayımla.
  - Beklenen: QR ve `https://arici-api-dev.tutunsoft.com/l/<id>` adresi gösterilir.
- [ ] **9b. Başka telefonda tarayıcı.** QR'ı B'nin kamerasıyla (uygulama dışı) tara.
  - Beklenen: HTML sayfa tarayıcının dilinde açılır; ürün, arılık bölgesi, tarih doğru; kişisel veri yok.
- [ ] **9c. Rapor.** Sayfadaki rapor linki.
  - Beklenen: `/l/<id>/report` PDF ya da JPEG'i açar.
- [ ] **9d. Yayımdan kaldır.** A'da yayımı kaldır, sayfayı yenile.
  - Beklenen: Sayfa ve rapor 404.

## 10. Hesap silme

- [ ] **10a. Kod e-postası.** `E3` hesabıyla Ayarlar → Hesabı sil → kod iste.
  - Beklenen: Hesabın dilinde "hesap silme kodun" e-postası; 60 sn içinde ikinci istek reddedilir.
- [ ] **10b. Talep.** Kodu gir, talebi onayla.
  - Beklenen: Ekranda silinecek kayıt sayıları; "şu tarihte silinecek" e-postası (7 gün sonrası); oturum kapanır (diğer cihazlarda da), push token'ı silinir.
- [ ] **10c. Bekleme ekranı ve iptal.** Aynı hesapla yeniden giriş.
  - Beklenen: Silme tarihini gösteren bekleme ekranı; "Vazgeç" ile talep iptal, uygulama normal açılır, veriler yerinde.
- [ ] **10d. Kalıcı silme.** `E3` ile yeniden talep (ya da ikinci bir atılabilir hesap). Coolify dev terminalinde:

  ```sh
  /pb/arici seed deletion expire --user <E3>
  ```

  Sonra PocketBase paneli → Settings → Crons → `account-deletion-purge` → çalıştır.
  - Beklenen: Komut "The deletion request of … is due" yazar (prod'da `this command runs only with APP_ENV=dev` hatası verir). Cron'dan sonra panelde kullanıcı, işletmesi, senkron kayıtları ve dosyaları (medya, belge, logo) yok; `deletion_log`'da kullanıcı kimliğinin özetiyle bir kayıt; `deletion_requests` satırı `tamamlandi`; `E3`'e kısa onay e-postası. Aynı e-postayla giriş yeni, boş bir hesap açar.

## 11. Demo hesabı

- [x] **11a. Parola girişi.** Çıkış yap, `demo@tutunsoft.com` + 6 haneli kod (e-posta kodu istemeden).
  - Beklenen: Demo işletmesi açılır (3 arılık, 15 kovan, 28 muayene, görevler). Başka bir e-postada parola girişi yok.

## Kapanış

- [ ] Coolify dev logunda deneme süresince `level=ERROR` yok (varsa nedenleri yukarıdaki maddelerin notlarında).
- [ ] Sonuçlar [progress.md](progress.md)'de; atılabilir hesaplar silindi.

## Notlar

Başarısız maddeler ve düzeltme commit'leri buraya, madde numarasıyla.

İlk tur (2026-11-12): 1, 3, 4, 6, 7, 11 geçti. Başarısız:

- **2.** Arılık eklendi ama konum seçerken harita açılmadı (OpenFreeMap; PocketBase'le ilgisi yok). Ayrıntı bekleniyor.
- **5.** Atanan görevde push gelmedi. iOS dev (`.dev`) için Firebase uygulaması yok, iPhone'da bu beklenen bir eksik. Alıcının telefonu ve `device_tokens` satırı soruldu.
- **8.** Görüş e-postası gelmedi. `feedback` satırı panelde var mı ve log soruldu.
- **9.** Kavanoz etiketi Paylaş/Yazdır: butonlar pasifleşiyor, paylaşma ya da yazdırma ekranı açılmıyor. PDF testte sorunsuz üretiliyor (gerçek adres ve Türkçe adla denendi); sorun cihazdaki yazdırma eklentisinde görünüyor. Kovan etiketlerinin aynı telefonda çalışıp çalışmadığı soruldu.
- **10.** Hesap silme kod e-postası gelmedi. Giriş e-postasıyla aynı SMTP'den gidiyor; uygulamadaki mesaj ve log soruldu.
