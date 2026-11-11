package lotpage

// texts is one language's wording of the page; the tables are
// supabase/functions/lot-page/page.ts (text) verbatim. Every language of
// auth.Locales has one; TestTextsEveryLanguage checks it.
type texts struct {
	Lot   string
	Honey map[string]string
	// Hives is a fmt format with the formatted count (%s).
	Hives           string
	Lab             string
	Moisture        string
	HMF             string
	Diastase        string
	Proline         string
	Residue         string
	ResidueNone     string
	ResidueDetected string
	Report          string
	Footer          string
	NotFound        string
	NotFoundHint    string
}

var textTable = map[string]texts{
	"tr": {
		Lot: "Lot",
		Honey: map[string]string{
			"pine": "Çam balı", "flower": "Çiçek balı", "chestnut": "Kestane balı",
			"citrus": "Narenciye balı", "other": "Bal",
		},
		Hives:           "%s kovan",
		Lab:             "Laboratuvar analizi",
		Moisture:        "Nem",
		HMF:             "HMF",
		Diastase:        "Diastaz sayısı",
		Proline:         "Prolin",
		Residue:         "İlaç kalıntısı",
		ResidueNone:     "Tespit edilmedi",
		ResidueDetected: "Tespit edildi",
		Report:          "Analiz raporunu aç",
		Footer:          "Bu sayfa üretici tarafından Mobil Arıcı ile yayımlandı.",
		NotFound:        "Bu lot yayımda değil",
		NotFoundHint:    "Sayfa kaldırılmış ya da adres hatalı olabilir. Ürünle ilgili sorular için üreticiye başvurun.",
	},
	"en": {
		Lot: "Lot",
		Honey: map[string]string{
			"pine": "Pine honey", "flower": "Flower honey", "chestnut": "Chestnut honey",
			"citrus": "Citrus honey", "other": "Honey",
		},
		Hives:           "%s hives",
		Lab:             "Laboratory analysis",
		Moisture:        "Moisture",
		HMF:             "HMF",
		Diastase:        "Diastase number",
		Proline:         "Proline",
		Residue:         "Drug residue",
		ResidueNone:     "Not detected",
		ResidueDetected: "Detected",
		Report:          "Open analysis report",
		Footer:          "This page was published by the producer with Mobil Arıcı.",
		NotFound:        "This lot is not published",
		NotFoundHint:    "The page may have been removed or the address may be wrong. Contact the producer about the product.",
	},
	"de": {
		Lot: "Charge",
		Honey: map[string]string{
			"pine": "Pinienhonig", "flower": "Blütenhonig", "chestnut": "Kastanienhonig",
			"citrus": "Zitrushonig", "other": "Honig",
		},
		Hives:           "%s Völker",
		Lab:             "Laboranalyse",
		Moisture:        "Wassergehalt",
		HMF:             "HMF",
		Diastase:        "Diastasezahl",
		Proline:         "Prolin",
		Residue:         "Arzneimittelrückstände",
		ResidueNone:     "Nicht nachgewiesen",
		ResidueDetected: "Nachgewiesen",
		Report:          "Analysebericht öffnen",
		Footer:          "Diese Seite wurde vom Erzeuger mit Mobil Arıcı veröffentlicht.",
		NotFound:        "Diese Charge ist nicht veröffentlicht",
		NotFoundHint:    "Die Seite wurde vielleicht entfernt oder die Adresse ist falsch. Wende dich bei Fragen zum Produkt an den Erzeuger.",
	},
	"es": {
		Lot: "Lote",
		Honey: map[string]string{
			"pine": "Miel de pino", "flower": "Miel de milflores", "chestnut": "Miel de castaño",
			"citrus": "Miel de azahar", "other": "Miel",
		},
		Hives:           "%s colmenas",
		Lab:             "Análisis de laboratorio",
		Moisture:        "Humedad",
		HMF:             "HMF",
		Diastase:        "Índice de diastasa",
		Proline:         "Prolina",
		Residue:         "Residuos de medicamentos",
		ResidueNone:     "No detectados",
		ResidueDetected: "Detectados",
		Report:          "Abrir informe del análisis",
		Footer:          "Esta página la publicó el productor con Mobil Arıcı.",
		NotFound:        "Este lote no está publicado",
		NotFoundHint:    "Puede que la página se haya retirado o que la dirección sea incorrecta. Para dudas sobre el producto, contacta con el productor.",
	},
	"pt": {
		Lot: "Lote",
		Honey: map[string]string{
			"pine": "Mel de pinho", "flower": "Mel silvestre", "chestnut": "Mel de castanheiro",
			"citrus": "Mel de laranjeira", "other": "Mel",
		},
		Hives:           "%s colmeias",
		Lab:             "Análise laboratorial",
		Moisture:        "Umidade",
		HMF:             "HMF",
		Diastase:        "Índice de diastase",
		Proline:         "Prolina",
		Residue:         "Resíduos de medicamentos",
		ResidueNone:     "Não detectados",
		ResidueDetected: "Detectados",
		Report:          "Abrir laudo da análise",
		Footer:          "Esta página foi publicada pelo produtor com o Mobil Arıcı.",
		NotFound:        "Este lote não está publicado",
		NotFoundHint:    "A página pode ter sido removida ou o endereço está errado. Para dúvidas sobre o produto, fale com o produtor.",
	},
	"ru": {
		Lot: "Партия",
		Honey: map[string]string{
			"pine": "Сосновый мёд", "flower": "Цветочный мёд", "chestnut": "Каштановый мёд",
			"citrus": "Цитрусовый мёд", "other": "Мёд",
		},
		Hives:           "ульев: %s",
		Lab:             "Лабораторный анализ",
		Moisture:        "Влажность",
		HMF:             "ГМФ",
		Diastase:        "Диастазное число",
		Proline:         "Пролин",
		Residue:         "Остатки препаратов",
		ResidueNone:     "Не обнаружены",
		ResidueDetected: "Обнаружены",
		Report:          "Открыть протокол анализа",
		Footer:          "Эту страницу опубликовал производитель с помощью Mobil Arıcı.",
		NotFound:        "Эта партия не опубликована",
		NotFoundHint:    "Возможно, страница удалена или адрес неверный. С вопросами о продукте обращайтесь к производителю.",
	},
	"uk": {
		Lot: "Партія",
		Honey: map[string]string{
			"pine": "Сосновий мед", "flower": "Квітковий мед", "chestnut": "Каштановий мед",
			"citrus": "Цитрусовий мед", "other": "Мед",
		},
		Hives:           "вуликів: %s",
		Lab:             "Лабораторний аналіз",
		Moisture:        "Вологість",
		HMF:             "ГМФ",
		Diastase:        "Діастазне число",
		Proline:         "Пролін",
		Residue:         "Залишки препаратів",
		ResidueNone:     "Не виявлено",
		ResidueDetected: "Виявлено",
		Report:          "Відкрити протокол аналізу",
		Footer:          "Цю сторінку опублікував виробник за допомогою Mobil Arıcı.",
		NotFound:        "Ця партія не опублікована",
		NotFoundHint:    "Можливо, сторінку видалено або адреса неправильна. З питаннями про продукт звертайтеся до виробника.",
	},
	"fa": {
		Lot: "بچ",
		Honey: map[string]string{
			"pine": "عسل کاج", "flower": "عسل گل", "chestnut": "عسل شاه‌بلوط",
			"citrus": "عسل مرکبات", "other": "عسل",
		},
		Hives:           "%s کندو",
		Lab:             "آزمایش آزمایشگاهی",
		Moisture:        "رطوبت",
		HMF:             "HMF",
		Diastase:        "عدد دیاستاز",
		Proline:         "پرولین",
		Residue:         "باقیمانده دارو",
		ResidueNone:     "یافت نشد",
		ResidueDetected: "یافت شد",
		Report:          "باز کردن گزارش آزمایش",
		Footer:          "این صفحه را تولیدکننده با Mobil Arıcı منتشر کرده است.",
		NotFound:        "این بچ منتشر نشده است",
		NotFoundHint:    "ممکن است صفحه برداشته شده یا نشانی اشتباه باشد. برای پرسش درباره محصول با تولیدکننده تماس بگیرید.",
	},
	"hi": {
		Lot: "लॉट",
		Honey: map[string]string{
			"pine": "चीड़ का शहद", "flower": "फूलों का शहद", "chestnut": "चेस्टनट शहद",
			"citrus": "नींबू वर्गीय शहद", "other": "शहद",
		},
		Hives:           "%s छत्ते",
		Lab:             "प्रयोगशाला जाँच",
		Moisture:        "नमी",
		HMF:             "HMF",
		Diastase:        "डायस्टेज़ संख्या",
		Proline:         "प्रोलीन",
		Residue:         "दवा के अवशेष",
		ResidueNone:     "नहीं मिले",
		ResidueDetected: "मिले",
		Report:          "जाँच रिपोर्ट खोलें",
		Footer:          "यह पेज उत्पादक ने Mobil Arıcı से प्रकाशित किया है।",
		NotFound:        "यह लॉट प्रकाशित नहीं है",
		NotFoundHint:    "हो सकता है पेज हटा दिया गया हो या पता गलत हो। उत्पाद के बारे में सवालों के लिए उत्पादक से संपर्क करें।",
	},
}

// numberFormat is a language's Intl.NumberFormat symbols (page.ts
// intlLocales; checked against Node's ICU): decimal mark, group separator,
// minus sign and grouping.
type numberFormat struct {
	Decimal string
	Group   string
	Minus   string
	// MinGroup: es-ES leaves four-digit numbers ungrouped ("1000").
	MinGroup bool
	// Indian: hi-IN groups by three, then by two ("12,34,567").
	Indian bool
}

var numberFormats = map[string]numberFormat{
	"tr": {Decimal: ",", Group: ".", Minus: "-"},
	"en": {Decimal: ".", Group: ",", Minus: "-"},
	"de": {Decimal: ",", Group: ".", Minus: "-"},
	"es": {Decimal: ",", Group: ".", Minus: "-", MinGroup: true},
	"pt": {Decimal: ",", Group: ".", Minus: "-"},
	"ru": {Decimal: ",", Group: " ", Minus: "-"},
	"uk": {Decimal: ",", Group: " ", Minus: "-"},
	// fa-IR-u-ca-gregory-nu-latn: Latin digits, like the app.
	"fa": {Decimal: ".", Group: ",", Minus: "‎−"},
	"hi": {Decimal: ".", Group: ",", Minus: "-", Indian: true},
}

// monthLabels are Intl.DateTimeFormat({month: "long", year: "numeric"}) in
// page.ts's locales: the month names and the pattern around them (%s the
// month, %d the year). Checked against Node's ICU.
var monthLabels = map[string]struct {
	Names  [12]string
	Layout string
}{
	"tr": {[12]string{"Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"}, "%s %d"},
	"en": {[12]string{"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}, "%s %d"},
	"de": {[12]string{"Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"}, "%s %d"},
	"es": {[12]string{"enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"}, "%s de %d"},
	"pt": {[12]string{"janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"}, "%s de %d"},
	"ru": {[12]string{"январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"}, "%s %d г."},
	"uk": {[12]string{"січень", "лютий", "березень", "квітень", "травень", "червень", "липень", "серпень", "вересень", "жовтень", "листопад", "грудень"}, "%s %d р."},
	"fa": {[12]string{"ژانویهٔ", "فوریهٔ", "مارس", "آوریل", "مهٔ", "ژوئن", "ژوئیهٔ", "اوت", "سپتامبر", "اکتبر", "نوامبر", "دسامبر"}, "%s %d"},
	"hi": {[12]string{"जनवरी", "फ़रवरी", "मार्च", "अप्रैल", "मई", "जून", "जुलाई", "अगस्त", "सितंबर", "अक्टूबर", "नवंबर", "दिसंबर"}, "%s %d"},
}
