import 'package:equatable/equatable.dart';

/// Entity representing a print job
class PrintJob extends Equatable {
  final String id;
  final String type; // 'pdf' or 'native'
  final String content; // URL for PDF, or data for native
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final PrintJobStatus status;

  const PrintJob({
    required this.id,
    required this.type,
    required this.content,
    this.metadata,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        content,
        metadata,
        createdAt,
        status,
      ];

  PrintJob copyWith({
    String? id,
    String? type,
    String? content,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    PrintJobStatus? status,
  }) {
    return PrintJob(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}

enum PrintJobStatus {
  pending,
  printing,
  completed,
  failed,
  cancelled,
}

/// Entity for PDF print job
class PdfPrintJob extends PrintJob {
  final String pdfUrl;
  final int? dpi;
  final bool includePreview;

  const PdfPrintJob({
    required super.id,
    required this.pdfUrl,
    this.dpi,
    this.includePreview = true,
    super.metadata,
    required super.createdAt,
    required super.status,
  }) : super(
          type: 'pdf',
          content: pdfUrl,
        );

  @override
  List<Object?> get props => [
        ...super.props,
        pdfUrl,
        dpi,
        includePreview,
      ];
}

/// Entity for Native print job
class NativePrintJob extends PrintJob {
  final String brand;
  final String lotName;
  final String plate;
  final DateTime start;
  final DateTime end;
  final String code6;
  final double amount;
  final String sessionId;
  final bool includeQR;
  final bool includeDetails;

  const NativePrintJob({
    required super.id,
    required this.brand,
    required this.lotName,
    required this.plate,
    required this.start,
    required this.end,
    required this.code6,
    required this.amount,
    required this.sessionId,
    this.includeQR = true,
    this.includeDetails = true,
    super.metadata,
    required super.createdAt,
    required super.status,
  }) : super(
          type: 'native',
          content: code6,
        );

  @override
  List<Object?> get props => [
        ...super.props,
        brand,
        lotName,
        plate,
        start,
        end,
        code6,
        amount,
        sessionId,
        includeQR,
        includeDetails,
      ];

  /// Calculate parking duration in minutes
  int get durationMinutes => end.difference(start).inMinutes;

  /// Format duration for display
  String get formattedDuration {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (hours > 0) {
      return '$hoursس $minutesد';
    } else {
      return '$minutesد';
    }
  }
}

