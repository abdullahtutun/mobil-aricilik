import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Okunan her kodun ham metnini [onCode]'a veren kamera görünümü.
typedef CodeScannerBuilder = Widget Function(ValueChanged<String> onCode);

/// Kamera neden açılamadı.
enum CameraFailure {
  /// Kullanıcı kamera iznini vermedi; Ayarlar'dan açılır.
  permissionDenied,

  /// Cihazda kullanılabilir kamera yok.
  unsupported,

  unknown,
}

/// Arka kamerayla QR ve barkod okur; ağ gerekmez. Ekrandan çıkınca kamera
/// kapanır, uygulama arka plana geçince durur ve dönünce yeniden açılır.
/// Kamera açılamazsa nedeni ekranda yazar.
class CameraCodeScanner extends StatelessWidget {
  const new({required this.onCode, super.key});

  final ValueChanged<String> onCode;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (capture) {
        for (final barcode in capture.barcodes) {
          if (barcode.rawValue case final value? when value.trim().isNotEmpty) {
            onCode(value);
            return;
          }
        }
      },
      errorBuilder: (context, error) =>
          CameraFailureView(switch (error.errorCode) {
            MobileScannerErrorCode.permissionDenied =>
              CameraFailure.permissionDenied,
            MobileScannerErrorCode.unsupported => CameraFailure.unsupported,
            _ => CameraFailure.unknown,
          }),
    );
  }
}

/// Kamera açılamayınca kameranın yerinde görünür.
class CameraFailureView extends StatelessWidget {
  const new(this.failure, {super.key});

  final CameraFailure failure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;

    return ColoredBox(
      color: colors.surface,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.no_photography_rounded,
                size: context.sizes.illustrationIcon,
                color: colors.statusWarning,
              ),
              SizedBox(height: spacing.lg),
              Semantics(
                header: true,
                child: Text(
                  l10n.cameraErrorTitle,
                  textAlign: TextAlign.center,
                  style: context.typography.title,
                ),
              ),
              SizedBox(height: spacing.sm),
              Text(
                switch (failure) {
                  CameraFailure.permissionDenied =>
                    l10n.cameraErrorPermissionDenied,
                  CameraFailure.unsupported => l10n.cameraErrorUnsupported,
                  CameraFailure.unknown => l10n.cameraErrorUnknown,
                },
                textAlign: TextAlign.center,
                style: context.typography.body.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
