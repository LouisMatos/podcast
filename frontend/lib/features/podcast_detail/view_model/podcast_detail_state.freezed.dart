// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PodcastDetailState {

 Podcast get podcast; List<Episode> get episodes;
/// Create a copy of PodcastDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastDetailStateCopyWith<PodcastDetailState> get copyWith => _$PodcastDetailStateCopyWithImpl<PodcastDetailState>(this as PodcastDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PodcastDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastDetailState&&(identical(other.podcast, _this.podcast) || other.podcast == _this.podcast)&&const DeepCollectionEquality().equals(other.episodes, _this.episodes));
}


@override
int get hashCode {
  final _this = this as PodcastDetailState;
  return Object.hash(runtimeType,_this.podcast,const DeepCollectionEquality().hash(_this.episodes));
}

@override
String toString() {
  final _this = this as PodcastDetailState;
  return 'PodcastDetailState(podcast: ${_this.podcast}, episodes: ${_this.episodes})';
}


}

/// @nodoc
abstract mixin class $PodcastDetailStateCopyWith<$Res>  {
  factory $PodcastDetailStateCopyWith(PodcastDetailState value, $Res Function(PodcastDetailState) _then) = _$PodcastDetailStateCopyWithImpl;
@useResult
$Res call({
 Podcast podcast, List<Episode> episodes
});


$PodcastCopyWith<$Res> get podcast;

}
/// @nodoc
class _$PodcastDetailStateCopyWithImpl<$Res>
    implements $PodcastDetailStateCopyWith<$Res> {
  _$PodcastDetailStateCopyWithImpl(this._self, this._then);

  final PodcastDetailState _self;
  final $Res Function(PodcastDetailState) _then;

/// Create a copy of PodcastDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcast = null,Object? episodes = null,}) {
  return _then(PodcastDetailState(
podcast: null == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,
  ));
}
/// Create a copy of PodcastDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastCopyWith<$Res> get podcast {
  
  return $PodcastCopyWith<$Res>(_self.podcast, (value) {
    return _then(_self.copyWith(podcast: value));
  });
}
}


/// Adds pattern-matching-related methods to [PodcastDetailState].
extension PodcastDetailStatePatterns on PodcastDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastDetailState value)  $default,){
final _that = this;
switch (_that) {
case _PodcastDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Podcast podcast,  List<Episode> episodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastDetailState() when $default != null:
return $default(_that.podcast,_that.episodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Podcast podcast,  List<Episode> episodes)  $default,) {final _that = this;
switch (_that) {
case _PodcastDetailState():
return $default(_that.podcast,_that.episodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Podcast podcast,  List<Episode> episodes)?  $default,) {final _that = this;
switch (_that) {
case _PodcastDetailState() when $default != null:
return $default(_that.podcast,_that.episodes);case _:
  return null;

}
}

}

/// @nodoc


class _PodcastDetailState implements PodcastDetailState {
  const _PodcastDetailState({required this.podcast,  List<Episode> episodes = const <Episode>[]}): _episodes = episodes;
  

@override final  Podcast podcast;
 final  List<Episode> _episodes;
@override@JsonKey() List<Episode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}


/// Create a copy of PodcastDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastDetailStateCopyWith<_PodcastDetailState> get copyWith => __$PodcastDetailStateCopyWithImpl<_PodcastDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastDetailState&&(identical(other.podcast, podcast) || other.podcast == podcast)&&const DeepCollectionEquality().equals(other.episodes, _episodes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,podcast,const DeepCollectionEquality().hash(_episodes));
}

@override
String toString() {
    return 'PodcastDetailState(podcast: $podcast, episodes: $episodes)';
}


}

/// @nodoc
abstract mixin class _$PodcastDetailStateCopyWith<$Res> implements $PodcastDetailStateCopyWith<$Res> {
  factory _$PodcastDetailStateCopyWith(_PodcastDetailState value, $Res Function(_PodcastDetailState) _then) = __$PodcastDetailStateCopyWithImpl;
@override @useResult
$Res call({
 Podcast podcast, List<Episode> episodes
});


@override $PodcastCopyWith<$Res> get podcast;

}
/// @nodoc
class __$PodcastDetailStateCopyWithImpl<$Res>
    implements _$PodcastDetailStateCopyWith<$Res> {
  __$PodcastDetailStateCopyWithImpl(this._self, this._then);

  final _PodcastDetailState _self;
  final $Res Function(_PodcastDetailState) _then;

/// Create a copy of PodcastDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcast = null,Object? episodes = null,}) {
  return _then(_PodcastDetailState(
podcast: null == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,
  ));
}

/// Create a copy of PodcastDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastCopyWith<$Res> get podcast {
  
  return $PodcastCopyWith<$Res>(_self.podcast, (value) {
    return _then(_self.copyWith(podcast: value));
  });
}
}

// dart format on
