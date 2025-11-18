import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:parkingtec/features/printing/domain/entities/printing_failure.dart';

/// Remote data source for printing operations
abstract class PrintingRemoteDataSource {
  /// Download PDF from URL
  Future<Either<PrintingFailure, List<int>>> downloadPdf(String pdfUrl);

  /// Validate PDF URL
  Future<Either<PrintingFailure, bool>> validatePdfUrl(String pdfUrl);

  /// Get PDF file size
  Future<Either<PrintingFailure, int>> getPdfFileSize(String pdfUrl);

  /// Check if PDF is accessible
  Future<Either<PrintingFailure, bool>> isPdfAccessible(String pdfUrl);
}

class PrintingRemoteDataSourceImpl implements PrintingRemoteDataSource {
  final http.Client client;

  PrintingRemoteDataSourceImpl({required this.client});

  @override
  Future<Either<PrintingFailure, List<int>>> downloadPdf(String pdfUrl) async {
    try {
      final response = await client.get(Uri.parse(pdfUrl));

      if (response.statusCode != 200) {
        return Left(
          PdfDownloadFailure(
            message: 'فشل تحميل PDF: ${response.statusCode}',
            code: 'HTTP_${response.statusCode}',
            details: {'statusCode': response.statusCode, 'url': pdfUrl},
          ),
        );
      }

      if (response.bodyBytes.isEmpty) {
        return const Left(
          PdfDownloadFailure(message: 'ملف PDF فارغ', code: 'EMPTY_PDF'),
        );
      }

      return Right(response.bodyBytes);
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        return const Left(PrintNetworkFailure());
      }

      return Left(
        PdfDownloadFailure(
          message: 'خطأ في تحميل PDF: ${e.toString()}',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  @override
  Future<Either<PrintingFailure, bool>> validatePdfUrl(String pdfUrl) async {
    try {
      final response = await client.head(Uri.parse(pdfUrl));

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        final isValidPdf = contentType?.contains('application/pdf') == true;
        return Right(isValidPdf);
      }

      return const Right(false);
    } catch (e) {
      return Left(
        PdfDownloadFailure(
          message: 'خطأ في التحقق من رابط PDF: ${e.toString()}',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  @override
  Future<Either<PrintingFailure, int>> getPdfFileSize(String pdfUrl) async {
    try {
      final response = await client.head(Uri.parse(pdfUrl));

      if (response.statusCode == 200) {
        final contentLength = response.headers['content-length'];
        return Right(contentLength != null ? int.parse(contentLength) : 0);
      }

      return const Right(0);
    } catch (e) {
      return Left(
        PdfDownloadFailure(
          message: 'خطأ في الحصول على حجم PDF: ${e.toString()}',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  @override
  Future<Either<PrintingFailure, bool>> isPdfAccessible(String pdfUrl) async {
    try {
      final response = await client.head(Uri.parse(pdfUrl));
      return Right(response.statusCode == 200);
    } catch (e) {
      return Left(
        PdfDownloadFailure(
          message: 'خطأ في التحقق من إمكانية الوصول لـ PDF: ${e.toString()}',
          details: {'error': e.toString()},
        ),
      );
    }
  }
}
