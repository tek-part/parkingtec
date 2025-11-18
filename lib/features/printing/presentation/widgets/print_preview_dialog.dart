import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/printing/data/datasources/unified_sunmi_printer.dart';
import 'package:parkingtec/features/printing/presentation/widgets/receipt_preview_widget.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Unified print preview dialog with printing functionality
class PrintPreviewDialog extends ConsumerStatefulWidget {
  final String pdfUrl;
  final dynamic invoiceData;
  final bool isArabic;

  const PrintPreviewDialog({
    super.key,
    required this.pdfUrl,
    this.invoiceData,
    this.isArabic = true,
  });

  @override
  ConsumerState<PrintPreviewDialog> createState() => _PrintPreviewDialogState();
}

class _PrintPreviewDialogState extends ConsumerState<PrintPreviewDialog> {
  bool _isPrinting = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildReceiptPreview(),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.print, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            S.of(context).printPreview,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: AppColors.textSecondary(context)),
        ),
      ],
    );
  }

  Widget _buildReceiptPreview() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ReceiptPreviewWidget(
            content: widget.invoiceData.toString(),
            type: 'invoice',
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.cancel, color: AppColors.textSecondary(context)),
            label: Text(
              S.of(context).cancel,
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.border(context)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isPrinting ? null : () => _printPdf(context),
            icon: _isPrinting
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textPrimary(context),
                      ),
                    ),
                  )
                : const Icon(Icons.print),
            label: Text(
              _isPrinting ? S.of(context).printing : S.of(context).printPdf,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isPrinting ? null : () => _printNative(context),
            icon: _isPrinting
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textPrimary(context),
                      ),
                    ),
                  )
                : const Icon(Icons.receipt),
            label: Text(
              _isPrinting ? S.of(context).printing : S.of(context).printNative,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _printPdf(BuildContext context) async {
    setState(() => _isPrinting = true);

    try {
      final result = await UnifiedSunmiPrinter.printPdfFromUrl(widget.pdfUrl);

      result.fold(
        (failure) {
          setState(() => _isPrinting = false);
          _showErrorMessage(context, failure.message);
        },
        (success) {
          setState(() => _isPrinting = false);
          _showSuccessMessage(context);
        },
      );
    } catch (e) {
      setState(() => _isPrinting = false);
      _showErrorMessage(
        context,
        '${S.of(context).printError}: ${e.toString()}',
      );
    }
  }

  Future<void> _printNative(BuildContext context) async {
    if (widget.invoiceData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).invoiceDataNotAvailable,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isPrinting = true);

    try {
      // Get currency from config
      final currency = ref.read(currencyProvider);
      final currencySymbol = ref.read(currencySymbolProvider);

      final result = await UnifiedSunmiPrinter.printNativeReceipt(
        brand: widget.invoiceData['brand'] ?? 'WAFI PARK',
        lotName: widget.invoiceData['lotName'] ?? '',
        plate: widget.invoiceData['plate'] ?? '',
        start: DateTime.parse(
          widget.invoiceData['start'] ?? DateTime.now().toIso8601String(),
        ),
        end: DateTime.parse(
          widget.invoiceData['end'] ?? DateTime.now().toIso8601String(),
        ),
        code6: widget.invoiceData['code6'] ?? '',
        amount: (widget.invoiceData['amount'] ?? 0.0).toDouble(),
        sessionId: widget.invoiceData['sessionId'] ?? '',
        isArabic: widget.isArabic,
        currency: currency,
        currencySymbol: currencySymbol,
      );

      result.fold(
        (failure) {
          setState(() => _isPrinting = false);
          _showErrorMessage(context, failure.message);
        },
        (success) {
          setState(() => _isPrinting = false);
          _showSuccessMessage(context);
        },
      );
    } catch (e) {
      setState(() => _isPrinting = false);
      _showErrorMessage(
        context,
        '${S.of(context).printError}: ${e.toString()}',
      );
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showSuccessMessage(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).printSuccessful),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
