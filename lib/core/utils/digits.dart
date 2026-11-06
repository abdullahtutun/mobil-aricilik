import 'package:flutter/services.dart';

/// Farsça (۰–۹) ve Arapça (٠–٩) rakamları Latin rakama, Arapça ondalık
/// ayırıcıyı (٫) virgüle çevirir. Farsça klavye bu rakamları yazar; uygulama
/// sayıları Latin rakamla ayrıştırır ve gösterir. Her karakter tek
/// karaktere eşlendiği için uzunluk değişmez.
String asciiDigits(String text) {
  final buffer = StringBuffer();
  for (final unit in text.codeUnits) {
    buffer.writeCharCode(switch (unit) {
      >= _persianZero && <= _persianNine => unit - _persianZero + _asciiZero,
      >= _arabicZero && <= _arabicNine => unit - _arabicZero + _asciiZero,
      _arabicDecimal => _comma,
      _ => unit,
    });
  }
  return buffer.toString();
}

/// Sayısal alanların ilk biçimlendiricisi: rakam süzgecinden önce Farsça ve
/// Arapça rakamları Latin'e çevirir; yoksa süzgeç onları siler.
class AsciiDigitsFormatter extends TextInputFormatter {
  const new();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = asciiDigits(newValue.text);
    return text == newValue.text ? newValue : newValue.copyWith(text: text);
  }
}

const _asciiZero = 0x30;
const _comma = 0x2C;
const _persianZero = 0x06F0;
const _persianNine = 0x06F9;
const _arabicZero = 0x0660;
const _arabicNine = 0x0669;
const _arabicDecimal = 0x066B;
