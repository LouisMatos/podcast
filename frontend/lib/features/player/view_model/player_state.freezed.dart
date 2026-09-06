// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerState {

 Podcast? get podcast; Episode? get episode; List<Episode> get queue; bool get isPlaying; bool get isBuffering; Duration get position; Duration get bufferedPosition; Duration? get duration; double get speed; Duration? get sleepTimerRemaining;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlayerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.podcast, _this.podcast) || other.podcast == _this.podcast)&&(identical(other.episode, _this.episode) || other.episode == _this.episode)&&const DeepCollectionEquality().equals(other.queue, _this.queue)&&(identical(other.isPlaying, _this.isPlaying) || other.isPlaying == _this.isPlaying)&&(identical(other.isBuffering, _this.isBuffering) || other.isBuffering == _this.isBuffering)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.bufferedPosition, _this.bufferedPosition) || other.bufferedPosition == _this.bufferedPosition)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.speed, _this.speed) || other.speed == _this.speed)&&(identical(other.sleepTimerRemaining, _this.sleepTimerRemaining) || other.sleepTimerRemaining == _this.sleepTimerRemaining));
}


@override
int get hashCode {
  final _this = this as PlayerState;
  return Object.hash(runtimeType,_this.podcast,_this.episode,const DeepCollectionEquality().hash(_this.queue),_this.isPlaying,_this.isBuffering,_this.position,_this.bufferedPosition,_this.duration,_this.speed,_this.sleepTimerRemaining);
}

@override
String toString() {
  final _this = this as PlayerState;
  return 'PlayerState(podcast: ${_this.podcast}, episode: ${_this.episode}, queue: ${_this.queue}, isPlaying: ${_this.isPlaying}, isBuffering: ${_this.isBuffering}, position: ${_this.position}, bufferedPosition: ${_this.bufferedPosition}, duration: ${_this.duration}, speed: ${_this.speed}, sleepTimerRemaining: ${_this.sleepTimerRemaining})';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 Podcast? podcast, Episode? episode, List<Episode> queue, bool isPlaying, bool isBuffering, Duration position, Duration bufferedPosition, Duration? duration, double speed, Duration? sleepTimerRemaining
});


$PodcastCopyWith<$Res>? get podcast;$EpisodeCopyWith<$Res>? get episode;

}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcast = freezed,Object? episode = freezed,Object? queue = null,Object? isPlaying = null,Object? isBuffering = null,Object? position = null,Object? bufferedPosition = null,Object? duration = freezed,Object? speed = null,Object? sleepTimerRemaining = freezed,}) {
  return _then(PlayerState(
podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,queue: null == queue ? _self.queue : queue // ignore: cast_nullable_to_non_nullable
as List<Episode>,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,bufferedPosition: null == bufferedPosition ? _self.bufferedPosition : bufferedPosition // ignore: cast_nullable_to_non_nullable
as Duration,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,sleepTimerRemaining: freezed == sleepTimerRemaining ? _self.sleepTimerRemaining : sleepTimerRemaining // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}
/// Create a copy of PlayerState
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
}/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res>? get episode {
    if (_self.episode == null) {
    return null;
  }

  return $EpisodeCopyWith<$Res>(_self.episode!, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Podcast? podcast,  Episode? episode,  List<Episode> queue,  bool isPlaying,  bool isBuffering,  Duration position,  Duration bufferedPosition,  Duration? duration,  double speed,  Duration? sleepTimerRemaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.podcast,_that.episode,_that.queue,_that.isPlaying,_that.isBuffering,_that.position,_that.bufferedPosition,_that.duration,_that.speed,_that.sleepTimerRemaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Podcast? podcast,  Episode? episode,  List<Episode> queue,  bool isPlaying,  bool isBuffering,  Duration position,  Duration bufferedPosition,  Duration? duration,  double speed,  Duration? sleepTimerRemaining)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.podcast,_that.episode,_that.queue,_that.isPlaying,_that.isBuffering,_that.position,_that.bufferedPosition,_that.duration,_that.speed,_that.sleepTimerRemaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Podcast? podcast,  Episode? episode,  List<Episode> queue,  bool isPlaying,  bool isBuffering,  Duration position,  Duration bufferedPosition,  Duration? duration,  double speed,  Duration? sleepTimerRemaining)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.podcast,_that.episode,_that.queue,_that.isPlaying,_that.isBuffering,_that.position,_that.bufferedPosition,_that.duration,_that.speed,_that.sleepTimerRemaining);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerState extends PlayerState {
  const _PlayerState({this.podcast, this.episode,  List<Episode> queue = const <Episode>[], this.isPlaying = false, this.isBuffering = false, this.position = Duration.zero, this.bufferedPosition = Duration.zero, this.duration, this.speed = 1.0, this.sleepTimerRemaining}): _queue = queue,super._();
  

@override final  Podcast? podcast;
@override final  Episode? episode;
 final  List<Episode> _queue;
@override@JsonKey() List<Episode> get queue {
  if (_queue is EqualUnmodifiableListView) return _queue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queue);
}

@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  bool isBuffering;
@override@JsonKey() final  Duration position;
@override@JsonKey() final  Duration bufferedPosition;
@override final  Duration? duration;
@override@JsonKey() final  double speed;
@override final  Duration? sleepTimerRemaining;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.podcast, podcast) || other.podcast == podcast)&&(identical(other.episode, episode) || other.episode == episode)&&const DeepCollectionEquality().equals(other.queue, _queue)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.position, position) || other.position == position)&&(identical(other.bufferedPosition, bufferedPosition) || other.bufferedPosition == bufferedPosition)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.sleepTimerRemaining, sleepTimerRemaining) || other.sleepTimerRemaining == sleepTimerRemaining));
}


@override
int get hashCode {
    return Object.hash(runtimeType,podcast,episode,const DeepCollectionEquality().hash(_queue),isPlaying,isBuffering,position,bufferedPosition,duration,speed,sleepTimerRemaining);
}

@override
String toString() {
    return 'PlayerState(podcast: $podcast, episode: $episode, queue: $queue, isPlaying: $isPlaying, isBuffering: $isBuffering, position: $position, bufferedPosition: $bufferedPosition, duration: $duration, speed: $speed, sleepTimerRemaining: $sleepTimerRemaining)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 Podcast? podcast, Episode? episode, List<Episode> queue, bool isPlaying, bool isBuffering, Duration position, Duration bufferedPosition, Duration? duration, double speed, Duration? sleepTimerRemaining
});


@override $PodcastCopyWith<$Res>? get podcast;@override $EpisodeCopyWith<$Res>? get episode;

}
/// @nodoc
class __$PlayerStateCopyWithImpl<$Res>
    implements _$PlayerStateCopyWith<$Res> {
  __$PlayerStateCopyWithImpl(this._self, this._then);

  final _PlayerState _self;
  final $Res Function(_PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcast = freezed,Object? episode = freezed,Object? queue = null,Object? isPlaying = null,Object? isBuffering = null,Object? position = null,Object? bufferedPosition = null,Object? duration = freezed,Object? speed = null,Object? sleepTimerRemaining = freezed,}) {
  return _then(_PlayerState(
podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,queue: null == queue ? _self._queue : queue // ignore: cast_nullable_to_non_nullable
as List<Episode>,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,bufferedPosition: null == bufferedPosition ? _self.bufferedPosition : bufferedPosition // ignore: cast_nullable_to_non_nullable
as Duration,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,sleepTimerRemaining: freezed == sleepTimerRemaining ? _self.sleepTimerRemaining : sleepTimerRemaining // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}

/// Create a copy of PlayerState
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
}/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res>? get episode {
    if (_self.episode == null) {
    return null;
  }

  return $EpisodeCopyWith<$Res>(_self.episode!, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}

// dart format on
