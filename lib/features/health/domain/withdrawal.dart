import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';

part 'withdrawal.freezed.dart';
part 'withdrawal.g.dart';

/// Bekleme süresindeki kovana bilerek bal katı verilmesinin ya da kovanın
/// hasada alınmasının gerekçesi. Muayenede kaydın `data` nesnesinde,
/// hasatta `public.withdrawal_override_reason` enum'unda bu değerlerle
/// durur.
@JsonEnum(valueField: 'value')
enum WithdrawalOverrideReason implements ServerEnum {
  /// İlaç planlanandan erken çıkarıldı.
  removedEarly('removed_early'),

  /// Kattaki bal satılmayacak (kendi kullanım ya da yem).
  notForSale('not_for_sale');

  new(this.value);

  @override
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
