import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/config/data/models/app_config.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/printing/controllers/bluetooth_printer_controller.dart';
import 'package:parkingtec/features/printing/controllers/sunmi_printer_controller.dart';
import 'package:parkingtec/features/printing/core/templates/ticket_template.dart';
import 'package:parkingtec/features/printing/utils/escpos_image_converter.dart';

/// Printing Service
/// Handles printing invoices using Canvas-based rendering (like tax_invoice_template.dart)
class PrintingService {
  final BluetoothPrinterController bluetoothController;
  final SunmiPrinterController sunmiController;

  PrintingService({
    required this.bluetoothController,
    required this.sunmiController,
  });

  /// Print entry ticket
  Future<Either<Failure, void>> printEntryTicket(
    Invoice invoice,
    AppConfig appConfig,
  ) async {
    try {
      // Paper width: 80mm = 384 pixels (for 8-dot mode), 58mm = 256 pixels
      const int paperWidthPx = 384; // 80mm paper

      // Render ticket to image bytes using Canvas (like tax_invoice_template.dart)
      final imageChunks = await TicketTemplateRenderer.renderEntryTicket(
        paperWidthPx: paperWidthPx,
        invoice: invoice,
        appConfig: appConfig,
      );

      // Try Sunmi first (if available)
      if (sunmiController.isInitialized) {
        // Print each chunk
        for (final chunk in imageChunks) {
          await sunmiController.printImage(chunk);
        }
        await sunmiController.lineWrap(2);
        await sunmiController.cutPaper();
        return const Right(null);
      }

      // Try Bluetooth if connected
      if (bluetoothController.isConnected) {
        // Convert each chunk to ESC/POS format and print
        for (final chunk in imageChunks) {
          try {
            final escPosBytes = await EscPosImageConverter.convert(
              chunk,
              paperWidth: 80.0, // 80mm paper
            );
            await bluetoothController.write(escPosBytes);
          } catch (e) {
            debugPrint('ESC/POS conversion error: $e');
            // Continue with next chunk
          }
        }
        return const Right(null);
      }

      return const Left(
        ServerFailure('No printer connected. Please connect a printer first.'),
      );
    } catch (e) {
      debugPrint('Print error: ${e.toString()}');
      return Left(ServerFailure('Print error: ${e.toString()}'));
    }
  }

  /// Print exit receipt
  Future<Either<Failure, void>> printExitReceipt(
    Invoice invoice,
    AppConfig appConfig,
  ) async {
    try {
      // Paper width: 80mm = 384 pixels (for 8-dot mode), 58mm = 256 pixels
      const int paperWidthPx = 384; // 80mm paper

      // Render receipt to image bytes using Canvas (like tax_invoice_template.dart)
      final imageChunks = await TicketTemplateRenderer.renderExitReceipt(
        paperWidthPx: paperWidthPx,
        invoice: invoice,
        appConfig: appConfig,
      );

      // Try Sunmi first (if available)
      if (sunmiController.isInitialized) {
        // Print each chunk
        for (final chunk in imageChunks) {
          await sunmiController.printImage(chunk);
        }
        await sunmiController.lineWrap(2);
        await sunmiController.cutPaper();
        return const Right(null);
      }

      // Try Bluetooth if connected
      if (bluetoothController.isConnected) {
        // Convert each chunk to ESC/POS format and print
        for (final chunk in imageChunks) {
          try {
            final escPosBytes = await EscPosImageConverter.convert(
              chunk,
              paperWidth: 80.0, // 80mm paper
            );
            await bluetoothController.write(escPosBytes);
          } catch (e) {
            debugPrint('ESC/POS conversion error: $e');
            // Continue with next chunk
          }
        }
        return const Right(null);
      }

      return const Left(
        ServerFailure('No printer connected. Please connect a printer first.'),
      );
    } catch (e) {
      debugPrint('Print error: ${e.toString()}');
      return Left(ServerFailure('Print error: ${e.toString()}'));
    }
  }
}
