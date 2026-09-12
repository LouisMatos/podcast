// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radio_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RadioState {

 List<RadioStation> get stations; String get query; Set<String> get favoriteIds; bool get isLoading; String? get error; bool get offline; String? get nowPlayingId; RadioStation? get nowPlaying; bool get isPlaying; bool get isBuffering;
/// Create a copy of RadioState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadioStateCopyWith<RadioState> get copyWith => _$RadioStateCopyWithImpl<RadioState>(this as RadioState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RadioState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadioState&&const DeepCollectionEquality().equals(other.stations, _this.stations)&&(identical(other.query, _this.query) || other.query == _this.query)&&const DeepCollectionEquality().equals(other.favoriteIds, _this.favoriteIds)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.offline, _this.offline) || other.offline == _this.offline)&&(identical(other.nowPlayingId, _this.nowPlayingId) || other.nowPlayingId == _this.nowPlayingId)&&(identical(other.nowPlaying, _this.nowPlaying) || other.nowPlaying == _this.nowPlaying)&&(identical(other.isPlaying, _this.isPlaying) || other.isPlaying == _this.isPlaying)&&(identical(other.isBuffering, _this.isBuffering) || other.isBuffering == _this.isBuffering));
}


@override
int get hashCode {
  final _this = this as RadioState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.stations),_this.query,const DeepCollectionEquality().hash(_this.favoriteIds),_this.isLoading,_this.error,_this.offline,_this.nowPlayingId,_this.nowPlaying,_this.isPlaying,_this.isBuffering);
}

@override
String toString() {
  final _this = this as RadioState;
  return 'RadioState(stations: ${_this.stations}, query: ${_this.query}, favoriteIds: ${_this.favoriteIds}, isLoading: ${_this.isLoading}, error: ${_this.error}, offline: ${_this.offline}, nowPlayingId: ${_this.nowPlayingId}, nowPlaying: ${_this.nowPlaying}, isPlaying: ${_this.isPlaying}, isBuffering: ${_this.isBuffering})';
}


}

/// @nodoc
abstract mixin class $RadioStateCopyWith<$Res>  {
  factory $RadioStateCopyWith(RadioState value, $Res Function(RadioState) _then) = _$RadioStateCopyWithImpl;
@useResult
$Res call({
 List<RadioStation> stations, String query, Set<String> favoriteIds, bool isLoading, String? error, bool offline, String? nowPlayingId, RadioStation? nowPlaying, bool isPlaying, bool isBuffering
});


$RadioStationCopyWith<$Res>? get nowPlaying;

}
/// @nodoc
class _$RadioStateCopyWithImpl<$Res>
    implements $RadioStateCopyWith<$Res> {
  _$RadioStateCopyWithImpl(this._self, this._then);

  final RadioState _self;
  final $Res Function(RadioState) _then;

/// Create a copy of RadioState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stations = null,Object? query = null,Object? favoriteIds = null,Object? isLoading = null,Object? error = freezed,Object? offline = null,Object? nowPlayingId = freezed,Object? nowPlaying = freezed,Object? isPlaying = null,Object? isBuffering = null,}) {
  return _then(RadioState(
stations: null == stations ? _self.stations : stations // ignore: cast_nullable_to_non_nullable
as List<RadioStation>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,favoriteIds: null == favoriteIds ? _self.favoriteIds : favoriteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool,nowPlayingId: freezed == nowPlayingId ? _self.nowPlayingId : nowPlayingId // ignore: cast_nullable_to_non_nullable
as String?,nowPlaying: freezed == nowPlaying ? _self.nowPlaying : nowPlaying // ignore: cast_nullable_to_non_nullable
as RadioStation?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of RadioState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadioStationCopyWith<$Res>? get nowPlaying {
    if (_self.nowPlaying == null) {
    return null;
  }

  return $RadioStationCopyWith<$Res>(_self.nowPlaying!, (value) {
    return _then(_self.copyWith(nowPlaying: value));
  });
}
}


/// Adds pattern-matching-related methods to [RadioState].
extension RadioStatePatterns on RadioState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadioState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadioState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadioState value)  $default,){
final _that = this;
switch (_that) {
case _RadioState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadioState value)?  $default,){
final _that = this;
switch (_that) {
case _RadioState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RadioStation> stations,  String query,  Set<String> favoriteIds,  bool isLoading,  String? error,  bool offline,  String? nowPlayingId,  RadioStation? nowPlaying,  bool isPlaying,  bool isBuffering)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadioState() when $default != null:
return $default(_that.stations,_that.query,_that.favoriteIds,_that.isLoading,_that.error,_that.offline,_that.nowPlayingId,_that.nowPlaying,_that.isPlaying,_that.isBuffering);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RadioStation> stations,  String query,  Set<String> favoriteIds,  bool isLoading,  String? error,  bool offline,  String? nowPlayingId,  RadioStation? nowPlaying,  bool isPlaying,  bool isBuffering)  $default,) {final _that = this;
switch (_that) {
case _RadioState():
return $default(_that.stations,_that.query,_that.favoriteIds,_that.isLoading,_that.error,_that.offline,_that.nowPlayingId,_that.nowPlaying,_that.isPlaying,_that.isBuffering);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RadioStation> stations,  String query,  Set<String> favoriteIds,  bool isLoading,  String? error,  bool offline,  String? nowPlayingId,  RadioStation? nowPlaying,  bool isPlaying,  bool isBuffering)?  $default,) {final _that = this;
switch (_that) {
case _RadioState() when $default != null:
return $default(_that.stations,_that.query,_that.favoriteIds,_that.isLoading,_that.error,_that.offline,_that.nowPlayingId,_that.nowPlaying,_that.isPlaying,_that.isBuffering);case _:
  return null;

}
}

}

/// @nodoc


class _RadioState implements RadioState {
  const _RadioState({ List<RadioStation> stations = const <RadioStation>[], this.query = '',  Set<String> favoriteIds = const <String>{}, this.isLoading = false, this.error, this.offline = false, this.nowPlayingId, this.nowPlaying, this.isPlaying = false, this.isBuffering = false}): _stations = stations,_favoriteIds = favoriteIds;
  

 final  List<RadioStation> _stations;
@override@JsonKey() List<RadioStation> get stations {
  if (_stations is EqualUnmodifiableListView) return _stations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stations);
}

@override@JsonKey() final  String query;
 final  Set<String> _favoriteIds;
@override@JsonKey() Set<String> get favoriteIds {
  if (_favoriteIds is EqualUnmodifiableSetView) return _favoriteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_favoriteIds);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;
@override@JsonKey() final  bool offline;
@override final  String? nowPlayingId;
@override final  RadioStation? nowPlaying;
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  bool isBuffering;

/// Create a copy of RadioState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadioStateCopyWith<_RadioState> get copyWith => __$RadioStateCopyWithImpl<_RadioState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadioState&&const DeepCollectionEquality().equals(other.stations, _stations)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.favoriteIds, _favoriteIds)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.offline, offline) || other.offline == offline)&&(identical(other.nowPlayingId, nowPlayingId) || other.nowPlayingId == nowPlayingId)&&(identical(other.nowPlaying, nowPlaying) || other.nowPlaying == nowPlaying)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_stations),query,const DeepCollectionEquality().hash(_favoriteIds),isLoading,error,offline,nowPlayingId,nowPlaying,isPlaying,isBuffering);
}

@override
String toString() {
    return 'RadioState(stations: $stations, query: $query, favoriteIds: $favoriteIds, isLoading: $isLoading, error: $error, offline: $offline, nowPlayingId: $nowPlayingId, nowPlaying: $nowPlaying, isPlaying: $isPlaying, isBuffering: $isBuffering)';
}


}

/// @nodoc
abstract mixin class _$RadioStateCopyWith<$Res> implements $RadioStateCopyWith<$Res> {
  factory _$RadioStateCopyWith(_RadioState value, $Res Function(_RadioState) _then) = __$RadioStateCopyWithImpl;
@override @useResult
$Res call({
 List<RadioStation> stations, String query, Set<String> favoriteIds, bool isLoading, String? error, bool offline, String? nowPlayingId, RadioStation? nowPlaying, bool isPlaying, bool isBuffering
});


@override $RadioStationCopyWith<$Res>? get nowPlaying;

}
/// @nodoc
class __$RadioStateCopyWithImpl<$Res>
    implements _$RadioStateCopyWith<$Res> {
  __$RadioStateCopyWithImpl(this._self, this._then);

  final _RadioState _self;
  final $Res Function(_RadioState) _then;

/// Create a copy of RadioState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stations = null,Object? query = null,Object? favoriteIds = null,Object? isLoading = null,Object? error = freezed,Object? offline = null,Object? nowPlayingId = freezed,Object? nowPlaying = freezed,Object? isPlaying = null,Object? isBuffering = null,}) {
  return _then(_RadioState(
stations: null == stations ? _self._stations : stations // ignore: cast_nullable_to_non_nullable
as List<RadioStation>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,favoriteIds: null == favoriteIds ? _self._favoriteIds : favoriteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool,nowPlayingId: freezed == nowPlayingId ? _self.nowPlayingId : nowPlayingId // ignore: cast_nullable_to_non_nullable
as String?,nowPlaying: freezed == nowPlaying ? _self.nowPlaying : nowPlaying // ignore: cast_nullable_to_non_nullable
as RadioStation?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of RadioState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadioStationCopyWith<$Res>? get nowPlaying {
    if (_self.nowPlaying == null) {
    return null;
  }

  return $RadioStationCopyWith<$Res>(_self.nowPlaying!, (value) {
    return _then(_self.copyWith(nowPlaying: value));
  });
}
}

// dart format on
