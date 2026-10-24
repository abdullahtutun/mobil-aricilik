// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaCapture {

/// Uygulamanın medya klasöründeki dosya adı.
 String get fileName; MediaKind get kind; DateTime get capturedAt; int get byteSize;/// Sesli notun süresi.
 int? get durationMs;
/// Create a copy of MediaCapture
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaCaptureCopyWith<MediaCapture> get copyWith => _$MediaCaptureCopyWithImpl<MediaCapture>(this as MediaCapture, _$identity);

  /// Serializes this MediaCapture to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MediaCapture;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaCapture&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.capturedAt, _this.capturedAt) || other.capturedAt == _this.capturedAt)&&(identical(other.byteSize, _this.byteSize) || other.byteSize == _this.byteSize)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MediaCapture;
  return Object.hash(runtimeType,_this.fileName,_this.kind,_this.capturedAt,_this.byteSize,_this.durationMs);
}

@override
String toString() {
  final _this = this as MediaCapture;
  return 'MediaCapture(fileName: ${_this.fileName}, kind: ${_this.kind}, capturedAt: ${_this.capturedAt}, byteSize: ${_this.byteSize}, durationMs: ${_this.durationMs})';
}


}

/// @nodoc
abstract mixin class $MediaCaptureCopyWith<$Res>  {
  factory $MediaCaptureCopyWith(MediaCapture value, $Res Function(MediaCapture) _then) = _$MediaCaptureCopyWithImpl;
@useResult
$Res call({
 String fileName, MediaKind kind, DateTime capturedAt, int byteSize, int? durationMs
});




}
/// @nodoc
class _$MediaCaptureCopyWithImpl<$Res>
    implements $MediaCaptureCopyWith<$Res> {
  _$MediaCaptureCopyWithImpl(this._self, this._then);

  final MediaCapture _self;
  final $Res Function(MediaCapture) _then;

/// Create a copy of MediaCapture
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? kind = null,Object? capturedAt = null,Object? byteSize = null,Object? durationMs = freezed,}) {
  return _then(MediaCapture(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MediaKind,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaCapture].
extension MediaCapturePatterns on MediaCapture {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaCapture value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaCapture() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaCapture value)  $default,){
final _that = this;
switch (_that) {
case _MediaCapture():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaCapture value)?  $default,){
final _that = this;
switch (_that) {
case _MediaCapture() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  MediaKind kind,  DateTime capturedAt,  int byteSize,  int? durationMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaCapture() when $default != null:
return $default(_that.fileName,_that.kind,_that.capturedAt,_that.byteSize,_that.durationMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  MediaKind kind,  DateTime capturedAt,  int byteSize,  int? durationMs)  $default,) {final _that = this;
switch (_that) {
case _MediaCapture():
return $default(_that.fileName,_that.kind,_that.capturedAt,_that.byteSize,_that.durationMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  MediaKind kind,  DateTime capturedAt,  int byteSize,  int? durationMs)?  $default,) {final _that = this;
switch (_that) {
case _MediaCapture() when $default != null:
return $default(_that.fileName,_that.kind,_that.capturedAt,_that.byteSize,_that.durationMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaCapture implements MediaCapture {
  const _MediaCapture({required this.fileName, required this.kind, required this.capturedAt, required this.byteSize, this.durationMs});
  factory _MediaCapture.fromJson(Map<String, dynamic> json) => _$MediaCaptureFromJson(json);

/// Uygulamanın medya klasöründeki dosya adı.
@override final  String fileName;
@override final  MediaKind kind;
@override final  DateTime capturedAt;
@override final  int byteSize;
/// Sesli notun süresi.
@override final  int? durationMs;

/// Create a copy of MediaCapture
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaCaptureCopyWith<_MediaCapture> get copyWith => __$MediaCaptureCopyWithImpl<_MediaCapture>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaCaptureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaCapture&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,fileName,kind,capturedAt,byteSize,durationMs);
}

@override
String toString() {
    return 'MediaCapture(fileName: $fileName, kind: $kind, capturedAt: $capturedAt, byteSize: $byteSize, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class _$MediaCaptureCopyWith<$Res> implements $MediaCaptureCopyWith<$Res> {
  factory _$MediaCaptureCopyWith(_MediaCapture value, $Res Function(_MediaCapture) _then) = __$MediaCaptureCopyWithImpl;
@override @useResult
$Res call({
 String fileName, MediaKind kind, DateTime capturedAt, int byteSize, int? durationMs
});




}
/// @nodoc
class __$MediaCaptureCopyWithImpl<$Res>
    implements _$MediaCaptureCopyWith<$Res> {
  __$MediaCaptureCopyWithImpl(this._self, this._then);

  final _MediaCapture _self;
  final $Res Function(_MediaCapture) _then;

/// Create a copy of MediaCapture
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? kind = null,Object? capturedAt = null,Object? byteSize = null,Object? durationMs = freezed,}) {
  return _then(_MediaCapture(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MediaKind,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MediaItem {

 String get id; String get orgId; String get hiveId; MediaKind get kind;/// `media` bucket'ındaki yol (`mediaStoragePath`).
 String get storagePath; DateTime get capturedAt; int get byteSize; DateTime get createdAt; DateTime get updatedAt; String? get inspectionId; int? get durationMs; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of MediaItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaItemCopyWith<MediaItem> get copyWith => _$MediaItemCopyWithImpl<MediaItem>(this as MediaItem, _$identity);

  /// Serializes this MediaItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MediaItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.storagePath, _this.storagePath) || other.storagePath == _this.storagePath)&&(identical(other.capturedAt, _this.capturedAt) || other.capturedAt == _this.capturedAt)&&(identical(other.byteSize, _this.byteSize) || other.byteSize == _this.byteSize)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.inspectionId, _this.inspectionId) || other.inspectionId == _this.inspectionId)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MediaItem;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.hiveId,_this.kind,_this.storagePath,_this.capturedAt,_this.byteSize,_this.createdAt,_this.updatedAt,_this.inspectionId,_this.durationMs,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as MediaItem;
  return 'MediaItem(id: ${_this.id}, orgId: ${_this.orgId}, hiveId: ${_this.hiveId}, kind: ${_this.kind}, storagePath: ${_this.storagePath}, capturedAt: ${_this.capturedAt}, byteSize: ${_this.byteSize}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, inspectionId: ${_this.inspectionId}, durationMs: ${_this.durationMs}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $MediaItemCopyWith<$Res>  {
  factory $MediaItemCopyWith(MediaItem value, $Res Function(MediaItem) _then) = _$MediaItemCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String hiveId, MediaKind kind, String storagePath, DateTime capturedAt, int byteSize, DateTime createdAt, DateTime updatedAt, String? inspectionId, int? durationMs, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$MediaItemCopyWithImpl<$Res>
    implements $MediaItemCopyWith<$Res> {
  _$MediaItemCopyWithImpl(this._self, this._then);

  final MediaItem _self;
  final $Res Function(MediaItem) _then;

/// Create a copy of MediaItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? kind = null,Object? storagePath = null,Object? capturedAt = null,Object? byteSize = null,Object? createdAt = null,Object? updatedAt = null,Object? inspectionId = freezed,Object? durationMs = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(MediaItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MediaKind,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,inspectionId: freezed == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaItem].
extension MediaItemPatterns on MediaItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaItem value)  $default,){
final _that = this;
switch (_that) {
case _MediaItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaItem value)?  $default,){
final _that = this;
switch (_that) {
case _MediaItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  MediaKind kind,  String storagePath,  DateTime capturedAt,  int byteSize,  DateTime createdAt,  DateTime updatedAt,  String? inspectionId,  int? durationMs,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaItem() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.kind,_that.storagePath,_that.capturedAt,_that.byteSize,_that.createdAt,_that.updatedAt,_that.inspectionId,_that.durationMs,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  MediaKind kind,  String storagePath,  DateTime capturedAt,  int byteSize,  DateTime createdAt,  DateTime updatedAt,  String? inspectionId,  int? durationMs,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _MediaItem():
return $default(_that.id,_that.orgId,_that.hiveId,_that.kind,_that.storagePath,_that.capturedAt,_that.byteSize,_that.createdAt,_that.updatedAt,_that.inspectionId,_that.durationMs,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String hiveId,  MediaKind kind,  String storagePath,  DateTime capturedAt,  int byteSize,  DateTime createdAt,  DateTime updatedAt,  String? inspectionId,  int? durationMs,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _MediaItem() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.kind,_that.storagePath,_that.capturedAt,_that.byteSize,_that.createdAt,_that.updatedAt,_that.inspectionId,_that.durationMs,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaItem implements MediaItem {
  const _MediaItem({required this.id, required this.orgId, required this.hiveId, required this.kind, required this.storagePath, required this.capturedAt, required this.byteSize, required this.createdAt, required this.updatedAt, this.inspectionId, this.durationMs, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _MediaItem.fromJson(Map<String, dynamic> json) => _$MediaItemFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String hiveId;
@override final  MediaKind kind;
/// `media` bucket'ındaki yol (`mediaStoragePath`).
@override final  String storagePath;
@override final  DateTime capturedAt;
@override final  int byteSize;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? inspectionId;
@override final  int? durationMs;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of MediaItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaItemCopyWith<_MediaItem> get copyWith => __$MediaItemCopyWithImpl<_MediaItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaItem&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.inspectionId, inspectionId) || other.inspectionId == inspectionId)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,hiveId,kind,storagePath,capturedAt,byteSize,createdAt,updatedAt,inspectionId,durationMs,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'MediaItem(id: $id, orgId: $orgId, hiveId: $hiveId, kind: $kind, storagePath: $storagePath, capturedAt: $capturedAt, byteSize: $byteSize, createdAt: $createdAt, updatedAt: $updatedAt, inspectionId: $inspectionId, durationMs: $durationMs, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$MediaItemCopyWith<$Res> implements $MediaItemCopyWith<$Res> {
  factory _$MediaItemCopyWith(_MediaItem value, $Res Function(_MediaItem) _then) = __$MediaItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String hiveId, MediaKind kind, String storagePath, DateTime capturedAt, int byteSize, DateTime createdAt, DateTime updatedAt, String? inspectionId, int? durationMs, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$MediaItemCopyWithImpl<$Res>
    implements _$MediaItemCopyWith<$Res> {
  __$MediaItemCopyWithImpl(this._self, this._then);

  final _MediaItem _self;
  final $Res Function(_MediaItem) _then;

/// Create a copy of MediaItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? kind = null,Object? storagePath = null,Object? capturedAt = null,Object? byteSize = null,Object? createdAt = null,Object? updatedAt = null,Object? inspectionId = freezed,Object? durationMs = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_MediaItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MediaKind,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,inspectionId: freezed == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
