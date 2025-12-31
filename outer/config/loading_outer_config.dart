import 'dart:ui';

// ============================================
// 4. Configuration Class
// ============================================

class LoadingOuterConfig {
  final double outerRadius;
  final double innerRadius;
  final double elevation;
  final Color? borderColor;
  final double borderWidth;
  final StrokeCap strokeCap;
  final Color? fillColor;
  final Gradient? gradient;
  final int fragments;
  final double fragmentsSpaceLength;

  const LoadingOuterConfig({
    required this.outerRadius,
    required this.innerRadius,
    this.elevation = 0,
    this.borderColor,
    this.borderWidth = 0,
    this.strokeCap = StrokeCap.round,
    this.fillColor,
    this.gradient,
    this.fragments = 1,
    this.fragmentsSpaceLength = 0,
  });
}
