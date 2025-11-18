import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

/// Utility functions for sharing and opening PDFs
class ShareOpenUtils {
  /// Share PDF file
  static Future<void> shareInvoicePdf(String pdfUrl) async {
    try {
      await Share.shareUri(Uri.parse(pdfUrl));
    } catch (e) {
      throw Exception('Failed to share PDF: $e');
    }
  }

  /// Open PDF in browser
  static Future<void> openInvoiceInBrowser(String pdfUrl) async {
    try {
      final uri = Uri.parse(pdfUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch URL: $pdfUrl');
      }
    } catch (e) {
      throw Exception('Failed to open PDF in browser: $e');
    }
  }
}

// Export functions for backward compatibility
Future<void> shareInvoicePdf(String pdfUrl) =>
    ShareOpenUtils.shareInvoicePdf(pdfUrl);
Future<void> openInvoiceInBrowser(String pdfUrl) =>
    ShareOpenUtils.openInvoiceInBrowser(pdfUrl);
