// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode_list_controls.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EpisodeListControlsState {

 String get query; EpisodeFilter get filter; EpisodeSort get sort; bool get showArchived;
/// Create a copy of EpisodeListControlsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeListControlsStateCopyWith<EpisodeListControlsState> get copyWith => _$EpisodeListControlsStateCopyWithImpl<EpisodeListControlsState>(this as EpisodeListControlsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EpisodeListControlsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodeListControlsState&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.filter, _this.filter) || other.filter == _this.filter)&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.showArchived, _this.showArchived) || other.showArchived == _this.showArchived));
}


@override
int get hashCode {
  final _this = this as EpisodeListControlsState;
  return Object.hash(runtimeType,_this.query,_this.filter,_this.sort,_this.showArchived);
}

@override
String toString() {
  final _this = this as EpisodeListControlsState;
  return 'EpisodeListControlsState(query: ${_this.query}, filter: ${_this.filter}, sort: ${_this.sort}, showArchived: ${_this.showArchived})';
}


}

/// @nodoc
abstract mixin class $EpisodeListControlsStateCopyWith<$Res>  {
  factory $EpisodeListControlsStateCopyWith(EpisodeListControlsState value, $Res Function(EpisodeListControlsState) _then) = _$EpisodeListControlsStateCopyWithImpl;
@useResult
$Res call({
 String query, EpisodeFilter filter, EpisodeSort sort, bool showArchived
});




}
/// @nodoc
class _$EpisodeListControlsStateCopyWithImpl<$Res>
    implements $EpisodeListControlsStateCopyWith<$Res> {
  _$EpisodeListControlsStateCopyWithImpl(this._self, this._then);

  final EpisodeListControlsState _self;
  final $Res Function(EpisodeListControlsState) _then;

/// Create a copy of EpisodeListControlsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? filter = null,Object? sort = null,Object? showArchived = null,}) {
  return _then(EpisodeListControlsState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as EpisodeFilter,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as EpisodeSort,showArchived: null == showArchived ? _self.showArchived : showArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EpisodeListControlsState].
extension EpisodeListControlsStatePatterns on EpisodeListControlsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpisodeListControlsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpisodeListControlsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpisodeListControlsState value)  $default,){
final _that = this;
switch (_that) {
case _EpisodeListControlsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpisodeListControlsState value)?  $default,){
final _that = this;
switch (_that) {
case _EpisodeListControlsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  EpisodeFilter filter,  EpisodeSort sort,  bool showArchived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpisodeListControlsState() when $default != null:
return $default(_that.query,_that.filter,_that.sort,_that.showArchived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  EpisodeFilter filter,  EpisodeSort sort,  bool showArchived)  $default,) {final _that = this;
switch (_that) {
case _EpisodeListControlsState():
return $default(_that.query,_that.filter,_that.sort,_that.showArchived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  EpisodeFilter filter,  EpisodeSort sort,  bool showArchived)?  $default,) {final _that = this;
switch (_that) {
case _EpisodeListControlsState() when $default != null:
return $default(_that.query,_that.filter,_that.sort,_that.showArchived);case _:
  return null;

}
}

}

/// @nodoc


class _EpisodeListControlsState implements EpisodeListControlsState {
  const _EpisodeListControlsState({this.query = '', this.filter = EpisodeFilter.todos, this.sort = EpisodeSort.recentes, this.showArchived = false});
  

@override@JsonKey() final  String query;
@override@JsonKey() final  EpisodeFilter filter;
@override@JsonKey() final  EpisodeSort sort;
@override@JsonKey() final  bool showArchived;

/// Create a copy of EpisodeListControlsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeListControlsStateCopyWith<_EpisodeListControlsState> get copyWith => __$EpisodeListControlsStateCopyWithImpl<_EpisodeListControlsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeListControlsState&&(identical(other.query, query) || other.query == query)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.showArchived, showArchived) || other.showArchived == showArchived));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,filter,sort,showArchived);
}

@override
String toString() {
    return 'EpisodeListControlsState(query: $query, filter: $filter, sort: $sort, showArchived: $showArchived)';
}


}

/// @nodoc
abstract mixin class _$EpisodeListControlsStateCopyWith<$Res> implements $EpisodeListControlsStateCopyWith<$Res> {
  factory _$EpisodeListControlsStateCopyWith(_EpisodeListControlsState value, $Res Function(_EpisodeListControlsState) _then) = __$EpisodeListControlsStateCopyWithImpl;
@override @useResult
$Res call({
 String query, EpisodeFilter filter, EpisodeSort sort, bool showArchived
});




}
/// @nodoc
class __$EpisodeListControlsStateCopyWithImpl<$Res>
    implements _$EpisodeListControlsStateCopyWith<$Res> {
  __$EpisodeListControlsStateCopyWithImpl(this._self, this._then);

  final _EpisodeListControlsState _self;
  final $Res Function(_EpisodeListControlsState) _then;

/// Create a copy of EpisodeListControlsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? filter = null,Object? sort = null,Object? showArchived = null,}) {
  return _then(_EpisodeListControlsState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as EpisodeFilter,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as EpisodeSort,showArchived: null == showArchived ? _self.showArchived : showArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
