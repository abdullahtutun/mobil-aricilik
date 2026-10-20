# Mobil Arıcılık – Özellik Taslağı

Oct 20, 2026 · @Abdullah Tutun

## Vizyon ve temel ilkeler

Uygulamanın amacı: arıcının defterini, hafızasını ve resmi evrak yükünü tek bir telefonda toplamak — dağda, çekmeyen yerde, eldivenle, arı üstüne gelirken bile kullanılabilecek şekilde.

- **Önce offline:** Her özellik internetsiz tam çalışır; çekim gelince sessizce eşitlenir. İnternet sadece hava durumu, yedekleme ve ekip paylaşımı için gerekir.
- **Eldivenle kullanım:** Büyük butonlar, az yazı, dokun-seç ağırlıklı giriş, sesli not. Bir kovan muayenesi 15–20 saniyede kaydedilebilmeli.
- **Saha koşulları:** Güneş altında okunur yüksek kontrast, tek elle kullanım, düşük pil tüketimi.
- **Küresel, Türkiye'ye özel modüllü:** Dünyanın her yerinde kullanılır; Türkiye'ye özel kısımlar yalnızca TR bölge profilinde görünür. TR profilinde Langstroth kovan varsayılanı, yerli arı ırkları (Kafkas, Anadolu, Muğla, Yığılca vb.), gezginci arıcılık, Arıcılık Kayıt Sistemi (AKS) ve destek ödemeleri düşünülerek tasarlanır.
- **Hedef kullanıcı:** 20 kovanlı hobi arıcısından 500+ kovanlı gezginci profesyonele kadar; arayüz kovan sayısına göre ölçeklenir (tek tek kovan takibi ya da grup/blok takibi).

## Bölge profili ve dil

Mobil Arıcılık dünyanın her yerinde kullanılabilir. Arayüz Türkçe ve İngilizce gelir; dil ile ülke birbirinden bağımsız seçilir. İşletme kurulurken seçilen ülke **bölge profilini** belirler.

- **TR profili:** AKS ve işletme tescil bilgileri, arılı kovan desteği hatırlatıcıları, mevzuat kütüphanesi, TR ilaç listesi, il/ilçe tarım müdürlüğü rehberi, Türkiye flora takvimi ve gezginci belge türleri açık.
- **Diğer ülkeler:** Bu modüller gizli ve pasif. Yerlerine genel karşılıklar gelir: serbest kayıt numarası, kullanıcı tanımlı belge türleri, kullanıcının girdiği yerel otorite iletişimi, etken madde bazlı ilaç listesi, kullanıcının oluşturduğu flora takvimi.
- Mevsim takvimi ve görev şablonları arılığın bulunduğu yarımküreye göre ayarlanır; birimler (kg/lb, °C/°F) ve para birimi ülkeye göre gelir.
- Ülke değişirse gizlenen veriler silinmez, yeniden görünür.

Aşağıdaki bölümlerde **(TR)** ile işaretli özellikler yalnızca TR profilinde görünür.

## 1. Arılık ve kovan yönetimi

Tüm kayıtların iskeleti: arılık → kovan → çerçeve/kat hiyerarşisi.

**Arılıklar (konumlar)**

- GPS ile arılık noktası kaydetme, offline harita üzerinde gösterme ve "oraya yol tarifi".
- Arılık bilgileri: arazi sahibi ve telefonu, kira/izin durumu, su kaynağı, araca uzaklık, rakım, yol durumu ("yağmurda araç girmez" gibi notlar).
- Arılığa giriş/çıkış tarihleri; kovanların hangi tarihte hangi arılıkta olduğunun geçmişi.

**Kovanlar**

- Her kovana numara + QR/NFC etiket: telefonu kovana tut, kartı açılsın. Etiket baskı şablonu uygulamadan çıkar.
- Kovan kartı: kovan tipi (Langstroth, Dadant, yerel), kat sayısı, çerçeve sayısı, ana arısı, kaynak (oğlak, bölme, satın alma, paket arı), durum (güçlü/orta/zayıf/ölü), renk/işaret.
- Toplu işlem: "bu arılıktaki 40 kovanın hepsine besleme verildi" tek dokunuşla.
- Kovan yaşam döngüsü: birleştirme, bölme, sönme, satış, çalınma, ayı/hayvan saldırısı kaydı — kovan sayısı her an doğru kalır.
- Arılık planı: kovanların sıra/dizilimini basit bir kroki olarak tutma ("3. sıra soldan 5.").

## 2. Kovan muayene kayıtları

Uygulamanın en sık kullanılacak ekranı; kovan kapağı açıkken saniyeler içinde doldurulabilmeli.

- **Hızlı muayene:** Hepsi dokun-seç — ana arı görüldü mü, taze yumurta var mı, yavru düzeni (kompakt/dağınık), arılı çerçeve sayısı, yavrulu çerçeve sayısı, bal/polen stoku, mizac (sakin/sinirli), oğul belirtisi, ana arı memesi (oğul/ana değiştirme/acil).
- **Güç puanı:** Girilen verilerden kovana 1–5 güç puanı; arılık listesinde renkli gösterim, zayıflar en üstte.
- **Sesli not:** "Ana yok, iki meme var, yarın bakılacak" gibi kayıt; internet yokken ses dosyası saklanır, mümkünse metne çevrilir.
- **Fotoğraf:** Çerçeve, şüpheli yavru, hastalık belirtisi fotoğrafı; kovan geçmişinde zaman sırasıyla.
- **Yapılan işlem:** Kat verildi/alındı, çerçeve eklendi, temel petek verildi, ana ızgarası takıldı, polen tuzak, kovan girişi daraltıldı.
- **Sonraki adım:** Muayene sonunda "X gün sonra tekrar bak" hatırlatıcısı tek dokunuşla.
- **Arılık turu modu:** Kovandan kovana sırayla geçiş, bir önceki muayene özeti üstte görünür; tur bitince arılık özeti (kaç kovan anasız, kaçı oğul eğilimli, kaçı zayıf).
- **Şablonlar:** İlkbahar açılışı, hasat öncesi, kışa hazırlık gibi mevsime göre hazır kontrol listeleri.

## 3. Ana arı ve koloni çoğaltma

Ana arı kovanın kalbi; yaşı, kökeni ve performansı kovandan bağımsız izlenir.

- **Ana arı kartı:** Doğum/alım yılı, ırk/hat, kaynağı (kendi üretimi, satın alınan yetiştirici, sertifikalı damızlık), çiftleşme durumu, işaret rengi, kanat kesimi.
- **Uluslararası renk kodu:** Yıla göre işaret rengini otomatik önerir (ör. 2026 = beyaz, 2027 = sarı).
- **Ana değişim uyarısı:** 2 yaşını geçen ya da düşük performanslı anaları listeler.
- **Performans:** Bal verimi, mizac, oğula meyil, hastalığa dayanıklılık, kışlama başarısı — iyi anaları damızlık adayı olarak işaretler.
- **Ana arı yetiştirme takvimi:** Larva aktarma günü girildiğinde tüm aşamaları hesaplar: meme kapanışı, memelerin çiftleşme kutularına dağıtımı (\~10. gün), ana çıkışı, çiftleşme ve yumurtlama kontrolü.
- **Çiftleşme kutuları (çiftleşme kovancıkları):** Ayrı envanter, başarı oranı.
- **Bölme/oğulcuk takibi:** Hangi kovandan bölündü, kaç çerçeve verildi, analı mı anasız mı bölündü; soy ağacı görünümü.
- **Oğul yakalama kaydı:** Yakalanan oğulun kaynağı ve yerleştirildiği kovan.

## 4. Hastalık, zararlı ve ilaçlama takibi

Türkiye'de koloni kayıplarının bir numaralı sebebi varroa; modülün merkezi varroa olmalı.

**Varroa yönetimi**

- Bulaşıklık ölçümü kaydı: pudra şekeri, alkol yıkama, alt tabla (yapışkan tabla) sayacı; sonuçtan yüzde hesaplar ve eşik aşımında uyarır.
- Arılık bazında varroa haritası/grafiği, mücadele öncesi ve sonrası karşılaştırma.
- Mücadele planlayıcı: yavrusuz dönem (ana hapsi, yavru kesme) ve sonbahar mücadele zamanını hatırlatır.

**İlaçlama kayıt defteri**

- Kullanılan ürün (amitraz, oksalik asit, formik asit, timol vb.), ruhsat no, parti no, doz, uygulama ve bitiş tarihi, uygulayan.
- **Bekleme süresi kilidi:** İlaç uygulanan kovana bal katı verilmesi veya hasat işaretlenmesi durumunda uyarır — kalıntı riskine karşı kritik.
- İlaç rotasyonu önerisi: Aynı etken maddenin üst üste kullanımını (direnç riski) gösterir.
- Veteriner reçetesi/fatura fotoğrafı eklenebilir; denetimde gösterilecek çıktı alınır.

**Diğer hastalık ve zararlılar**

- Teşhis yardımcısı: Belirtiye göre seçim (delikli kapaklar, kibrit testi, kireçleşmiş larva, ishal izi) → olası hastalıklar ve fotoğraflı rehber. Nosema, kireç hastalığı, Avrupa yavru çürüklüğü, kanat deformasyon virüsü.
- **İhbarı mecburi hastalıklar** (Amerikan yavru çürüklüğü, küçük kovan böceği vb.): şüphe işaretlenince ne yapılması gerektiği ve yetkili kurum iletişimi (TR: il/ilçe tarım müdürlüğü; diğer ülkeler: kullanıcının tanımladığı yerel otorite); kovan karantinaya alınır, ekipman paylaşımı uyarısı çıkar.
- Zararlılar: Eşek arısı (özellikle Vespa orientalis), mum güvesi, arı kuşu, karınca, fare, ayı — tuzak kurma ve hasar kaydı.
- İlaçlama/zehirlenme bildirimi: Yakındaki tarımsal ilaçlama sonrası toplu ölüm kaydı (foto, tarih, konum) — tazminat/şikayet süreci için belge.

## 5. Besleme kayıtları

Besleme hem kovan sağlığı hem maliyet hem de balın şurup karışımı riski açısından izlenmeli.

- Besleme türü: Şurup (1:1 teşvik, 2:1 kışlık), arı keki/kandi, polen/polen ikamesi, su.
- Miktar ve maliyet: Kovan başına kg/L, toplam stok düşümü otomatik (Malzeme modülüyle bağlantılı).
- Şurup hesaplayıcı: "60 kovana 2:1, kovan başına 3 L" girildiğinde kaç kg şeker ve kaç L su gerektiğini hesaplar.
- **Bal katı uyarısı:** Bal katı taşıyan kovana şurup verilirse uyarır; hasat öncesi son besleme tarihi raporu.
- Kışlık stok tahmini: Muayenede girilen bal çerçevesi sayısından "kışa yeter mi" değerlendirmesi, bölgeye göre (Erzurum ile Muğla aynı değil).
- Arılık bazında toplu besleme kaydı (tek dokunuş).

## 6. Hasat ve ürün yönetimi

Hasat kaydı, kovandan kavanoza izlenebilirlik zincirinin başlangıcıdır.

- **Hasat kaydı:** Tarih, arılık, kovan(lar), alınan kat/çerçeve sayısı, süzülen kg, bal türü (çam, kestane, ayçiçeği, narenciye, çiçek, geven, kekik, püren vb.).
- **Parti (lot) oluşturma:** Her hasat bir parti numarası alır; partinin hangi kovanlardan geldiği, o kovanlara son ilaçlama/besleme tarihi otomatik ilişkilendirilir.
- **Kalite bilgisi:** Nem (refraktömetre değeri), laboratuvar analiz sonuçları (HMF, diastaz, prolin, polen analizi, kalıntı) ve rapor PDF/fotoğrafı partiye eklenir.
- Diğer ürünler: Polen, propolis, arı sütü, bal mumu, petek bal, ana arı/oğulcuk satışı ayrı kalemler.
- Verim analizi: Kovan, arılık, ana arı hattı ve yıl bazında kg/kovan karşılaştırması.
- Depo/stok: Teneke, kavanoz, petek stokları; partiden satışa düşen miktar.
- **İzlenebilirlik etiketi:** Parti için QR kod — müşteri okuttuğunda balın yöresi, hasat tarihi ve (istenirse) analiz raporu görünür. Sahte bala karşı arıcının güven aracı.

## 7. Gezginci arıcılık ve konaklama

Türkiye'de profesyonel arıcının büyük kısmı gezginci; göç planı ve evrakı ayrı bir modül hak ediyor.

- **Göç planı:** Yıllık rota (ör. Muğla/Akdeniz kışlak → narenciye → iç Anadolu yayla → Karadeniz kestane → Muğla çam) ve her durak için planlanan tarih, kovan sayısı.
- **Taşıma kaydı:** Hangi kovanlar hangi araçla, hangi tarihte, nereden nereye götürüldü; taşıma kaybı.
- **Yükleme listesi:** Taşımadan önce kontrol listesi (girişler kapandı mı, havalandırma, kayış, su) ve kovan sayımı — "yüklenen 120, indirilen 120".
- **Evrak çantası:** Belge türleri bölgeye göre gelir (TR: işletme tescil belgesi, gezginci arıcı belgesi/nakil evrakı, sağlık raporu, konaklama yeri izni; diğer ülkeler: kullanıcı tanımlı). Belgelerin fotoğrafları offline erişilebilir; yol kontrolünde açıp gösterilir. Süre dolumu yaklaşınca uyarır.
- **Konaklama noktası arşivi:** Geçmiş yıllarda konaklanan noktalar, verim geçmişi, arazi sahibi iletişimi, "bu noktada su yok" gibi notlar.
- **Mesafe kontrolü:** Haritada diğer kayıtlı arılıklara (kendi ekibinin) uzaklık; ilgili mevzuattaki mesafe kuralları için bilgi notu.
- **İleri faz:** İsteğe bağlı, anonim "bu bölgede kaç arıcı var / nektar akımı başladı mı" topluluk bilgisi.

## 8. Takvim, görevler ve hatırlatıcılar

Arıcının "unuttum" dediği her şey burada; hatırlatıcılar internetsiz de telefonda çalar.

- **Otomatik görevler:** Diğer modüllerden doğar — ana arı çıkışı kontrolü, ilaç şeridini çıkarma günü, "7 gün sonra tekrar bak", belge süre dolumu.
- **Mevsimsel görev şablonları:** Bölgeye göre (Akdeniz, Ege, İç Anadolu, Karadeniz, Doğu) ilkbahar açılışı, oğul dönemi kontrolleri, kat verme, hasat, sonbahar varroa mücadelesi, kışa hazırlık, kış kontrolleri.
- **Günlük plan:** "Bugün hangi arılığa gidiyorum, orada ne yapacağım, yanıma ne almalıyım" (gerekli malzeme listesi görevlerden çıkar).
- **Görev atama:** Ekipte görevi işçiye/ortak arıcıya atama, tamamlanma işareti.
- **Hatırlatma tercihleri:** Sabah özeti, sessiz saatler, kritik uyarılar (bekleme süresi, ihbarı mecburi hastalık) her zaman öncelikli.

## 9. Hava durumu ve flora takvimi

Arıcı havaya ve çiçeğe göre çalışır; uygulama "bugün kovan açılır mı" sorusuna cevap vermeli.

- **Arılık bazında hava:** Open-Meteo verisiyle her arılığın konumu için sıcaklık, rüzgar, yağış; son alınan tahmin offline saklanır.
- **"Kovan açma uygunluğu" göstergesi:** Sıcaklık, rüzgar ve yağmura göre yeşil/sarı/kırmızı.
- **Uyarılar:** Geç don, aşırı sıcak, fırtına, sel riski — özellikle ilkbahar donu ve taşıma günleri için.
- **Flora takvimi:** Bölgeye göre başlıca nektar kaynaklarının çiçeklenme dönemi; arıcı kendi gözlemini ekleyerek yıldan yıla kişisel takvim oluşturur.
- **Kovan tartımı (isteğe bağlı):** Elle tartı kaydı ya da ileride akıllı kantar; günlük kilo artışı nektar akımının en net göstergesi.
- **Topluluk gözlemi (ileri faz):** "Bu hafta Yeniçağa'da akım başladı" gibi anonim bölgesel bildirimler.

TR profilinde flora takviminin hazır başlangıç içeriği (diğer ülkelerde takvim boş başlar) (yaklaşık dönemler; rakım ve yıla göre kayar):

| Kaynak | Başlıca bölge | Yaklaşık dönem |
| --- | --- | --- |
| Narenciye | Akdeniz (Adana, Mersin, Antalya) | Mart–Nisan |
| Akasya | Trakya, Marmara | Mayıs |
| Kestane | Karadeniz, Marmara | Haziran–Temmuz |
| Ayçiçeği | Trakya, Orta Anadolu | Temmuz–Ağustos |
| Geven, kekik, yayla çiçekleri | Doğu ve İç Anadolu yaylaları | Haziran–Ağustos |
| Pamuk | Çukurova, Ege | Ağustos–Eylül |
| Çam (basra salgısı) | Muğla, Aydın, İzmir | Ağustos–Kasım |
| Püren | Ege, Akdeniz kıyıları | Eylül–Kasım |

## 10. Malzeme, stok ve ekipman

Sahada "temel petek bitti" demek bir günü kaybettirir; stok kovan işlemleriyle otomatik düşer.

- **Sarf malzemesi:** Şeker, kek, temel petek, ilaç, kavanoz/teneke, etiket — kritik seviyede uyarı.
- **Ekipman envanteri:** Boş kovan, kat, çerçeve, ana ızgarası, polen tuzağı, çiftleşme kutusu, süzme makinesi, körük, maske; hangisi hangi arılıkta/depoda.
- **Petek yönetimi:** Kuru petek stoku, kışın mum güvesine karşı saklama kaydı, eski peteklerin yenilenme döngüsü.
- **Hastalıklı ekipman işareti:** Hastalıklı kovandan gelen malzeme dezenfekte edilene kadar "kullanma" etiketi.
- **Alışveriş listesi:** Stok ve planlanan işlemlerden otomatik çıkar, tedarikçi bilgisi ve son alış fiyatı ile.
- **Araç ve bakım:** Kamyonet/römork bakım, muayene, sigorta tarihleri (gezginci için kritik).

## 11. Finans: gelir, gider, satış ve destekler

Arıcıların çoğu kovan başına gerçek kârını bilmez; bu modül onu görünür kılar.

- **Gider kaydı:** Kategori bazlı (besleme, ilaç, ana arı, ekipman, yakıt/nakliye, arazi kirası, işçilik, analiz); fiş/fatura fotoğrafı eklenir.
- **Gelir kaydı:** Bal, polen, propolis, mum, ana arı, oğulcuk satışları; perakende ve toptan ayrımı.
- **Müşteri defteri:** Müşteri listesi, sipariş, veresiye/alacak takibi, kargo bilgisi; WhatsApp üzerinden hazır sipariş özeti gönderme.
- **Toptancı satışı:** Hangi partinin, kime, hangi kg fiyatından satıldığı.
- **Kârlılık raporu:** Kovan başına maliyet, arılık/konaklama noktası bazlı kâr ("kestaneye gitmek bu yıl kazandırdı mı?").
- **Destek ödemeleri (TR):** Arılı kovan desteği ve diğer hayvancılık desteklerinin başvuru dönemi hatırlatıcısı, başvuruda beyan edilecek kovan sayısının kayıtlarla tutarlılık kontrolü, ödeme takibi. (Destek kalemleri ve tutarları her yıl değiştiği için içerik güncellenebilir tutulmalı.)
- **Kredi/borç:** Kredi taksit hatırlatıcıları (TR'de Tarım Kredi, Ziraat Bankası vb.).

## 12. Mevzuat ve resmi kayıtlar (TR; belge kasası tüm ülkelerde)

Uygulama resmi sistemlerin yerine geçmez; ama arıcının o sistemlere gireceği bilgiyi hazır ve tutarlı tutar.

- **İşletme profili:** İşletme tescil numarası, Arıcılık Kayıt Sistemi (AKS) bilgileri, birlik üyeliği (il arı yetiştiricileri birliği), çiftçi kayıt bilgileri.
- **AKS ile tutarlılık:** Kovan sayısı ve konum değişikliklerinde "AKS'de güncellemeyi unutma" hatırlatıcısı ve güncellenecek bilgilerin özeti.
- **Denetim modu:** İlaç kayıt defteri, hastalık kayıtları, nakil evrakı ve analiz raporları tek ekranda; PDF çıktı alınır.
- **Belge kasası:** Tüm belgelerin fotoğrafı/PDF'i, geçerlilik tarihi ve süre dolumu uyarısı.
- **Mevzuat kütüphanesi:** Arıcılık yönetmeliği, gezginci arıcılık kuralları, bal tebliği gibi metinlerin sade özetleri ve resmi kaynağa bağlantı; değişiklik olduğunda bildirim.
- **Resmi iletişim:** İl/ilçe tarım müdürlüğü, veteriner, birlik ve laboratuvar rehberi — offline erişilebilir.

## 13. Bilgi bankası, ekip ve raporlar

**Bilgi bankası (tamamen offline)**

- Mevsim mevsim yapılacaklar rehberi, bölgeye göre.
- Fotoğraflı hastalık/zararlı atlası ve mücadele yöntemleri.
- Teknik rehberler: bölme yapma, ana verme, birleştirme, oğul önleme, kışlatma, larva aktarma.
- Hesaplayıcılar: şurup, ilaç dozu (kovan sayısına göre), ana arı yetiştirme takvimi, kg/kovan verim.
- Yeni başlayanlar için adım adım "ilk yılım" modu.

**Ekip kullanımı**

- Kullanıcı rolleri: işletme sahibi, ortak, işçi (sadece veri girişi), danışman/veteriner (sadece okuma).
- Kim, hangi kovana, ne zaman, ne yaptı — işlem geçmişi.
- Aynı arılıkta iki kişi offline çalışırsa kayıtlar çakışmadan birleşir.

**Raporlar ve pano**

- Ana ekran panosu: toplam kovan, zayıf/anasız kovanlar, bekleyen görevler, bugünün hava durumu, yaklaşan son tarihler.
- Sezon raporu: kovan sayısı değişimi, kayıplar ve nedenleri, verim, maliyet, kâr.
- Kış kaybı analizi: Hangi arılık/ana hattı/mücadele yöntemi daha az kayıp verdi.
- Dışa aktarma: PDF ve Excel; sezon sonu yedek.

## 14. Offline çalışma ve saha kullanılabilirliği

Kural: "İnternet yok" diye hiçbir kayıt ertelenmez, hiçbir ekran boş açılmaz.

**Offline tam çalışan**

- Tüm kayıt, düzenleme, silme işlemleri; fotoğraf ve ses kaydı.
- Hatırlatıcılar ve bildirimler (telefonun kendisinde planlanır).
- Bilgi bankası, hesaplayıcılar, belge kasası.
- Önceden indirilmiş harita bölgeleri (ör. "Muğla il haritasını indir") ve GPS konumu.
- QR/NFC etiket okuma.

**İnternet gelince**

- Arka planda otomatik eşitleme; ekranda "en son eşitleme: 3 gün önce, 47 kayıt bekliyor" göstergesi.
- Fotoğraflar önce sıkıştırılır, isteğe bağlı olarak sadece Wi‑Fi'da yüklenir (mobil veri kotası için).
- Hava tahmini ve mevzuat/bilgi bankası güncellemeleri indirilir.
- Ekip kayıtları birleşir; gerçek bir çakışmada (iki kişi aynı kovanı farklı güncellediyse) kullanıcıya sorulur.

**Saha kullanılabilirliği**

- Eldivenle dokunulabilecek büyük hedefler; kritik işlemler 1–2 dokunuşta.
- Güneş modu (yüksek kontrast), karanlık mod (akşam taşımaları).
- Sesli komut/sesli not ile ellere dokunmadan kayıt.
- Pil tasarrufu: GPS sadece gerektiğinde, ekran çok kısa süre açık kalsa da kayıt kaybolmaz (her dokunuş anında kaydedilir).
- Basit dil, Türkçe saha terimleri ("anasız", "kat vermek", "oğulcuk"); Türkçe ve İngilizce ilk sürümden; ileride ek diller (ör. mevsimlik işçiler için).
- Yaşlı kullanıcılar düşünülerek büyük yazı seçeneği.

## 15. Sürüm önceliklendirmesi

Öneri: İlk sürüm arıcının defterini tamamen değiştirmeli; finans ve topluluk özellikleri arıcı uygulamaya alıştıktan sonra gelir.

| Faz | Kapsam | Neden bu sırada |
| --- | --- | --- |
| 1 – MVP | Arılık ve kovan yönetimi, hızlı muayene, QR etiket, ana arı kartı, varroa ve ilaç kayıt defteri (bekleme süresi uyarısıyla), besleme, basit hasat kaydı, görevler/hatırlatıcılar, tam offline çalışma, TR/EN dil ve bölge profili | Günlük saha işi; arıcının her gün açmasını sağlayan çekirdek |
| 2 | Gezginci modülü ve belge kasası, hava durumu ve kovan açma göstergesi, malzeme/stok, ana arı yetiştirme takvimi, ekip kullanımı | Profesyonel ve gezginci arıcıyı kazanmak |
| 3 | Finans ve müşteri defteri, parti/lot ve izlenebilirlik QR'ı, raporlar, destek ve AKS hatırlatıcıları (TR), bilgi bankasının genişletilmesi | Kayıt biriktiğinde anlam kazanır |
| 4 – İleri | Topluluk akım bildirimleri, akıllı kantar/sensör entegrasyonu, fotoğraftan hastalık tanıma, arıcılar arası pazar yeri (ana arı, oğulcuk, ekipman) | Kullanıcı tabanı ve veri oluştuktan sonra |

Açık sorular: Hedef kitle önce profesyonel gezginci mi, hobi/yarı profesyonel mi? Ücretsiz/ücretli özellik ayrımı nasıl olacak? Birlikler veya il müdürlükleriyle iş birliği hedefleniyor mu?
