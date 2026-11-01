import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'inventory.freezed.dart';
part 'inventory.g.dart';

/// Stok kaleminin kategorisi (`public.inventory_category`); ekranın
/// sekmeleri bu sırayla.
@JsonEnum(valueField: 'value')
enum InventoryCategory implements ServerEnum {
  /// Sarf: şeker, kek, ilaç, kavanoz, etiket.
  consumable('consumable'),

  /// Ekipman: boş kovan, kat, çerçeve, körük.
  equipment('equipment'),

  /// Petek: kuru petek stoku.
  comb('comb');

  new(this.value);

  @override
  final String value;
}

/// Stok kaleminin birimi (`public.inventory_unit`).
@JsonEnum(valueField: 'value')
enum InventoryUnit implements ServerEnum {
  kg('kg'),
  liter('liter'),
  piece('piece'),
  roll('roll'),
  pack('pack');

  new(this.value);

  @override
  final String value;

  /// Miktar ondalıklı olabilir (kg, litre); değilse tam sayı.
  bool get allowsFraction => this == kg || this == liter;
}

/// Stok hareketinin türü (`public.inventory_move_kind`).
@JsonEnum(valueField: 'value')
enum InventoryMoveKind implements ServerEnum {
  /// Giriş; miktar pozitif.
  stockIn('in'),

  /// Çıkış; miktar negatif.
  stockOut('out'),

  /// Düzeltme: sayımla bulunan fark; sıfırdan farklı, iki yönde.
  adjustment('adjustment');

  new(this.value);

  @override
  final String value;
}

/// Kalemin adı ve konumu en çok bu kadar karakter (sunucudaki CHECK).
const maxInventoryNameLength = 80;
const maxInventoryPlaceLength = 60;

/// Eşik ve hareket miktarı bunun altında (sunucudaki `numeric(12, 3)`
/// CHECK'i).
const inventoryQuantityLimit = 1000000;

/// Stok kalemi (`inventory_items`). Durum kaydı: son yazan kazanır. Mevcut
/// stok burada değil, hareketlerin toplamı ([InventoryStock]).
@freezed
abstract class InventoryItem with _$InventoryItem implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String name,
    required InventoryCategory category,
    required InventoryUnit unit,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Kalemin durduğu yer ("depo", "kamyonet"); serbest metin.
    String? place,

    /// Stok bunun altına düşünce uyarı; boşsa uyarı yok.
    double? threshold,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _InventoryItem;

  factory fromJson(Map<String, Object?> json) => _$InventoryItemFromJson(json);
}

/// Stok hareketi (`inventory_moves`). Olay kaydı: yalnız eklenir, yanlış
/// kayıt silinir (Geri al da silmedir).
@freezed
abstract class InventoryMove with _$InventoryMove implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String itemId,
    required InventoryMoveKind kind,

    /// İşaretli değişim: giriş pozitif, çıkış negatif, düzeltme iki yönde.
    required double quantity,
    required DateTime movedAt,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Hareketin bağlı olduğu kaydın tablosu (ör. `feedings`) ve kimliği;
    /// ikisi birlikte dolu ya da boş.
    String? linkedTable,
    String? linkedId,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _InventoryMove;

  factory fromJson(Map<String, Object?> json) => _$InventoryMoveFromJson(json);
}

/// Kalem ve mevcut stoğu (silinmemiş hareketlerin toplamı).
typedef InventoryStock = ({InventoryItem item, double quantity});
