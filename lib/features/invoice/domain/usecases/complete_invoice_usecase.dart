import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/data/models/requests/complete_invoice_request.dart';
import 'package:parkingtec/features/invoice/domain/repositories/invoice_repository.dart';

/// Use case for completing an invoice
/// Handles the business logic for invoice completion
class CompleteInvoiceUseCase {
  final InvoiceRepository _invoiceRepository;

  CompleteInvoiceUseCase(this._invoiceRepository);

  Future<Either<Failure, Invoice>> execute(CompleteInvoiceRequest request) async {
    // Business logic validation
    if (request.invoiceId <= 0) {
      return const Left(ValidationFailure('Invalid invoice ID'));
    }

    return await _invoiceRepository.completeInvoice(request);
  }
}

