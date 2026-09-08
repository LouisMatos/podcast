// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listening_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListeningStats {

/// Tempo total ouvido desde sempre.
 Duration get total;/// Tempo ouvido nesta semana (a partir de segunda 00:00 local).
 Duration get thisWeek;/// Dias consecutivos com registro, terminando hoje ou ontem.
 int get streakDays;/// Hoje e os 6 dias anteriores, em ordem cronológica; `listened` 0 nos
/// dias sem registro.
 List<DailyListening> get last7Days;
/// Create a copy of ListeningStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListeningStatsCopyWith<ListeningStats> get copyWith => _$ListeningStatsCopyWithImpl<ListeningStats>(this as ListeningStats, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ListeningStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListeningStats&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.thisWeek, _this.thisWeek) || other.thisWeek == _this.thisWeek)&&(identical(other.streakDays, _this.streakDays) || other.streakDays == _this.streakDays)&&const DeepCollectionEquality().equals(other.last7Days, _this.last7Days));
}


@override
int get hashCode {
  final _this = this as ListeningStats;
  return Object.hash(runtimeType,_this.total,_this.thisWeek,_this.streakDays,const DeepCollectionEquality().hash(_this.last7Days));
}

@override
String toString() {
  final _this = this as ListeningStats;
  return 'ListeningStats(total: ${_this.total}, thisWeek: ${_this.thisWeek}, streakDays: ${_this.streakDays}, last7Days: ${_this.last7Days})';
}


}

/// @nodoc
abstract mixin class $ListeningStatsCopyWith<$Res>  {
  factory $ListeningStatsCopyWith(ListeningStats value, $Res Function(ListeningStats) _then) = _$ListeningStatsCopyWithImpl;
@useResult
$Res call({
 Duration total, Duration thisWeek, int streakDays, List<DailyListening> last7Days
});




}
/// @nodoc
class _$ListeningStatsCopyWithImpl<$Res>
    implements $ListeningStatsCopyWith<$Res> {
  _$ListeningStatsCopyWithImpl(this._self, this._then);

  final ListeningStats _self;
  final $Res Function(ListeningStats) _then;

/// Create a copy of ListeningStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? thisWeek = null,Object? streakDays = null,Object? last7Days = null,}) {
  return _then(ListeningStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Duration,thisWeek: null == thisWeek ? _self.thisWeek : thisWeek // ignore: cast_nullable_to_non_nullable
as Duration,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,last7Days: null == last7Days ? _self.last7Days : last7Days // ignore: cast_nullable_to_non_nullable
as List<DailyListening>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListeningStats].
extension ListeningStatsPatterns on ListeningStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListeningStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListeningStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListeningStats value)  $default,){
final _that = this;
switch (_that) {
case _ListeningStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListeningStats value)?  $default,){
final _that = this;
switch (_that) {
case _ListeningStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Duration total,  Duration thisWeek,  int streakDays,  List<DailyListening> last7Days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListeningStats() when $default != null:
return $default(_that.total,_that.thisWeek,_that.streakDays,_that.last7Days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Duration total,  Duration thisWeek,  int streakDays,  List<DailyListening> last7Days)  $default,) {final _that = this;
switch (_that) {
case _ListeningStats():
return $default(_that.total,_that.thisWeek,_that.streakDays,_that.last7Days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Duration total,  Duration thisWeek,  int streakDays,  List<DailyListening> last7Days)?  $default,) {final _that = this;
switch (_that) {
case _ListeningStats() when $default != null:
return $default(_that.total,_that.thisWeek,_that.streakDays,_that.last7Days);case _:
  return null;

}
}

}

/// @nodoc


class _ListeningStats implements ListeningStats {
  const _ListeningStats({this.total = Duration.zero, this.thisWeek = Duration.zero, this.streakDays = 0,  List<DailyListening> last7Days = const <DailyListening>[]}): _last7Days = last7Days;
  

/// Tempo total ouvido desde sempre.
@override@JsonKey() final  Duration total;
/// Tempo ouvido nesta semana (a partir de segunda 00:00 local).
@override@JsonKey() final  Duration thisWeek;
/// Dias consecutivos com registro, terminando hoje ou ontem.
@override@JsonKey() final  int streakDays;
/// Hoje e os 6 dias anteriores, em ordem cronológica; `listened` 0 nos
/// dias sem registro.
 final  List<DailyListening> _last7Days;
/// Hoje e os 6 dias anteriores, em ordem cronológica; `listened` 0 nos
/// dias sem registro.
@override@JsonKey() List<DailyListening> get last7Days {
  if (_last7Days is EqualUnmodifiableListView) return _last7Days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_last7Days);
}


/// Create a copy of ListeningStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListeningStatsCopyWith<_ListeningStats> get copyWith => __$ListeningStatsCopyWithImpl<_ListeningStats>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListeningStats&&(identical(other.total, total) || other.total == total)&&(identical(other.thisWeek, thisWeek) || other.thisWeek == thisWeek)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&const DeepCollectionEquality().equals(other.last7Days, _last7Days));
}


@override
int get hashCode {
    return Object.hash(runtimeType,total,thisWeek,streakDays,const DeepCollectionEquality().hash(_last7Days));
}

@override
String toString() {
    return 'ListeningStats(total: $total, thisWeek: $thisWeek, streakDays: $streakDays, last7Days: $last7Days)';
}


}

/// @nodoc
abstract mixin class _$ListeningStatsCopyWith<$Res> implements $ListeningStatsCopyWith<$Res> {
  factory _$ListeningStatsCopyWith(_ListeningStats value, $Res Function(_ListeningStats) _then) = __$ListeningStatsCopyWithImpl;
@override @useResult
$Res call({
 Duration total, Duration thisWeek, int streakDays, List<DailyListening> last7Days
});




}
/// @nodoc
class __$ListeningStatsCopyWithImpl<$Res>
    implements _$ListeningStatsCopyWith<$Res> {
  __$ListeningStatsCopyWithImpl(this._self, this._then);

  final _ListeningStats _self;
  final $Res Function(_ListeningStats) _then;

/// Create a copy of ListeningStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? thisWeek = null,Object? streakDays = null,Object? last7Days = null,}) {
  return _then(_ListeningStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Duration,thisWeek: null == thisWeek ? _self.thisWeek : thisWeek // ignore: cast_nullable_to_non_nullable
as Duration,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,last7Days: null == last7Days ? _self._last7Days : last7Days // ignore: cast_nullable_to_non_nullable
as List<DailyListening>,
  ));
}


}

/// @nodoc
mixin _$DailyListening {

 DateTime get day; Duration get listened;
/// Create a copy of DailyListening
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyListeningCopyWith<DailyListening> get copyWith => _$DailyListeningCopyWithImpl<DailyListening>(this as DailyListening, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailyListening;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyListening&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.listened, _this.listened) || other.listened == _this.listened));
}


@override
int get hashCode {
  final _this = this as DailyListening;
  return Object.hash(runtimeType,_this.day,_this.listened);
}

@override
String toString() {
  final _this = this as DailyListening;
  return 'DailyListening(day: ${_this.day}, listened: ${_this.listened})';
}


}

/// @nodoc
abstract mixin class $DailyListeningCopyWith<$Res>  {
  factory $DailyListeningCopyWith(DailyListening value, $Res Function(DailyListening) _then) = _$DailyListeningCopyWithImpl;
@useResult
$Res call({
 DateTime day, Duration listened
});




}
/// @nodoc
class _$DailyListeningCopyWithImpl<$Res>
    implements $DailyListeningCopyWith<$Res> {
  _$DailyListeningCopyWithImpl(this._self, this._then);

  final DailyListening _self;
  final $Res Function(DailyListening) _then;

/// Create a copy of DailyListening
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? listened = null,}) {
  return _then(DailyListening(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,listened: null == listened ? _self.listened : listened // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyListening].
extension DailyListeningPatterns on DailyListening {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyListening value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyListening() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyListening value)  $default,){
final _that = this;
switch (_that) {
case _DailyListening():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyListening value)?  $default,){
final _that = this;
switch (_that) {
case _DailyListening() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime day,  Duration listened)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyListening() when $default != null:
return $default(_that.day,_that.listened);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime day,  Duration listened)  $default,) {final _that = this;
switch (_that) {
case _DailyListening():
return $default(_that.day,_that.listened);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime day,  Duration listened)?  $default,) {final _that = this;
switch (_that) {
case _DailyListening() when $default != null:
return $default(_that.day,_that.listened);case _:
  return null;

}
}

}

/// @nodoc


class _DailyListening implements DailyListening {
  const _DailyListening({required this.day, required this.listened});
  

@override final  DateTime day;
@override final  Duration listened;

/// Create a copy of DailyListening
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyListeningCopyWith<_DailyListening> get copyWith => __$DailyListeningCopyWithImpl<_DailyListening>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyListening&&(identical(other.day, day) || other.day == day)&&(identical(other.listened, listened) || other.listened == listened));
}


@override
int get hashCode {
    return Object.hash(runtimeType,day,listened);
}

@override
String toString() {
    return 'DailyListening(day: $day, listened: $listened)';
}


}

/// @nodoc
abstract mixin class _$DailyListeningCopyWith<$Res> implements $DailyListeningCopyWith<$Res> {
  factory _$DailyListeningCopyWith(_DailyListening value, $Res Function(_DailyListening) _then) = __$DailyListeningCopyWithImpl;
@override @useResult
$Res call({
 DateTime day, Duration listened
});




}
/// @nodoc
class __$DailyListeningCopyWithImpl<$Res>
    implements _$DailyListeningCopyWith<$Res> {
  __$DailyListeningCopyWithImpl(this._self, this._then);

  final _DailyListening _self;
  final $Res Function(_DailyListening) _then;

/// Create a copy of DailyListening
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? listened = null,}) {
  return _then(_DailyListening(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,listened: null == listened ? _self.listened : listened // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
