// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscribe_feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubscribeFeedState {

 bool get isLoading; Podcast? get podcast; List<Episode> get episodes; String? get error; bool get alreadySubscribed;
/// Create a copy of SubscribeFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscribeFeedStateCopyWith<SubscribeFeedState> get copyWith => _$SubscribeFeedStateCopyWithImpl<SubscribeFeedState>(this as SubscribeFeedState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SubscribeFeedState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscribeFeedState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.podcast, _this.podcast) || other.podcast == _this.podcast)&&const DeepCollectionEquality().equals(other.episodes, _this.episodes)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.alreadySubscribed, _this.alreadySubscribed) || other.alreadySubscribed == _this.alreadySubscribed));
}


@override
int get hashCode {
  final _this = this as SubscribeFeedState;
  return Object.hash(runtimeType,_this.isLoading,_this.podcast,const DeepCollectionEquality().hash(_this.episodes),_this.error,_this.alreadySubscribed);
}

@override
String toString() {
  final _this = this as SubscribeFeedState;
  return 'SubscribeFeedState(isLoading: ${_this.isLoading}, podcast: ${_this.podcast}, episodes: ${_this.episodes}, error: ${_this.error}, alreadySubscribed: ${_this.alreadySubscribed})';
}


}

/// @nodoc
abstract mixin class $SubscribeFeedStateCopyWith<$Res>  {
  factory $SubscribeFeedStateCopyWith(SubscribeFeedState value, $Res Function(SubscribeFeedState) _then) = _$SubscribeFeedStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, Podcast? podcast, List<Episode> episodes, String? error, bool alreadySubscribed
});


$PodcastCopyWith<$Res>? get podcast;

}
/// @nodoc
class _$SubscribeFeedStateCopyWithImpl<$Res>
    implements $SubscribeFeedStateCopyWith<$Res> {
  _$SubscribeFeedStateCopyWithImpl(this._self, this._then);

  final SubscribeFeedState _self;
  final $Res Function(SubscribeFeedState) _then;

/// Create a copy of SubscribeFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? podcast = freezed,Object? episodes = null,Object? error = freezed,Object? alreadySubscribed = null,}) {
  return _then(SubscribeFeedState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,alreadySubscribed: null == alreadySubscribed ? _self.alreadySubscribed : alreadySubscribed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SubscribeFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastCopyWith<$Res>? get podcast {
    if (_self.podcast == null) {
    return null;
  }

  return $PodcastCopyWith<$Res>(_self.podcast!, (value) {
    return _then(_self.copyWith(podcast: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubscribeFeedState].
extension SubscribeFeedStatePatterns on SubscribeFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscribeFeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscribeFeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscribeFeedState value)  $default,){
final _that = this;
switch (_that) {
case _SubscribeFeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscribeFeedState value)?  $default,){
final _that = this;
switch (_that) {
case _SubscribeFeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  Podcast? podcast,  List<Episode> episodes,  String? error,  bool alreadySubscribed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscribeFeedState() when $default != null:
return $default(_that.isLoading,_that.podcast,_that.episodes,_that.error,_that.alreadySubscribed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  Podcast? podcast,  List<Episode> episodes,  String? error,  bool alreadySubscribed)  $default,) {final _that = this;
switch (_that) {
case _SubscribeFeedState():
return $default(_that.isLoading,_that.podcast,_that.episodes,_that.error,_that.alreadySubscribed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  Podcast? podcast,  List<Episode> episodes,  String? error,  bool alreadySubscribed)?  $default,) {final _that = this;
switch (_that) {
case _SubscribeFeedState() when $default != null:
return $default(_that.isLoading,_that.podcast,_that.episodes,_that.error,_that.alreadySubscribed);case _:
  return null;

}
}

}

/// @nodoc


class _SubscribeFeedState implements SubscribeFeedState {
  const _SubscribeFeedState({this.isLoading = true, this.podcast,  List<Episode> episodes = const <Episode>[], this.error, this.alreadySubscribed = false}): _episodes = episodes;
  

@override@JsonKey() final  bool isLoading;
@override final  Podcast? podcast;
 final  List<Episode> _episodes;
@override@JsonKey() List<Episode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

@override final  String? error;
@override@JsonKey() final  bool alreadySubscribed;

/// Create a copy of SubscribeFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscribeFeedStateCopyWith<_SubscribeFeedState> get copyWith => __$SubscribeFeedStateCopyWithImpl<_SubscribeFeedState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscribeFeedState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.podcast, podcast) || other.podcast == podcast)&&const DeepCollectionEquality().equals(other.episodes, _episodes)&&(identical(other.error, error) || other.error == error)&&(identical(other.alreadySubscribed, alreadySubscribed) || other.alreadySubscribed == alreadySubscribed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,podcast,const DeepCollectionEquality().hash(_episodes),error,alreadySubscribed);
}

@override
String toString() {
    return 'SubscribeFeedState(isLoading: $isLoading, podcast: $podcast, episodes: $episodes, error: $error, alreadySubscribed: $alreadySubscribed)';
}


}

/// @nodoc
abstract mixin class _$SubscribeFeedStateCopyWith<$Res> implements $SubscribeFeedStateCopyWith<$Res> {
  factory _$SubscribeFeedStateCopyWith(_SubscribeFeedState value, $Res Function(_SubscribeFeedState) _then) = __$SubscribeFeedStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, Podcast? podcast, List<Episode> episodes, String? error, bool alreadySubscribed
});


@override $PodcastCopyWith<$Res>? get podcast;

}
/// @nodoc
class __$SubscribeFeedStateCopyWithImpl<$Res>
    implements _$SubscribeFeedStateCopyWith<$Res> {
  __$SubscribeFeedStateCopyWithImpl(this._self, this._then);

  final _SubscribeFeedState _self;
  final $Res Function(_SubscribeFeedState) _then;

/// Create a copy of SubscribeFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? podcast = freezed,Object? episodes = null,Object? error = freezed,Object? alreadySubscribed = null,}) {
  return _then(_SubscribeFeedState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,alreadySubscribed: null == alreadySubscribed ? _self.alreadySubscribed : alreadySubscribed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SubscribeFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastCopyWith<$Res>? get podcast {
    if (_self.podcast == null) {
    return null;
  }

  return $PodcastCopyWith<$Res>(_self.podcast!, (value) {
    return _then(_self.copyWith(podcast: value));
  });
}
}

// dart format on
