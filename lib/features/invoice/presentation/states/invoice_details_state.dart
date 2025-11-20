import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'invoice_details_state.freezed.dart';

/// Invoice Details State
/// Manages state for loading single invoice details
@freezed
class InvoiceDetailsState with _$InvoiceDetailsState {
  const factory InvoiceDetailsState.initial() = _Initial;
  const factory InvoiceDetailsState.loading() = _Loading;
  const factory InvoiceDetailsState.loaded({required Invoice invoice}) = _Loaded;
  const factory InvoiceDetailsState.error({required Failure failure}) = _Error;
}

