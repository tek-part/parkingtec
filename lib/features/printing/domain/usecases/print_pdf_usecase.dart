import 'package:dartz/dartz.dart';
import 'package:parkingtec/features/printing/domain/entities/printing_failure.dart';
import 'package:parkingtec/features/printing/domain/repositories/printing_repository.dart';

/// Use case for printing PDF
class PrintPdfUseCase {
  final PrintingRepository repository;

  PrintPdfUseCase({required this.repository});

  Future<Either<PrintingFailure, Unit>> call({
    required String pdfUrl,
    int? dpi,
  }) async {
    // Validate input
    if (pdfUrl.isEmpty) {
      return const Left(
        InvalidPrintDataFailure(
          message: 'رابط PDF فارغ',
          code: 'EMPTY_PDF_URL',
        ),
      );
    }

    if (!pdfUrl.startsWith('http')) {
      return const Left(
        InvalidPrintDataFailure(
          message: 'رابط PDF غير صحيح',
          code: 'INVALID_PDF_URL',
        ),
      );
    }

    // Check printer status
    final printerStatus = await repository.isPrinterReady();
    return printerStatus.fold((failure) => Left(failure), (isReady) async {
      if (!isReady) {
        return const Left(PrinterNotReadyFailure());
      }

      // Print PDF
      return await repository.printPdf(pdfUrl, dpi: dpi);
    });
  }
}

/// Use case for printing PDF with safety checks
class PrintPdfSafeUseCase {
  final PrintingRepository repository;

  PrintPdfSafeUseCase({required this.repository});

  Future<Either<PrintingFailure, Unit>> call({
    required String pdfUrl,
    int? dpi,
    bool checkPrinterStatus = true,
  }) async {
    try {
      // Check printer status if required
      if (checkPrinterStatus) {
        final printerStatus = await repository.isPrinterReady();
        if (printerStatus.isLeft()) {
          return printerStatus.fold(
            (failure) => Left(failure),
            (_) => const Left(PrinterStatusFailure()),
          );
        }
      }

      // Print PDF
      return await repository.printPdf(pdfUrl, dpi: dpi);
    } catch (e) {
      return Left(
        PrintExecutionFailure(
          message: 'خطأ غير متوقع في الطباعة: ${e.toString()}',
          details: {'error': e.toString()},
        ),
      );
    }
  }
}

/// Use case for printing PDF with retry mechanism
class PrintPdfWithRetryUseCase {
  final PrintingRepository repository;
  final int maxRetries;
  final Duration retryDelay;

  PrintPdfWithRetryUseCase({
    required this.repository,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  Future<Either<PrintingFailure, Unit>> call({
    required String pdfUrl,
    int? dpi,
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      final result = await repository.printPdf(pdfUrl, dpi: dpi);

      if (result.isRight()) {
        return result;
      }

      // If not the last attempt, wait and retry
      if (attempt < maxRetries) {
        await Future.delayed(retryDelay);
      }
    }

    return const Left(
      PrintExecutionFailure(
        message: 'فشل الطباعة بعد عدة محاولات',
        code: 'PRINT_RETRY_EXHAUSTED',
      ),
    );
  }
}
