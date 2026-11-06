import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/services/pdf_fonts.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  test('PDF yönü: Farsça RTL, diğer diller LTR', () {
    expect(pdfTextDirection('fa'), pw.TextDirection.rtl);
    expect(pdfTextDirection('fa_IR'), pw.TextDirection.rtl);
    expect(pdfTextDirection('tr'), pw.TextDirection.ltr);
    expect(pdfTextDirection('ru'), pw.TextDirection.ltr);
  });

  test('metnin yönü ilk harfinden', () {
    expect(pdfTextDirectionOf('کندوی ۱۰۱'), pw.TextDirection.rtl);
    expect(pdfTextDirectionOf('101 کندو'), pw.TextDirection.rtl);
    expect(pdfTextDirectionOf('Yayla arılığı'), pw.TextDirection.ltr);
    expect(pdfTextDirectionOf('Пасека'), pw.TextDirection.ltr);
    expect(pdfTextDirectionOf('101'), pw.TextDirection.ltr);
    expect(pdfTextDirectionOf(''), pw.TextDirection.ltr);
  });

  test('PDF teması Farsça için yedek font taşır', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final theme = await interPdfTheme();
    expect(theme.defaultTextStyle.fontFallback, hasLength(1));
  });
}
