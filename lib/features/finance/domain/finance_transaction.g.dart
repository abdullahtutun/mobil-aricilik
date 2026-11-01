// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinanceTransaction _$FinanceTransactionFromJson(Map<String, dynamic> json) =>
    _FinanceTransaction(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      kind: $enumDecode(_$TransactionKindEnumMap, json['kind']),
      category: $enumDecode(_$TransactionCategoryEnumMap, json['category']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      occurredOn: const DateOnlyJsonConverter().fromJson(
        json['occurred_on'] as String,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      description: json['description'] as String?,
      receiptPath: json['receipt_path'] as String?,
      apiaryId: json['apiary_id'] as String?,
      lotId: json['lot_id'] as String?,
      transportId: json['transport_id'] as String?,
      lotSaleId: json['lot_sale_id'] as String?,
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FinanceTransactionToJson(_FinanceTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'kind': _$TransactionKindEnumMap[instance.kind]!,
      'category': _$TransactionCategoryEnumMap[instance.category]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'occurred_on': const DateOnlyJsonConverter().toJson(instance.occurredOn),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'description': instance.description,
      'receipt_path': instance.receiptPath,
      'apiary_id': instance.apiaryId,
      'lot_id': instance.lotId,
      'transport_id': instance.transportId,
      'lot_sale_id': instance.lotSaleId,
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$TransactionKindEnumMap = {
  TransactionKind.income: 'income',
  TransactionKind.expense: 'expense',
};

const _$TransactionCategoryEnumMap = {
  TransactionCategory.feeding: 'feeding',
  TransactionCategory.treatment: 'treatment',
  TransactionCategory.equipment: 'equipment',
  TransactionCategory.fuelTransport: 'fuel_transport',
  TransactionCategory.landRent: 'land_rent',
  TransactionCategory.labor: 'labor',
  TransactionCategory.labAnalysis: 'lab_analysis',
  TransactionCategory.honey: 'honey',
  TransactionCategory.pollen: 'pollen',
  TransactionCategory.propolis: 'propolis',
  TransactionCategory.wax: 'wax',
  TransactionCategory.nucs: 'nucs',
  TransactionCategory.queens: 'queens',
  TransactionCategory.other: 'other',
};
