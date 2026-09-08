// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibrarySearchState {

 String get query; bool get isLoading; List<RecentEpisodeItem> get results; String? get error;
/// Create a copy of LibrarySearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibrarySearchStateCopyWith<LibrarySearchState> get copyWith => _$LibrarySearchStateCopyWithImpl<LibrarySearchState>(this as LibrarySearchState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LibrarySearchState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibrarySearchState&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&const DeepCollectionEquality().equals(other.results, _this.results)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as LibrarySearchState;
  return Object.hash(runtimeType,_this.query,_this.isLoading,const DeepCollectionEquality().hash(_this.results),_this.error);
}

@override
String toString() {
  final _this = this as LibrarySearchState;
  return 'LibrarySearchState(query: ${_this.query}, isLoading: ${_this.isLoading}, results: ${_this.results}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $LibrarySearchStateCopyWith<$Res>  {
  factory $LibrarySearchStateCopyWith(LibrarySearchState value, $Res Function(LibrarySearchState) _then) = _$LibrarySearchStateCopyWithImpl;
@useResult
$Res call({
 String query, bool isLoading, List<RecentEpisodeItem> results, String? error
});




}
/// @nodoc
class _$LibrarySearchStateCopyWithImpl<$Res>
    implements $LibrarySearchStateCopyWith<$Res> {
  _$LibrarySearchStateCopyWithImpl(this._self, this._then);

  final LibrarySearchState _self;
  final $Res Function(LibrarySearchState) _then;

/// Create a copy of LibrarySearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? isLoading = null,Object? results = null,Object? error = freezed,}) {
  return _then(LibrarySearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<RecentEpisodeItem>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LibrarySearchState].
extension LibrarySearchStatePatterns on LibrarySearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibrarySearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibrarySearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibrarySearchState value)  $default,){
final _that = this;
switch (_that) {
case _LibrarySearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibrarySearchState value)?  $default,){
final _that = this;
switch (_that) {
case _LibrarySearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  bool isLoading,  List<RecentEpisodeItem> results,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibrarySearchState() when $default != null:
return $default(_that.query,_that.isLoading,_that.results,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  bool isLoading,  List<RecentEpisodeItem> results,  String? error)  $default,) {final _that = this;
switch (_that) {
case _LibrarySearchState():
return $default(_that.query,_that.isLoading,_that.results,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  bool isLoading,  List<RecentEpisodeItem> results,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _LibrarySearchState() when $default != null:
return $default(_that.query,_that.isLoading,_that.results,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _LibrarySearchState implements LibrarySearchState {
  const _LibrarySearchState({this.query = '', this.isLoading = false,  List<RecentEpisodeItem> results = const <RecentEpisodeItem>[], this.error}): _results = results;
  

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isLoading;
 final  List<RecentEpisodeItem> _results;
@override@JsonKey() List<RecentEpisodeItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override final  String? error;

/// Create a copy of LibrarySearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibrarySearchStateCopyWith<_LibrarySearchState> get copyWith => __$LibrarySearchStateCopyWithImpl<_LibrarySearchState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibrarySearchState&&(identical(other.query, query) || other.query == query)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.results, _results)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,isLoading,const DeepCollectionEquality().hash(_results),error);
}

@override
String toString() {
    return 'LibrarySearchState(query: $query, isLoading: $isLoading, results: $results, error: $error)';
}


}

/// @nodoc
abstract mixin class _$LibrarySearchStateCopyWith<$Res> implements $LibrarySearchStateCopyWith<$Res> {
  factory _$LibrarySearchStateCopyWith(_LibrarySearchState value, $Res Function(_LibrarySearchState) _then) = __$LibrarySearchStateCopyWithImpl;
@override @useResult
$Res call({
 String query, bool isLoading, List<RecentEpisodeItem> results, String? error
});




}
/// @nodoc
class __$LibrarySearchStateCopyWithImpl<$Res>
    implements _$LibrarySearchStateCopyWith<$Res> {
  __$LibrarySearchStateCopyWithImpl(this._self, this._then);

  final _LibrarySearchState _self;
  final $Res Function(_LibrarySearchState) _then;

/// Create a copy of LibrarySearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? isLoading = null,Object? results = null,Object? error = freezed,}) {
  return _then(_LibrarySearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<RecentEpisodeItem>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
