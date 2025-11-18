import 'package:dartz/dartz.dart';
import 'package:parkingtec/features/printing/domain/entities/print_job.dart';
import 'package:parkingtec/features/printing/domain/entities/printing_failure.dart';
import 'package:parkingtec/features/printing/domain/repositories/printing_repository.dart';

/// Use case for printing native receipt
class PrintNativeUseCase {
  final PrintingRepository repository;

  PrintNativeUseCase({required this.repository});

  Future<Either<PrintingFailure, Unit>> call(NativePrintJob printJob) async {
    // Validate print job
    if (!_isValidPrintJob(printJob)) {
      return const Left(
        InvalidPrintDataFailure(
          message: 'بيانات الإيصال غير صحيحة',
          code: 'INVALID_PRINT_JOB',
        ),
      );
    }

    // Check printer status
    final printerStatus = await repository.isPrinterReady();
    return printerStatus.fold((failure) => Left(failure), (isReady) async {
      if (!isReady) {
        return const Left(PrinterNotReadyFailure());
      }

      // Print native receipt
      return await repository.printNative(printJob);
    });
  }

  bool _isValidPrintJob(NativePrintJob printJob) {
    return printJob.brand.isNotEmpty &&
        printJob.lotName.isNotEmpty &&
        printJob.plate.isNotEmpty &&
        printJob.code6.isNotEmpty &&
        printJob.sessionId.isNotEmpty &&
        printJob.amount > 0;
  }
}

/// Use case for printing simple receipt (without QR)
class PrintSimpleReceiptUseCase {
  final PrintingRepository repository;

  PrintSimpleReceiptUseCase({required this.repository});

  Future<Either<PrintingFailure, Unit>> call(NativePrintJob printJob) async {
    // Validate print job
    if (!_isValidPrintJob(printJob)) {
      return const Left(
        InvalidPrintDataFailure(
          message: 'بيانات الإيصال غير صحيحة',
          code: 'INVALID_PRINT_JOB',
        ),
      );
    }

    // Check printer status
    final printerStatus = await repository.isPrinterReady();
    return printerStatus.fold((failure) => Left(failure), (isReady) async {
      if (!isReady) {
        return const Left(PrinterNotReadyFailure());
      }

      // Print simple receipt
      return await repository.printSimpleReceipt(printJob);
    });
  }

  bool _isValidPrintJob(NativePrintJob printJob) {
    return printJob.brand.isNotEmpty &&
        printJob.lotName.isNotEmpty &&
        printJob.plate.isNotEmpty &&
        printJob.code6.isNotEmpty &&
        printJob.sessionId.isNotEmpty &&
        printJob.amount > 0;
  }
}

/// Use case for printing QR code only
class PrintQROnlyUseCase {
  final PrintingRepository repository;

  PrintQROnlyUseCase({required this.repository});

  Future<Either<PrintingFailure, Unit>> call({
    required String sessionId,
    required String code6,
    required String lotName,
  }) async {
    // Validate input
    if (sessionId.isEmpty || code6.isEmpty || lotName.isEmpty) {
      return const Left(
        InvalidPrintDataFailure(
          message: 'بيانات QR غير صحيحة',
          code: 'INVALID_QR_DATA',
        ),
      );
    }

    // Check printer status
    final printerStatus = await repository.isPrinterReady();
    return printerStatus.fold((failure) => Left(failure), (isReady) async {
      if (!isReady) {
        return const Left(PrinterNotReadyFailure());
      }

      // Print QR only
      return await repository.printQROnly(
        sessionId: sessionId,
        code6: code6,
        lotName: lotName,
      );
    });
  }
}

/// Use case for printing custom receipt with options
class PrintCustomReceiptUseCase {
  final PrintingRepository repository;

  PrintCustomReceiptUseCase({required this.repository});

  Future<Either<PrintingFailure, Unit>> call(
    NativePrintJob printJob, {
    bool includeQR = true,
    bool includeDetails = true,
    int qrSize = 6,
  }) async {
    // Validate print job
    if (!_isValidPrintJob(printJob)) {
      return const Left(
        InvalidPrintDataFailure(
          message: 'بيانات الإيصال غير صحيحة',
          code: 'INVALID_PRINT_JOB',
        ),
      );
    }

    // Check printer status
    final printerStatus = await repository.isPrinterReady();
    return printerStatus.fold((failure) => Left(failure), (isReady) async {
      if (!isReady) {
        return const Left(PrinterNotReadyFailure());
      }

      // Print custom receipt
      return await repository.printCustomReceipt(
        printJob,
        includeQR: includeQR,
        includeDetails: includeDetails,
        qrSize: qrSize,
      );
    });
  }

  bool _isValidPrintJob(NativePrintJob printJob) {
    return printJob.brand.isNotEmpty &&
        printJob.lotName.isNotEmpty &&
        printJob.plate.isNotEmpty &&
        printJob.code6.isNotEmpty &&
        printJob.sessionId.isNotEmpty &&
        printJob.amount > 0;
  }
}
