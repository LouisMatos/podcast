// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_controls.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibraryControlsState {

 String get filter; LibrarySort get sort; bool get grid;
/// Create a copy of LibraryControlsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryControlsStateCopyWith<LibraryControlsState> get copyWith => _$LibraryControlsStateCopyWithImpl<LibraryControlsState>(this as LibraryControlsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LibraryControlsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryControlsState&&(identical(other.filter, _this.filter) || other.filter == _this.filter)&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.grid, _this.grid) || other.grid == _this.grid));
}


@override
int get hashCode {
  final _this = this as LibraryControlsState;
  return Object.hash(runtimeType,_this.filter,_this.sort,_this.grid);
}

@override
String toString() {
  final _this = this as LibraryControlsState;
  return 'LibraryControlsState(filter: ${_this.filter}, sort: ${_this.sort}, grid: ${_this.grid})';
}


}

/// @nodoc
abstract mixin class $LibraryControlsStateCopyWith<$Res>  {
  factory $LibraryControlsStateCopyWith(LibraryControlsState value, $Res Function(LibraryControlsState) _then) = _$LibraryControlsStateCopyWithImpl;
@useResult
$Res call({
 String filter, LibrarySort sort, bool grid
});




}
/// @nodoc
class _$LibraryControlsStateCopyWithImpl<$Res>
    implements $LibraryControlsStateCopyWith<$Res> {
  _$LibraryControlsStateCopyWithImpl(this._self, this._then);

  final LibraryControlsState _self;
  final $Res Function(LibraryControlsState) _then;

/// Create a copy of LibraryControlsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filter = null,Object? sort = null,Object? grid = null,}) {
  return _then(LibraryControlsState(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as LibrarySort,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryControlsState].
extension LibraryControlsStatePatterns on LibraryControlsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryControlsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryControlsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryControlsState value)  $default,){
final _that = this;
switch (_that) {
case _LibraryControlsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryControlsState value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryControlsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String filter,  LibrarySort sort,  bool grid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryControlsState() when $default != null:
return $default(_that.filter,_that.sort,_that.grid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String filter,  LibrarySort sort,  bool grid)  $default,) {final _that = this;
switch (_that) {
case _LibraryControlsState():
return $default(_that.filter,_that.sort,_that.grid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String filter,  LibrarySort sort,  bool grid)?  $default,) {final _that = this;
switch (_that) {
case _LibraryControlsState() when $default != null:
return $default(_that.filter,_that.sort,_that.grid);case _:
  return null;

}
}

}

/// @nodoc


class _LibraryControlsState implements LibraryControlsState {
  const _LibraryControlsState({this.filter = '', this.sort = LibrarySort.recentes, this.grid = false});
  

@override@JsonKey() final  String filter;
@override@JsonKey() final  LibrarySort sort;
@override@JsonKey() final  bool grid;

/// Create a copy of LibraryControlsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryControlsStateCopyWith<_LibraryControlsState> get copyWith => __$LibraryControlsStateCopyWithImpl<_LibraryControlsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryControlsState&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.grid, grid) || other.grid == grid));
}


@override
int get hashCode {
    return Object.hash(runtimeType,filter,sort,grid);
}

@override
String toString() {
    return 'LibraryControlsState(filter: $filter, sort: $sort, grid: $grid)';
}


}

/// @nodoc
abstract mixin class _$LibraryControlsStateCopyWith<$Res> implements $LibraryControlsStateCopyWith<$Res> {
  factory _$LibraryControlsStateCopyWith(_LibraryControlsState value, $Res Function(_LibraryControlsState) _then) = __$LibraryControlsStateCopyWithImpl;
@override @useResult
$Res call({
 String filter, LibrarySort sort, bool grid
});




}
/// @nodoc
class __$LibraryControlsStateCopyWithImpl<$Res>
    implements _$LibraryControlsStateCopyWith<$Res> {
  __$LibraryControlsStateCopyWithImpl(this._self, this._then);

  final _LibraryControlsState _self;
  final $Res Function(_LibraryControlsState) _then;

/// Create a copy of LibraryControlsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filter = null,Object? sort = null,Object? grid = null,}) {
  return _then(_LibraryControlsState(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as LibrarySort,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
