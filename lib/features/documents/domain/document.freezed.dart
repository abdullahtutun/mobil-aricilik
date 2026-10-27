// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VaultDocument {

 String get id; String get orgId; DocumentType get type; String get name; DocumentFileKind get fileKind;/// `documents` bucket'ındaki yol (`documentStoragePath`).
 String get storagePath; int get byteSize; DateTime get createdAt; DateTime get updatedAt;/// Kullanıcı tanımlı türün adı; hazır türde boş.
 String? get customTypeName; String? get description;/// Son geçerlilik günü (o gün dahil); boşsa süresiz.
@DateOnlyJsonConverter() DateTime? get expiresOn; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of VaultDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaultDocumentCopyWith<VaultDocument> get copyWith => _$VaultDocumentCopyWithImpl<VaultDocument>(this as VaultDocument, _$identity);

  /// Serializes this VaultDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VaultDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaultDocument&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.fileKind, _this.fileKind) || other.fileKind == _this.fileKind)&&(identical(other.storagePath, _this.storagePath) || other.storagePath == _this.storagePath)&&(identical(other.byteSize, _this.byteSize) || other.byteSize == _this.byteSize)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.customTypeName, _this.customTypeName) || other.customTypeName == _this.customTypeName)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.expiresOn, _this.expiresOn) || other.expiresOn == _this.expiresOn)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VaultDocument;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.type,_this.name,_this.fileKind,_this.storagePath,_this.byteSize,_this.createdAt,_this.updatedAt,_this.customTypeName,_this.description,_this.expiresOn,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as VaultDocument;
  return 'VaultDocument(id: ${_this.id}, orgId: ${_this.orgId}, type: ${_this.type}, name: ${_this.name}, fileKind: ${_this.fileKind}, storagePath: ${_this.storagePath}, byteSize: ${_this.byteSize}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, customTypeName: ${_this.customTypeName}, description: ${_this.description}, expiresOn: ${_this.expiresOn}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $VaultDocumentCopyWith<$Res>  {
  factory $VaultDocumentCopyWith(VaultDocument value, $Res Function(VaultDocument) _then) = _$VaultDocumentCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, DocumentType type, String name, DocumentFileKind fileKind, String storagePath, int byteSize, DateTime createdAt, DateTime updatedAt, String? customTypeName, String? description,@DateOnlyJsonConverter() DateTime? expiresOn, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$VaultDocumentCopyWithImpl<$Res>
    implements $VaultDocumentCopyWith<$Res> {
  _$VaultDocumentCopyWithImpl(this._self, this._then);

  final VaultDocument _self;
  final $Res Function(VaultDocument) _then;

/// Create a copy of VaultDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? type = null,Object? name = null,Object? fileKind = null,Object? storagePath = null,Object? byteSize = null,Object? createdAt = null,Object? updatedAt = null,Object? customTypeName = freezed,Object? description = freezed,Object? expiresOn = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(VaultDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fileKind: null == fileKind ? _self.fileKind : fileKind // ignore: cast_nullable_to_non_nullable
as DocumentFileKind,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,customTypeName: freezed == customTypeName ? _self.customTypeName : customTypeName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expiresOn: freezed == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [VaultDocument].
extension VaultDocumentPatterns on VaultDocument {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaultDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaultDocument() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaultDocument value)  $default,){
final _that = this;
switch (_that) {
case _VaultDocument():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaultDocument value)?  $default,){
final _that = this;
switch (_that) {
case _VaultDocument() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  DocumentType type,  String name,  DocumentFileKind fileKind,  String storagePath,  int byteSize,  DateTime createdAt,  DateTime updatedAt,  String? customTypeName,  String? description, @DateOnlyJsonConverter()  DateTime? expiresOn,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaultDocument() when $default != null:
return $default(_that.id,_that.orgId,_that.type,_that.name,_that.fileKind,_that.storagePath,_that.byteSize,_that.createdAt,_that.updatedAt,_that.customTypeName,_that.description,_that.expiresOn,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  DocumentType type,  String name,  DocumentFileKind fileKind,  String storagePath,  int byteSize,  DateTime createdAt,  DateTime updatedAt,  String? customTypeName,  String? description, @DateOnlyJsonConverter()  DateTime? expiresOn,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _VaultDocument():
return $default(_that.id,_that.orgId,_that.type,_that.name,_that.fileKind,_that.storagePath,_that.byteSize,_that.createdAt,_that.updatedAt,_that.customTypeName,_that.description,_that.expiresOn,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  DocumentType type,  String name,  DocumentFileKind fileKind,  String storagePath,  int byteSize,  DateTime createdAt,  DateTime updatedAt,  String? customTypeName,  String? description, @DateOnlyJsonConverter()  DateTime? expiresOn,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _VaultDocument() when $default != null:
return $default(_that.id,_that.orgId,_that.type,_that.name,_that.fileKind,_that.storagePath,_that.byteSize,_that.createdAt,_that.updatedAt,_that.customTypeName,_that.description,_that.expiresOn,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaultDocument implements VaultDocument {
  const _VaultDocument({required this.id, required this.orgId, required this.type, required this.name, required this.fileKind, required this.storagePath, required this.byteSize, required this.createdAt, required this.updatedAt, this.customTypeName, this.description, @DateOnlyJsonConverter() this.expiresOn, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _VaultDocument.fromJson(Map<String, dynamic> json) => _$VaultDocumentFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  DocumentType type;
@override final  String name;
@override final  DocumentFileKind fileKind;
/// `documents` bucket'ındaki yol (`documentStoragePath`).
@override final  String storagePath;
@override final  int byteSize;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Kullanıcı tanımlı türün adı; hazır türde boş.
@override final  String? customTypeName;
@override final  String? description;
/// Son geçerlilik günü (o gün dahil); boşsa süresiz.
@override@DateOnlyJsonConverter() final  DateTime? expiresOn;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of VaultDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaultDocumentCopyWith<_VaultDocument> get copyWith => __$VaultDocumentCopyWithImpl<_VaultDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaultDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaultDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.fileKind, fileKind) || other.fileKind == fileKind)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.customTypeName, customTypeName) || other.customTypeName == customTypeName)&&(identical(other.description, description) || other.description == description)&&(identical(other.expiresOn, expiresOn) || other.expiresOn == expiresOn)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,type,name,fileKind,storagePath,byteSize,createdAt,updatedAt,customTypeName,description,expiresOn,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'VaultDocument(id: $id, orgId: $orgId, type: $type, name: $name, fileKind: $fileKind, storagePath: $storagePath, byteSize: $byteSize, createdAt: $createdAt, updatedAt: $updatedAt, customTypeName: $customTypeName, description: $description, expiresOn: $expiresOn, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$VaultDocumentCopyWith<$Res> implements $VaultDocumentCopyWith<$Res> {
  factory _$VaultDocumentCopyWith(_VaultDocument value, $Res Function(_VaultDocument) _then) = __$VaultDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, DocumentType type, String name, DocumentFileKind fileKind, String storagePath, int byteSize, DateTime createdAt, DateTime updatedAt, String? customTypeName, String? description,@DateOnlyJsonConverter() DateTime? expiresOn, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$VaultDocumentCopyWithImpl<$Res>
    implements _$VaultDocumentCopyWith<$Res> {
  __$VaultDocumentCopyWithImpl(this._self, this._then);

  final _VaultDocument _self;
  final $Res Function(_VaultDocument) _then;

/// Create a copy of VaultDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? type = null,Object? name = null,Object? fileKind = null,Object? storagePath = null,Object? byteSize = null,Object? createdAt = null,Object? updatedAt = null,Object? customTypeName = freezed,Object? description = freezed,Object? expiresOn = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_VaultDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fileKind: null == fileKind ? _self.fileKind : fileKind // ignore: cast_nullable_to_non_nullable
as DocumentFileKind,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,customTypeName: freezed == customTypeName ? _self.customTypeName : customTypeName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expiresOn: freezed == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
