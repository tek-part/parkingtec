import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:parkingtec/features/printing/domain/entities/print_job.dart';
import 'package:parkingtec/features/printing/domain/entities/printing_failure.dart';

/// Repository interface for printing operations
abstract class PrintingRepository {
  /// Check if printer is ready
  Future<Either<PrintingFailure, bool>> isPrinterReady();

  /// Print PDF from URL
  Future<Either<PrintingFailure, Unit>> printPdf(String pdfUrl, {int? dpi});

  /// Print native receipt
  Future<Either<PrintingFailure, Unit>> printNative(NativePrintJob printJob);

  /// Print simple receipt (without QR)
  Future<Either<PrintingFailure, Unit>> printSimpleReceipt(
    NativePrintJob printJob,
  );

  /// Print QR code only
  Future<Either<PrintingFailure, Unit>> printQROnly({
    required String sessionId,
    required String code6,
    required String lotName,
  });

  /// Print custom receipt with options
  Future<Either<PrintingFailure, Unit>> printCustomReceipt(
    NativePrintJob printJob, {
    bool includeQR = true,
    bool includeDetails = true,
    int qrSize = 6,
  });

  /// Download PDF from URL
  Future<Either<PrintingFailure, List<int>>> downloadPdf(String pdfUrl);

  /// Convert PDF to images
  Future<Either<PrintingFailure, List<Uint8List>>> convertPdfToImages(
    List<int> pdfBytes, {
    double dpi = 203.0,
  });

  /// Get printer status
  Future<Either<PrintingFailure, String>> getPrinterStatus();

  /// Initialize printer
  Future<Either<PrintingFailure, Unit>> initializePrinter();

  /// Unbind printer
  Future<Either<PrintingFailure, Unit>> unbindPrinter();

  /// Cut paper
  Future<Either<PrintingFailure, Unit>> cutPaper();

  /// Line wrap
  Future<Either<PrintingFailure, Unit>> lineWrap(int lines);
}
