class QRVerification {
  /// استخراج ID العربية من QR Link
  static String extractVehicleId(String qrLink) {
    try {
      final uri = Uri.parse(qrLink);
      final segments = uri.pathSegments;

      // البحث عن ID في المسار
      for (int i = 0; i < segments.length; i++) {
        if (segments[i] == 'vehicle' && i + 1 < segments.length) {
          return segments[i + 1];
        }
      }

      // إذا لم يتم العثور على 'vehicle' في المسار، أخذ آخر جزء
      if (segments.isNotEmpty) {
        return segments.last;
      }

      throw Exception('Unable to extract vehicle ID from QR link');
    } catch (e) {
      throw Exception('Invalid QR link format: $e');
    }
  }

  /// التحقق من صحة QR Code
  static bool verifyVehicle(String qrLink, String expectedId) {
    try {
      final extractedId = extractVehicleId(qrLink);
      return extractedId == expectedId;
    } catch (e) {
      return false;
    }
  }

  /// التحقق من صحة QR Link
  static bool isValidQRLink(String qrLink) {
    try {
      final uri = Uri.parse(qrLink);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  /// إنشاء QR Link للعربية
  static String generateQRLink(String vehicleId, {String? baseUrl}) {
    final base = baseUrl ?? 'https://parking.alwafierp.com';
    return '$base/vehicle/$vehicleId';
  }

  /// التحقق من أن QR Code يحتوي على معلومات صحيحة
  static Map<String, dynamic> parseQRData(String qrLink) {
    try {
      final uri = Uri.parse(qrLink);
      final vehicleId = extractVehicleId(qrLink);

      return {
        'vehicleId': vehicleId,
        'baseUrl': '${uri.scheme}://${uri.authority}',
        'isValid': true,
      };
    } catch (e) {
      return {
        'vehicleId': null,
        'baseUrl': null,
        'isValid': false,
        'error': e.toString(),
      };
    }
  }
}
