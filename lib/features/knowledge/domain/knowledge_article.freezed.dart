// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knowledge_article.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KnowledgeArticle {

 String get id;/// Dosyanın klasörü (`tr`, `en`).
 String get language; KnowledgeRegion get region; KnowledgeCategory get category; String get title; String get summary; String get body;/// Makalenin ait olduğu aylar (1–12), Kuzey yarımküreye göre; Güney'de
/// 6 ay kaydırılarak eşlenir.
 List<int> get months;
/// Create a copy of KnowledgeArticle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KnowledgeArticleCopyWith<KnowledgeArticle> get copyWith => _$KnowledgeArticleCopyWithImpl<KnowledgeArticle>(this as KnowledgeArticle, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KnowledgeArticle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnowledgeArticle&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.body, _this.body) || other.body == _this.body)&&const DeepCollectionEquality().equals(other.months, _this.months));
}


@override
int get hashCode {
  final _this = this as KnowledgeArticle;
  return Object.hash(runtimeType,_this.id,_this.language,_this.region,_this.category,_this.title,_this.summary,_this.body,const DeepCollectionEquality().hash(_this.months));
}

@override
String toString() {
  final _this = this as KnowledgeArticle;
  return 'KnowledgeArticle(id: ${_this.id}, language: ${_this.language}, region: ${_this.region}, category: ${_this.category}, title: ${_this.title}, summary: ${_this.summary}, body: ${_this.body}, months: ${_this.months})';
}


}

/// @nodoc
abstract mixin class $KnowledgeArticleCopyWith<$Res>  {
  factory $KnowledgeArticleCopyWith(KnowledgeArticle value, $Res Function(KnowledgeArticle) _then) = _$KnowledgeArticleCopyWithImpl;
@useResult
$Res call({
 String id, String language, KnowledgeRegion region, KnowledgeCategory category, String title, String summary, String body, List<int> months
});




}
/// @nodoc
class _$KnowledgeArticleCopyWithImpl<$Res>
    implements $KnowledgeArticleCopyWith<$Res> {
  _$KnowledgeArticleCopyWithImpl(this._self, this._then);

  final KnowledgeArticle _self;
  final $Res Function(KnowledgeArticle) _then;

/// Create a copy of KnowledgeArticle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? language = null,Object? region = null,Object? category = null,Object? title = null,Object? summary = null,Object? body = null,Object? months = null,}) {
  return _then(KnowledgeArticle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as KnowledgeRegion,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as KnowledgeCategory,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [KnowledgeArticle].
extension KnowledgeArticlePatterns on KnowledgeArticle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KnowledgeArticle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KnowledgeArticle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KnowledgeArticle value)  $default,){
final _that = this;
switch (_that) {
case _KnowledgeArticle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KnowledgeArticle value)?  $default,){
final _that = this;
switch (_that) {
case _KnowledgeArticle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String language,  KnowledgeRegion region,  KnowledgeCategory category,  String title,  String summary,  String body,  List<int> months)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KnowledgeArticle() when $default != null:
return $default(_that.id,_that.language,_that.region,_that.category,_that.title,_that.summary,_that.body,_that.months);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String language,  KnowledgeRegion region,  KnowledgeCategory category,  String title,  String summary,  String body,  List<int> months)  $default,) {final _that = this;
switch (_that) {
case _KnowledgeArticle():
return $default(_that.id,_that.language,_that.region,_that.category,_that.title,_that.summary,_that.body,_that.months);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String language,  KnowledgeRegion region,  KnowledgeCategory category,  String title,  String summary,  String body,  List<int> months)?  $default,) {final _that = this;
switch (_that) {
case _KnowledgeArticle() when $default != null:
return $default(_that.id,_that.language,_that.region,_that.category,_that.title,_that.summary,_that.body,_that.months);case _:
  return null;

}
}

}

/// @nodoc


class _KnowledgeArticle implements KnowledgeArticle {
  const _KnowledgeArticle({required this.id, required this.language, required this.region, required this.category, required this.title, required this.summary, required this.body,  List<int> months = const []}): _months = months;
  

@override final  String id;
/// Dosyanın klasörü (`tr`, `en`).
@override final  String language;
@override final  KnowledgeRegion region;
@override final  KnowledgeCategory category;
@override final  String title;
@override final  String summary;
@override final  String body;
/// Makalenin ait olduğu aylar (1–12), Kuzey yarımküreye göre; Güney'de
/// 6 ay kaydırılarak eşlenir.
 final  List<int> _months;
/// Makalenin ait olduğu aylar (1–12), Kuzey yarımküreye göre; Güney'de
/// 6 ay kaydırılarak eşlenir.
@override@JsonKey() List<int> get months {
  if (_months is EqualUnmodifiableListView) return _months;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_months);
}


/// Create a copy of KnowledgeArticle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KnowledgeArticleCopyWith<_KnowledgeArticle> get copyWith => __$KnowledgeArticleCopyWithImpl<_KnowledgeArticle>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KnowledgeArticle&&(identical(other.id, id) || other.id == id)&&(identical(other.language, language) || other.language == language)&&(identical(other.region, region) || other.region == region)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.months, _months));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,language,region,category,title,summary,body,const DeepCollectionEquality().hash(_months));
}

@override
String toString() {
    return 'KnowledgeArticle(id: $id, language: $language, region: $region, category: $category, title: $title, summary: $summary, body: $body, months: $months)';
}


}

/// @nodoc
abstract mixin class _$KnowledgeArticleCopyWith<$Res> implements $KnowledgeArticleCopyWith<$Res> {
  factory _$KnowledgeArticleCopyWith(_KnowledgeArticle value, $Res Function(_KnowledgeArticle) _then) = __$KnowledgeArticleCopyWithImpl;
@override @useResult
$Res call({
 String id, String language, KnowledgeRegion region, KnowledgeCategory category, String title, String summary, String body, List<int> months
});




}
/// @nodoc
class __$KnowledgeArticleCopyWithImpl<$Res>
    implements _$KnowledgeArticleCopyWith<$Res> {
  __$KnowledgeArticleCopyWithImpl(this._self, this._then);

  final _KnowledgeArticle _self;
  final $Res Function(_KnowledgeArticle) _then;

/// Create a copy of KnowledgeArticle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? language = null,Object? region = null,Object? category = null,Object? title = null,Object? summary = null,Object? body = null,Object? months = null,}) {
  return _then(_KnowledgeArticle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as KnowledgeRegion,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as KnowledgeCategory,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,months: null == months ? _self._months : months // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
mixin _$KnowledgeLibrary {

 int get version; List<KnowledgeArticle> get articles;
/// Create a copy of KnowledgeLibrary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KnowledgeLibraryCopyWith<KnowledgeLibrary> get copyWith => _$KnowledgeLibraryCopyWithImpl<KnowledgeLibrary>(this as KnowledgeLibrary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KnowledgeLibrary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnowledgeLibrary&&(identical(other.version, _this.version) || other.version == _this.version)&&const DeepCollectionEquality().equals(other.articles, _this.articles));
}


@override
int get hashCode {
  final _this = this as KnowledgeLibrary;
  return Object.hash(runtimeType,_this.version,const DeepCollectionEquality().hash(_this.articles));
}

@override
String toString() {
  final _this = this as KnowledgeLibrary;
  return 'KnowledgeLibrary(version: ${_this.version}, articles: ${_this.articles})';
}


}

/// @nodoc
abstract mixin class $KnowledgeLibraryCopyWith<$Res>  {
  factory $KnowledgeLibraryCopyWith(KnowledgeLibrary value, $Res Function(KnowledgeLibrary) _then) = _$KnowledgeLibraryCopyWithImpl;
@useResult
$Res call({
 int version, List<KnowledgeArticle> articles
});




}
/// @nodoc
class _$KnowledgeLibraryCopyWithImpl<$Res>
    implements $KnowledgeLibraryCopyWith<$Res> {
  _$KnowledgeLibraryCopyWithImpl(this._self, this._then);

  final KnowledgeLibrary _self;
  final $Res Function(KnowledgeLibrary) _then;

/// Create a copy of KnowledgeLibrary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? articles = null,}) {
  return _then(KnowledgeLibrary(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as List<KnowledgeArticle>,
  ));
}

}


/// Adds pattern-matching-related methods to [KnowledgeLibrary].
extension KnowledgeLibraryPatterns on KnowledgeLibrary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KnowledgeLibrary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KnowledgeLibrary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KnowledgeLibrary value)  $default,){
final _that = this;
switch (_that) {
case _KnowledgeLibrary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KnowledgeLibrary value)?  $default,){
final _that = this;
switch (_that) {
case _KnowledgeLibrary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<KnowledgeArticle> articles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KnowledgeLibrary() when $default != null:
return $default(_that.version,_that.articles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<KnowledgeArticle> articles)  $default,) {final _that = this;
switch (_that) {
case _KnowledgeLibrary():
return $default(_that.version,_that.articles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<KnowledgeArticle> articles)?  $default,) {final _that = this;
switch (_that) {
case _KnowledgeLibrary() when $default != null:
return $default(_that.version,_that.articles);case _:
  return null;

}
}

}

/// @nodoc


class _KnowledgeLibrary implements KnowledgeLibrary {
  const _KnowledgeLibrary({required this.version, required  List<KnowledgeArticle> articles}): _articles = articles;
  

@override final  int version;
 final  List<KnowledgeArticle> _articles;
@override List<KnowledgeArticle> get articles {
  if (_articles is EqualUnmodifiableListView) return _articles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_articles);
}


/// Create a copy of KnowledgeLibrary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KnowledgeLibraryCopyWith<_KnowledgeLibrary> get copyWith => __$KnowledgeLibraryCopyWithImpl<_KnowledgeLibrary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KnowledgeLibrary&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.articles, _articles));
}


@override
int get hashCode {
    return Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_articles));
}

@override
String toString() {
    return 'KnowledgeLibrary(version: $version, articles: $articles)';
}


}

/// @nodoc
abstract mixin class _$KnowledgeLibraryCopyWith<$Res> implements $KnowledgeLibraryCopyWith<$Res> {
  factory _$KnowledgeLibraryCopyWith(_KnowledgeLibrary value, $Res Function(_KnowledgeLibrary) _then) = __$KnowledgeLibraryCopyWithImpl;
@override @useResult
$Res call({
 int version, List<KnowledgeArticle> articles
});




}
/// @nodoc
class __$KnowledgeLibraryCopyWithImpl<$Res>
    implements _$KnowledgeLibraryCopyWith<$Res> {
  __$KnowledgeLibraryCopyWithImpl(this._self, this._then);

  final _KnowledgeLibrary _self;
  final $Res Function(_KnowledgeLibrary) _then;

/// Create a copy of KnowledgeLibrary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? articles = null,}) {
  return _then(_KnowledgeLibrary(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,articles: null == articles ? _self._articles : articles // ignore: cast_nullable_to_non_nullable
as List<KnowledgeArticle>,
  ));
}


}

/// @nodoc
mixin _$KnowledgeManifest {

 int get format; int get version; String get path; String get sha256;
/// Create a copy of KnowledgeManifest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KnowledgeManifestCopyWith<KnowledgeManifest> get copyWith => _$KnowledgeManifestCopyWithImpl<KnowledgeManifest>(this as KnowledgeManifest, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KnowledgeManifest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnowledgeManifest&&(identical(other.format, _this.format) || other.format == _this.format)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.sha256, _this.sha256) || other.sha256 == _this.sha256));
}


@override
int get hashCode {
  final _this = this as KnowledgeManifest;
  return Object.hash(runtimeType,_this.format,_this.version,_this.path,_this.sha256);
}

@override
String toString() {
  final _this = this as KnowledgeManifest;
  return 'KnowledgeManifest(format: ${_this.format}, version: ${_this.version}, path: ${_this.path}, sha256: ${_this.sha256})';
}


}

/// @nodoc
abstract mixin class $KnowledgeManifestCopyWith<$Res>  {
  factory $KnowledgeManifestCopyWith(KnowledgeManifest value, $Res Function(KnowledgeManifest) _then) = _$KnowledgeManifestCopyWithImpl;
@useResult
$Res call({
 int format, int version, String path, String sha256
});




}
/// @nodoc
class _$KnowledgeManifestCopyWithImpl<$Res>
    implements $KnowledgeManifestCopyWith<$Res> {
  _$KnowledgeManifestCopyWithImpl(this._self, this._then);

  final KnowledgeManifest _self;
  final $Res Function(KnowledgeManifest) _then;

/// Create a copy of KnowledgeManifest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? format = null,Object? version = null,Object? path = null,Object? sha256 = null,}) {
  return _then(KnowledgeManifest(
format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KnowledgeManifest].
extension KnowledgeManifestPatterns on KnowledgeManifest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KnowledgeManifest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KnowledgeManifest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KnowledgeManifest value)  $default,){
final _that = this;
switch (_that) {
case _KnowledgeManifest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KnowledgeManifest value)?  $default,){
final _that = this;
switch (_that) {
case _KnowledgeManifest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int format,  int version,  String path,  String sha256)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KnowledgeManifest() when $default != null:
return $default(_that.format,_that.version,_that.path,_that.sha256);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int format,  int version,  String path,  String sha256)  $default,) {final _that = this;
switch (_that) {
case _KnowledgeManifest():
return $default(_that.format,_that.version,_that.path,_that.sha256);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int format,  int version,  String path,  String sha256)?  $default,) {final _that = this;
switch (_that) {
case _KnowledgeManifest() when $default != null:
return $default(_that.format,_that.version,_that.path,_that.sha256);case _:
  return null;

}
}

}

/// @nodoc


class _KnowledgeManifest implements KnowledgeManifest {
  const _KnowledgeManifest({required this.format, required this.version, required this.path, required this.sha256});
  

@override final  int format;
@override final  int version;
@override final  String path;
@override final  String sha256;

/// Create a copy of KnowledgeManifest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KnowledgeManifestCopyWith<_KnowledgeManifest> get copyWith => __$KnowledgeManifestCopyWithImpl<_KnowledgeManifest>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KnowledgeManifest&&(identical(other.format, format) || other.format == format)&&(identical(other.version, version) || other.version == version)&&(identical(other.path, path) || other.path == path)&&(identical(other.sha256, sha256) || other.sha256 == sha256));
}


@override
int get hashCode {
    return Object.hash(runtimeType,format,version,path,sha256);
}

@override
String toString() {
    return 'KnowledgeManifest(format: $format, version: $version, path: $path, sha256: $sha256)';
}


}

/// @nodoc
abstract mixin class _$KnowledgeManifestCopyWith<$Res> implements $KnowledgeManifestCopyWith<$Res> {
  factory _$KnowledgeManifestCopyWith(_KnowledgeManifest value, $Res Function(_KnowledgeManifest) _then) = __$KnowledgeManifestCopyWithImpl;
@override @useResult
$Res call({
 int format, int version, String path, String sha256
});




}
/// @nodoc
class __$KnowledgeManifestCopyWithImpl<$Res>
    implements _$KnowledgeManifestCopyWith<$Res> {
  __$KnowledgeManifestCopyWithImpl(this._self, this._then);

  final _KnowledgeManifest _self;
  final $Res Function(_KnowledgeManifest) _then;

/// Create a copy of KnowledgeManifest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? format = null,Object? version = null,Object? path = null,Object? sha256 = null,}) {
  return _then(_KnowledgeManifest(
format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
