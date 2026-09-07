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

 Podcast? get podcast; Episode? get episode; List<Episode> get queue; bool get isPlaying; bool get isBuffering; Duration get position; Duration get bufferedPosition; Duration? get duration; double get speed; Duration? get sleepTimerRemaining; SleepTimerMode get sleepTimerMode; double get volume; bool get equalizerEnabled; bool get equalizerAvailable; double get equalizerMinDb; double get equalizerMaxDb; List<EqualizerBand> get equalizerBands; bool get skipSilenceEnabled; bool get volumeBoostEnabled; double get volumeBoostGainDb; List<Chapter> get chapters;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlayerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.podcast, _this.podcast) || other.podcast == _this.podcast)&&(identical(other.episode, _this.episode) || other.episode == _this.episode)&&const DeepCollectionEquality().equals(other.queue, _this.queue)&&(identical(other.isPlaying, _this.isPlaying) || other.isPlaying == _this.isPlaying)&&(identical(other.isBuffering, _this.isBuffering) || other.isBuffering == _this.isBuffering)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.bufferedPosition, _this.bufferedPosition) || other.bufferedPosition == _this.bufferedPosition)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.speed, _this.speed) || other.speed == _this.speed)&&(identical(other.sleepTimerRemaining, _this.sleepTimerRemaining) || other.sleepTimerRemaining == _this.sleepTimerRemaining)&&(identical(other.sleepTimerMode, _this.sleepTimerMode) || other.sleepTimerMode == _this.sleepTimerMode)&&(identical(other.volume, _this.volume) || other.volume == _this.volume)&&(identical(other.equalizerEnabled, _this.equalizerEnabled) || other.equalizerEnabled == _this.equalizerEnabled)&&(identical(other.equalizerAvailable, _this.equalizerAvailable) || other.equalizerAvailable == _this.equalizerAvailable)&&(identical(other.equalizerMinDb, _this.equalizerMinDb) || other.equalizerMinDb == _this.equalizerMinDb)&&(identical(other.equalizerMaxDb, _this.equalizerMaxDb) || other.equalizerMaxDb == _this.equalizerMaxDb)&&const DeepCollectionEquality().equals(other.equalizerBands, _this.equalizerBands)&&(identical(other.skipSilenceEnabled, _this.skipSilenceEnabled) || other.skipSilenceEnabled == _this.skipSilenceEnabled)&&(identical(other.volumeBoostEnabled, _this.volumeBoostEnabled) || other.volumeBoostEnabled == _this.volumeBoostEnabled)&&(identical(other.volumeBoostGainDb, _this.volumeBoostGainDb) || other.volumeBoostGainDb == _this.volumeBoostGainDb)&&const DeepCollectionEquality().equals(other.chapters, _this.chapters));
}


@override
int get hashCode {
  final _this = this as PlayerState;
  return Object.hashAll([runtimeType,_this.podcast,_this.episode,const DeepCollectionEquality().hash(_this.queue),_this.isPlaying,_this.isBuffering,_this.position,_this.bufferedPosition,_this.duration,_this.speed,_this.sleepTimerRemaining,_this.sleepTimerMode,_this.volume,_this.equalizerEnabled,_this.equalizerAvailable,_this.equalizerMinDb,_this.equalizerMaxDb,const DeepCollectionEquality().hash(_this.equalizerBands),_this.skipSilenceEnabled,_this.volumeBoostEnabled,_this.volumeBoostGainDb,const DeepCollectionEquality().hash(_this.chapters)]);
}

@override
String toString() {
  final _this = this as PlayerState;
  return 'PlayerState(podcast: ${_this.podcast}, episode: ${_this.episode}, queue: ${_this.queue}, isPlaying: ${_this.isPlaying}, isBuffering: ${_this.isBuffering}, position: ${_this.position}, bufferedPosition: ${_this.bufferedPosition}, duration: ${_this.duration}, speed: ${_this.speed}, sleepTimerRemaining: ${_this.sleepTimerRemaining}, sleepTimerMode: ${_this.sleepTimerMode}, volume: ${_this.volume}, equalizerEnabled: ${_this.equalizerEnabled}, equalizerAvailable: ${_this.equalizerAvailable}, equalizerMinDb: ${_this.equalizerMinDb}, equalizerMaxDb: ${_this.equalizerMaxDb}, equalizerBands: ${_this.equalizerBands}, skipSilenceEnabled: ${_this.skipSilenceEnabled}, volumeBoostEnabled: ${_this.volumeBoostEnabled}, volumeBoostGainDb: ${_this.volumeBoostGainDb}, chapters: ${_this.chapters})';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 Podcast? podcast, Episode? episode, List<Episode> queue, bool isPlaying, bool isBuffering, Duration position, Duration bufferedPosition, Duration? duration, double speed, Duration? sleepTimerRemaining, SleepTimerMode sleepTimerMode, double volume, bool equalizerEnabled, bool equalizerAvailable, double equalizerMinDb, double equalizerMaxDb, List<EqualizerBand> equalizerBands, bool skipSilenceEnabled, bool volumeBoostEnabled, double volumeBoostGainDb, List<Chapter> chapters
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
@pragma('vm:prefer-inline') @override $Res call({Object? podcast = freezed,Object? episode = freezed,Object? queue = null,Object? isPlaying = null,Object? isBuffering = null,Object? position = null,Object? bufferedPosition = null,Object? duration = freezed,Object? speed = null,Object? sleepTimerRemaining = freezed,Object? sleepTimerMode = null,Object? volume = null,Object? equalizerEnabled = null,Object? equalizerAvailable = null,Object? equalizerMinDb = null,Object? equalizerMaxDb = null,Object? equalizerBands = null,Object? skipSilenceEnabled = null,Object? volumeBoostEnabled = null,Object? volumeBoostGainDb = null,Object? chapters = null,}) {
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
as Duration?,sleepTimerMode: null == sleepTimerMode ? _self.sleepTimerMode : sleepTimerMode // ignore: cast_nullable_to_non_nullable
as SleepTimerMode,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,equalizerEnabled: null == equalizerEnabled ? _self.equalizerEnabled : equalizerEnabled // ignore: cast_nullable_to_non_nullable
as bool,equalizerAvailable: null == equalizerAvailable ? _self.equalizerAvailable : equalizerAvailable // ignore: cast_nullable_to_non_nullable
as bool,equalizerMinDb: null == equalizerMinDb ? _self.equalizerMinDb : equalizerMinDb // ignore: cast_nullable_to_non_nullable
as double,equalizerMaxDb: null == equalizerMaxDb ? _self.equalizerMaxDb : equalizerMaxDb // ignore: cast_nullable_to_non_nullable
as double,equalizerBands: null == equalizerBands ? _self.equalizerBands : equalizerBands // ignore: cast_nullable_to_non_nullable
as List<EqualizerBand>,skipSilenceEnabled: null == skipSilenceEnabled ? _self.skipSilenceEnabled : skipSilenceEnabled // ignore: cast_nullable_to_non_nullable
as bool,volumeBoostEnabled: null == volumeBoostEnabled ? _self.volumeBoostEnabled : volumeBoostEnabled // ignore: cast_nullable_to_non_nullable
as bool,volumeBoostGainDb: null == volumeBoostGainDb ? _self.volumeBoostGainDb : volumeBoostGainDb // ignore: cast_nullable_to_non_nullable
as double,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Podcast? podcast,  Episode? episode,  List<Episode> queue,  bool isPlaying,  bool isBuffering,  Duration position,  Duration bufferedPosition,  Duration? duration,  double speed,  Duration? sleepTimerRemaining,  SleepTimerMode sleepTimerMode,  double volume,  bool equalizerEnabled,  bool equalizerAvailable,  double equalizerMinDb,  double equalizerMaxDb,  List<EqualizerBand> equalizerBands,  bool skipSilenceEnabled,  bool volumeBoostEnabled,  double volumeBoostGainDb,  List<Chapter> chapters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.podcast,_that.episode,_that.queue,_that.isPlaying,_that.isBuffering,_that.position,_that.bufferedPosition,_that.duration,_that.speed,_that.sleepTimerRemaining,_that.sleepTimerMode,_that.volume,_that.equalizerEnabled,_that.equalizerAvailable,_that.equalizerMinDb,_that.equalizerMaxDb,_that.equalizerBands,_that.skipSilenceEnabled,_that.volumeBoostEnabled,_that.volumeBoostGainDb,_that.chapters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Podcast? podcast,  Episode? episode,  List<Episode> queue,  bool isPlaying,  bool isBuffering,  Duration position,  Duration bufferedPosition,  Duration? duration,  double speed,  Duration? sleepTimerRemaining,  SleepTimerMode sleepTimerMode,  double volume,  bool equalizerEnabled,  bool equalizerAvailable,  double equalizerMinDb,  double equalizerMaxDb,  List<EqualizerBand> equalizerBands,  bool skipSilenceEnabled,  bool volumeBoostEnabled,  double volumeBoostGainDb,  List<Chapter> chapters)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.podcast,_that.episode,_that.queue,_that.isPlaying,_that.isBuffering,_that.position,_that.bufferedPosition,_that.duration,_that.speed,_that.sleepTimerRemaining,_that.sleepTimerMode,_that.volume,_that.equalizerEnabled,_that.equalizerAvailable,_that.equalizerMinDb,_that.equalizerMaxDb,_that.equalizerBands,_that.skipSilenceEnabled,_that.volumeBoostEnabled,_that.volumeBoostGainDb,_that.chapters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Podcast? podcast,  Episode? episode,  List<Episode> queue,  bool isPlaying,  bool isBuffering,  Duration position,  Duration bufferedPosition,  Duration? duration,  double speed,  Duration? sleepTimerRemaining,  SleepTimerMode sleepTimerMode,  double volume,  bool equalizerEnabled,  bool equalizerAvailable,  double equalizerMinDb,  double equalizerMaxDb,  List<EqualizerBand> equalizerBands,  bool skipSilenceEnabled,  bool volumeBoostEnabled,  double volumeBoostGainDb,  List<Chapter> chapters)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.podcast,_that.episode,_that.queue,_that.isPlaying,_that.isBuffering,_that.position,_that.bufferedPosition,_that.duration,_that.speed,_that.sleepTimerRemaining,_that.sleepTimerMode,_that.volume,_that.equalizerEnabled,_that.equalizerAvailable,_that.equalizerMinDb,_that.equalizerMaxDb,_that.equalizerBands,_that.skipSilenceEnabled,_that.volumeBoostEnabled,_that.volumeBoostGainDb,_that.chapters);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerState extends PlayerState {
  const _PlayerState({this.podcast, this.episode,  List<Episode> queue = const <Episode>[], this.isPlaying = false, this.isBuffering = false, this.position = Duration.zero, this.bufferedPosition = Duration.zero, this.duration, this.speed = 1.0, this.sleepTimerRemaining, this.sleepTimerMode = SleepTimerMode.off, this.volume = 1.0, this.equalizerEnabled = false, this.equalizerAvailable = false, this.equalizerMinDb = 0.0, this.equalizerMaxDb = 0.0,  List<EqualizerBand> equalizerBands = const <EqualizerBand>[], this.skipSilenceEnabled = false, this.volumeBoostEnabled = false, this.volumeBoostGainDb = 0.0,  List<Chapter> chapters = const <Chapter>[]}): _queue = queue,_equalizerBands = equalizerBands,_chapters = chapters,super._();
  

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
@override@JsonKey() final  SleepTimerMode sleepTimerMode;
@override@JsonKey() final  double volume;
@override@JsonKey() final  bool equalizerEnabled;
@override@JsonKey() final  bool equalizerAvailable;
@override@JsonKey() final  double equalizerMinDb;
@override@JsonKey() final  double equalizerMaxDb;
 final  List<EqualizerBand> _equalizerBands;
@override@JsonKey() List<EqualizerBand> get equalizerBands {
  if (_equalizerBands is EqualUnmodifiableListView) return _equalizerBands;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_equalizerBands);
}

@override@JsonKey() final  bool skipSilenceEnabled;
@override@JsonKey() final  bool volumeBoostEnabled;
@override@JsonKey() final  double volumeBoostGainDb;
 final  List<Chapter> _chapters;
@override@JsonKey() List<Chapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.podcast, podcast) || other.podcast == podcast)&&(identical(other.episode, episode) || other.episode == episode)&&const DeepCollectionEquality().equals(other.queue, _queue)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.position, position) || other.position == position)&&(identical(other.bufferedPosition, bufferedPosition) || other.bufferedPosition == bufferedPosition)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.sleepTimerRemaining, sleepTimerRemaining) || other.sleepTimerRemaining == sleepTimerRemaining)&&(identical(other.sleepTimerMode, sleepTimerMode) || other.sleepTimerMode == sleepTimerMode)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.equalizerEnabled, equalizerEnabled) || other.equalizerEnabled == equalizerEnabled)&&(identical(other.equalizerAvailable, equalizerAvailable) || other.equalizerAvailable == equalizerAvailable)&&(identical(other.equalizerMinDb, equalizerMinDb) || other.equalizerMinDb == equalizerMinDb)&&(identical(other.equalizerMaxDb, equalizerMaxDb) || other.equalizerMaxDb == equalizerMaxDb)&&const DeepCollectionEquality().equals(other.equalizerBands, _equalizerBands)&&(identical(other.skipSilenceEnabled, skipSilenceEnabled) || other.skipSilenceEnabled == skipSilenceEnabled)&&(identical(other.volumeBoostEnabled, volumeBoostEnabled) || other.volumeBoostEnabled == volumeBoostEnabled)&&(identical(other.volumeBoostGainDb, volumeBoostGainDb) || other.volumeBoostGainDb == volumeBoostGainDb)&&const DeepCollectionEquality().equals(other.chapters, _chapters));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,podcast,episode,const DeepCollectionEquality().hash(_queue),isPlaying,isBuffering,position,bufferedPosition,duration,speed,sleepTimerRemaining,sleepTimerMode,volume,equalizerEnabled,equalizerAvailable,equalizerMinDb,equalizerMaxDb,const DeepCollectionEquality().hash(_equalizerBands),skipSilenceEnabled,volumeBoostEnabled,volumeBoostGainDb,const DeepCollectionEquality().hash(_chapters)]);
}

@override
String toString() {
    return 'PlayerState(podcast: $podcast, episode: $episode, queue: $queue, isPlaying: $isPlaying, isBuffering: $isBuffering, position: $position, bufferedPosition: $bufferedPosition, duration: $duration, speed: $speed, sleepTimerRemaining: $sleepTimerRemaining, sleepTimerMode: $sleepTimerMode, volume: $volume, equalizerEnabled: $equalizerEnabled, equalizerAvailable: $equalizerAvailable, equalizerMinDb: $equalizerMinDb, equalizerMaxDb: $equalizerMaxDb, equalizerBands: $equalizerBands, skipSilenceEnabled: $skipSilenceEnabled, volumeBoostEnabled: $volumeBoostEnabled, volumeBoostGainDb: $volumeBoostGainDb, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 Podcast? podcast, Episode? episode, List<Episode> queue, bool isPlaying, bool isBuffering, Duration position, Duration bufferedPosition, Duration? duration, double speed, Duration? sleepTimerRemaining, SleepTimerMode sleepTimerMode, double volume, bool equalizerEnabled, bool equalizerAvailable, double equalizerMinDb, double equalizerMaxDb, List<EqualizerBand> equalizerBands, bool skipSilenceEnabled, bool volumeBoostEnabled, double volumeBoostGainDb, List<Chapter> chapters
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
@override @pragma('vm:prefer-inline') $Res call({Object? podcast = freezed,Object? episode = freezed,Object? queue = null,Object? isPlaying = null,Object? isBuffering = null,Object? position = null,Object? bufferedPosition = null,Object? duration = freezed,Object? speed = null,Object? sleepTimerRemaining = freezed,Object? sleepTimerMode = null,Object? volume = null,Object? equalizerEnabled = null,Object? equalizerAvailable = null,Object? equalizerMinDb = null,Object? equalizerMaxDb = null,Object? equalizerBands = null,Object? skipSilenceEnabled = null,Object? volumeBoostEnabled = null,Object? volumeBoostGainDb = null,Object? chapters = null,}) {
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
as Duration?,sleepTimerMode: null == sleepTimerMode ? _self.sleepTimerMode : sleepTimerMode // ignore: cast_nullable_to_non_nullable
as SleepTimerMode,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,equalizerEnabled: null == equalizerEnabled ? _self.equalizerEnabled : equalizerEnabled // ignore: cast_nullable_to_non_nullable
as bool,equalizerAvailable: null == equalizerAvailable ? _self.equalizerAvailable : equalizerAvailable // ignore: cast_nullable_to_non_nullable
as bool,equalizerMinDb: null == equalizerMinDb ? _self.equalizerMinDb : equalizerMinDb // ignore: cast_nullable_to_non_nullable
as double,equalizerMaxDb: null == equalizerMaxDb ? _self.equalizerMaxDb : equalizerMaxDb // ignore: cast_nullable_to_non_nullable
as double,equalizerBands: null == equalizerBands ? _self._equalizerBands : equalizerBands // ignore: cast_nullable_to_non_nullable
as List<EqualizerBand>,skipSilenceEnabled: null == skipSilenceEnabled ? _self.skipSilenceEnabled : skipSilenceEnabled // ignore: cast_nullable_to_non_nullable
as bool,volumeBoostEnabled: null == volumeBoostEnabled ? _self.volumeBoostEnabled : volumeBoostEnabled // ignore: cast_nullable_to_non_nullable
as bool,volumeBoostGainDb: null == volumeBoostGainDb ? _self.volumeBoostGainDb : volumeBoostGainDb // ignore: cast_nullable_to_non_nullable
as double,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,
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
