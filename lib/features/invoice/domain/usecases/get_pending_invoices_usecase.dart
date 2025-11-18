import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/domain/repositories/invoice_repository.dart';

/// Use case for getting pending invoices
/// Handles the business logic for fetching pending invoices
class GetPendingInvoicesUseCase {
  final InvoiceRepository _invoiceRepository;

  GetPendingInvoicesUseCase(this._invoiceRepository);

  Future<Either<Failure, List<Invoice>>> execute() async {
    return await _invoiceRepository.getPendingInvoices();
  }
}

