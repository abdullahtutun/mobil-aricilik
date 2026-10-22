/// Ad sıralaması. Büyük-küçük harf gözetilmez; Türkçe harfler alfabedeki
/// yerinde durur (c < ç < d, ı < i, s < ş < t); rakam dizileri sayı
/// değeriyle karşılaştırılır ("Arılık 2" < "Arılık 10"). SQLite metin
/// sırası bunların hiçbirini yapmaz.
///
/// Büyük `I`, `i` sayılır. Yalnız büyük-küçük harfte ya da baştaki sıfırda
/// ayrılan adlar kendi aralarında metin sırasıyla dizilir.
int compareNatural(String a, String b) {
  final left = a.runes.toList();
  final right = b.runes.toList();
  var i = 0;
  var j = 0;
  while (i < left.length && j < right.length) {
    if (_isDigit(left[i]) && _isDigit(right[j])) {
      final leftEnd = _digitsEnd(left, i);
      final rightEnd = _digitsEnd(right, j);
      final order = _compareNumbers(left, i, leftEnd, right, j, rightEnd);
      if (order != 0) return order;
      i = leftEnd;
      j = rightEnd;
      continue;
    }
    final order = _rank(left[i]).compareTo(_rank(right[j]));
    if (order != 0) return order;
    i++;
    j++;
  }
  final remaining = (left.length - i).compareTo(right.length - j);
  return remaining != 0 ? remaining : a.compareTo(b);
}

bool _isDigit(int rune) => rune >= _zero && rune <= _nine;

int _digitsEnd(List<int> runes, int start) {
  var end = start;
  while (end < runes.length && _isDigit(runes[end])) {
    end++;
  }
  return end;
}

/// Baştaki sıfırlar atılınca uzun olan büyüktür; boy eşitse rakam rakam.
int _compareNumbers(
  List<int> left,
  int leftStart,
  int leftEnd,
  List<int> right,
  int rightStart,
  int rightEnd,
) {
  var i = leftStart;
  var j = rightStart;
  while (i < leftEnd - 1 && left[i] == _zero) {
    i++;
  }
  while (j < rightEnd - 1 && right[j] == _zero) {
    j++;
  }
  final length = (leftEnd - i).compareTo(rightEnd - j);
  if (length != 0) return length;
  for (; i < leftEnd; i++, j++) {
    final digit = left[i].compareTo(right[j]);
    if (digit != 0) return digit;
  }
  return 0;
}

/// Harfin sıra değeri: küçük harfin kod noktasının iki katı. Türkçe harfler
/// temel harfin hemen ardına (`ı` hemen önüne) yerleşir.
int _rank(int rune) {
  final char = String.fromCharCode(rune);
  if (_turkishRanks[char] case final rank?) return rank;
  final lower = char.toLowerCase();
  if (_turkishRanks[lower] case final rank?) return rank;
  // `toLowerCase` bazı harflerde birden çok karakter üretir; ilki yeter.
  return lower.runes.first * 2;
}

const _zero = 0x30;
const _nine = 0x39;

int _after(String base) => base.codeUnitAt(0) * 2 + 1;

final Map<String, int> _turkishRanks = {
  'ç': _after('c'),
  'ğ': _after('g'),
  'ı': 'i'.codeUnitAt(0) * 2 - 1,
  'İ': 'i'.codeUnitAt(0) * 2,
  'ö': _after('o'),
  'ş': _after('s'),
  'ü': _after('u'),
};
