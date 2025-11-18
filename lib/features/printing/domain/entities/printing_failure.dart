import 'package:equatable/equatable.dart';

/// Base class for printing failures
abstract class PrintingFailure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const PrintingFailure(
    this.message, {
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];
}

/// Printer not ready failure
class PrinterNotReadyFailure extends PrintingFailure {
  const PrinterNotReadyFailure({
    String message = 'الطابعة غير جاهزة',
    String? code = 'PRINTER_NOT_READY',
  }) : super(message, code: code);
}

/// PDF download failure
class PdfDownloadFailure extends PrintingFailure {
  const PdfDownloadFailure({
    String message = 'فشل تحميل PDF',
    String? code = 'PDF_DOWNLOAD_FAILED',
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}

/// PDF conversion failure
class PdfConversionFailure extends PrintingFailure {
  const PdfConversionFailure({
    String message = 'فشل تحويل PDF',
    String? code = 'PDF_CONVERSION_FAILED',
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}

/// Printer binding failure
class PrinterBindingFailure extends PrintingFailure {
  const PrinterBindingFailure({
    String message = 'فشل ربط الطابعة',
    String? code = 'PRINTER_BINDING_FAILED',
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}

/// Printer initialization failure
class PrinterInitFailure extends PrintingFailure {
  const PrinterInitFailure({
    String message = 'فشل تهيئة الطابعة',
    String? code = 'PRINTER_INIT_FAILED',
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}

/// Print execution failure
class PrintExecutionFailure extends PrintingFailure {
  const PrintExecutionFailure({
    String message = 'فشل تنفيذ الطباعة',
    String? code = 'PRINT_EXECUTION_FAILED',
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}

/// Invalid print data failure
class InvalidPrintDataFailure extends PrintingFailure {
  const InvalidPrintDataFailure({
    String message = 'بيانات الطباعة غير صحيحة',
    String? code = 'INVALID_PRINT_DATA',
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}

/// Network failure for PDF download
class PrintNetworkFailure extends PrintingFailure {
  const PrintNetworkFailure({
    String message = 'خطأ في الشبكة',
    String? code = 'PRINT_NETWORK_ERROR',
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}

/// Printer status check failure
class PrinterStatusFailure extends PrintingFailure {
  const PrinterStatusFailure({
    String message = 'فشل فحص حالة الطابعة',
    String? code = 'PRINTER_STATUS_FAILED',
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}

/// Print job validation failure
class PrintJobValidationFailure extends PrintingFailure {
  const PrintJobValidationFailure({
    String message = 'فشل التحقق من صحة مهمة الطباعة',
    String? code = 'PRINT_JOB_VALIDATION_FAILED',
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}

