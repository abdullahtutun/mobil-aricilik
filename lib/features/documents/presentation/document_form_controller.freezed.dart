// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentFormState {

/// Seçilen tür; TR profilinde seçilene kadar boş, diğer bölgelerde
/// hep [DocumentType.custom].
 DocumentType? get type; String get customTypeName; String get name;/// Ad elle yazıldı ya da belge düzenleniyor; tür seçilince ad artık
/// türden doldurulmaz.
 bool get nameEdited; String get description;/// Son geçerlilik günü (yerel); boşsa süresiz.
 DateTime? get expiresOn;/// Bu formda seçilen, henüz kaydedilmemiş dosya.
 DocumentFileCapture? get newFile;/// Düzenlenen belgenin kayıtlı dosyası; yeni dosya seçilmediyse kalır.
 DocumentFileKind? get savedFileKind; int? get savedByteSize; bool get saving;
/// Create a copy of DocumentFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentFormStateCopyWith<DocumentFormState> get copyWith => _$DocumentFormStateCopyWithImpl<DocumentFormState>(this as DocumentFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DocumentFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentFormState&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.customTypeName, _this.customTypeName) || other.customTypeName == _this.customTypeName)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.nameEdited, _this.nameEdited) || other.nameEdited == _this.nameEdited)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.expiresOn, _this.expiresOn) || other.expiresOn == _this.expiresOn)&&(identical(other.newFile, _this.newFile) || other.newFile == _this.newFile)&&(identical(other.savedFileKind, _this.savedFileKind) || other.savedFileKind == _this.savedFileKind)&&(identical(other.savedByteSize, _this.savedByteSize) || other.savedByteSize == _this.savedByteSize)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as DocumentFormState;
  return Object.hash(runtimeType,_this.type,_this.customTypeName,_this.name,_this.nameEdited,_this.description,_this.expiresOn,_this.newFile,_this.savedFileKind,_this.savedByteSize,_this.saving);
}

@override
String toString() {
  final _this = this as DocumentFormState;
  return 'DocumentFormState(type: ${_this.type}, customTypeName: ${_this.customTypeName}, name: ${_this.name}, nameEdited: ${_this.nameEdited}, description: ${_this.description}, expiresOn: ${_this.expiresOn}, newFile: ${_this.newFile}, savedFileKind: ${_this.savedFileKind}, savedByteSize: ${_this.savedByteSize}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $DocumentFormStateCopyWith<$Res>  {
  factory $DocumentFormStateCopyWith(DocumentFormState value, $Res Function(DocumentFormState) _then) = _$DocumentFormStateCopyWithImpl;
@useResult
$Res call({
 DocumentType? type, String customTypeName, String name, bool nameEdited, String description, DateTime? expiresOn, DocumentFileCapture? newFile, DocumentFileKind? savedFileKind, int? savedByteSize, bool saving
});




}
/// @nodoc
class _$DocumentFormStateCopyWithImpl<$Res>
    implements $DocumentFormStateCopyWith<$Res> {
  _$DocumentFormStateCopyWithImpl(this._self, this._then);

  final DocumentFormState _self;
  final $Res Function(DocumentFormState) _then;

/// Create a copy of DocumentFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? customTypeName = null,Object? name = null,Object? nameEdited = null,Object? description = null,Object? expiresOn = freezed,Object? newFile = freezed,Object? savedFileKind = freezed,Object? savedByteSize = freezed,Object? saving = null,}) {
  return _then(DocumentFormState(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType?,customTypeName: null == customTypeName ? _self.customTypeName : customTypeName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEdited: null == nameEdited ? _self.nameEdited : nameEdited // ignore: cast_nullable_to_non_nullable
as bool,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,expiresOn: freezed == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime?,newFile: freezed == newFile ? _self.newFile : newFile // ignore: cast_nullable_to_non_nullable
as DocumentFileCapture?,savedFileKind: freezed == savedFileKind ? _self.savedFileKind : savedFileKind // ignore: cast_nullable_to_non_nullable
as DocumentFileKind?,savedByteSize: freezed == savedByteSize ? _self.savedByteSize : savedByteSize // ignore: cast_nullable_to_non_nullable
as int?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentFormState].
extension DocumentFormStatePatterns on DocumentFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentFormState value)  $default,){
final _that = this;
switch (_that) {
case _DocumentFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentFormState value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DocumentType? type,  String customTypeName,  String name,  bool nameEdited,  String description,  DateTime? expiresOn,  DocumentFileCapture? newFile,  DocumentFileKind? savedFileKind,  int? savedByteSize,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentFormState() when $default != null:
return $default(_that.type,_that.customTypeName,_that.name,_that.nameEdited,_that.description,_that.expiresOn,_that.newFile,_that.savedFileKind,_that.savedByteSize,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DocumentType? type,  String customTypeName,  String name,  bool nameEdited,  String description,  DateTime? expiresOn,  DocumentFileCapture? newFile,  DocumentFileKind? savedFileKind,  int? savedByteSize,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _DocumentFormState():
return $default(_that.type,_that.customTypeName,_that.name,_that.nameEdited,_that.description,_that.expiresOn,_that.newFile,_that.savedFileKind,_that.savedByteSize,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DocumentType? type,  String customTypeName,  String name,  bool nameEdited,  String description,  DateTime? expiresOn,  DocumentFileCapture? newFile,  DocumentFileKind? savedFileKind,  int? savedByteSize,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _DocumentFormState() when $default != null:
return $default(_that.type,_that.customTypeName,_that.name,_that.nameEdited,_that.description,_that.expiresOn,_that.newFile,_that.savedFileKind,_that.savedByteSize,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentFormState implements DocumentFormState {
  const _DocumentFormState({this.type, this.customTypeName = '', this.name = '', this.nameEdited = false, this.description = '', this.expiresOn, this.newFile, this.savedFileKind, this.savedByteSize, this.saving = false});
  

/// Seçilen tür; TR profilinde seçilene kadar boş, diğer bölgelerde
/// hep [DocumentType.custom].
@override final  DocumentType? type;
@override@JsonKey() final  String customTypeName;
@override@JsonKey() final  String name;
/// Ad elle yazıldı ya da belge düzenleniyor; tür seçilince ad artık
/// türden doldurulmaz.
@override@JsonKey() final  bool nameEdited;
@override@JsonKey() final  String description;
/// Son geçerlilik günü (yerel); boşsa süresiz.
@override final  DateTime? expiresOn;
/// Bu formda seçilen, henüz kaydedilmemiş dosya.
@override final  DocumentFileCapture? newFile;
/// Düzenlenen belgenin kayıtlı dosyası; yeni dosya seçilmediyse kalır.
@override final  DocumentFileKind? savedFileKind;
@override final  int? savedByteSize;
@override@JsonKey() final  bool saving;

/// Create a copy of DocumentFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentFormStateCopyWith<_DocumentFormState> get copyWith => __$DocumentFormStateCopyWithImpl<_DocumentFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentFormState&&(identical(other.type, type) || other.type == type)&&(identical(other.customTypeName, customTypeName) || other.customTypeName == customTypeName)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEdited, nameEdited) || other.nameEdited == nameEdited)&&(identical(other.description, description) || other.description == description)&&(identical(other.expiresOn, expiresOn) || other.expiresOn == expiresOn)&&(identical(other.newFile, newFile) || other.newFile == newFile)&&(identical(other.savedFileKind, savedFileKind) || other.savedFileKind == savedFileKind)&&(identical(other.savedByteSize, savedByteSize) || other.savedByteSize == savedByteSize)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,customTypeName,name,nameEdited,description,expiresOn,newFile,savedFileKind,savedByteSize,saving);
}

@override
String toString() {
    return 'DocumentFormState(type: $type, customTypeName: $customTypeName, name: $name, nameEdited: $nameEdited, description: $description, expiresOn: $expiresOn, newFile: $newFile, savedFileKind: $savedFileKind, savedByteSize: $savedByteSize, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$DocumentFormStateCopyWith<$Res> implements $DocumentFormStateCopyWith<$Res> {
  factory _$DocumentFormStateCopyWith(_DocumentFormState value, $Res Function(_DocumentFormState) _then) = __$DocumentFormStateCopyWithImpl;
@override @useResult
$Res call({
 DocumentType? type, String customTypeName, String name, bool nameEdited, String description, DateTime? expiresOn, DocumentFileCapture? newFile, DocumentFileKind? savedFileKind, int? savedByteSize, bool saving
});




}
/// @nodoc
class __$DocumentFormStateCopyWithImpl<$Res>
    implements _$DocumentFormStateCopyWith<$Res> {
  __$DocumentFormStateCopyWithImpl(this._self, this._then);

  final _DocumentFormState _self;
  final $Res Function(_DocumentFormState) _then;

/// Create a copy of DocumentFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? customTypeName = null,Object? name = null,Object? nameEdited = null,Object? description = null,Object? expiresOn = freezed,Object? newFile = freezed,Object? savedFileKind = freezed,Object? savedByteSize = freezed,Object? saving = null,}) {
  return _then(_DocumentFormState(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType?,customTypeName: null == customTypeName ? _self.customTypeName : customTypeName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEdited: null == nameEdited ? _self.nameEdited : nameEdited // ignore: cast_nullable_to_non_nullable
as bool,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,expiresOn: freezed == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime?,newFile: freezed == newFile ? _self.newFile : newFile // ignore: cast_nullable_to_non_nullable
as DocumentFileCapture?,savedFileKind: freezed == savedFileKind ? _self.savedFileKind : savedFileKind // ignore: cast_nullable_to_non_nullable
as DocumentFileKind?,savedByteSize: freezed == savedByteSize ? _self.savedByteSize : savedByteSize // ignore: cast_nullable_to_non_nullable
as int?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
