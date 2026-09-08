// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoverState {

 String get query; bool get isLoading; SearchMode get mode; List<Podcast> get results; List<EpisodeSearchResult> get episodeResults; String? get error; bool get offline;
/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverStateCopyWith<DiscoverState> get copyWith => _$DiscoverStateCopyWithImpl<DiscoverState>(this as DiscoverState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiscoverState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverState&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&const DeepCollectionEquality().equals(other.results, _this.results)&&const DeepCollectionEquality().equals(other.episodeResults, _this.episodeResults)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.offline, _this.offline) || other.offline == _this.offline));
}


@override
int get hashCode {
  final _this = this as DiscoverState;
  return Object.hash(runtimeType,_this.query,_this.isLoading,_this.mode,const DeepCollectionEquality().hash(_this.results),const DeepCollectionEquality().hash(_this.episodeResults),_this.error,_this.offline);
}

@override
String toString() {
  final _this = this as DiscoverState;
  return 'DiscoverState(query: ${_this.query}, isLoading: ${_this.isLoading}, mode: ${_this.mode}, results: ${_this.results}, episodeResults: ${_this.episodeResults}, error: ${_this.error}, offline: ${_this.offline})';
}


}

/// @nodoc
abstract mixin class $DiscoverStateCopyWith<$Res>  {
  factory $DiscoverStateCopyWith(DiscoverState value, $Res Function(DiscoverState) _then) = _$DiscoverStateCopyWithImpl;
@useResult
$Res call({
 String query, bool isLoading, SearchMode mode, List<Podcast> results, List<EpisodeSearchResult> episodeResults, String? error, bool offline
});




}
/// @nodoc
class _$DiscoverStateCopyWithImpl<$Res>
    implements $DiscoverStateCopyWith<$Res> {
  _$DiscoverStateCopyWithImpl(this._self, this._then);

  final DiscoverState _self;
  final $Res Function(DiscoverState) _then;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? isLoading = null,Object? mode = null,Object? results = null,Object? episodeResults = null,Object? error = freezed,Object? offline = null,}) {
  return _then(DiscoverState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SearchMode,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<Podcast>,episodeResults: null == episodeResults ? _self.episodeResults : episodeResults // ignore: cast_nullable_to_non_nullable
as List<EpisodeSearchResult>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverState].
extension DiscoverStatePatterns on DiscoverState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverState value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverState value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  bool isLoading,  SearchMode mode,  List<Podcast> results,  List<EpisodeSearchResult> episodeResults,  String? error,  bool offline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
return $default(_that.query,_that.isLoading,_that.mode,_that.results,_that.episodeResults,_that.error,_that.offline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  bool isLoading,  SearchMode mode,  List<Podcast> results,  List<EpisodeSearchResult> episodeResults,  String? error,  bool offline)  $default,) {final _that = this;
switch (_that) {
case _DiscoverState():
return $default(_that.query,_that.isLoading,_that.mode,_that.results,_that.episodeResults,_that.error,_that.offline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  bool isLoading,  SearchMode mode,  List<Podcast> results,  List<EpisodeSearchResult> episodeResults,  String? error,  bool offline)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
return $default(_that.query,_that.isLoading,_that.mode,_that.results,_that.episodeResults,_that.error,_that.offline);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoverState implements DiscoverState {
  const _DiscoverState({this.query = '', this.isLoading = false, this.mode = SearchMode.podcasts,  List<Podcast> results = const <Podcast>[],  List<EpisodeSearchResult> episodeResults = const <EpisodeSearchResult>[], this.error, this.offline = false}): _results = results,_episodeResults = episodeResults;
  

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  SearchMode mode;
 final  List<Podcast> _results;
@override@JsonKey() List<Podcast> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  List<EpisodeSearchResult> _episodeResults;
@override@JsonKey() List<EpisodeSearchResult> get episodeResults {
  if (_episodeResults is EqualUnmodifiableListView) return _episodeResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodeResults);
}

@override final  String? error;
@override@JsonKey() final  bool offline;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverStateCopyWith<_DiscoverState> get copyWith => __$DiscoverStateCopyWithImpl<_DiscoverState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverState&&(identical(other.query, query) || other.query == query)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.results, _results)&&const DeepCollectionEquality().equals(other.episodeResults, _episodeResults)&&(identical(other.error, error) || other.error == error)&&(identical(other.offline, offline) || other.offline == offline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,isLoading,mode,const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_episodeResults),error,offline);
}

@override
String toString() {
    return 'DiscoverState(query: $query, isLoading: $isLoading, mode: $mode, results: $results, episodeResults: $episodeResults, error: $error, offline: $offline)';
}


}

/// @nodoc
abstract mixin class _$DiscoverStateCopyWith<$Res> implements $DiscoverStateCopyWith<$Res> {
  factory _$DiscoverStateCopyWith(_DiscoverState value, $Res Function(_DiscoverState) _then) = __$DiscoverStateCopyWithImpl;
@override @useResult
$Res call({
 String query, bool isLoading, SearchMode mode, List<Podcast> results, List<EpisodeSearchResult> episodeResults, String? error, bool offline
});




}
/// @nodoc
class __$DiscoverStateCopyWithImpl<$Res>
    implements _$DiscoverStateCopyWith<$Res> {
  __$DiscoverStateCopyWithImpl(this._self, this._then);

  final _DiscoverState _self;
  final $Res Function(_DiscoverState) _then;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? isLoading = null,Object? mode = null,Object? results = null,Object? episodeResults = null,Object? error = freezed,Object? offline = null,}) {
  return _then(_DiscoverState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SearchMode,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Podcast>,episodeResults: null == episodeResults ? _self._episodeResults : episodeResults // ignore: cast_nullable_to_non_nullable
as List<EpisodeSearchResult>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
