import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';

/// Belge türünün adı: hazır türde kullanıcının dilinde, kullanıcı tanımlı
/// türde yazıldığı gibi.
String documentTypeLabel(AppLocalizations l10n, VaultDocument document) =>
    switch (document.type) {
      DocumentType.custom => document.customTypeName ?? '',
      final type => presetDocumentTypeLabel(l10n, type),
    };

/// Hazır belge türünün adı.
String presetDocumentTypeLabel(
  AppLocalizations l10n,
  DocumentType type,
) => switch (type) {
  DocumentType.healthReport => l10n.documentTypeHealthReport,
  DocumentType.transportPermit => l10n.documentTypeTransportPermit,
  DocumentType.migratoryCertificate => l10n.documentTypeMigratoryCertificate,
  DocumentType.businessRegistration => l10n.documentTypeBusinessRegistration,
  DocumentType.landPermit => l10n.documentTypeLandPermit,
  DocumentType.analysisReport => l10n.documentTypeAnalysisReport,
  DocumentType.custom => '',
};

/// Dosya türünün küçük resimdeki etiketi ("PDF", "FOTO").
String documentFileKindLabel(AppLocalizations l10n, DocumentFileKind kind) =>
    switch (kind) {
      DocumentFileKind.photo => l10n.documentFileKindPhoto,
      DocumentFileKind.pdf => l10n.documentFileKindPdf,
    };

/// Dosya boyutu: 1 MB altı KB, üstü bir ondalıkla MB.
String documentFileSize(AppLocalizations l10n, AppFormat format, int bytes) {
  const kb = 1024;
  if (bytes < kb * kb) {
    return l10n.documentFileSizeKb(format.number((bytes / kb).ceil()));
  }
  return l10n.documentFileSizeMb(
    format.number(bytes / (kb * kb), maxFractionDigits: 1),
  );
}

/// Geçerlilik rozeti: durum rengi + ikon + kelime. Süresizde bilgi, uzak
/// tarihte ay ve yıl ("May 2027"), 90 gün içinde ay, 30 gün içinde gün,
/// süresi dolunca "Süresi doldu".
({AppStatus status, String label}) documentExpiryBadge(
  AppLocalizations l10n,
  AppFormat format,
  VaultDocument document,
  DateTime now,
) {
  final expiry = documentExpiry(document.expiresOn, now);
  final days = expiry.daysLeft;
  return switch (expiry.level) {
    DocumentExpiryLevel.none => (
      status: AppStatus.info,
      label: l10n.documentExpiryNone,
    ),
    DocumentExpiryLevel.valid => (
      status: AppStatus.good,
      label: format.monthYear(document.expiresOn!),
    ),
    DocumentExpiryLevel.soon => (
      status: AppStatus.warning,
      label: l10n.documentExpiryMonths(monthsLeft(days!)),
    ),
    DocumentExpiryLevel.urgent => (
      status: AppStatus.critical,
      label: days == 0
          ? l10n.documentExpiryToday
          : l10n.documentExpiryDays(days!),
    ),
    DocumentExpiryLevel.expired => (
      status: AppStatus.critical,
      label: l10n.documentExpiryExpired,
    ),
  };
}
