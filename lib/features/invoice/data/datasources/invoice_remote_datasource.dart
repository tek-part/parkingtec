import 'package:parkingtec/core/errors/api_result.dart';
import 'package:parkingtec/core/errors/exception_mapper.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/core/services/api_service.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/data/models/requests/complete_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/requests/create_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/requests/pay_invoice_request.dart';

/// Remote data source for invoice operations
/// Handles all API calls related to invoices
abstract class InvoiceRemoteDataSource {
  Future<ApiResult<List<Invoice>>> getInvoices({String? carNum});
  Future<ApiResult<List<Invoice>>> getActiveInvoices();
  Future<ApiResult<List<Invoice>>> getPendingInvoices();
  Future<ApiResult<Invoice>> getInvoice(int invoiceId);
  Future<ApiResult<Invoice>> createInvoice(CreateInvoiceRequest request);
  Future<ApiResult<Invoice>> completeInvoice(CompleteInvoiceRequest request);
  Future<ApiResult<Invoice>> payInvoice(int invoiceId, PayInvoiceRequest request);
  Future<ApiResult<Invoice>> pickupInvoice(int invoiceId);
  Future<ApiResult<Invoice>> scanInvoice(int invoiceId);
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final ApiService _apiService;

  InvoiceRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResult<List<Invoice>>> getInvoices({String? carNum}) async {
    try {
      final response = await _apiService.getInvoices(carNum: carNum);
      if (response.invoices == null) {
        return ApiResult.failure(
          const ServerFailure('Invoices data not found in response'),
        );
      }
      return ApiResult.success(response.invoices!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<List<Invoice>>> getActiveInvoices() async {
    try {
      final response = await _apiService.getActiveInvoices();
      if (response.invoices == null) {
        return ApiResult.failure(
          const ServerFailure('Active invoices data not found in response'),
        );
      }
      return ApiResult.success(response.invoices!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<List<Invoice>>> getPendingInvoices() async {
    try {
      final response = await _apiService.getPendingInvoices();
      if (response.invoices == null) {
        return ApiResult.failure(
          const ServerFailure('Pending invoices data not found in response'),
        );
      }
      return ApiResult.success(response.invoices!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<Invoice>> getInvoice(int invoiceId) async {
    try {
      final response = await _apiService.getInvoice(invoiceId);
      if (response.invoice == null) {
        return ApiResult.failure(
          const ServerFailure('Invoice data not found in response'),
        );
      }
      return ApiResult.success(response.invoice!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<Invoice>> createInvoice(
    CreateInvoiceRequest request,
  ) async {
    try {
      final response = await _apiService.createInvoice(request);
      if (response.invoice == null) {
        return ApiResult.failure(
          const ServerFailure('Invoice data not found in response'),
        );
      }
      return ApiResult.success(response.invoice!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<Invoice>> completeInvoice(
    CompleteInvoiceRequest request,
  ) async {
    try {
      final response = await _apiService.completeInvoice(request);
      if (response.invoice == null) {
        return ApiResult.failure(
          const ServerFailure('Invoice data not found in response'),
        );
      }
      return ApiResult.success(response.invoice!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<Invoice>> payInvoice(
    int invoiceId,
    PayInvoiceRequest request,
  ) async {
    try {
      final response = await _apiService.payInvoice(invoiceId, request);
      if (response.data?.invoice == null) {
        return ApiResult.failure(
          const ServerFailure('Invoice data not found in response'),
        );
      }
      return ApiResult.success(response.data!.invoice!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<Invoice>> pickupInvoice(int invoiceId) async {
    try {
      final response = await _apiService.pickupInvoice(invoiceId);
      if (response.invoice == null) {
        return ApiResult.failure(
          const ServerFailure('Invoice data not found in response'),
        );
      }
      return ApiResult.success(response.invoice!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<Invoice>> scanInvoice(int invoiceId) async {
    try {
      final response = await _apiService.scanInvoice(invoiceId, 1);
      if (response.invoice == null) {
        return ApiResult.failure(
          const ServerFailure('Invoice data not found in response'),
        );
      }
      return ApiResult.success(response.invoice!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }
}
