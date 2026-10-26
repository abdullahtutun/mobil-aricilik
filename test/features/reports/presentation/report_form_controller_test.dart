import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/reports/domain/report.dart';
import 'package:mobil_arici/features/reports/presentation/report_form_controller.dart';

void main() {
  late ProviderContainer container;
  ReportFormController controller() =>
      container.read(reportFormControllerProvider.notifier);
  ReportFormState form() => container.read(reportFormControllerProvider);

  setUp(() {
    container = ProviderContainer.test();
    withClock(Clock.fixed(DateTime(2026, 10, 24, 15)), form);
  });

  test('bu yılın başından bugüne, ilaç kayıt defteriyle açılır', () {
    expect(form().from, DateTime(2026));
    expect(form().to, DateTime(2026, 10, 24));
    expect(form().kind, ReportKind.treatmentRegister);
    expect(form().apiaryId, isNull);
  });

  test('başlangıç bitişten sonraya alınırsa bitiş de o gün olur', () {
    controller().setFrom(DateTime(2026, 11, 2));
    expect(form().to, DateTime(2026, 11, 2));

    controller().setFrom(DateTime(2026, 3));
    expect(form().to, DateTime(2026, 11, 2));
  });

  test('bitiş başlangıçtan önceye alınırsa başlangıç da o gün olur', () {
    controller()
      ..setFrom(DateTime(2026, 6))
      ..setTo(DateTime(2026, 5, 3));
    expect(form().from, DateTime(2026, 5, 3));
  });

  test('arılık değişince kovan seçimi kalkar', () {
    controller()
      ..setKind(ReportKind.hiveHistory)
      ..setApiary('a1')
      ..setHive('h1');
    expect(form().hiveId, 'h1');

    controller().setApiary('a2');
    expect(form().apiaryId, 'a2');
    expect(form().hiveId, isNull);
  });
}
