// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EpisodeSearchResult {

/// collectionId iTunes do podcast dono.
 int get collectionId; String get collectionName; String? get feedUrl; String? get podcastArtworkUrl; Episode get episode;
/// Create a copy of EpisodeSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeSearchResultCopyWith<EpisodeSearchResult> get copyWith => _$EpisodeSearchResultCopyWithImpl<EpisodeSearchResult>(this as EpisodeSearchResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EpisodeSearchResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodeSearchResult&&(identical(other.collectionId, _this.collectionId) || other.collectionId == _this.collectionId)&&(identical(other.collectionName, _this.collectionName) || other.collectionName == _this.collectionName)&&(identical(other.feedUrl, _this.feedUrl) || other.feedUrl == _this.feedUrl)&&(identical(other.podcastArtworkUrl, _this.podcastArtworkUrl) || other.podcastArtworkUrl == _this.podcastArtworkUrl)&&(identical(other.episode, _this.episode) || other.episode == _this.episode));
}


@override
int get hashCode {
  final _this = this as EpisodeSearchResult;
  return Object.hash(runtimeType,_this.collectionId,_this.collectionName,_this.feedUrl,_this.podcastArtworkUrl,_this.episode);
}

@override
String toString() {
  final _this = this as EpisodeSearchResult;
  return 'EpisodeSearchResult(collectionId: ${_this.collectionId}, collectionName: ${_this.collectionName}, feedUrl: ${_this.feedUrl}, podcastArtworkUrl: ${_this.podcastArtworkUrl}, episode: ${_this.episode})';
}


}

/// @nodoc
abstract mixin class $EpisodeSearchResultCopyWith<$Res>  {
  factory $EpisodeSearchResultCopyWith(EpisodeSearchResult value, $Res Function(EpisodeSearchResult) _then) = _$EpisodeSearchResultCopyWithImpl;
@useResult
$Res call({
 int collectionId, String collectionName, String? feedUrl, String? podcastArtworkUrl, Episode episode
});


$EpisodeCopyWith<$Res> get episode;

}
/// @nodoc
class _$EpisodeSearchResultCopyWithImpl<$Res>
    implements $EpisodeSearchResultCopyWith<$Res> {
  _$EpisodeSearchResultCopyWithImpl(this._self, this._then);

  final EpisodeSearchResult _self;
  final $Res Function(EpisodeSearchResult) _then;

/// Create a copy of EpisodeSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? collectionId = null,Object? collectionName = null,Object? feedUrl = freezed,Object? podcastArtworkUrl = freezed,Object? episode = null,}) {
  return _then(EpisodeSearchResult(
collectionId: null == collectionId ? _self.collectionId : collectionId // ignore: cast_nullable_to_non_nullable
as int,collectionName: null == collectionName ? _self.collectionName : collectionName // ignore: cast_nullable_to_non_nullable
as String,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,podcastArtworkUrl: freezed == podcastArtworkUrl ? _self.podcastArtworkUrl : podcastArtworkUrl // ignore: cast_nullable_to_non_nullable
as String?,episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode,
  ));
}
/// Create a copy of EpisodeSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res> get episode {
  
  return $EpisodeCopyWith<$Res>(_self.episode, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}


/// Adds pattern-matching-related methods to [EpisodeSearchResult].
extension EpisodeSearchResultPatterns on EpisodeSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpisodeSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpisodeSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpisodeSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _EpisodeSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpisodeSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _EpisodeSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int collectionId,  String collectionName,  String? feedUrl,  String? podcastArtworkUrl,  Episode episode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpisodeSearchResult() when $default != null:
return $default(_that.collectionId,_that.collectionName,_that.feedUrl,_that.podcastArtworkUrl,_that.episode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int collectionId,  String collectionName,  String? feedUrl,  String? podcastArtworkUrl,  Episode episode)  $default,) {final _that = this;
switch (_that) {
case _EpisodeSearchResult():
return $default(_that.collectionId,_that.collectionName,_that.feedUrl,_that.podcastArtworkUrl,_that.episode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int collectionId,  String collectionName,  String? feedUrl,  String? podcastArtworkUrl,  Episode episode)?  $default,) {final _that = this;
switch (_that) {
case _EpisodeSearchResult() when $default != null:
return $default(_that.collectionId,_that.collectionName,_that.feedUrl,_that.podcastArtworkUrl,_that.episode);case _:
  return null;

}
}

}

/// @nodoc


class _EpisodeSearchResult implements EpisodeSearchResult {
  const _EpisodeSearchResult({required this.collectionId, required this.collectionName, this.feedUrl, this.podcastArtworkUrl, required this.episode});
  

/// collectionId iTunes do podcast dono.
@override final  int collectionId;
@override final  String collectionName;
@override final  String? feedUrl;
@override final  String? podcastArtworkUrl;
@override final  Episode episode;

/// Create a copy of EpisodeSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeSearchResultCopyWith<_EpisodeSearchResult> get copyWith => __$EpisodeSearchResultCopyWithImpl<_EpisodeSearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeSearchResult&&(identical(other.collectionId, collectionId) || other.collectionId == collectionId)&&(identical(other.collectionName, collectionName) || other.collectionName == collectionName)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.podcastArtworkUrl, podcastArtworkUrl) || other.podcastArtworkUrl == podcastArtworkUrl)&&(identical(other.episode, episode) || other.episode == episode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,collectionId,collectionName,feedUrl,podcastArtworkUrl,episode);
}

@override
String toString() {
    return 'EpisodeSearchResult(collectionId: $collectionId, collectionName: $collectionName, feedUrl: $feedUrl, podcastArtworkUrl: $podcastArtworkUrl, episode: $episode)';
}


}

/// @nodoc
abstract mixin class _$EpisodeSearchResultCopyWith<$Res> implements $EpisodeSearchResultCopyWith<$Res> {
  factory _$EpisodeSearchResultCopyWith(_EpisodeSearchResult value, $Res Function(_EpisodeSearchResult) _then) = __$EpisodeSearchResultCopyWithImpl;
@override @useResult
$Res call({
 int collectionId, String collectionName, String? feedUrl, String? podcastArtworkUrl, Episode episode
});


@override $EpisodeCopyWith<$Res> get episode;

}
/// @nodoc
class __$EpisodeSearchResultCopyWithImpl<$Res>
    implements _$EpisodeSearchResultCopyWith<$Res> {
  __$EpisodeSearchResultCopyWithImpl(this._self, this._then);

  final _EpisodeSearchResult _self;
  final $Res Function(_EpisodeSearchResult) _then;

/// Create a copy of EpisodeSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? collectionId = null,Object? collectionName = null,Object? feedUrl = freezed,Object? podcastArtworkUrl = freezed,Object? episode = null,}) {
  return _then(_EpisodeSearchResult(
collectionId: null == collectionId ? _self.collectionId : collectionId // ignore: cast_nullable_to_non_nullable
as int,collectionName: null == collectionName ? _self.collectionName : collectionName // ignore: cast_nullable_to_non_nullable
as String,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,podcastArtworkUrl: freezed == podcastArtworkUrl ? _self.podcastArtworkUrl : podcastArtworkUrl // ignore: cast_nullable_to_non_nullable
as String?,episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode,
  ));
}

/// Create a copy of EpisodeSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res> get episode {
  
  return $EpisodeCopyWith<$Res>(_self.episode, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}

// dart format on
