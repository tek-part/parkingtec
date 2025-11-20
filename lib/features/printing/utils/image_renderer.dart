import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/rendering.dart';

/// Image Renderer Utility
/// Converts Widget to image bytes for printing
class ImageRenderer {
  /// Convert widget to image bytes using BuildContext
  /// This is the recommended approach with reliable rendering
  static Future<Uint8List> widgetToImageBytes(
    BuildContext context,
    Widget widget, {
    double? paperWidth,
  }) async {
    final width = paperWidth ?? 300.0;
    final globalKey = GlobalKey();

    // Build the widget tree with RepaintBoundary
    final widgetTree = RepaintBoundary(
      key: globalKey,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: Colors.white,
          child: widget,
        ),
      ),
    );

    // Render the widget in an overlay
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: -10000, // Off-screen
        top: -10000,
        child: SizedBox(
          width: width,
          child: widgetTree,
        ),
      ),
    );

    overlay.insert(overlayEntry);

    try {
      // Wait for the widget to render using post-frame callbacks
      await _waitForFrame();

      // Get render object
      final renderObject = globalKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        throw Exception('Failed to get RenderRepaintBoundary');
      }

      // Wait for another frame to ensure complete rendering
      await _waitForFrame();

      // Convert to image
      final image = await renderObject.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      return byteData.buffer.asUint8List();
    } finally {
      // Remove overlay entry
      overlayEntry.remove();
    }
  }

  /// Wait for frame to be rendered
  static Future<void> _waitForFrame() async {
    final completer = Completer<void>();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        completer.complete();
      });
    });
    
    return completer.future;
  }
}
