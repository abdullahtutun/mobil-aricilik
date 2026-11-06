/// Arama için sadeleştirir: küçük harf, `ı`/`İ` → `i`, Türkçe ve aksanlı
/// harf → düz harf, tipografik kesme → `'`. "KİREÇ", "kirec" ve "Kireç"
/// aynı olur.
String foldForSearch(String text) {
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    final char = String.fromCharCode(rune);
    // `İ`.toLowerCase() iki karakter (i + nokta) üretir; önce eşlenmeli.
    final lower = _folds[char] ?? char.toLowerCase();
    buffer.write(_folds[lower] ?? lower);
  }
  return buffer.toString();
}

/// Küçük harfe çevrilmiş karakterin arama karşılığı. Latin aksanları düz
/// harfe; Rusçada `ё` → `е` (çoğu metinde noktasız yazılır); Farsçada
/// Arapça klavyeden gelen `ي`/`ى` → `ی`, `ك` → `ک`, hemzeli ve
/// medli elif → `ا`.
const _folds = {
  'İ': 'i',
  'ı': 'i',
  'ç': 'c',
  'ğ': 'g',
  'ö': 'o',
  'ş': 's',
  'ü': 'u',
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'ä': 'a',
  'å': 'a',
  'ã': 'a',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'ñ': 'n',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'õ': 'o',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ß': 'ss',
  'ё': 'е',
  'ي': 'ی',
  'ى': 'ی',
  'ك': 'ک',
  'أ': 'ا',
  'إ': 'ا',
  'آ': 'ا',
  '’': "'",
};
