// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    _InventoryItem(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      name: json['name'] as String,
      category: $enumDecode(_$InventoryCategoryEnumMap, json['category']),
      unit: $enumDecode(_$InventoryUnitEnumMap, json['unit']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      place: json['place'] as String?,
      threshold: (json['threshold'] as num?)?.toDouble(),
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InventoryItemToJson(_InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'name': instance.name,
      'category': _$InventoryCategoryEnumMap[instance.category]!,
      'unit': _$InventoryUnitEnumMap[instance.unit]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'place': instance.place,
      'threshold': instance.threshold,
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$InventoryCategoryEnumMap = {
  InventoryCategory.consumable: 'consumable',
  InventoryCategory.equipment: 'equipment',
  InventoryCategory.comb: 'comb',
};

const _$InventoryUnitEnumMap = {
  InventoryUnit.kg: 'kg',
  InventoryUnit.liter: 'liter',
  InventoryUnit.piece: 'piece',
  InventoryUnit.roll: 'roll',
  InventoryUnit.pack: 'pack',
};

_InventoryMove _$InventoryMoveFromJson(Map<String, dynamic> json) =>
    _InventoryMove(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      itemId: json['item_id'] as String,
      kind: $enumDecode(_$InventoryMoveKindEnumMap, json['kind']),
      quantity: (json['quantity'] as num).toDouble(),
      movedAt: DateTime.parse(json['moved_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      linkedTable: json['linked_table'] as String?,
      linkedId: json['linked_id'] as String?,
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InventoryMoveToJson(_InventoryMove instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'item_id': instance.itemId,
      'kind': _$InventoryMoveKindEnumMap[instance.kind]!,
      'quantity': instance.quantity,
      'moved_at': instance.movedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'linked_table': instance.linkedTable,
      'linked_id': instance.linkedId,
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$InventoryMoveKindEnumMap = {
  InventoryMoveKind.stockIn: 'in',
  InventoryMoveKind.stockOut: 'out',
  InventoryMoveKind.adjustment: 'adjustment',
};
