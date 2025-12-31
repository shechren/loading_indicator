import 'dart:math' as math;
import 'package:flutter/material.dart';

// ============================================
// 1. inner Circle Widget (중앙 위젯)
// ============================================
class LoadingInnerIndicator extends StatefulWidget {
  final double size;
  final Widget? child;
  final int rotationSpeed; // 밀리초 단위 (1000 = 1초에 1바퀴)

  const LoadingInnerIndicator({
    super.key,
    required this.size,
    this.child,
    this.rotationSpeed = 1000,
  }) : assert(rotationSpeed >= 100 && rotationSpeed <= 5000);

  @override
  State<LoadingInnerIndicator> createState() => _LoadingInnerIndicatorState();
}

class _LoadingInnerIndicatorState extends State<LoadingInnerIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.rotationSpeed),
    )..repeat();
  }

  @override
  void didUpdateWidget(LoadingInnerIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rotationSpeed != widget.rotationSpeed) {
      _controller.duration = Duration(milliseconds: widget.rotationSpeed);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.child == null ? Colors.transparent : null,
        ),
        child: widget.child,
      ),
    );
  }
}
