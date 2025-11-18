import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/errors.dart';
import 'package:parkingtec/features/invoice/data/datasources/invoice_remote_datasource.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/data/models/requests/complete_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/requests/create_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/requests/pay_invoice_request.dart';
import 'package:parkingtec/features/invoice/domain/repositories/invoice_repository.dart';

/// Implementation of InvoiceRepository
/// Handles invoice business logic and data flow
/// Converts ApiResult to Either<Failure, T> for functional error handling
class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource _remoteDataSource;

  InvoiceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Invoice>>> getInvoices({String? carNum}) async {
    final result = await _remoteDataSource.getInvoices(carNum: carNum);
    return result.toEither();
  }

  @override
  Future<Either<Failure, List<Invoice>>> getActiveInvoices() async {
    final result = await _remoteDataSource.getActiveInvoices();
    return result.toEither();
  }

  @override
  Future<Either<Failure, List<Invoice>>> getPendingInvoices() async {
    final result = await _remoteDataSource.getPendingInvoices();
    return result.toEither();
  }

  @override
  Future<Either<Failure, Invoice>> getInvoice(int invoiceId) async {
    final result = await _remoteDataSource.getInvoice(invoiceId);
    return result.toEither();
  }

  @override
  Future<Either<Failure, Invoice>> createInvoice(
    CreateInvoiceRequest request,
  ) async {
    final result = await _remoteDataSource.createInvoice(request);
    return result.toEither();
  }

  @override
  Future<Either<Failure, Invoice>> completeInvoice(
    CompleteInvoiceRequest request,
  ) async {
    final result = await _remoteDataSource.completeInvoice(request);
    return result.toEither();
  }

  @override
  Future<Either<Failure, Invoice>> payInvoice(
    int invoiceId,
    PayInvoiceRequest request,
  ) async {
    final result = await _remoteDataSource.payInvoice(invoiceId, request);
    return result.toEither();
  }

  @override
  Future<Either<Failure, Invoice>> pickupInvoice(int invoiceId) async {
    final result = await _remoteDataSource.pickupInvoice(invoiceId);
    return result.toEither();
  }

  @override
  Future<Either<Failure, Invoice>> scanInvoice(int invoiceId) async {
    final result = await _remoteDataSource.scanInvoice(invoiceId);
    return result.toEither();
  }
}
