import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/config/data/models/app_config.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/printing/services/printing_service.dart';

/// Reprint Invoice Use Case
/// Simple use case for reprinting invoices
class ReprintInvoiceUseCase {
  final PrintingService printingService;

  ReprintInvoiceUseCase(this.printingService);

  /// Reprint invoice (entry ticket or exit receipt)
  Future<Either<Failure, void>> call(
    Invoice invoice,
    AppConfig appConfig,
    PrintJobType jobType,
  ) async {
    try {
      bool success;
    switch (jobType) {
      case PrintJobType.entryTicket:
          success = await printingService.printEntryTicket(
            invoice: invoice,
            appConfig: appConfig,
          );
          break;
      case PrintJobType.exitReceipt:
          success = await printingService.printExitReceipt(
            invoice: invoice,
            appConfig: appConfig,
          );
          break;
      }

      if (success) {
        return const Right(null);
      } else {
        return const Left(
          ServerFailure('Print failed. Please check printer connection.'),
        );
      }
    } catch (e) {
      return Left(ServerFailure('Print error: ${e.toString()}'));
    }
  }
}

/// Print Job Type Enum
enum PrintJobType {
  entryTicket,
  exitReceipt,
}
