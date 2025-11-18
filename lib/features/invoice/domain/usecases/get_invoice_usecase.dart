import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/domain/repositories/invoice_repository.dart';

/// Use case for getting a specific invoice
/// Handles the business logic for fetching invoice by ID
class GetInvoiceUseCase {
  final InvoiceRepository _invoiceRepository;

  GetInvoiceUseCase(this._invoiceRepository);

  Future<Either<Failure, Invoice>> execute(int invoiceId) async {
    if (invoiceId <= 0) {
      return const Left(ValidationFailure('Invalid invoice ID'));
    }
    return await _invoiceRepository.getInvoice(invoiceId);
  }
}

