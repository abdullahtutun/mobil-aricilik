import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/features/reports/domain/report.dart';
import 'package:mobil_arici/features/reports/domain/report_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_form_controller.freezed.dart';
part 'report_form_controller.g.dart';

@freezed
abstract class ReportFormState with _$ReportFormState {
  const factory({
    /// Dönemin ilk ve son günü (yerel takvimde gece yarısı); ilk gün son
    /// günden sonra olamaz.
    required DateTime from,
    required DateTime to,
    @Default(ReportKind.treatmentRegister) ReportKind kind,

    /// Boşsa bütün arılıklar.
    String? apiaryId,

    /// Yalnız kovan geçmişinde; boşsa kapsamdaki bütün kovanlar.
    String? hiveId,

    /// PDF'in dili; boşsa uygulamanın dili.
    AppLanguage? language,
  }) = _ReportFormState;
}

/// Rapor ekranının seçimleri; ekran açık kaldığı sürece yaşar. Dönem bu
/// yılın başından bugüne açılır.
@riverpod
class ReportFormController extends _$ReportFormController {
  @override
  ReportFormState build() {
    final period = defaultReportPeriod(clock.now());
    return ReportFormState(from: period.from, to: period.to);
  }

  void setKind(ReportKind kind) => state = state.copyWith(kind: kind);

  /// İlk gün son günden sonraysa son gün de o gün olur.
  void setFrom(DateTime day) => state = state.copyWith(
    from: day,
    to: day.isAfter(state.to) ? day : state.to,
  );

  /// Son gün ilk günden önceyse ilk gün de o gün olur.
  void setTo(DateTime day) => state = state.copyWith(
    to: day,
    from: day.isBefore(state.from) ? day : state.from,
  );

  /// Arılık değişince kovan seçimi kalkar.
  void setApiary(String? apiaryId) =>
      state = state.copyWith(apiaryId: apiaryId, hiveId: null);

  void setHive(String? hiveId) => state = state.copyWith(hiveId: hiveId);

  void setLanguage(AppLanguage language) =>
      state = state.copyWith(language: language);
}
