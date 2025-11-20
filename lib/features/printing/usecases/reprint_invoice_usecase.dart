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
    switch (jobType) {
      case PrintJobType.entryTicket:
        return await printingService.printEntryTicket(invoice, appConfig);
      case PrintJobType.exitReceipt:
        return await printingService.printExitReceipt(invoice, appConfig);
    }
  }
}

/// Print Job Type Enum
enum PrintJobType {
  entryTicket,
  exitReceipt,
}
