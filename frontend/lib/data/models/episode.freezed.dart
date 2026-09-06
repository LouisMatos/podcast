// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Episode {

 String get guid; String get title; String get audioUrl; String? get description; String? get imageUrl; Duration? get duration; DateTime? get publishedAt;
/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeCopyWith<Episode> get copyWith => _$EpisodeCopyWithImpl<Episode>(this as Episode, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Episode;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Episode&&(identical(other.guid, _this.guid) || other.guid == _this.guid)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.audioUrl, _this.audioUrl) || other.audioUrl == _this.audioUrl)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt));
}


@override
int get hashCode {
  final _this = this as Episode;
  return Object.hash(runtimeType,_this.guid,_this.title,_this.audioUrl,_this.description,_this.imageUrl,_this.duration,_this.publishedAt);
}

@override
String toString() {
  final _this = this as Episode;
  return 'Episode(guid: ${_this.guid}, title: ${_this.title}, audioUrl: ${_this.audioUrl}, description: ${_this.description}, imageUrl: ${_this.imageUrl}, duration: ${_this.duration}, publishedAt: ${_this.publishedAt})';
}


}

/// @nodoc
abstract mixin class $EpisodeCopyWith<$Res>  {
  factory $EpisodeCopyWith(Episode value, $Res Function(Episode) _then) = _$EpisodeCopyWithImpl;
@useResult
$Res call({
 String guid, String title, String audioUrl, String? description, String? imageUrl, Duration? duration, DateTime? publishedAt
});




}
/// @nodoc
class _$EpisodeCopyWithImpl<$Res>
    implements $EpisodeCopyWith<$Res> {
  _$EpisodeCopyWithImpl(this._self, this._then);

  final Episode _self;
  final $Res Function(Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? guid = null,Object? title = null,Object? audioUrl = null,Object? description = freezed,Object? imageUrl = freezed,Object? duration = freezed,Object? publishedAt = freezed,}) {
  return _then(Episode(
guid: null == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Episode].
extension EpisodePatterns on Episode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Episode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Episode value)  $default,){
final _that = this;
switch (_that) {
case _Episode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Episode value)?  $default,){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String guid,  String title,  String audioUrl,  String? description,  String? imageUrl,  Duration? duration,  DateTime? publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.guid,_that.title,_that.audioUrl,_that.description,_that.imageUrl,_that.duration,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String guid,  String title,  String audioUrl,  String? description,  String? imageUrl,  Duration? duration,  DateTime? publishedAt)  $default,) {final _that = this;
switch (_that) {
case _Episode():
return $default(_that.guid,_that.title,_that.audioUrl,_that.description,_that.imageUrl,_that.duration,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String guid,  String title,  String audioUrl,  String? description,  String? imageUrl,  Duration? duration,  DateTime? publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.guid,_that.title,_that.audioUrl,_that.description,_that.imageUrl,_that.duration,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Episode implements Episode {
  const _Episode({required this.guid, required this.title, required this.audioUrl, this.description, this.imageUrl, this.duration, this.publishedAt});
  

@override final  String guid;
@override final  String title;
@override final  String audioUrl;
@override final  String? description;
@override final  String? imageUrl;
@override final  Duration? duration;
@override final  DateTime? publishedAt;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeCopyWith<_Episode> get copyWith => __$EpisodeCopyWithImpl<_Episode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Episode&&(identical(other.guid, guid) || other.guid == guid)&&(identical(other.title, title) || other.title == title)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,guid,title,audioUrl,description,imageUrl,duration,publishedAt);
}

@override
String toString() {
    return 'Episode(guid: $guid, title: $title, audioUrl: $audioUrl, description: $description, imageUrl: $imageUrl, duration: $duration, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$EpisodeCopyWith<$Res> implements $EpisodeCopyWith<$Res> {
  factory _$EpisodeCopyWith(_Episode value, $Res Function(_Episode) _then) = __$EpisodeCopyWithImpl;
@override @useResult
$Res call({
 String guid, String title, String audioUrl, String? description, String? imageUrl, Duration? duration, DateTime? publishedAt
});




}
/// @nodoc
class __$EpisodeCopyWithImpl<$Res>
    implements _$EpisodeCopyWith<$Res> {
  __$EpisodeCopyWithImpl(this._self, this._then);

  final _Episode _self;
  final $Res Function(_Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? guid = null,Object? title = null,Object? audioUrl = null,Object? description = freezed,Object? imageUrl = freezed,Object? duration = freezed,Object? publishedAt = freezed,}) {
  return _then(_Episode(
guid: null == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
