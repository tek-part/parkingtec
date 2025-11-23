import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/config/data/models/app_config.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/printing/services/printing_service.dart';

/// Print Invoice Use Case
/// Simple use case for printing invoices
class PrintInvoiceUseCase {
  final PrintingService printingService;

  PrintInvoiceUseCase(this.printingService);

  /// Print entry ticket
  Future<Either<Failure, void>> printEntryTicket(
    Invoice invoice,
    AppConfig appConfig,
  ) async {
    try {
      final success = await printingService.printEntryTicket(
        invoice: invoice,
        appConfig: appConfig,
      );
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

  /// Print exit receipt
  Future<Either<Failure, void>> printExitReceipt(
    Invoice invoice,
    AppConfig appConfig,
  ) async {
    try {
      final success = await printingService.printExitReceipt(
        invoice: invoice,
        appConfig: appConfig,
      );
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
