// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_refresh_settings_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedRefreshSettings {

 bool get backgroundRefresh; bool get notifications; bool get wifiOnly;
/// Create a copy of FeedRefreshSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedRefreshSettingsCopyWith<FeedRefreshSettings> get copyWith => _$FeedRefreshSettingsCopyWithImpl<FeedRefreshSettings>(this as FeedRefreshSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FeedRefreshSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedRefreshSettings&&(identical(other.backgroundRefresh, _this.backgroundRefresh) || other.backgroundRefresh == _this.backgroundRefresh)&&(identical(other.notifications, _this.notifications) || other.notifications == _this.notifications)&&(identical(other.wifiOnly, _this.wifiOnly) || other.wifiOnly == _this.wifiOnly));
}


@override
int get hashCode {
  final _this = this as FeedRefreshSettings;
  return Object.hash(runtimeType,_this.backgroundRefresh,_this.notifications,_this.wifiOnly);
}

@override
String toString() {
  final _this = this as FeedRefreshSettings;
  return 'FeedRefreshSettings(backgroundRefresh: ${_this.backgroundRefresh}, notifications: ${_this.notifications}, wifiOnly: ${_this.wifiOnly})';
}


}

/// @nodoc
abstract mixin class $FeedRefreshSettingsCopyWith<$Res>  {
  factory $FeedRefreshSettingsCopyWith(FeedRefreshSettings value, $Res Function(FeedRefreshSettings) _then) = _$FeedRefreshSettingsCopyWithImpl;
@useResult
$Res call({
 bool backgroundRefresh, bool notifications, bool wifiOnly
});




}
/// @nodoc
class _$FeedRefreshSettingsCopyWithImpl<$Res>
    implements $FeedRefreshSettingsCopyWith<$Res> {
  _$FeedRefreshSettingsCopyWithImpl(this._self, this._then);

  final FeedRefreshSettings _self;
  final $Res Function(FeedRefreshSettings) _then;

/// Create a copy of FeedRefreshSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backgroundRefresh = null,Object? notifications = null,Object? wifiOnly = null,}) {
  return _then(FeedRefreshSettings(
backgroundRefresh: null == backgroundRefresh ? _self.backgroundRefresh : backgroundRefresh // ignore: cast_nullable_to_non_nullable
as bool,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as bool,wifiOnly: null == wifiOnly ? _self.wifiOnly : wifiOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedRefreshSettings].
extension FeedRefreshSettingsPatterns on FeedRefreshSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedRefreshSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedRefreshSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedRefreshSettings value)  $default,){
final _that = this;
switch (_that) {
case _FeedRefreshSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedRefreshSettings value)?  $default,){
final _that = this;
switch (_that) {
case _FeedRefreshSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool backgroundRefresh,  bool notifications,  bool wifiOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedRefreshSettings() when $default != null:
return $default(_that.backgroundRefresh,_that.notifications,_that.wifiOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool backgroundRefresh,  bool notifications,  bool wifiOnly)  $default,) {final _that = this;
switch (_that) {
case _FeedRefreshSettings():
return $default(_that.backgroundRefresh,_that.notifications,_that.wifiOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool backgroundRefresh,  bool notifications,  bool wifiOnly)?  $default,) {final _that = this;
switch (_that) {
case _FeedRefreshSettings() when $default != null:
return $default(_that.backgroundRefresh,_that.notifications,_that.wifiOnly);case _:
  return null;

}
}

}

/// @nodoc


class _FeedRefreshSettings implements FeedRefreshSettings {
  const _FeedRefreshSettings({required this.backgroundRefresh, required this.notifications, required this.wifiOnly});
  

@override final  bool backgroundRefresh;
@override final  bool notifications;
@override final  bool wifiOnly;

/// Create a copy of FeedRefreshSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedRefreshSettingsCopyWith<_FeedRefreshSettings> get copyWith => __$FeedRefreshSettingsCopyWithImpl<_FeedRefreshSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedRefreshSettings&&(identical(other.backgroundRefresh, backgroundRefresh) || other.backgroundRefresh == backgroundRefresh)&&(identical(other.notifications, notifications) || other.notifications == notifications)&&(identical(other.wifiOnly, wifiOnly) || other.wifiOnly == wifiOnly));
}


@override
int get hashCode {
    return Object.hash(runtimeType,backgroundRefresh,notifications,wifiOnly);
}

@override
String toString() {
    return 'FeedRefreshSettings(backgroundRefresh: $backgroundRefresh, notifications: $notifications, wifiOnly: $wifiOnly)';
}


}

/// @nodoc
abstract mixin class _$FeedRefreshSettingsCopyWith<$Res> implements $FeedRefreshSettingsCopyWith<$Res> {
  factory _$FeedRefreshSettingsCopyWith(_FeedRefreshSettings value, $Res Function(_FeedRefreshSettings) _then) = __$FeedRefreshSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool backgroundRefresh, bool notifications, bool wifiOnly
});




}
/// @nodoc
class __$FeedRefreshSettingsCopyWithImpl<$Res>
    implements _$FeedRefreshSettingsCopyWith<$Res> {
  __$FeedRefreshSettingsCopyWithImpl(this._self, this._then);

  final _FeedRefreshSettings _self;
  final $Res Function(_FeedRefreshSettings) _then;

/// Create a copy of FeedRefreshSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backgroundRefresh = null,Object? notifications = null,Object? wifiOnly = null,}) {
  return _then(_FeedRefreshSettings(
backgroundRefresh: null == backgroundRefresh ? _self.backgroundRefresh : backgroundRefresh // ignore: cast_nullable_to_non_nullable
as bool,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as bool,wifiOnly: null == wifiOnly ? _self.wifiOnly : wifiOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
