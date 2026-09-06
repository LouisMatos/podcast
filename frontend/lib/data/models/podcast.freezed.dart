// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Podcast {

 int get id; String get title; String get author; String get feedUrl; String? get artworkUrl; String? get genre; int get episodeCount;
/// Create a copy of Podcast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastCopyWith<Podcast> get copyWith => _$PodcastCopyWithImpl<Podcast>(this as Podcast, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Podcast;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Podcast&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.feedUrl, _this.feedUrl) || other.feedUrl == _this.feedUrl)&&(identical(other.artworkUrl, _this.artworkUrl) || other.artworkUrl == _this.artworkUrl)&&(identical(other.genre, _this.genre) || other.genre == _this.genre)&&(identical(other.episodeCount, _this.episodeCount) || other.episodeCount == _this.episodeCount));
}


@override
int get hashCode {
  final _this = this as Podcast;
  return Object.hash(runtimeType,_this.id,_this.title,_this.author,_this.feedUrl,_this.artworkUrl,_this.genre,_this.episodeCount);
}

@override
String toString() {
  final _this = this as Podcast;
  return 'Podcast(id: ${_this.id}, title: ${_this.title}, author: ${_this.author}, feedUrl: ${_this.feedUrl}, artworkUrl: ${_this.artworkUrl}, genre: ${_this.genre}, episodeCount: ${_this.episodeCount})';
}


}

/// @nodoc
abstract mixin class $PodcastCopyWith<$Res>  {
  factory $PodcastCopyWith(Podcast value, $Res Function(Podcast) _then) = _$PodcastCopyWithImpl;
@useResult
$Res call({
 int id, String title, String author, String feedUrl, String? artworkUrl, String? genre, int episodeCount
});




}
/// @nodoc
class _$PodcastCopyWithImpl<$Res>
    implements $PodcastCopyWith<$Res> {
  _$PodcastCopyWithImpl(this._self, this._then);

  final Podcast _self;
  final $Res Function(Podcast) _then;

/// Create a copy of Podcast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? author = null,Object? feedUrl = null,Object? artworkUrl = freezed,Object? genre = freezed,Object? episodeCount = null,}) {
  return _then(Podcast(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,feedUrl: null == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Podcast].
extension PodcastPatterns on Podcast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Podcast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Podcast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Podcast value)  $default,){
final _that = this;
switch (_that) {
case _Podcast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Podcast value)?  $default,){
final _that = this;
switch (_that) {
case _Podcast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String author,  String feedUrl,  String? artworkUrl,  String? genre,  int episodeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Podcast() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.feedUrl,_that.artworkUrl,_that.genre,_that.episodeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String author,  String feedUrl,  String? artworkUrl,  String? genre,  int episodeCount)  $default,) {final _that = this;
switch (_that) {
case _Podcast():
return $default(_that.id,_that.title,_that.author,_that.feedUrl,_that.artworkUrl,_that.genre,_that.episodeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String author,  String feedUrl,  String? artworkUrl,  String? genre,  int episodeCount)?  $default,) {final _that = this;
switch (_that) {
case _Podcast() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.feedUrl,_that.artworkUrl,_that.genre,_that.episodeCount);case _:
  return null;

}
}

}

/// @nodoc


class _Podcast implements Podcast {
  const _Podcast({required this.id, required this.title, required this.author, required this.feedUrl, this.artworkUrl, this.genre, this.episodeCount = 0});
  

@override final  int id;
@override final  String title;
@override final  String author;
@override final  String feedUrl;
@override final  String? artworkUrl;
@override final  String? genre;
@override@JsonKey() final  int episodeCount;

/// Create a copy of Podcast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastCopyWith<_Podcast> get copyWith => __$PodcastCopyWithImpl<_Podcast>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Podcast&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.artworkUrl, artworkUrl) || other.artworkUrl == artworkUrl)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,author,feedUrl,artworkUrl,genre,episodeCount);
}

@override
String toString() {
    return 'Podcast(id: $id, title: $title, author: $author, feedUrl: $feedUrl, artworkUrl: $artworkUrl, genre: $genre, episodeCount: $episodeCount)';
}


}

/// @nodoc
abstract mixin class _$PodcastCopyWith<$Res> implements $PodcastCopyWith<$Res> {
  factory _$PodcastCopyWith(_Podcast value, $Res Function(_Podcast) _then) = __$PodcastCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String author, String feedUrl, String? artworkUrl, String? genre, int episodeCount
});




}
/// @nodoc
class __$PodcastCopyWithImpl<$Res>
    implements _$PodcastCopyWith<$Res> {
  __$PodcastCopyWithImpl(this._self, this._then);

  final _Podcast _self;
  final $Res Function(_Podcast) _then;

/// Create a copy of Podcast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? author = null,Object? feedUrl = null,Object? artworkUrl = freezed,Object? genre = freezed,Object? episodeCount = null,}) {
  return _then(_Podcast(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,feedUrl: null == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
