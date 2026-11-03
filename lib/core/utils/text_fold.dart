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

const _folds = {
  'İ': 'i',
  'ı': 'i',
  'ç': 'c',
  'ğ': 'g',
  'ö': 'o',
  'ş': 's',
  'ü': 'u',
  'â': 'a',
  'å': 'a',
  'ã': 'a',
  'é': 'e',
  'í': 'i',
  'î': 'i',
  'ô': 'o',
  'û': 'u',
  '’': "'",
};
