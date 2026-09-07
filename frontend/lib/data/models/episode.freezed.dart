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

 String get guid; String get title; String get audioUrl; String? get description; String? get imageUrl; Duration? get duration; DateTime? get publishedAt;/// Metadados avançados (Fase 14) — todos opcionais, o feed pode não
/// declarar nenhum.
 int? get seasonNumber; int? get episodeNumber;/// `full` | `trailer` | `bonus`, do `itunes:episodeType`.
 String? get episodeType;/// `<link>` do item — página do episódio no site do podcast.
 String? get link;/// URL do JSON de capítulos (`<podcast:chapters>`).
 String? get chaptersUrl;
/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeCopyWith<Episode> get copyWith => _$EpisodeCopyWithImpl<Episode>(this as Episode, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Episode;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Episode&&(identical(other.guid, _this.guid) || other.guid == _this.guid)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.audioUrl, _this.audioUrl) || other.audioUrl == _this.audioUrl)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt)&&(identical(other.seasonNumber, _this.seasonNumber) || other.seasonNumber == _this.seasonNumber)&&(identical(other.episodeNumber, _this.episodeNumber) || other.episodeNumber == _this.episodeNumber)&&(identical(other.episodeType, _this.episodeType) || other.episodeType == _this.episodeType)&&(identical(other.link, _this.link) || other.link == _this.link)&&(identical(other.chaptersUrl, _this.chaptersUrl) || other.chaptersUrl == _this.chaptersUrl));
}


@override
int get hashCode {
  final _this = this as Episode;
  return Object.hash(runtimeType,_this.guid,_this.title,_this.audioUrl,_this.description,_this.imageUrl,_this.duration,_this.publishedAt,_this.seasonNumber,_this.episodeNumber,_this.episodeType,_this.link,_this.chaptersUrl);
}

@override
String toString() {
  final _this = this as Episode;
  return 'Episode(guid: ${_this.guid}, title: ${_this.title}, audioUrl: ${_this.audioUrl}, description: ${_this.description}, imageUrl: ${_this.imageUrl}, duration: ${_this.duration}, publishedAt: ${_this.publishedAt}, seasonNumber: ${_this.seasonNumber}, episodeNumber: ${_this.episodeNumber}, episodeType: ${_this.episodeType}, link: ${_this.link}, chaptersUrl: ${_this.chaptersUrl})';
}


}

/// @nodoc
abstract mixin class $EpisodeCopyWith<$Res>  {
  factory $EpisodeCopyWith(Episode value, $Res Function(Episode) _then) = _$EpisodeCopyWithImpl;
@useResult
$Res call({
 String guid, String title, String audioUrl, String? description, String? imageUrl, Duration? duration, DateTime? publishedAt, int? seasonNumber, int? episodeNumber, String? episodeType, String? link, String? chaptersUrl
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
@pragma('vm:prefer-inline') @override $Res call({Object? guid = null,Object? title = null,Object? audioUrl = null,Object? description = freezed,Object? imageUrl = freezed,Object? duration = freezed,Object? publishedAt = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? episodeType = freezed,Object? link = freezed,Object? chaptersUrl = freezed,}) {
  return _then(Episode(
guid: null == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeType: freezed == episodeType ? _self.episodeType : episodeType // ignore: cast_nullable_to_non_nullable
as String?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,chaptersUrl: freezed == chaptersUrl ? _self.chaptersUrl : chaptersUrl // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String guid,  String title,  String audioUrl,  String? description,  String? imageUrl,  Duration? duration,  DateTime? publishedAt,  int? seasonNumber,  int? episodeNumber,  String? episodeType,  String? link,  String? chaptersUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.guid,_that.title,_that.audioUrl,_that.description,_that.imageUrl,_that.duration,_that.publishedAt,_that.seasonNumber,_that.episodeNumber,_that.episodeType,_that.link,_that.chaptersUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String guid,  String title,  String audioUrl,  String? description,  String? imageUrl,  Duration? duration,  DateTime? publishedAt,  int? seasonNumber,  int? episodeNumber,  String? episodeType,  String? link,  String? chaptersUrl)  $default,) {final _that = this;
switch (_that) {
case _Episode():
return $default(_that.guid,_that.title,_that.audioUrl,_that.description,_that.imageUrl,_that.duration,_that.publishedAt,_that.seasonNumber,_that.episodeNumber,_that.episodeType,_that.link,_that.chaptersUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String guid,  String title,  String audioUrl,  String? description,  String? imageUrl,  Duration? duration,  DateTime? publishedAt,  int? seasonNumber,  int? episodeNumber,  String? episodeType,  String? link,  String? chaptersUrl)?  $default,) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.guid,_that.title,_that.audioUrl,_that.description,_that.imageUrl,_that.duration,_that.publishedAt,_that.seasonNumber,_that.episodeNumber,_that.episodeType,_that.link,_that.chaptersUrl);case _:
  return null;

}
}

}

/// @nodoc


class _Episode implements Episode {
  const _Episode({required this.guid, required this.title, required this.audioUrl, this.description, this.imageUrl, this.duration, this.publishedAt, this.seasonNumber, this.episodeNumber, this.episodeType, this.link, this.chaptersUrl});
  

@override final  String guid;
@override final  String title;
@override final  String audioUrl;
@override final  String? description;
@override final  String? imageUrl;
@override final  Duration? duration;
@override final  DateTime? publishedAt;
/// Metadados avançados (Fase 14) — todos opcionais, o feed pode não
/// declarar nenhum.
@override final  int? seasonNumber;
@override final  int? episodeNumber;
/// `full` | `trailer` | `bonus`, do `itunes:episodeType`.
@override final  String? episodeType;
/// `<link>` do item — página do episódio no site do podcast.
@override final  String? link;
/// URL do JSON de capítulos (`<podcast:chapters>`).
@override final  String? chaptersUrl;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeCopyWith<_Episode> get copyWith => __$EpisodeCopyWithImpl<_Episode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Episode&&(identical(other.guid, guid) || other.guid == guid)&&(identical(other.title, title) || other.title == title)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.episodeType, episodeType) || other.episodeType == episodeType)&&(identical(other.link, link) || other.link == link)&&(identical(other.chaptersUrl, chaptersUrl) || other.chaptersUrl == chaptersUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,guid,title,audioUrl,description,imageUrl,duration,publishedAt,seasonNumber,episodeNumber,episodeType,link,chaptersUrl);
}

@override
String toString() {
    return 'Episode(guid: $guid, title: $title, audioUrl: $audioUrl, description: $description, imageUrl: $imageUrl, duration: $duration, publishedAt: $publishedAt, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, episodeType: $episodeType, link: $link, chaptersUrl: $chaptersUrl)';
}


}

/// @nodoc
abstract mixin class _$EpisodeCopyWith<$Res> implements $EpisodeCopyWith<$Res> {
  factory _$EpisodeCopyWith(_Episode value, $Res Function(_Episode) _then) = __$EpisodeCopyWithImpl;
@override @useResult
$Res call({
 String guid, String title, String audioUrl, String? description, String? imageUrl, Duration? duration, DateTime? publishedAt, int? seasonNumber, int? episodeNumber, String? episodeType, String? link, String? chaptersUrl
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
@override @pragma('vm:prefer-inline') $Res call({Object? guid = null,Object? title = null,Object? audioUrl = null,Object? description = freezed,Object? imageUrl = freezed,Object? duration = freezed,Object? publishedAt = freezed,Object? seasonNumber = freezed,Object? episodeNumber = freezed,Object? episodeType = freezed,Object? link = freezed,Object? chaptersUrl = freezed,}) {
  return _then(_Episode(
guid: null == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seasonNumber: freezed == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeNumber: freezed == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int?,episodeType: freezed == episodeType ? _self.episodeType : episodeType // ignore: cast_nullable_to_non_nullable
as String?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,chaptersUrl: freezed == chaptersUrl ? _self.chaptersUrl : chaptersUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
