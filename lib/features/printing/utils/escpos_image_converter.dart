import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';

/// ESC/POS Image Converter
/// Converts PNG image bytes to ESC/POS format for thermal printers
class EscPosImageConverter {
  /// Convert PNG image bytes to ESC/POS format
  /// 
  /// [imageBytes] - PNG image bytes
  /// [paperWidth] - Paper width in mm (58 or 80)
  /// Returns ESC/POS command bytes
  static Future<Uint8List> convert(
    Uint8List imageBytes, {
    double paperWidth = 80.0,
  }) async {
    try {
      // Decode PNG image
      final image = await _decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Calculate target width in pixels
      // For 8-dot single-density mode: 80mm = 384 pixels, 58mm = 256 pixels
      final targetWidth = paperWidth == 58.0 ? 256 : 384;
      
      // Resize image to fit printer width
      final resizedImage = _resizeImage(image, targetWidth);
      
      // Convert to grayscale
      final grayscaleImage = _convertToGrayscale(resizedImage);
      
      // Convert to 1-bit bitmap (black and white)
      final bitmap = _convertToBitmap(grayscaleImage);
      
      // Generate ESC/POS commands
      final escPosBytes = _generateEscPosCommands(bitmap);
      
      return escPosBytes;
    } catch (e) {
      debugPrint('ESC/POS conversion error: $e');
      rethrow;
    }
  }

  /// Decode PNG image bytes
  static Future<ImageData?> _decodeImage(Uint8List bytes) async {
    try {
      // Use Flutter's image decoder
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      
      final width = image.width;
      final height = image.height;
      final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      
      if (byteData == null) return null;
      
      return ImageData(
        width: width,
        height: height,
        pixels: byteData.buffer.asUint8List(),
      );
    } catch (e) {
      debugPrint('Image decode error: $e');
      return null;
    }
  }

  /// Resize image to target width while maintaining aspect ratio
  static ImageData _resizeImage(ImageData image, int targetWidth) {
    // If image is already the right size, return as-is
    if (image.width == targetWidth) {
      return image;
    }
    
    // Always resize to target width for consistent printing
    final aspectRatio = image.height / image.width;
    final targetHeight = (targetWidth * aspectRatio).round();
    
    final resizedPixels = Uint8List(targetWidth * targetHeight * 4);
    
    // Simple nearest neighbor resize (faster and more reliable for thermal printing)
    for (int y = 0; y < targetHeight; y++) {
      for (int x = 0; x < targetWidth; x++) {
        final srcX = (x * image.width / targetWidth).round().clamp(0, image.width - 1);
        final srcY = (y * image.height / targetHeight).round().clamp(0, image.height - 1);
        
        final srcIndex = (srcY * image.width + srcX) * 4;
        final dstIndex = (y * targetWidth + x) * 4;
        
        if (srcIndex + 3 < image.pixels.length && dstIndex + 3 < resizedPixels.length) {
          resizedPixels[dstIndex] = image.pixels[srcIndex]; // R
          resizedPixels[dstIndex + 1] = image.pixels[srcIndex + 1]; // G
          resizedPixels[dstIndex + 2] = image.pixels[srcIndex + 2]; // B
          resizedPixels[dstIndex + 3] = image.pixels[srcIndex + 3]; // A
        }
      }
    }
    
    return ImageData(
      width: targetWidth,
      height: targetHeight,
      pixels: resizedPixels,
    );
  }

  /// Convert RGBA image to grayscale
  static ImageData _convertToGrayscale(ImageData image) {
    final grayscalePixels = Uint8List(image.width * image.height);
    
    for (int i = 0; i < image.width * image.height; i++) {
      final r = image.pixels[i * 4];
      final g = image.pixels[i * 4 + 1];
      final b = image.pixels[i * 4 + 2];
      
      // Convert to grayscale using luminance formula
      final gray = (0.299 * r + 0.587 * g + 0.114 * b).round();
      grayscalePixels[i] = gray;
    }
    
    return ImageData(
      width: image.width,
      height: image.height,
      pixels: grayscalePixels,
      isGrayscale: true,
    );
  }

  /// Convert grayscale image to 1-bit bitmap (black and white)
  static BitmapData _convertToBitmap(ImageData grayscaleImage) {
    final width = grayscaleImage.width;
    final height = grayscaleImage.height;
    
    // Calculate bytes per line (width must be multiple of 8)
    final bytesPerLine = (width / 8).ceil();
    final totalBytes = bytesPerLine * height;
    final bitmap = Uint8List(totalBytes);
    
    // Use threshold (128) to convert to black and white
    // Invert: white pixels (255) become 0, black pixels (0) become 1
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixelIndex = y * width + x;
        if (pixelIndex < grayscaleImage.pixels.length) {
          final gray = grayscaleImage.pixels[pixelIndex];
          // For thermal printers: darker pixels (lower values) should be printed
          // ESC/POS: 1 = print (black), 0 = don't print (white)
          final isBlack = gray < 128;
          
          if (isBlack) {
            final byteIndex = (y * bytesPerLine) + (x ~/ 8);
            final bitIndex = 7 - (x % 8);
            if (byteIndex < bitmap.length) {
              bitmap[byteIndex] |= (1 << bitIndex);
            }
          }
        }
      }
    }
    
    return BitmapData(
      width: width,
      height: height,
      data: bitmap,
    );
  }

  /// Generate ESC/POS commands for bitmap
  static Uint8List _generateEscPosCommands(BitmapData bitmap) {
    final List<int> commands = [];
    
    // Initialize printer (ESC @) - Reset printer to default state
    commands.add(0x1B); // ESC
    commands.add(0x40); // @
    
    // Set line spacing to 0 (ESC 3 n) - No spacing between image lines
    commands.add(0x1B); // ESC
    commands.add(0x33); // 3
    commands.add(0x00); // n = 0
    
    // ESC * command: ESC * m nL nH d1...dk
    // m = 0 (8-dot single-density), 1 (8-dot double-density), 32 (24-dot single-density), 33 (24-dot double-density)
    // We use m = 0 (8-dot single-density) for maximum compatibility
    const int m = 0;
    
    final width = bitmap.width;
    final height = bitmap.height;
    
    // Calculate bytes per line (width must be multiple of 8)
    final bytesPerLine = (width / 8).ceil();
    
    // Print each line
    for (int y = 0; y < height; y++) {
      // ESC * command for bitmap printing
      commands.add(0x1B); // ESC
      commands.add(0x2A); // *
      commands.add(m); // Mode (0 = 8-dot single-density)
      
      // nL and nH (low and high bytes of bytesPerLine)
      // Most thermal printers use little-endian for nL/nH
      commands.add(bytesPerLine & 0xFF); // nL (low byte)
      commands.add((bytesPerLine >> 8) & 0xFF); // nH (high byte)
      
      // Image data for this line
      final lineStart = y * bytesPerLine;
      for (int x = 0; x < bytesPerLine; x++) {
        final index = lineStart + x;
        if (index < bitmap.data.length) {
          commands.add(bitmap.data[index]);
        } else {
          commands.add(0); // Padding for incomplete bytes
        }
      }
    }
    
    // Reset line spacing to default (ESC 2)
    commands.add(0x1B); // ESC
    commands.add(0x32); // 2
    
    // Feed paper a few lines (ESC d n)
    commands.add(0x1B); // ESC
    commands.add(0x64); // d
    commands.add(0x03); // n = 3 lines
    
    // Cut paper (GS V m)
    // GS V 0 = Full cut, GS V 1 = Partial cut
    commands.add(0x1D); // GS
    commands.add(0x56); // V
    commands.add(0x00); // m = 0 (full cut)
    
    return Uint8List.fromList(commands);
  }
}

/// Image data structure
class ImageData {
  final int width;
  final int height;
  final Uint8List pixels;
  final bool isGrayscale;

  ImageData({
    required this.width,
    required this.height,
    required this.pixels,
    this.isGrayscale = false,
  });
}

/// Bitmap data structure
class BitmapData {
  final int width;
  final int height;
  final Uint8List data;

  BitmapData({
    required this.width,
    required this.height,
    required this.data,
  });
}
