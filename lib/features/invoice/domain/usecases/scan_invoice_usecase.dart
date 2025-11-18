import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/domain/repositories/invoice_repository.dart';

/// Use case for scanning an invoice QR code
/// Handles the business logic for invoice scanning
class ScanInvoiceUseCase {
  final InvoiceRepository _invoiceRepository;

  ScanInvoiceUseCase(this._invoiceRepository);

  Future<Either<Failure, Invoice>> execute(int invoiceId) async {
    // Business logic validation
    if (invoiceId <= 0) {
      return const Left(ValidationFailure('Invalid invoice ID'));
    }

    return await _invoiceRepository.scanInvoice(invoiceId);
  }
}

