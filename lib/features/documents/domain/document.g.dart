// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VaultDocument _$VaultDocumentFromJson(Map<String, dynamic> json) =>
    _VaultDocument(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      type: $enumDecode(_$DocumentTypeEnumMap, json['type']),
      name: json['name'] as String,
      fileKind: $enumDecode(_$DocumentFileKindEnumMap, json['file_kind']),
      storagePath: json['storage_path'] as String,
      byteSize: (json['byte_size'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      customTypeName: json['custom_type_name'] as String?,
      description: json['description'] as String?,
      expiresOn: _$JsonConverterFromJson<String, DateTime>(
        json['expires_on'],
        const DateOnlyJsonConverter().fromJson,
      ),
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VaultDocumentToJson(_VaultDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'type': _$DocumentTypeEnumMap[instance.type]!,
      'name': instance.name,
      'file_kind': _$DocumentFileKindEnumMap[instance.fileKind]!,
      'storage_path': instance.storagePath,
      'byte_size': instance.byteSize,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'custom_type_name': instance.customTypeName,
      'description': instance.description,
      'expires_on': _$JsonConverterToJson<String, DateTime>(
        instance.expiresOn,
        const DateOnlyJsonConverter().toJson,
      ),
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$DocumentTypeEnumMap = {
  DocumentType.healthReport: 'health_report',
  DocumentType.transportPermit: 'transport_permit',
  DocumentType.migratoryCertificate: 'migratory_certificate',
  DocumentType.businessRegistration: 'business_registration',
  DocumentType.landPermit: 'land_permit',
  DocumentType.analysisReport: 'analysis_report',
  DocumentType.custom: 'custom',
};

const _$DocumentFileKindEnumMap = {
  DocumentFileKind.photo: 'photo',
  DocumentFileKind.pdf: 'pdf',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
