import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal.freezed.dart';
part 'withdrawal.g.dart';

/// Bekleme süresindeki kovana bilerek bal katı verilmesinin (ya da hasat
/// işaretlenmesinin) gerekçesi. Sunucuda enum değil, kaydın `data`
/// nesnesinde bu değerlerle durur.
@JsonEnum(valueField: 'value')
enum WithdrawalOverrideReason {
  /// İlaç planlanandan erken çıkarıldı.
  removedEarly('removed_early'),

  /// Kattaki bal satılmayacak (kendi kullanım ya da yem).
  notForSale('not_for_sale');

  new(this.value);

  final String value;
}

/// Bekleme süresi kilidinin bilerek geçilmesi: hangi uygulamanın kilidi ve
/// neden.
@freezed
abstract class WithdrawalOverride with _$WithdrawalOverride {
  const factory({
    required String treatmentId,
    required WithdrawalOverrideReason reason,
  }) = _WithdrawalOverride;

  factory fromJson(Map<String, Object?> json) =>
      _$WithdrawalOverrideFromJson(json);
}
