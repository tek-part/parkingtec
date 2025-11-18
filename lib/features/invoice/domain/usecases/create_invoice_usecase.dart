import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/data/models/requests/create_invoice_request.dart';
import 'package:parkingtec/features/invoice/domain/repositories/invoice_repository.dart';

/// Use case for creating a new invoice
/// Handles the business logic for invoice creation
class CreateInvoiceUseCase {
  final InvoiceRepository _invoiceRepository;

  CreateInvoiceUseCase(this._invoiceRepository);

  Future<Either<Failure, Invoice>> execute(CreateInvoiceRequest request) async {
    // Business logic validation
    if (request.carNum.isEmpty) {
      return const Left(ValidationFailure('Car number is required'));
    }

    return await _invoiceRepository.createInvoice(request);
  }
}

