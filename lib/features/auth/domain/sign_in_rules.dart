/// E-postadaki kodun hane sayısı (`config.toml` → `auth.email.otp_length`).
const int otpLength = 6;

/// Yeni kod istemeden önce beklenen süre. Supabase aynı adrese 60 saniyede
/// bir e-posta gönderir (`auth.email.max_frequency`); erken istek reddedilir.
const Duration resendCooldown = Duration(seconds: 60);

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
final _otpRun = RegExp('(?<![0-9])[0-9]{$otpLength}(?![0-9])');
final _nonDigit = RegExp('[^0-9]');

/// Baştaki/sondaki boşluğu atar, küçük harfe çevirir; aynı adres iki
/// yazımla iki ayrı hesap gibi görünmesin.
String normalizeEmail(String input) => input.trim().toLowerCase();

/// Kaba biçim denetimi; gerçek doğrulamayı gelen kod yapar.
bool isValidEmail(String email) => _emailPattern.hasMatch(email);

/// Yazılan ya da yapıştırılan metinden kodu çıkarır. "Kodun: 123456" veya
/// "123 456" gibi metinlerde de çalışır: önce tam [otpLength] haneli bir
/// sayı aranır, yoksa rakamlar sırayla alınır ve [otpLength]'e kırpılır.
String extractOtpCode(String input) {
  final run = _otpRun.firstMatch(input);
  if (run != null) return run.group(0)!;
  final digits = input.replaceAll(_nonDigit, '');
  return digits.length > otpLength ? digits.substring(0, otpLength) : digits;
}

/// Kod alanındaki değişikliği koda çevirir. Eklenen metin tam bir kod
/// içeriyorsa (yapıştırma, otomatik doldurma) yarım girişin sonuna eklenmez,
/// onun yerine geçer.
String otpInput({required String previous, required String next}) {
  if (next.startsWith(previous)) {
    final inserted = extractOtpCode(next.substring(previous.length));
    if (inserted.length == otpLength) return inserted;
  }
  return extractOtpCode(next);
}
