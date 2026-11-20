# App Store mağaza metinleri

App Store Connect → uygulama → **App Information** (ad, alt başlık) ve sürüm sayfası (tanıtım metni, açıklama, anahtar kelimeler, URL'ler, telif). Diğer diller sağ üstteki dil menüsünden eklenir. Uzun açıklamalar [play-listing.md](play-listing.md) ile aynı; terimler uygulamanın ARB dosyalarıyla aynı. TR dışındaki metinler makine çevirisi, ana dili konuşan biri gözden geçirmeli.

Sınırlar: ad 30, alt başlık 30, tanıtım metni 170, açıklama 4000, anahtar kelimeler 100 karakter. Sayılar bu dosya üretilirken denetlendi.

- **Ad:** Play'dekiyle aynı. "Mobil Arıcı" tek başına App Store'da başka birine ait; ad her dilde "Mobil Arıcı: <ne olduğu>". Telefonda ikonun altındaki ad "Mobil Arıcı" kalır.
- **Alt başlık (Subtitle):** Adın altında görünür ve aramada adla birlikte sayılır; bu yüzden addaki kelimeyi tekrar etmez.
- **Anahtar kelimeler:** virgülle ayrılır, virgülden sonra boşluk yok (boşluk da karakter sayılır). Ad ve alt başlıktaki kelimeler burada tekrarlanmaz, Apple onları zaten arar.
- **Tanıtım metni (Promotional Text):** yeni sürüm göndermeden istenildiği zaman değiştirilebilir.
- **Farsça:** App Store'da Farsça mağaza dili yok. Farsça arayüz uygulamanın içinde var; mağazada Farsça kullanıcı birincil dili (İngilizce) görür. İran'da App Store yok.
- **Açıklama farkı:** Türkçe açıklamada "destek takvimi" yok; destekler modülü 2026-11-18'den beri gizli (Play metninde hâlâ var).

## Bütün dillerde aynı alanlar

| Alan | Değer |
|---|---|
| Version | `1.0.0` (yüklenen derlemenin sürümüyle aynı olmalı; formdaki varsayılan `1.0`'ı değiştir) |
| Copyright | `2026 Abdullah Tutun` (geliştirici hesabı bireysel; Apple yıl + sahip adı ister) |
| Support URL | `https://www.tutunsoft.com/mobil-arici/privacy-policy.html` (iletişim adresi `support@tutunsoft.com` bu sayfada; ayrı bir destek sayfası açılırsa onunla değiştir) |
| Marketing URL | boş (isteğe bağlı; `https://www.tutunsoft.com/mobil-arici/` şu an 403 veriyor) |
| Privacy Policy URL | `https://www.tutunsoft.com/mobil-arici/privacy-policy.html` (App Privacy sayfasında) |

---

## en-US — English

App Store Connect dili: **English (U.S.) — birincil dil**

**Name** (27/30):

```
Mobil Arıcı: Beekeeping Log
```

**Subtitle** (28/30):

```
Hives, inspections & harvest
```

**Promotional Text** (149/170):

```
Log inspections, varroa counts, treatments, feeding and harvests right at the hive, even with gloves on and no signal. Your whole team stays in sync.
```

**Keywords** (99/100):

```
beekeeper,bee,apiary,honey,varroa,queen,mite,treatment,feeding,syrup,migratory,colony,brood,beehive
```

**Description** (1463/4000):

```
Mobil Arıcı brings a beekeeper's logbook, records and paperwork together on one phone. It works without internet in the field, and with large buttons and glove mode you can use it at the hive even with gloves on.

Apiaries and hives
• Save your apiaries with their location; add hives one by one or in bulk
• Print QR labels for your hives and scan them to open the hive card
• Move hives between apiaries and see their history
• Track each queen's age, breed and color code; record queen rearing batches

Inspections and health
• Inspect in a few taps: strength, brood, queen, temper, stores
• Varroa counts and treatment records with withdrawal periods calculated
• Attach photos and voice notes to your records

Feeding, harvest and sales
• Feeding records with a syrup calculator
• Record the harvest hive by hive and create honey lots
• Track income, expenses, customers and payments; stock and supply list

Migratory beekeeping
• Migration plans, stops and move records
• Download maps around your apiaries to use them offline
• Weather for each apiary

Team
• Invite your partner, workers or advisor; everyone sees and edits according to their role
• Records sync to everyone's phone when there is internet

Reports and documents
• Season report and PDF reports
• Export all your records to Excel
• Keep permits, certificates and receipts with your records

Available in English, Turkish, German, Spanish, Portuguese, Russian, Ukrainian, Persian and Hindi.
```

---

## tr — Türkçe

App Store Connect dili: **Turkish**

**Name** (29/30):

```
Mobil Arıcı: Arıcılık Defteri
```

**Subtitle** (29/30):

```
Kovan, muayene ve hasat kaydı
```

**Promotional Text** (160/170):

```
Muayene, varroa, ilaçlama, besleme ve hasat kayıtların kovan başında, eldivenle ve dağda internetsiz. İnternet gelince ekibindeki herkesin telefonuna eşitlenir.
```

**Keywords** (97/100):

```
arı,bal,arılık,varroa,ilaçlama,ana arı,besleme,şurup,gezginci,göçer,petek,polen,propolis,arı sütü
```

**Description** (1422/4000):

```
Mobil Arıcı, arıcının defterini, kayıtlarını ve evrakını tek telefonda toplar. Dağda internet yokken de çalışır; büyük düğmeler ve eldiven modu sayesinde kovan başında eldivenle bile kullanılır.

Arılık ve kovan
• Arılıklarını konumuyla kaydet, kovanlarını numarayla ya da toplu oluştur
• Kovanlara QR etiket bas, okutunca kovanın kartı açılsın
• Kovanı arılıklar arasında taşı, geçmişini gör
• Ana arının yaşını, ırkını ve renk kodunu takip et; ana arı yetiştirme partilerini kaydet

Muayene ve sağlık
• Birkaç dokunuşla muayene: güç, yavru, ana arı, huy, yiyecek
• Varroa sayımı ve ilaçlama kayıtları; bekleme süresi hesaplanır
• Fotoğraf ve sesli notu kayda ekle

Besleme, hasat ve satış
• Şurup hesabı ile besleme kayıtları
• Hasadı kovan kovan kaydet, bal partisi (lot) oluştur
• Gelir, gider, müşteri ve tahsilat takibi; stok ve malzeme listesi

Gezginci arıcılık
• Göç planı, duraklar ve taşıma kayıtları
• Arılık çevresinin haritasını internetsiz kullanmak için indir
• Arılık bazında hava durumu

Ekip
• Ortağını, işçini ya da danışmanını davet et; herkes rolüne göre görür ve yazar
• Kayıtlar internet gelince ekipteki herkesin telefonuna eşitlenir

Raporlar ve resmi işler
• Sezon raporu ve PDF raporlar
• Bütün kayıtlarını Excel olarak dışa aktar
• Türkiye profilinde AKS bilgileri ve mevzuat; ruhsat ve belgeleri saklama

Türkçe, İngilizce, Almanca, İspanyolca, Portekizce, Rusça, Ukraynaca, Farsça ve Hintçe.
```

---

## de-DE — Deutsch

App Store Connect dili: **German**

**Name** (23/30):

```
Mobil Arıcı: Stockkarte
```

**Subtitle** (28/30):

```
Völker, Durchsicht und Ernte
```

**Promotional Text** (157/170):

```
Durchsichten, Varroa-Zählungen, Behandlungen, Fütterung und Ernte direkt am Stand erfassen, auch mit Handschuhen und ohne Netz. Dein Team bleibt abgeglichen.
```

**Keywords** (98/100):

```
imker,imkerei,bienen,honig,varroa,königin,bienenstand,stockbuch,fütterung,behandlung,wandern,beute
```

**Description** (1556/4000):

```
Mobil Arıcı bringt Stockkarte, Aufzeichnungen und Unterlagen eines Imkers auf ein Handy. Die App funktioniert am Stand auch ohne Internet, und dank großer Schaltflächen und Handschuhmodus lässt sie sich sogar mit Handschuhen bedienen.

Stände und Völker
• Bienenstände mit Standort speichern, Völker einzeln oder in einem Schritt anlegen
• QR-Etiketten für die Beuten drucken und scannen, um die Stockkarte zu öffnen
• Völker zwischen Ständen umsetzen und ihre Geschichte sehen
• Alter, Rasse und Farbcode jeder Königin verfolgen; Königinnenzucht-Serien erfassen

Durchsicht und Gesundheit
• Durchsicht mit wenigen Tipps: Stärke, Brut, Königin, Sanftmut, Futter
• Varroa-Zählungen und Behandlungen; die Wartezeit wird berechnet
• Fotos und Sprachnotizen an Einträge anhängen

Fütterung, Ernte und Verkauf
• Fütterungen mit Sirup-Rechner
• Ernte Volk für Volk erfassen und Honigchargen anlegen
• Einnahmen, Ausgaben, Kunden und Zahlungen; Lager und Materialliste

Wanderimkerei
• Wanderplan, Stationen und Wanderungen erfassen
• Karten rund um deine Stände für die Offline-Nutzung herunterladen
• Wetter für jeden Stand

Team
• Partner, Helfer oder Berater einladen; jeder sieht und schreibt je nach Rolle
• Einträge werden mit allen Handys im Team abgeglichen, sobald Internet da ist

Berichte und Unterlagen
• Saisonbericht und PDF-Berichte
• Alle Daten als Excel exportieren
• Genehmigungen, Gesundheitszeugnisse und Belege bei den Einträgen aufbewahren

Auf Deutsch, Englisch, Türkisch, Spanisch, Portugiesisch, Russisch, Ukrainisch, Persisch und Hindi.
```

---

## es-MX — Español (México)

App Store Connect dili: **Spanish (Mexico)**

**Name** (29/30):

```
Mobil Arıcı: Cuaderno apícola
```

**Subtitle** (30/30):

```
Colmenas, revisiones y cosecha
```

**Promotional Text** (151/170):

```
Registra revisiones, varroa, tratamientos, alimentación y cosecha junto a la colmena, con guantes y sin señal. Todo tu equipo se mantiene sincronizado.
```

**Keywords** (99/100):

```
apicultor,apicultura,abejas,miel,varroa,reina,colmenar,tratamiento,alimentación,jarabe,trashumancia
```

**Description** (1585/4000):

```
Mobil Arıcı reúne el cuaderno de campo, los registros y los documentos del apicultor en un solo teléfono. Funciona sin internet en el colmenar y, gracias a sus botones grandes y al modo guantes, se puede usar junto a la colmena incluso con guantes.

Colmenares y colmenas
• Guarda tus colmenares con su ubicación y crea colmenas una a una o en bloque
• Imprime etiquetas QR para tus colmenas y escanéalas para abrir su ficha
• Traslada colmenas entre colmenares y consulta su historial
• Sigue la edad, la raza y el color de cada reina; registra lotes de cría de reinas

Revisión y sanidad
• Revisiones en pocos toques: fuerza, cría, reina, carácter, reservas
• Conteos de varroa y tratamientos, con cálculo del tiempo de espera
• Agrega fotos y notas de voz a tus registros

Alimentación, cosecha y ventas
• Registros de alimentación con calculadora de jarabe
• Registra la cosecha colmena por colmena y crea lotes de miel
• Ingresos, gastos, clientes y pagos; existencias y lista de materiales

Trashumancia
• Plan de trashumancia, paradas y traslados
• Descarga mapas alrededor de tus colmenares para usarlos sin conexión
• Clima de cada colmenar

Equipo
• Invita a tu socio, trabajadores o asesor; cada uno ve y escribe según su rol
• Los registros se sincronizan en los teléfonos de todo el equipo cuando hay internet

Informes y documentos
• Informe de temporada e informes en PDF
• Exporta todos tus registros a Excel
• Guarda permisos, certificados y comprobantes junto con tus registros

Disponible en español, inglés, turco, alemán, portugués, ruso, ucraniano, persa e hindi.
```

---

## pt-BR — Português (Brasil)

App Store Connect dili: **Portuguese (Brazil)**

**Name** (28/30):

```
Mobil Arıcı: Caderno apícola
```

**Subtitle** (29/30):

```
Colmeias, revisões e colheita
```

**Promotional Text** (137/170):

```
Registre revisões, varroa, tratamentos, alimentação e colheita ao lado da colmeia, de luvas e sem sinal. Toda a equipe fica sincronizada.
```

**Keywords** (100/100):

```
apicultor,apicultura,abelhas,mel,varroa,rainha,apiário,tratamento,alimentação,xarope,migratória,favo
```

**Description** (1534/4000):

```
O Mobil Arıcı reúne o caderno de campo, os registros e os documentos do apicultor em um só celular. Funciona sem internet no apiário e, com botões grandes e modo luva, dá para usar ao lado da colmeia até de luvas.

Apiários e colmeias
• Salve seus apiários com a localização e crie colmeias uma a uma ou em lote
• Imprima etiquetas QR para as colmeias e escaneie para abrir a ficha
• Mude colmeias de apiário e veja o histórico
• Acompanhe idade, raça e cor de cada rainha; registre lotes de criação de rainhas

Revisão e sanidade
• Revisões com poucos toques: força, cria, rainha, comportamento, reservas
• Contagens de varroa e tratamentos, com cálculo do período de carência
• Adicione fotos e notas de voz aos registros

Alimentação, colheita e vendas
• Registros de alimentação com calculadora de xarope
• Registre a colheita colmeia por colmeia e crie lotes de mel
• Receitas, despesas, clientes e pagamentos; estoque e lista de materiais

Apicultura migratória
• Plano de migração, paradas e mudanças
• Baixe mapas ao redor dos apiários para usar off-line
• Previsão do tempo de cada apiário

Equipe
• Convide sócio, funcionários ou consultor; cada um vê e registra conforme sua função
• Os registros são sincronizados com os celulares da equipe quando há internet

Relatórios e documentos
• Relatório da safra e relatórios em PDF
• Exporte todos os registros para Excel
• Guarde licenças, certificados e recibos junto com os registros

Disponível em português, inglês, turco, alemão, espanhol, russo, ucraniano, persa e hindi.
```

---

## ru — Русский

App Store Connect dili: **Russian**

**Name** (28/30):

```
Mobil Arıcı: Пасечный журнал
```

**Subtitle** (24/30):

```
Ульи, осмотры и медосбор
```

**Promotional Text** (138/170):

```
Записывайте осмотры, варроа, обработки, подкормки и медосбор прямо у улья, в перчатках и без связи. Вся команда видит одни и те же записи.
```

**Keywords** (96/100):

```
пчеловод,пчеловодство,пчелы,пасека,мёд,варроа,матка,подкормка,сироп,кочёвка,обработка,пчелосемья
```

**Description** (1468/4000):

```
Mobil Arıcı собирает пасечный журнал, записи и документы пчеловода в одном телефоне. Приложение работает на точке без интернета, а крупные кнопки и режим перчаток позволяют пользоваться им у улья прямо в перчатках.

Пасеки и ульи
• Сохраняйте пасеки с координатами, добавляйте ульи по одному или сразу партией
• Печатайте QR-этикетки для ульев и сканируйте их, чтобы открыть карточку улья
• Переставляйте ульи между пасеками и смотрите их историю
• Следите за возрастом, породой и цветовой меткой маток; записывайте партии вывода маток

Осмотр и здоровье
• Осмотр в несколько касаний: сила, расплод, матка, нрав, корм
• Подсчёты варроа и обработки с расчётом срока ожидания
• Прикрепляйте к записям фото и голосовые заметки

Подкормка, медосбор и продажи
• Подкормки с калькулятором сиропа
• Записывайте медосбор по каждому улью и создавайте партии мёда
• Доходы, расходы, клиенты и оплаты; склад и список материалов

Кочёвка
• План кочёвки, стоянки и переезды
• Скачивайте карты вокруг пасек для работы офлайн
• Погода для каждой пасеки

Команда
• Приглашайте партнёра, работников или консультанта; каждый видит и записывает по своей роли
• Записи синхронизируются на телефонах всей команды, когда появляется интернет

Отчёты и документы
• Отчёт за сезон и отчёты в PDF
• Экспорт всех записей в Excel
• Храните разрешения, справки и чеки вместе с записями

Доступно на русском, английском, турецком, немецком, испанском, португальском, украинском, персидском и хинди.
```

---

## uk — Українська

App Store Connect dili: **Ukrainian**

**Name** (28/30):

```
Mobil Arıcı: Пасічний журнал
```

**Subtitle** (25/30):

```
Вулики, огляди й медозбір
```

**Promotional Text** (139/170):

```
Записуйте огляди, варроа, обробки, підгодівлі й медозбір просто біля вулика, у рукавичках і без зв'язку. Уся команда бачить ті самі записи.
```

**Keywords** (97/100):

```
пасічник,бджільництво,бджоли,пасіка,мед,варроа,матка,підгодівля,сироп,кочівля,обробка,бджолосім'я
```

**Description** (1498/4000):

```
Mobil Arıcı збирає пасічний журнал, записи та документи пасічника в одному телефоні. Застосунок працює на точку без інтернету, а великі кнопки й режим рукавичок дають змогу користуватися ним біля вулика просто в рукавичках.

Пасіки й вулики
• Зберігайте пасіки з координатами, додавайте вулики по одному або одразу партією
• Друкуйте QR-етикетки для вуликів і скануйте їх, щоб відкрити картку вулика
• Переставляйте вулики між пасіками й переглядайте їхню історію
• Стежте за віком, породою та кольоровою міткою маток; записуйте партії виведення маток

Огляд і здоров'я
• Огляд у кілька дотиків: сила, розплід, матка, вдача, корм
• Підрахунки варроа й обробки з розрахунком терміну очікування
• Додавайте до записів фото й голосові нотатки

Підгодівля, медозбір і продажі
• Підгодівлі з калькулятором сиропу
• Записуйте медозбір по кожному вулику й створюйте партії меду
• Доходи, витрати, клієнти й оплати; склад і список матеріалів

Кочівля
• План кочівлі, стоянки й переїзди
• Завантажуйте мапи навколо пасік для роботи офлайн
• Погода для кожної пасіки

Команда
• Запрошуйте партнера, працівників або консультанта; кожен бачить і записує відповідно до своєї ролі
• Записи синхронізуються на телефонах усієї команди, щойно з'являється інтернет

Звіти й документи
• Звіт за сезон і звіти в PDF
• Експорт усіх записів в Excel
• Зберігайте дозволи, довідки й чеки разом із записами

Доступно українською, англійською, турецькою, німецькою, іспанською, португальською, російською, перською та гінді.
```

---

## hi — हिन्दी

App Store Connect dili: **Hindi**

**Name** (27/30):

```
Mobil Arıcı: मधुमक्खी डायरी
```

**Subtitle** (29/30):

```
छत्ते, निरीक्षण और शहद निकासी
```

**Promotional Text** (141/170):

```
छत्ते के पास दस्ताने पहनकर और बिना नेटवर्क के निरीक्षण, वरोआ, उपचार, भोजन और शहद निकासी दर्ज करें। पूरी टीम के फ़ोन पर रिकॉर्ड सिंक रहते हैं।
```

**Keywords** (83/100):

```
शहद,मधुपालन,वरोआ,रानी मक्खी,छत्ता,फार्म,उपचार,चाशनी,प्रवासी,beekeeping,honey,apiary
```

**Description** (1394/4000):

```
Mobil Arıcı मधुमक्खी पालक की डायरी, रिकॉर्ड और कागज़ात एक ही फ़ोन में रखता है। यह फार्म पर बिना इंटरनेट के चलता है, और बड़े बटन व दस्ताना मोड की वजह से छत्ते के पास दस्ताने पहनकर भी इस्तेमाल किया जा सकता है।

मधुमक्खी फार्म और छत्ते
• अपने फार्म जगह के साथ सहेजें, छत्ते एक-एक करके या एक साथ बनाएँ
• छत्तों के लिए QR लेबल छापें और स्कैन करके छत्ते का कार्ड खोलें
• छत्तों को एक फार्म से दूसरे में ले जाएँ और उनका इतिहास देखें
• हर रानी की उम्र, नस्ल और रंग कोड पर नज़र रखें; रानी पालन के बैच दर्ज करें

निरीक्षण और स्वास्थ्य
• कुछ टैप में निरीक्षण: ताकत, ब्रूड, रानी, स्वभाव, भोजन भंडार
• वरोआ गिनती और उपचार रिकॉर्ड, प्रतीक्षा अवधि की गणना के साथ
• रिकॉर्ड में फ़ोटो और आवाज़ नोट जोड़ें

भोजन, शहद निकासी और बिक्री
• चाशनी कैलकुलेटर के साथ भोजन रिकॉर्ड
• हर छत्ते की शहद निकासी दर्ज करें और शहद के लॉट बनाएँ
• आय, खर्च, ग्राहक और भुगतान; स्टॉक और सामग्री सूची

प्रवासी मधुमक्खी पालन
• प्रवास योजना, पड़ाव और प्रवास रिकॉर्ड
• फार्म के आसपास के नक्शे ऑफ़लाइन इस्तेमाल के लिए डाउनलोड करें
• हर फार्म का मौसम

टीम
• साथी, कामगार या सलाहकार को आमंत्रित करें; हर कोई अपनी भूमिका के अनुसार देखता और लिखता है
• इंटरनेट आने पर रिकॉर्ड टीम के सभी फ़ोन पर सिंक हो जाते हैं

रिपोर्ट और दस्तावेज़
• सीज़न रिपोर्ट और PDF रिपोर्ट
• सभी रिकॉर्ड Excel में निर्यात करें
• परमिट, प्रमाणपत्र और रसीदें रिकॉर्ड के साथ रखें

हिन्दी, अंग्रेज़ी, तुर्की, जर्मन, स्पेनिश, पुर्तगाली, रूसी, यूक्रेनी और फ़ारसी में उपलब्ध।
```
