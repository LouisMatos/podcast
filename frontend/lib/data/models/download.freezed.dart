// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Download {

 int get podcastId; String get episodeGuid; String? get taskId; String? get localPath; DownloadStatus get status; int get progress;
/// Create a copy of Download
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadCopyWith<Download> get copyWith => _$DownloadCopyWithImpl<Download>(this as Download, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Download;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Download&&(identical(other.podcastId, _this.podcastId) || other.podcastId == _this.podcastId)&&(identical(other.episodeGuid, _this.episodeGuid) || other.episodeGuid == _this.episodeGuid)&&(identical(other.taskId, _this.taskId) || other.taskId == _this.taskId)&&(identical(other.localPath, _this.localPath) || other.localPath == _this.localPath)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.progress, _this.progress) || other.progress == _this.progress));
}


@override
int get hashCode {
  final _this = this as Download;
  return Object.hash(runtimeType,_this.podcastId,_this.episodeGuid,_this.taskId,_this.localPath,_this.status,_this.progress);
}

@override
String toString() {
  final _this = this as Download;
  return 'Download(podcastId: ${_this.podcastId}, episodeGuid: ${_this.episodeGuid}, taskId: ${_this.taskId}, localPath: ${_this.localPath}, status: ${_this.status}, progress: ${_this.progress})';
}


}

/// @nodoc
abstract mixin class $DownloadCopyWith<$Res>  {
  factory $DownloadCopyWith(Download value, $Res Function(Download) _then) = _$DownloadCopyWithImpl;
@useResult
$Res call({
 int podcastId, String episodeGuid, String? taskId, String? localPath, DownloadStatus status, int progress
});




}
/// @nodoc
class _$DownloadCopyWithImpl<$Res>
    implements $DownloadCopyWith<$Res> {
  _$DownloadCopyWithImpl(this._self, this._then);

  final Download _self;
  final $Res Function(Download) _then;

/// Create a copy of Download
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcastId = null,Object? episodeGuid = null,Object? taskId = freezed,Object? localPath = freezed,Object? status = null,Object? progress = null,}) {
  return _then(Download(
podcastId: null == podcastId ? _self.podcastId : podcastId // ignore: cast_nullable_to_non_nullable
as int,episodeGuid: null == episodeGuid ? _self.episodeGuid : episodeGuid // ignore: cast_nullable_to_non_nullable
as String,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Download].
extension DownloadPatterns on Download {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Download value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Download() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Download value)  $default,){
final _that = this;
switch (_that) {
case _Download():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Download value)?  $default,){
final _that = this;
switch (_that) {
case _Download() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int podcastId,  String episodeGuid,  String? taskId,  String? localPath,  DownloadStatus status,  int progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Download() when $default != null:
return $default(_that.podcastId,_that.episodeGuid,_that.taskId,_that.localPath,_that.status,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int podcastId,  String episodeGuid,  String? taskId,  String? localPath,  DownloadStatus status,  int progress)  $default,) {final _that = this;
switch (_that) {
case _Download():
return $default(_that.podcastId,_that.episodeGuid,_that.taskId,_that.localPath,_that.status,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int podcastId,  String episodeGuid,  String? taskId,  String? localPath,  DownloadStatus status,  int progress)?  $default,) {final _that = this;
switch (_that) {
case _Download() when $default != null:
return $default(_that.podcastId,_that.episodeGuid,_that.taskId,_that.localPath,_that.status,_that.progress);case _:
  return null;

}
}

}

/// @nodoc


class _Download implements Download {
  const _Download({required this.podcastId, required this.episodeGuid, this.taskId, this.localPath, this.status = DownloadStatus.queued, this.progress = 0});
  

@override final  int podcastId;
@override final  String episodeGuid;
@override final  String? taskId;
@override final  String? localPath;
@override@JsonKey() final  DownloadStatus status;
@override@JsonKey() final  int progress;

/// Create a copy of Download
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadCopyWith<_Download> get copyWith => __$DownloadCopyWithImpl<_Download>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Download&&(identical(other.podcastId, podcastId) || other.podcastId == podcastId)&&(identical(other.episodeGuid, episodeGuid) || other.episodeGuid == episodeGuid)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode {
    return Object.hash(runtimeType,podcastId,episodeGuid,taskId,localPath,status,progress);
}

@override
String toString() {
    return 'Download(podcastId: $podcastId, episodeGuid: $episodeGuid, taskId: $taskId, localPath: $localPath, status: $status, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$DownloadCopyWith<$Res> implements $DownloadCopyWith<$Res> {
  factory _$DownloadCopyWith(_Download value, $Res Function(_Download) _then) = __$DownloadCopyWithImpl;
@override @useResult
$Res call({
 int podcastId, String episodeGuid, String? taskId, String? localPath, DownloadStatus status, int progress
});




}
/// @nodoc
class __$DownloadCopyWithImpl<$Res>
    implements _$DownloadCopyWith<$Res> {
  __$DownloadCopyWithImpl(this._self, this._then);

  final _Download _self;
  final $Res Function(_Download) _then;

/// Create a copy of Download
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcastId = null,Object? episodeGuid = null,Object? taskId = freezed,Object? localPath = freezed,Object? status = null,Object? progress = null,}) {
  return _then(_Download(
podcastId: null == podcastId ? _self.podcastId : podcastId // ignore: cast_nullable_to_non_nullable
as int,episodeGuid: null == episodeGuid ? _self.episodeGuid : episodeGuid // ignore: cast_nullable_to_non_nullable
as String,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DownloadStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
