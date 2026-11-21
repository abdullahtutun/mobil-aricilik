import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_status.freezed.dart';
part 'plan_status.g.dart';

/// İşletmenin planı. Sunucudaki `org_subscriptions.plan` değerleriyle aynı.
enum PlanTier {
  free,
  pro;

  static PlanTier fromServer(String? value) =>
      value == 'pro' ? PlanTier.pro : PlanTier.free;
}

/// İşletmenin neyi kullanabileceği: `POST /api/app/plan` yanıtı
/// (`server/internal/plans.Status`). Telefonda işletme başına saklanır;
/// çevrimdışıyken saklanan değer geçerlidir.
///
/// Planlar kapalıyken ([plansEnabled] false) sunucu herkese sınırsız döner;
/// hiç alınmamış durum da ([PlanStatus.unlimited]) böyledir. Plan yüzünden
/// hiçbir kayıt silinmez ya da kilitlenmez: sınır yalnız yeni kovan eklemeyi
/// ve ekibe yeni üye almayı durdurur.
@freezed
abstract class PlanStatus with _$PlanStatus {
  const factory({
    @Default(false) bool plansEnabled,
    @Default(PlanTier.free)
    @JsonKey(fromJson: PlanTier.fromServer, toJson: _tierToJson)
    PlanTier plan,

    /// Pro döneminin bittiği an; süresiz satın almada ya da ücretsizde null.
    @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) DateTime? expiresAt,

    /// En çok kaç aktif kovan; null sınırsız.
    int? hiveLimit,

    /// Sahibin dışında üye alınabilir mi.
    @Default(true) bool team,

    /// En çok kaç günlük hava tahmini; null sunucuda ne varsa.
    int? forecastDays,
  }) = _PlanStatus;

  factory fromJson(Map<String, Object?> json) => _$PlanStatusFromJson(json);

  /// Planlar kapalıyken ya da durum hiç alınmamışken: her şey açık.
  static const unlimited = PlanStatus();
}

String _tierToJson(PlanTier tier) => tier.name;

/// Sunucu süresizde boş metin gönderir.
DateTime? _timeFromJson(Object? value) =>
    value is String && value.isNotEmpty ? DateTime.tryParse(value) : null;

String _timeToJson(DateTime? value) => value?.toUtc().toIso8601String() ?? '';

/// Telefonda saklanan durum ve sunucudan alındığı an.
@freezed
abstract class StoredPlanStatus with _$StoredPlanStatus {
  const factory({required PlanStatus status, required DateTime fetchedAt}) =
      _StoredPlanStatus;

  factory fromJson(Map<String, Object?> json) =>
      _$StoredPlanStatusFromJson(json);
}
