// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radio_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RadioStation {

 String get id; String get name; String get streamUrl; String? get logoUrl; String? get genre; String? get state; String? get programacaoHoje;
/// Create a copy of RadioStation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadioStationCopyWith<RadioStation> get copyWith => _$RadioStationCopyWithImpl<RadioStation>(this as RadioStation, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RadioStation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadioStation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.streamUrl, _this.streamUrl) || other.streamUrl == _this.streamUrl)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&(identical(other.genre, _this.genre) || other.genre == _this.genre)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.programacaoHoje, _this.programacaoHoje) || other.programacaoHoje == _this.programacaoHoje));
}


@override
int get hashCode {
  final _this = this as RadioStation;
  return Object.hash(runtimeType,_this.id,_this.name,_this.streamUrl,_this.logoUrl,_this.genre,_this.state,_this.programacaoHoje);
}

@override
String toString() {
  final _this = this as RadioStation;
  return 'RadioStation(id: ${_this.id}, name: ${_this.name}, streamUrl: ${_this.streamUrl}, logoUrl: ${_this.logoUrl}, genre: ${_this.genre}, state: ${_this.state}, programacaoHoje: ${_this.programacaoHoje})';
}


}

/// @nodoc
abstract mixin class $RadioStationCopyWith<$Res>  {
  factory $RadioStationCopyWith(RadioStation value, $Res Function(RadioStation) _then) = _$RadioStationCopyWithImpl;
@useResult
$Res call({
 String id, String name, String streamUrl, String? logoUrl, String? genre, String? state, String? programacaoHoje
});




}
/// @nodoc
class _$RadioStationCopyWithImpl<$Res>
    implements $RadioStationCopyWith<$Res> {
  _$RadioStationCopyWithImpl(this._self, this._then);

  final RadioStation _self;
  final $Res Function(RadioStation) _then;

/// Create a copy of RadioStation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? streamUrl = null,Object? logoUrl = freezed,Object? genre = freezed,Object? state = freezed,Object? programacaoHoje = freezed,}) {
  return _then(RadioStation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,streamUrl: null == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,programacaoHoje: freezed == programacaoHoje ? _self.programacaoHoje : programacaoHoje // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RadioStation].
extension RadioStationPatterns on RadioStation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadioStation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadioStation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadioStation value)  $default,){
final _that = this;
switch (_that) {
case _RadioStation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadioStation value)?  $default,){
final _that = this;
switch (_that) {
case _RadioStation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String streamUrl,  String? logoUrl,  String? genre,  String? state,  String? programacaoHoje)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadioStation() when $default != null:
return $default(_that.id,_that.name,_that.streamUrl,_that.logoUrl,_that.genre,_that.state,_that.programacaoHoje);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String streamUrl,  String? logoUrl,  String? genre,  String? state,  String? programacaoHoje)  $default,) {final _that = this;
switch (_that) {
case _RadioStation():
return $default(_that.id,_that.name,_that.streamUrl,_that.logoUrl,_that.genre,_that.state,_that.programacaoHoje);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String streamUrl,  String? logoUrl,  String? genre,  String? state,  String? programacaoHoje)?  $default,) {final _that = this;
switch (_that) {
case _RadioStation() when $default != null:
return $default(_that.id,_that.name,_that.streamUrl,_that.logoUrl,_that.genre,_that.state,_that.programacaoHoje);case _:
  return null;

}
}

}

/// @nodoc


class _RadioStation implements RadioStation {
  const _RadioStation({required this.id, required this.name, required this.streamUrl, this.logoUrl, this.genre, this.state, this.programacaoHoje});
  

@override final  String id;
@override final  String name;
@override final  String streamUrl;
@override final  String? logoUrl;
@override final  String? genre;
@override final  String? state;
@override final  String? programacaoHoje;

/// Create a copy of RadioStation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadioStationCopyWith<_RadioStation> get copyWith => __$RadioStationCopyWithImpl<_RadioStation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadioStation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.state, state) || other.state == state)&&(identical(other.programacaoHoje, programacaoHoje) || other.programacaoHoje == programacaoHoje));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,streamUrl,logoUrl,genre,state,programacaoHoje);
}

@override
String toString() {
    return 'RadioStation(id: $id, name: $name, streamUrl: $streamUrl, logoUrl: $logoUrl, genre: $genre, state: $state, programacaoHoje: $programacaoHoje)';
}


}

/// @nodoc
abstract mixin class _$RadioStationCopyWith<$Res> implements $RadioStationCopyWith<$Res> {
  factory _$RadioStationCopyWith(_RadioStation value, $Res Function(_RadioStation) _then) = __$RadioStationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String streamUrl, String? logoUrl, String? genre, String? state, String? programacaoHoje
});




}
/// @nodoc
class __$RadioStationCopyWithImpl<$Res>
    implements _$RadioStationCopyWith<$Res> {
  __$RadioStationCopyWithImpl(this._self, this._then);

  final _RadioStation _self;
  final $Res Function(_RadioStation) _then;

/// Create a copy of RadioStation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? streamUrl = null,Object? logoUrl = freezed,Object? genre = freezed,Object? state = freezed,Object? programacaoHoje = freezed,}) {
  return _then(_RadioStation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,streamUrl: null == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,programacaoHoje: freezed == programacaoHoje ? _self.programacaoHoje : programacaoHoje // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
