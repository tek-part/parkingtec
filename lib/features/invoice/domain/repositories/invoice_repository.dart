import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/data/models/requests/complete_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/requests/create_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/requests/pay_invoice_request.dart';

/// Repository interface for invoice operations
/// Defines the contract for invoice data access
abstract class InvoiceRepository {
  Future<Either<Failure, List<Invoice>>> getInvoices({String? carNum});
  Future<Either<Failure, List<Invoice>>> getActiveInvoices();
  Future<Either<Failure, List<Invoice>>> getPendingInvoices();
  Future<Either<Failure, Invoice>> getInvoice(int invoiceId);
  Future<Either<Failure, Invoice>> createInvoice(CreateInvoiceRequest request);
  Future<Either<Failure, Invoice>> completeInvoice(
    CompleteInvoiceRequest request,
  );
  Future<Either<Failure, Invoice>> payInvoice(
    int invoiceId,
    PayInvoiceRequest request,
  );
  Future<Either<Failure, Invoice>> pickupInvoice(int invoiceId);
  Future<Either<Failure, Invoice>> scanInvoice(int invoiceId);
}
