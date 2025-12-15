// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrinterState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PrinterState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PrinterState()';
  }
}

/// @nodoc
class $PrinterStateCopyWith<$Res> {
  $PrinterStateCopyWith(PrinterState _, $Res Function(PrinterState) __);
}

/// Adds pattern-matching-related methods to [PrinterState].
extension PrinterStatePatterns on PrinterState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_ProcessingTemplate value)? processingTemplate,
    TResult Function(_RenderingProgress value)? renderingProgress,
    TResult Function(_SendingProgress value)? sendingProgress,
    TResult Function(_SendingToPrinter value)? sendingToPrinter,
    TResult Function(_Connected value)? connected,
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Error value)? error,
    TResult Function(_Cancelling value)? cancelling,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _ProcessingTemplate() when processingTemplate != null:
        return processingTemplate(_that);
      case _RenderingProgress() when renderingProgress != null:
        return renderingProgress(_that);
      case _SendingProgress() when sendingProgress != null:
        return sendingProgress(_that);
      case _SendingToPrinter() when sendingToPrinter != null:
        return sendingToPrinter(_that);
      case _Connected() when connected != null:
        return connected(_that);
      case _Disconnected() when disconnected != null:
        return disconnected(_that);
      case _Error() when error != null:
        return error(_that);
      case _Cancelling() when cancelling != null:
        return cancelling(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_ProcessingTemplate value) processingTemplate,
    required TResult Function(_RenderingProgress value) renderingProgress,
    required TResult Function(_SendingProgress value) sendingProgress,
    required TResult Function(_SendingToPrinter value) sendingToPrinter,
    required TResult Function(_Connected value) connected,
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Error value) error,
    required TResult Function(_Cancelling value) cancelling,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial(_that);
      case _ProcessingTemplate():
        return processingTemplate(_that);
      case _RenderingProgress():
        return renderingProgress(_that);
      case _SendingProgress():
        return sendingProgress(_that);
      case _SendingToPrinter():
        return sendingToPrinter(_that);
      case _Connected():
        return connected(_that);
      case _Disconnected():
        return disconnected(_that);
      case _Error():
        return error(_that);
      case _Cancelling():
        return cancelling(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_ProcessingTemplate value)? processingTemplate,
    TResult? Function(_RenderingProgress value)? renderingProgress,
    TResult? Function(_SendingProgress value)? sendingProgress,
    TResult? Function(_SendingToPrinter value)? sendingToPrinter,
    TResult? Function(_Connected value)? connected,
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Error value)? error,
    TResult? Function(_Cancelling value)? cancelling,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _ProcessingTemplate() when processingTemplate != null:
        return processingTemplate(_that);
      case _RenderingProgress() when renderingProgress != null:
        return renderingProgress(_that);
      case _SendingProgress() when sendingProgress != null:
        return sendingProgress(_that);
      case _SendingToPrinter() when sendingToPrinter != null:
        return sendingToPrinter(_that);
      case _Connected() when connected != null:
        return connected(_that);
      case _Disconnected() when disconnected != null:
        return disconnected(_that);
      case _Error() when error != null:
        return error(_that);
      case _Cancelling() when cancelling != null:
        return cancelling(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? processingTemplate,
    TResult Function(double progress)? renderingProgress,
    TResult Function(double progress)? sendingProgress,
    TResult Function()? sendingToPrinter,
    TResult Function(PrinterDevice device)? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    TResult Function()? cancelling,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _ProcessingTemplate() when processingTemplate != null:
        return processingTemplate();
      case _RenderingProgress() when renderingProgress != null:
        return renderingProgress(_that.progress);
      case _SendingProgress() when sendingProgress != null:
        return sendingProgress(_that.progress);
      case _SendingToPrinter() when sendingToPrinter != null:
        return sendingToPrinter();
      case _Connected() when connected != null:
        return connected(_that.device);
      case _Disconnected() when disconnected != null:
        return disconnected();
      case _Error() when error != null:
        return error(_that.message);
      case _Cancelling() when cancelling != null:
        return cancelling();
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() processingTemplate,
    required TResult Function(double progress) renderingProgress,
    required TResult Function(double progress) sendingProgress,
    required TResult Function() sendingToPrinter,
    required TResult Function(PrinterDevice device) connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
    required TResult Function() cancelling,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial();
      case _ProcessingTemplate():
        return processingTemplate();
      case _RenderingProgress():
        return renderingProgress(_that.progress);
      case _SendingProgress():
        return sendingProgress(_that.progress);
      case _SendingToPrinter():
        return sendingToPrinter();
      case _Connected():
        return connected(_that.device);
      case _Disconnected():
        return disconnected();
      case _Error():
        return error(_that.message);
      case _Cancelling():
        return cancelling();
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? processingTemplate,
    TResult? Function(double progress)? renderingProgress,
    TResult? Function(double progress)? sendingProgress,
    TResult? Function()? sendingToPrinter,
    TResult? Function(PrinterDevice device)? connected,
    TResult? Function()? disconnected,
    TResult? Function(String message)? error,
    TResult? Function()? cancelling,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _ProcessingTemplate() when processingTemplate != null:
        return processingTemplate();
      case _RenderingProgress() when renderingProgress != null:
        return renderingProgress(_that.progress);
      case _SendingProgress() when sendingProgress != null:
        return sendingProgress(_that.progress);
      case _SendingToPrinter() when sendingToPrinter != null:
        return sendingToPrinter();
      case _Connected() when connected != null:
        return connected(_that.device);
      case _Disconnected() when disconnected != null:
        return disconnected();
      case _Error() when error != null:
        return error(_that.message);
      case _Cancelling() when cancelling != null:
        return cancelling();
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Initial implements PrinterState {
  const _Initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PrinterState.initial()';
  }
}

/// @nodoc

class _ProcessingTemplate implements PrinterState {
  const _ProcessingTemplate();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _ProcessingTemplate);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PrinterState.processingTemplate()';
  }
}

/// @nodoc

class _RenderingProgress implements PrinterState {
  const _RenderingProgress(this.progress);

  final double progress;

  /// Create a copy of PrinterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RenderingProgressCopyWith<_RenderingProgress> get copyWith =>
      __$RenderingProgressCopyWithImpl<_RenderingProgress>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RenderingProgress &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress);

  @override
  String toString() {
    return 'PrinterState.renderingProgress(progress: $progress)';
  }
}

/// @nodoc
abstract mixin class _$RenderingProgressCopyWith<$Res>
    implements $PrinterStateCopyWith<$Res> {
  factory _$RenderingProgressCopyWith(
          _RenderingProgress value, $Res Function(_RenderingProgress) _then) =
      __$RenderingProgressCopyWithImpl;
  @useResult
  $Res call({double progress});
}

/// @nodoc
class __$RenderingProgressCopyWithImpl<$Res>
    implements _$RenderingProgressCopyWith<$Res> {
  __$RenderingProgressCopyWithImpl(this._self, this._then);

  final _RenderingProgress _self;
  final $Res Function(_RenderingProgress) _then;

  /// Create a copy of PrinterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? progress = null,
  }) {
    return _then(_RenderingProgress(
      null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _SendingProgress implements PrinterState {
  const _SendingProgress(this.progress);

  final double progress;

  /// Create a copy of PrinterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SendingProgressCopyWith<_SendingProgress> get copyWith =>
      __$SendingProgressCopyWithImpl<_SendingProgress>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SendingProgress &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress);

  @override
  String toString() {
    return 'PrinterState.sendingProgress(progress: $progress)';
  }
}

/// @nodoc
abstract mixin class _$SendingProgressCopyWith<$Res>
    implements $PrinterStateCopyWith<$Res> {
  factory _$SendingProgressCopyWith(
          _SendingProgress value, $Res Function(_SendingProgress) _then) =
      __$SendingProgressCopyWithImpl;
  @useResult
  $Res call({double progress});
}

/// @nodoc
class __$SendingProgressCopyWithImpl<$Res>
    implements _$SendingProgressCopyWith<$Res> {
  __$SendingProgressCopyWithImpl(this._self, this._then);

  final _SendingProgress _self;
  final $Res Function(_SendingProgress) _then;

  /// Create a copy of PrinterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? progress = null,
  }) {
    return _then(_SendingProgress(
      null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _SendingToPrinter implements PrinterState {
  const _SendingToPrinter();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _SendingToPrinter);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PrinterState.sendingToPrinter()';
  }
}

/// @nodoc

class _Connected implements PrinterState {
  const _Connected(this.device);

  final PrinterDevice device;

  /// Create a copy of PrinterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConnectedCopyWith<_Connected> get copyWith =>
      __$ConnectedCopyWithImpl<_Connected>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Connected &&
            (identical(other.device, device) || other.device == device));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device);

  @override
  String toString() {
    return 'PrinterState.connected(device: $device)';
  }
}

/// @nodoc
abstract mixin class _$ConnectedCopyWith<$Res>
    implements $PrinterStateCopyWith<$Res> {
  factory _$ConnectedCopyWith(
          _Connected value, $Res Function(_Connected) _then) =
      __$ConnectedCopyWithImpl;
  @useResult
  $Res call({PrinterDevice device});
}

/// @nodoc
class __$ConnectedCopyWithImpl<$Res> implements _$ConnectedCopyWith<$Res> {
  __$ConnectedCopyWithImpl(this._self, this._then);

  final _Connected _self;
  final $Res Function(_Connected) _then;

  /// Create a copy of PrinterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? device = null,
  }) {
    return _then(_Connected(
      null == device
          ? _self.device
          : device // ignore: cast_nullable_to_non_nullable
              as PrinterDevice,
    ));
  }
}

/// @nodoc

class _Disconnected implements PrinterState {
  const _Disconnected();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Disconnected);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PrinterState.disconnected()';
  }
}

/// @nodoc

class _Error implements PrinterState {
  const _Error(this.message);

  final String message;

  /// Create a copy of PrinterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'PrinterState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res>
    implements $PrinterStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) =
      __$ErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

  /// Create a copy of PrinterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_Error(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _Cancelling implements PrinterState {
  const _Cancelling();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Cancelling);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PrinterState.cancelling()';
  }
}

// dart format on
