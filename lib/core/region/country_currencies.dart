/// Ülke kodu (ISO 3166-1 alpha-2) → para birimi (ISO 4217).
///
/// Birden fazla resmi para birimi olan ülkelerde ISO 4217'de ilk sıradaki
/// yerel para birimi seçildi (ör. Panama `PAB`, Butan `BTN`). Antarktika'nın
/// (AQ) para birimi yok; [fallbackCurrencyCode] kullanılır. Kosova (XK) resmi
/// ISO kodu değil ama yaygın kullanıldığı için tabloda.
const countryCurrencyCodes = <String, String>{
  'AD': 'EUR', // Andorra
  'AE': 'AED', // Birleşik Arap Emirlikleri
  'AF': 'AFN', // Afganistan
  'AG': 'XCD', // Antigua ve Barbuda
  'AI': 'XCD', // Anguilla
  'AL': 'ALL', // Arnavutluk
  'AM': 'AMD', // Ermenistan
  'AO': 'AOA', // Angola
  'AR': 'ARS', // Arjantin
  'AS': 'USD', // Amerikan Samoası
  'AT': 'EUR', // Avusturya
  'AU': 'AUD', // Avustralya
  'AW': 'AWG', // Aruba
  'AX': 'EUR', // Åland Adaları
  'AZ': 'AZN', // Azerbaycan
  'BA': 'BAM', // Bosna-Hersek
  'BB': 'BBD', // Barbados
  'BD': 'BDT', // Bangladeş
  'BE': 'EUR', // Belçika
  'BF': 'XOF', // Burkina Faso
  'BG': 'EUR', // Bulgaristan (2026'dan beri)
  'BH': 'BHD', // Bahreyn
  'BI': 'BIF', // Burundi
  'BJ': 'XOF', // Benin
  'BL': 'EUR', // Saint Barthélemy
  'BM': 'BMD', // Bermuda
  'BN': 'BND', // Brunei
  'BO': 'BOB', // Bolivya
  'BQ': 'USD', // Karayip Hollandası
  'BR': 'BRL', // Brezilya
  'BS': 'BSD', // Bahamalar
  'BT': 'BTN', // Butan
  'BV': 'NOK', // Bouvet Adası
  'BW': 'BWP', // Botsvana
  'BY': 'BYN', // Belarus
  'BZ': 'BZD', // Belize
  'CA': 'CAD', // Kanada
  'CC': 'AUD', // Cocos (Keeling) Adaları
  'CD': 'CDF', // Kongo Demokratik Cumhuriyeti
  'CF': 'XAF', // Orta Afrika Cumhuriyeti
  'CG': 'XAF', // Kongo
  'CH': 'CHF', // İsviçre
  'CI': 'XOF', // Fildişi Sahili
  'CK': 'NZD', // Cook Adaları
  'CL': 'CLP', // Şili
  'CM': 'XAF', // Kamerun
  'CN': 'CNY', // Çin
  'CO': 'COP', // Kolombiya
  'CR': 'CRC', // Kosta Rika
  'CU': 'CUP', // Küba
  'CV': 'CVE', // Yeşil Burun Adaları
  'CW': 'XCG', // Curaçao (2025'ten beri Karayip guldeni)
  'CX': 'AUD', // Christmas Adası
  'CY': 'EUR', // Kıbrıs
  'CZ': 'CZK', // Çekya
  'DE': 'EUR', // Almanya
  'DJ': 'DJF', // Cibuti
  'DK': 'DKK', // Danimarka
  'DM': 'XCD', // Dominika
  'DO': 'DOP', // Dominik Cumhuriyeti
  'DZ': 'DZD', // Cezayir
  'EC': 'USD', // Ekvador
  'EE': 'EUR', // Estonya
  'EG': 'EGP', // Mısır
  'EH': 'MAD', // Batı Sahra
  'ER': 'ERN', // Eritre
  'ES': 'EUR', // İspanya
  'ET': 'ETB', // Etiyopya
  'FI': 'EUR', // Finlandiya
  'FJ': 'FJD', // Fiji
  'FK': 'FKP', // Falkland Adaları
  'FM': 'USD', // Mikronezya
  'FO': 'DKK', // Faroe Adaları
  'FR': 'EUR', // Fransa
  'GA': 'XAF', // Gabon
  'GB': 'GBP', // Birleşik Krallık
  'GD': 'XCD', // Grenada
  'GE': 'GEL', // Gürcistan
  'GF': 'EUR', // Fransız Guyanası
  'GG': 'GBP', // Guernsey
  'GH': 'GHS', // Gana
  'GI': 'GIP', // Cebelitarık
  'GL': 'DKK', // Grönland
  'GM': 'GMD', // Gambiya
  'GN': 'GNF', // Gine
  'GP': 'EUR', // Guadeloupe
  'GQ': 'XAF', // Ekvator Ginesi
  'GR': 'EUR', // Yunanistan
  'GS': 'GBP', // Güney Georgia ve Güney Sandwich Adaları
  'GT': 'GTQ', // Guatemala
  'GU': 'USD', // Guam
  'GW': 'XOF', // Gine-Bissau
  'GY': 'GYD', // Guyana
  'HK': 'HKD', // Hong Kong
  'HM': 'AUD', // Heard ve McDonald Adaları
  'HN': 'HNL', // Honduras
  'HR': 'EUR', // Hırvatistan
  'HT': 'HTG', // Haiti
  'HU': 'HUF', // Macaristan
  'ID': 'IDR', // Endonezya
  'IE': 'EUR', // İrlanda
  'IL': 'ILS', // İsrail
  'IM': 'GBP', // Man Adası
  'IN': 'INR', // Hindistan
  'IO': 'USD', // Britanya Hint Okyanusu Toprakları
  'IQ': 'IQD', // Irak
  'IR': 'IRR', // İran
  'IS': 'ISK', // İzlanda
  'IT': 'EUR', // İtalya
  'JE': 'GBP', // Jersey
  'JM': 'JMD', // Jamaika
  'JO': 'JOD', // Ürdün
  'JP': 'JPY', // Japonya
  'KE': 'KES', // Kenya
  'KG': 'KGS', // Kırgızistan
  'KH': 'KHR', // Kamboçya
  'KI': 'AUD', // Kiribati
  'KM': 'KMF', // Komorlar
  'KN': 'XCD', // Saint Kitts ve Nevis
  'KP': 'KPW', // Kuzey Kore
  'KR': 'KRW', // Güney Kore
  'KW': 'KWD', // Kuveyt
  'KY': 'KYD', // Cayman Adaları
  'KZ': 'KZT', // Kazakistan
  'LA': 'LAK', // Laos
  'LB': 'LBP', // Lübnan
  'LC': 'XCD', // Saint Lucia
  'LI': 'CHF', // Lihtenştayn
  'LK': 'LKR', // Sri Lanka
  'LR': 'LRD', // Liberya
  'LS': 'LSL', // Lesotho
  'LT': 'EUR', // Litvanya
  'LU': 'EUR', // Lüksemburg
  'LV': 'EUR', // Letonya
  'LY': 'LYD', // Libya
  'MA': 'MAD', // Fas
  'MC': 'EUR', // Monako
  'MD': 'MDL', // Moldova
  'ME': 'EUR', // Karadağ
  'MF': 'EUR', // Saint Martin
  'MG': 'MGA', // Madagaskar
  'MH': 'USD', // Marshall Adaları
  'MK': 'MKD', // Kuzey Makedonya
  'ML': 'XOF', // Mali
  'MM': 'MMK', // Myanmar
  'MN': 'MNT', // Moğolistan
  'MO': 'MOP', // Makao
  'MP': 'USD', // Kuzey Mariana Adaları
  'MQ': 'EUR', // Martinik
  'MR': 'MRU', // Moritanya
  'MS': 'XCD', // Montserrat
  'MT': 'EUR', // Malta
  'MU': 'MUR', // Mauritius
  'MV': 'MVR', // Maldivler
  'MW': 'MWK', // Malavi
  'MX': 'MXN', // Meksika
  'MY': 'MYR', // Malezya
  'MZ': 'MZN', // Mozambik
  'NA': 'NAD', // Namibya
  'NC': 'XPF', // Yeni Kaledonya
  'NE': 'XOF', // Nijer
  'NF': 'AUD', // Norfolk Adası
  'NG': 'NGN', // Nijerya
  'NI': 'NIO', // Nikaragua
  'NL': 'EUR', // Hollanda
  'NO': 'NOK', // Norveç
  'NP': 'NPR', // Nepal
  'NR': 'AUD', // Nauru
  'NU': 'NZD', // Niue
  'NZ': 'NZD', // Yeni Zelanda
  'OM': 'OMR', // Umman
  'PA': 'PAB', // Panama
  'PE': 'PEN', // Peru
  'PF': 'XPF', // Fransız Polinezyası
  'PG': 'PGK', // Papua Yeni Gine
  'PH': 'PHP', // Filipinler
  'PK': 'PKR', // Pakistan
  'PL': 'PLN', // Polonya
  'PM': 'EUR', // Saint Pierre ve Miquelon
  'PN': 'NZD', // Pitcairn Adaları
  'PR': 'USD', // Porto Riko
  'PS': 'ILS', // Filistin
  'PT': 'EUR', // Portekiz
  'PW': 'USD', // Palau
  'PY': 'PYG', // Paraguay
  'QA': 'QAR', // Katar
  'RE': 'EUR', // Réunion
  'RO': 'RON', // Romanya
  'RS': 'RSD', // Sırbistan
  'RU': 'RUB', // Rusya
  'RW': 'RWF', // Ruanda
  'SA': 'SAR', // Suudi Arabistan
  'SB': 'SBD', // Solomon Adaları
  'SC': 'SCR', // Seyşeller
  'SD': 'SDG', // Sudan
  'SE': 'SEK', // İsveç
  'SG': 'SGD', // Singapur
  'SH': 'SHP', // Saint Helena
  'SI': 'EUR', // Slovenya
  'SJ': 'NOK', // Svalbard ve Jan Mayen
  'SK': 'EUR', // Slovakya
  'SL': 'SLE', // Sierra Leone
  'SM': 'EUR', // San Marino
  'SN': 'XOF', // Senegal
  'SO': 'SOS', // Somali
  'SR': 'SRD', // Surinam
  'SS': 'SSP', // Güney Sudan
  'ST': 'STN', // São Tomé ve Príncipe
  'SV': 'USD', // El Salvador
  'SX': 'XCG', // Sint Maarten (2025'ten beri Karayip guldeni)
  'SY': 'SYP', // Suriye
  'SZ': 'SZL', // Esvatini
  'TC': 'USD', // Turks ve Caicos Adaları
  'TD': 'XAF', // Çad
  'TF': 'EUR', // Fransız Güney Toprakları
  'TG': 'XOF', // Togo
  'TH': 'THB', // Tayland
  'TJ': 'TJS', // Tacikistan
  'TK': 'NZD', // Tokelau
  'TL': 'USD', // Doğu Timor
  'TM': 'TMT', // Türkmenistan
  'TN': 'TND', // Tunus
  'TO': 'TOP', // Tonga
  'TR': 'TRY', // Türkiye
  'TT': 'TTD', // Trinidad ve Tobago
  'TV': 'AUD', // Tuvalu
  'TW': 'TWD', // Tayvan
  'TZ': 'TZS', // Tanzanya
  'UA': 'UAH', // Ukrayna
  'UG': 'UGX', // Uganda
  'UM': 'USD', // ABD Küçük Dış Adaları
  'US': 'USD', // Amerika Birleşik Devletleri
  'UY': 'UYU', // Uruguay
  'UZ': 'UZS', // Özbekistan
  'VA': 'EUR', // Vatikan
  'VC': 'XCD', // Saint Vincent ve Grenadinler
  'VE': 'VES', // Venezuela
  'VG': 'USD', // Britanya Virjin Adaları
  'VI': 'USD', // ABD Virjin Adaları
  'VN': 'VND', // Vietnam
  'VU': 'VUV', // Vanuatu
  'WF': 'XPF', // Wallis ve Futuna
  'WS': 'WST', // Samoa
  'XK': 'EUR', // Kosova
  'YE': 'YER', // Yemen
  'YT': 'EUR', // Mayotte
  'ZA': 'ZAR', // Güney Afrika
  'ZM': 'ZMW', // Zambiya
  'ZW': 'ZWG', // Zimbabve (2024'ten beri ZiG)
};

/// Tabloda olmayan ülkelerde kullanılan para birimi.
const fallbackCurrencyCode = 'USD';

/// [countryCode] büyük harf ISO 3166-1 alpha-2 olmalı.
String currencyCodeFor(String countryCode) =>
    countryCurrencyCodes[countryCode] ?? fallbackCurrencyCode;
