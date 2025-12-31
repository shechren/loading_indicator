import 'dart:math' as math;
import 'package:flutter/material.dart';

// ============================================
// 2. outer Ring Widget (외부 장식 위젯)
// ============================================
class LoadingOuterIndicator extends StatelessWidget {
  final double outerRadius;
  final double innerRadius;
  final double elevation;
  final Color? borderColor;
  final double borderWidth;
  final StrokeCap strokeCap;
  final Color? fillColor;
  final Gradient? gradient;
  final int fragments; // 1-16
  final double fragmentsSpaceLength; // 조각 사이 간격 (라디안)
  final AnimationController controller;

  const LoadingOuterIndicator({
    super.key,
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
    required this.controller,
  }) : assert(fragments >= 1 && fragments <= 16),
        assert(innerRadius < outerRadius);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2 * math.pi,
          child: CustomPaint(
            size: Size(outerRadius * 2, outerRadius * 2),
            painter: _OuterRingPainter(
              outerRadius: outerRadius,
              innerRadius: innerRadius,
              elevation: elevation,
              borderColor: borderColor,
              borderWidth: borderWidth,
              strokeCap: strokeCap,
              fillColor: fillColor,
              gradient: gradient,
              fragments: fragments,
              fragmentsSpaceLength: fragmentsSpaceLength,
            ),
          ),
        );
      },
    );
  }
}

class _OuterRingPainter extends CustomPainter {
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

  _OuterRingPainter({
    required this.outerRadius,
    required this.innerRadius,
    required this.elevation,
    this.borderColor,
    required this.borderWidth,
    required this.strokeCap,
    this.fillColor,
    this.gradient,
    required this.fragments,
    required this.fragmentsSpaceLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Elevation (그림자)
    if (elevation > 0) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, elevation);

      _drawFragments(canvas, center, shadowPaint, isElevation: true);
    }

    // 메인 도넛 그리기
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor ?? Colors.blue;

    if (gradient != null) {
      paint.shader = gradient!.createShader(
        Rect.fromCircle(center: center, radius: outerRadius),
      );
    }

    _drawFragments(canvas, center, paint);

    // Border
    if (borderWidth > 0 && borderColor != null) {
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..strokeCap = strokeCap
        ..color = borderColor!;

      _drawFragments(canvas, center, borderPaint, isBorder: true);
    }
  }

  void _drawFragments(Canvas canvas, Offset center, Paint paint, {bool isElevation = false, bool isBorder = false}) {
    final sweepAngle = (2 * math.pi / fragments) - fragmentsSpaceLength;

    for (int i = 0; i < fragments; i++) {
      final startAngle = (2 * math.pi / fragments) * i - math.pi / 2;

      final path = Path();

      if (isBorder) {
        // Border는 외곽선만
        path.addArc(
          Rect.fromCircle(center: center, radius: outerRadius),
          startAngle,
          sweepAngle,
        );
        path.arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          startAngle + sweepAngle,
          -sweepAngle,
          false,
        );
        path.close();
      } else {
        // 외부 호
        path.addArc(
          Rect.fromCircle(center: center, radius: outerRadius),
          startAngle,
          sweepAngle,
        );

        // 내부 호 (반대 방향)
        path.arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          startAngle + sweepAngle,
          -sweepAngle,
          false,
        );

        path.close();
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OuterRingPainter oldDelegate) {
    return oldDelegate.outerRadius != outerRadius ||
        oldDelegate.innerRadius != innerRadius ||
        oldDelegate.elevation != elevation ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.fragments != fragments ||
        oldDelegate.fragmentsSpaceLength != fragmentsSpaceLength;
  }
}
