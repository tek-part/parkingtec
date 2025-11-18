import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/domain/repositories/invoice_repository.dart';

/// Use case for searching invoices by car number
/// Handles the business logic for invoice search
class SearchInvoicesUseCase {
  final InvoiceRepository _invoiceRepository;

  SearchInvoicesUseCase(this._invoiceRepository);

  Future<Either<Failure, List<Invoice>>> execute(String carNum) async {
    // Business logic validation
    if (carNum.isEmpty) {
      return const Left(ValidationFailure('Car number is required for search'));
    }

    return await _invoiceRepository.getInvoices(carNum: carNum);
  }
}

