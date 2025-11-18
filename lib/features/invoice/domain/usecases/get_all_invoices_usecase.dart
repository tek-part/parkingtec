import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/domain/repositories/invoice_repository.dart';

/// Use case for getting all invoices
/// Handles the business logic for fetching all invoices
class GetAllInvoicesUseCase {
  final InvoiceRepository _invoiceRepository;

  GetAllInvoicesUseCase(this._invoiceRepository);

  Future<Either<Failure, List<Invoice>>> execute({String? carNum}) async {
    return await _invoiceRepository.getInvoices(carNum: carNum);
  }
}

