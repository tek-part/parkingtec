import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'printer_state.freezed.dart';

/// Printer State
/// Freezed union type for managing printer state
@freezed
class PrinterState with _$PrinterState {
  const factory PrinterState.initial() = _Initial;
  const factory PrinterState.processingTemplate() = _ProcessingTemplate;
  const factory PrinterState.renderingProgress(double progress) =
      _RenderingProgress;
  const factory PrinterState.sendingProgress(double progress) =
      _SendingProgress;
  const factory PrinterState.sendingToPrinter() = _SendingToPrinter;
  const factory PrinterState.connected(PrinterDevice device) = _Connected;
  const factory PrinterState.disconnected() = _Disconnected;
  const factory PrinterState.error(String message) = _Error;
  const factory PrinterState.cancelling() = _Cancelling;
}
