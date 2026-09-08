// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opml_import_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OpmlImportResult {

 int get added; int get skipped; int get failed; List<String> get failedTitles;
/// Create a copy of OpmlImportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpmlImportResultCopyWith<OpmlImportResult> get copyWith => _$OpmlImportResultCopyWithImpl<OpmlImportResult>(this as OpmlImportResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OpmlImportResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpmlImportResult&&(identical(other.added, _this.added) || other.added == _this.added)&&(identical(other.skipped, _this.skipped) || other.skipped == _this.skipped)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&const DeepCollectionEquality().equals(other.failedTitles, _this.failedTitles));
}


@override
int get hashCode {
  final _this = this as OpmlImportResult;
  return Object.hash(runtimeType,_this.added,_this.skipped,_this.failed,const DeepCollectionEquality().hash(_this.failedTitles));
}

@override
String toString() {
  final _this = this as OpmlImportResult;
  return 'OpmlImportResult(added: ${_this.added}, skipped: ${_this.skipped}, failed: ${_this.failed}, failedTitles: ${_this.failedTitles})';
}


}

/// @nodoc
abstract mixin class $OpmlImportResultCopyWith<$Res>  {
  factory $OpmlImportResultCopyWith(OpmlImportResult value, $Res Function(OpmlImportResult) _then) = _$OpmlImportResultCopyWithImpl;
@useResult
$Res call({
 int added, int skipped, int failed, List<String> failedTitles
});




}
/// @nodoc
class _$OpmlImportResultCopyWithImpl<$Res>
    implements $OpmlImportResultCopyWith<$Res> {
  _$OpmlImportResultCopyWithImpl(this._self, this._then);

  final OpmlImportResult _self;
  final $Res Function(OpmlImportResult) _then;

/// Create a copy of OpmlImportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? added = null,Object? skipped = null,Object? failed = null,Object? failedTitles = null,}) {
  return _then(OpmlImportResult(
added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,failedTitles: null == failedTitles ? _self.failedTitles : failedTitles // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OpmlImportResult].
extension OpmlImportResultPatterns on OpmlImportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpmlImportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpmlImportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpmlImportResult value)  $default,){
final _that = this;
switch (_that) {
case _OpmlImportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpmlImportResult value)?  $default,){
final _that = this;
switch (_that) {
case _OpmlImportResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int added,  int skipped,  int failed,  List<String> failedTitles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpmlImportResult() when $default != null:
return $default(_that.added,_that.skipped,_that.failed,_that.failedTitles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int added,  int skipped,  int failed,  List<String> failedTitles)  $default,) {final _that = this;
switch (_that) {
case _OpmlImportResult():
return $default(_that.added,_that.skipped,_that.failed,_that.failedTitles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int added,  int skipped,  int failed,  List<String> failedTitles)?  $default,) {final _that = this;
switch (_that) {
case _OpmlImportResult() when $default != null:
return $default(_that.added,_that.skipped,_that.failed,_that.failedTitles);case _:
  return null;

}
}

}

/// @nodoc


class _OpmlImportResult implements OpmlImportResult {
  const _OpmlImportResult({this.added = 0, this.skipped = 0, this.failed = 0,  List<String> failedTitles = const <String>[]}): _failedTitles = failedTitles;
  

@override@JsonKey() final  int added;
@override@JsonKey() final  int skipped;
@override@JsonKey() final  int failed;
 final  List<String> _failedTitles;
@override@JsonKey() List<String> get failedTitles {
  if (_failedTitles is EqualUnmodifiableListView) return _failedTitles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedTitles);
}


/// Create a copy of OpmlImportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpmlImportResultCopyWith<_OpmlImportResult> get copyWith => __$OpmlImportResultCopyWithImpl<_OpmlImportResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpmlImportResult&&(identical(other.added, added) || other.added == added)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.failed, failed) || other.failed == failed)&&const DeepCollectionEquality().equals(other.failedTitles, _failedTitles));
}


@override
int get hashCode {
    return Object.hash(runtimeType,added,skipped,failed,const DeepCollectionEquality().hash(_failedTitles));
}

@override
String toString() {
    return 'OpmlImportResult(added: $added, skipped: $skipped, failed: $failed, failedTitles: $failedTitles)';
}


}

/// @nodoc
abstract mixin class _$OpmlImportResultCopyWith<$Res> implements $OpmlImportResultCopyWith<$Res> {
  factory _$OpmlImportResultCopyWith(_OpmlImportResult value, $Res Function(_OpmlImportResult) _then) = __$OpmlImportResultCopyWithImpl;
@override @useResult
$Res call({
 int added, int skipped, int failed, List<String> failedTitles
});




}
/// @nodoc
class __$OpmlImportResultCopyWithImpl<$Res>
    implements _$OpmlImportResultCopyWith<$Res> {
  __$OpmlImportResultCopyWithImpl(this._self, this._then);

  final _OpmlImportResult _self;
  final $Res Function(_OpmlImportResult) _then;

/// Create a copy of OpmlImportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? added = null,Object? skipped = null,Object? failed = null,Object? failedTitles = null,}) {
  return _then(_OpmlImportResult(
added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,failedTitles: null == failedTitles ? _self._failedTitles : failedTitles // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
