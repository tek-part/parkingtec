import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/data/models/requests/pay_invoice_request.dart';
import 'package:parkingtec/features/invoice/domain/repositories/invoice_repository.dart';

/// Use case for paying an invoice
/// Handles the business logic for invoice payment
class PayInvoiceUseCase {
  final InvoiceRepository _invoiceRepository;

  PayInvoiceUseCase(this._invoiceRepository);

  Future<Either<Failure, Invoice>> execute(
    int invoiceId,
    PayInvoiceRequest request,
  ) async {
    // Business logic validation
    if (invoiceId <= 0) {
      return const Left(ValidationFailure('Invalid invoice ID'));
    }

    if (request.amount <= 0) {
      return const Left(ValidationFailure('Amount must be greater than zero'));
    }

    return await _invoiceRepository.payInvoice(invoiceId, request);
  }
}

