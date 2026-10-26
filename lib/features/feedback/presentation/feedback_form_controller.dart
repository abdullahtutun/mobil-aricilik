import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/services/app_info_service_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';
import 'package:mobil_arici/features/feedback/domain/feedback_rules.dart';
import 'package:mobil_arici/features/feedback/presentation/feedback_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_form_controller.freezed.dart';
part 'feedback_form_controller.g.dart';

@freezed
abstract class FeedbackFormState with _$FeedbackFormState {
  const factory({
    @Default(FeedbackKind.bug) FeedbackKind kind,
    @Default('') String message,

    /// Seçilen ekran görüntüsünün medya klasöründeki dosya adı ve tam
    /// yolu (küçük resim için).
    String? screenshotFileName,
    String? screenshotPath,
    @Default(true) bool includeDeviceInfo,
    @Default(false) bool sending,
  }) = _FeedbackFormState;
}

extension FeedbackFormValidation on FeedbackFormState {
  bool get canSend => !sending && feedbackMessage(message) != null;
}

/// "Görüş bildir" formu. Görüş yerel kuyruğa yazılır; internet yoksa
/// bağlanınca gider. Ekran kapanırken gönderilmemiş görüşün ekran
/// görüntüsü silinir.
@riverpod
class FeedbackFormController extends _$FeedbackFormController {
  var _sent = false;

  /// Seçili ekran görüntüsü; kapanırken `state` okunamadığı için ayrıca.
  String? _screenshot;

  @override
  FeedbackFormState build() {
    final files = ref.read(mediaFileStoreProvider);
    ref.onDispose(() {
      if (_screenshot case final fileName? when !_sent) {
        unawaited(files.delete(fileName));
      }
    });
    return const FeedbackFormState();
  }

  void setKind(FeedbackKind kind) => state = state.copyWith(kind: kind);

  void setMessage(String message) => state = state.copyWith(message: message);

  void setIncludeDeviceInfo({required bool include}) =>
      state = state.copyWith(includeDeviceInfo: include);

  /// Galeriden bir görüntü seçtirir; öncekinin yerine geçer. Vazgeçilirse
  /// bir şey değişmez. Hata `MediaCaptureException`.
  Future<void> pickScreenshot() async {
    final files = ref.read(mediaFileStoreProvider);
    final fileName = 'feedback-${generateId()}.jpg';
    final path = await files.pathOf(fileName);
    final byteSize = await ref.read(cameraServiceProvider).pickImage(path);
    if (byteSize == null) return;
    if (!ref.mounted) {
      await files.delete(fileName);
      return;
    }
    final previous = _screenshot;
    _screenshot = fileName;
    state = state.copyWith(screenshotFileName: fileName, screenshotPath: path);
    if (previous != null) await files.delete(previous);
  }

  Future<void> removeScreenshot() async {
    final fileName = _screenshot;
    if (fileName == null) return;
    _screenshot = null;
    state = state.copyWith(screenshotFileName: null, screenshotPath: null);
    await ref.read(mediaFileStoreProvider).delete(fileName);
  }

  /// Görüşü kuyruğa yazar; yazıldıysa true. [locale] cihaz bilgisine
  /// eklenir.
  Future<bool> send({required String locale}) async {
    final message = feedbackMessage(state.message);
    final orgId = ref.read(currentOrgIdProvider);
    if (state.sending || message == null || orgId == null) return false;
    state = state.copyWith(sending: true);
    try {
      final deviceInfo = state.includeDeviceInfo
          ? feedbackDeviceInfo(
              await ref.read(appInfoServiceProvider).read(),
              locale: locale,
            )
          : null;
      await ref
          .read(feedbackRepositoryProvider)
          .queue(
            orgId: orgId,
            kind: state.kind,
            message: message,
            screenshotFileName: state.screenshotFileName,
            deviceInfo: deviceInfo,
          );
      _sent = true;
      return true;
    } finally {
      if (ref.mounted) state = state.copyWith(sending: false);
    }
  }
}
