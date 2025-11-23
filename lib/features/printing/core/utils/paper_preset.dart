/// Paper Preset Enum
/// Defines standard paper widths for thermal printers
enum PaperPreset {
  /// 58mm paper width (256 pixels at 8-dot single-density)
  mm58,

  /// 80mm paper width (384 pixels at 8-dot single-density)
  mm80,

  /// 110mm paper width (528 pixels at 8-dot single-density)
  mm110;

  /// Get paper width in pixels (8-dot single-density mode)
  int get width {
    switch (this) {
      case PaperPreset.mm58:
        return 256;
      case PaperPreset.mm80:
        return 384;
      case PaperPreset.mm110:
        return 528;
    }
  }

  /// Get paper width in millimeters
  double get widthMm {
    switch (this) {
      case PaperPreset.mm58:
        return 58.0;
      case PaperPreset.mm80:
        return 80.0;
      case PaperPreset.mm110:
        return 110.0;
    }
  }
}
