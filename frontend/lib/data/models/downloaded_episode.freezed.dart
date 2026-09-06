// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloaded_episode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadedEpisode {

 int get podcastId; String get episodeGuid; String get episodeTitle; String get podcastTitle; String? get artworkUrl; String? get localPath; DownloadStatus get status; int get progress;
/// Create a copy of DownloadedEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadedEpisodeCopyWith<DownloadedEpisode> get copyWith => _$DownloadedEpisodeCopyWithImpl<DownloadedEpisode>(this as DownloadedEpisode, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DownloadedEpisode;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadedEpisode&&(identical(other.podcastId, _this.podcastId) || other.podcastId == _this.podcastId)&&(identical(other.episodeGuid, _this.episodeGuid) || other.episodeGuid == _this.episodeGuid)&&(identical(other.episodeTitle, _this.episodeTitle) || other.episodeTitle == _this.episodeTitle)&&(identical(other.podcastTitle, _this.podcastTitle) || other.podcastTitle == _this.podcastTitle)&&(identical(other.artworkUrl, _this.artworkUrl) || other.artworkUrl == _this.artworkUrl)&&(identical(other.localPath, _this.localPath) || other.localPath == _this.localPath)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.progress, _this.progress) || other.progress == _this.progress));
}


@override
int get hashCode {
  final _this = this as DownloadedEpisode;
  return Object.hash(runtimeType,_this.podcastId,_this.episodeGuid,_this.episodeTitle,_this.podcastTitle,_this.artworkUrl,_this.localPath,_this.status,_this.progress);
}

@override
String toString() {
  final _this = this as DownloadedEpisode;
  return 'DownloadedEpisode(podcastId: ${_this.podcastId}, episodeGuid: ${_this.episodeGuid}, episodeTitle: ${_this.episodeTitle}, podcastTitle: ${_this.podcastTitle}, artworkUrl: ${_this.artworkUrl}, localPath: ${_this.localPath}, status: ${_this.status}, progress: ${_this.progress})';
}


}

/// @nodoc
abstract mixin class $DownloadedEpisodeCopyWith<$Res>  {
  factory $DownloadedEpisodeCopyWith(DownloadedEpisode value, $Res Function(DownloadedEpisode) _then) = _$DownloadedEpisodeCopyWithImpl;
@useResult
$Res call({
 int podcastId, String episodeGuid, String episodeTitle, String podcastTitle, String? artworkUrl, String? localPath, DownloadStatus status, int progress
});




}
/// @nodoc
class _$DownloadedEpisodeCopyWithImpl<$Res>
    implements $DownloadedEpisodeCopyWith<$Res> {
  _$DownloadedEpisodeCopyWithImpl(this._self, this._then);

  final DownloadedEpisode _self;
  final $Res Function(DownloadedEpisode) _then;

/// Create a copy of DownloadedEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcastId = null,Object? episodeGuid = null,Object? episodeTitle = null,Object? podcastTitle = null,Object? artworkUrl = freezed,Object? localPath = freezed,Object? status = null,Object? progress = null,}) {
  return _then(DownloadedEpisode(
podcastId: null == podcastId ? _self.podcastId : podcastId // ignore: cast_nullable_to_non_nullable
as int,episodeGuid: null == episodeGuid ? _self.episodeGuid : episodeGuid // ignore: cast_nullable_to_non_nullable
as String,episodeTitle: null == episodeTitle ? _self.episodeTitle : episodeTitle // ignore: cast_nullable_to_non_nullable
as String,podcastTitle: null == podcastTitle ? _self.podcastTitle : podcastTitle // ignore: cast_nullable_to_non_nullable
as String,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadedEpisode].
extension DownloadedEpisodePatterns on DownloadedEpisode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadedEpisode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadedEpisode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadedEpisode value)  $default,){
final _that = this;
switch (_that) {
case _DownloadedEpisode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadedEpisode value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadedEpisode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int podcastId,  String episodeGuid,  String episodeTitle,  String podcastTitle,  String? artworkUrl,  String? localPath,  DownloadStatus status,  int progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadedEpisode() when $default != null:
return $default(_that.podcastId,_that.episodeGuid,_that.episodeTitle,_that.podcastTitle,_that.artworkUrl,_that.localPath,_that.status,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int podcastId,  String episodeGuid,  String episodeTitle,  String podcastTitle,  String? artworkUrl,  String? localPath,  DownloadStatus status,  int progress)  $default,) {final _that = this;
switch (_that) {
case _DownloadedEpisode():
return $default(_that.podcastId,_that.episodeGuid,_that.episodeTitle,_that.podcastTitle,_that.artworkUrl,_that.localPath,_that.status,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int podcastId,  String episodeGuid,  String episodeTitle,  String podcastTitle,  String? artworkUrl,  String? localPath,  DownloadStatus status,  int progress)?  $default,) {final _that = this;
switch (_that) {
case _DownloadedEpisode() when $default != null:
return $default(_that.podcastId,_that.episodeGuid,_that.episodeTitle,_that.podcastTitle,_that.artworkUrl,_that.localPath,_that.status,_that.progress);case _:
  return null;

}
}

}

/// @nodoc


class _DownloadedEpisode implements DownloadedEpisode {
  const _DownloadedEpisode({required this.podcastId, required this.episodeGuid, required this.episodeTitle, required this.podcastTitle, this.artworkUrl, this.localPath, required this.status, required this.progress});
  

@override final  int podcastId;
@override final  String episodeGuid;
@override final  String episodeTitle;
@override final  String podcastTitle;
@override final  String? artworkUrl;
@override final  String? localPath;
@override final  DownloadStatus status;
@override final  int progress;

/// Create a copy of DownloadedEpisode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadedEpisodeCopyWith<_DownloadedEpisode> get copyWith => __$DownloadedEpisodeCopyWithImpl<_DownloadedEpisode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadedEpisode&&(identical(other.podcastId, podcastId) || other.podcastId == podcastId)&&(identical(other.episodeGuid, episodeGuid) || other.episodeGuid == episodeGuid)&&(identical(other.episodeTitle, episodeTitle) || other.episodeTitle == episodeTitle)&&(identical(other.podcastTitle, podcastTitle) || other.podcastTitle == podcastTitle)&&(identical(other.artworkUrl, artworkUrl) || other.artworkUrl == artworkUrl)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode {
    return Object.hash(runtimeType,podcastId,episodeGuid,episodeTitle,podcastTitle,artworkUrl,localPath,status,progress);
}

@override
String toString() {
    return 'DownloadedEpisode(podcastId: $podcastId, episodeGuid: $episodeGuid, episodeTitle: $episodeTitle, podcastTitle: $podcastTitle, artworkUrl: $artworkUrl, localPath: $localPath, status: $status, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$DownloadedEpisodeCopyWith<$Res> implements $DownloadedEpisodeCopyWith<$Res> {
  factory _$DownloadedEpisodeCopyWith(_DownloadedEpisode value, $Res Function(_DownloadedEpisode) _then) = __$DownloadedEpisodeCopyWithImpl;
@override @useResult
$Res call({
 int podcastId, String episodeGuid, String episodeTitle, String podcastTitle, String? artworkUrl, String? localPath, DownloadStatus status, int progress
});




}
/// @nodoc
class __$DownloadedEpisodeCopyWithImpl<$Res>
    implements _$DownloadedEpisodeCopyWith<$Res> {
  __$DownloadedEpisodeCopyWithImpl(this._self, this._then);

  final _DownloadedEpisode _self;
  final $Res Function(_DownloadedEpisode) _then;

/// Create a copy of DownloadedEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcastId = null,Object? episodeGuid = null,Object? episodeTitle = null,Object? podcastTitle = null,Object? artworkUrl = freezed,Object? localPath = freezed,Object? status = null,Object? progress = null,}) {
  return _then(_DownloadedEpisode(
podcastId: null == podcastId ? _self.podcastId : podcastId // ignore: cast_nullable_to_non_nullable
as int,episodeGuid: null == episodeGuid ? _self.episodeGuid : episodeGuid // ignore: cast_nullable_to_non_nullable
as String,episodeTitle: null == episodeTitle ? _self.episodeTitle : episodeTitle // ignore: cast_nullable_to_non_nullable
as String,podcastTitle: null == podcastTitle ? _self.podcastTitle : podcastTitle // ignore: cast_nullable_to_non_nullable
as String,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
