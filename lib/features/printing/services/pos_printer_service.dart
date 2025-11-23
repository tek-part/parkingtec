import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:parkingtec/features/config/data/models/app_config.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/printing/controllers/bluetooth_printer_controller.dart';
import 'package:parkingtec/features/printing/controllers/sunmi_printer_controller.dart';
import 'package:parkingtec/features/printing/core/templates/ticket_template.dart';
import 'package:parkingtec/features/printing/core/utils/paper_preset.dart';
import 'package:parkingtec/features/printing/utils/escpos_image_converter.dart';

/// POS Printer Service
/// Handles printing tickets with progress tracking and cancellation support
class PosPrinterService {
  const PosPrinterService();

  /// Preview ticket (generate image chunks)
  Future<List<Uint8List>> previewTicket({
    required PaperPreset paper,
    required Invoice invoice,
    required AppConfig appConfig,
    required bool isExitReceipt,
    String fontFamily = 'Cairo',
    int sliceHeight = 900,
    Function(double progress)? onProgress,
  }) async {
    final width = paper.width;

    if (isExitReceipt) {
      return await TicketTemplateRenderer.renderExitReceipt(
        paperWidthPx: width,
        invoice: invoice,
        appConfig: appConfig,
        maxSliceHeightPx: sliceHeight,
        fontFamily: fontFamily,
        onProgress: onProgress,
      );
    } else {
      return await TicketTemplateRenderer.renderEntryTicket(
        paperWidthPx: width,
        invoice: invoice,
        appConfig: appConfig,
        maxSliceHeightPx: sliceHeight,
        fontFamily: fontFamily,
        onProgress: onProgress,
      );
    }
  }

  /// Print ticket
  Future<void> printTicket({
    required PaperPreset paper,
    required Invoice invoice,
    required AppConfig appConfig,
    required bool isExitReceipt,
    String fontFamily = 'Cairo',
    int sliceHeight = 900,
    int feedLines = 2,
    Function(double progress)? onRenderingProgress,
    Function(double progress)? onSendingProgress,
    bool Function()? shouldCancel,
    required bool isSunmi,
    SunmiPrinterController? sunmiController,
    BluetoothPrinterController? bluetoothController,
  }) async {
    // Generate image chunks
    final chunks = await previewTicket(
      paper: paper,
      invoice: invoice,
      appConfig: appConfig,
      isExitReceipt: isExitReceipt,
      fontFamily: fontFamily,
      sliceHeight: sliceHeight,
      onProgress: onRenderingProgress,
    );

    // Check cancellation after rendering
    if (shouldCancel?.call() ?? false) {
      return;
    }

    if (isSunmi && sunmiController != null) {
      // Print via Sunmi
      for (int i = 0; i < chunks.length; i++) {
        // Check cancellation before each chunk
        if (shouldCancel?.call() ?? false) {
          return;
        }

        // Yield to UI
        await Future.microtask(() {});
        await SchedulerBinding.instance.endOfFrame;

        // Print image chunk
        await sunmiController.printImage(chunks[i]);

        // Update sending progress
        onSendingProgress?.call((i + 1) / chunks.length);

        // Yield after each chunk
        await Future.microtask(() {});
      }

      // Add line wrap and cut only after all chunks
      await sunmiController.lineWrap(feedLines);
      await sunmiController.cutPaper();
    } else if (bluetoothController != null) {
      // Print via Bluetooth (ESC/POS) - Convert images to ESC/POS commands
      debugPrint('🖨️ Starting Bluetooth print with ${chunks.length} chunks');

      if (chunks.isEmpty) {
        debugPrint('❌ No image chunks to print!');
        return;
      }

      final esc = EscCommand();
      await esc.cleanCommand();

      // Set paper preset for proper sizing
      esc.setPaperPreset(paper);

      // Add all image chunks
      for (int i = 0; i < chunks.length; i++) {
        final chunk = chunks[i];
        debugPrint(
          '📦 Adding chunk ${i + 1}/${chunks.length}, size: ${chunk.length} bytes',
        );
        await esc.addImageChunk(chunk);
      }

      // Finalize command (add feed lines and cut)
      await esc.print(feedLines: feedLines);
      final bytes = await esc.getCommand();

      debugPrint('📤 Generated ${bytes?.length ?? 0} bytes for printer');

      if (bytes != null && bytes.isNotEmpty) {
        // Yield before sending
        await Future.microtask(() {});
        await SchedulerBinding.instance.endOfFrame;

        // Send to printer
        debugPrint('📡 Sending bytes to printer...');
        await bluetoothController.write(bytes);
        debugPrint('✅ Bytes sent successfully');

        // Yield after sending
        await Future.microtask(() {});
      } else {
        debugPrint('❌ No bytes to send to printer!');
      }
    }
  }
}
