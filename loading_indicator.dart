import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'Outer/loading_outer_indicator.dart';
import 'inner/loading_inner_indicator.dart';
import 'outer/config/loading_outer_config.dart';


// ============================================
// 3. Main Loading Indicator (전체 위젯)
// ============================================
class LoadingIndicator extends StatefulWidget {
  final double size;
  final Widget? innerChild;
  final int rotationSpeed;
  final List<LoadingOuterConfig> outerConfigs;

  const LoadingIndicator({
    super.key,
    required this.size,
    this.innerChild,
    required this.rotationSpeed,
    this.outerConfigs = const [],
  });

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
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
  void didUpdateWidget(LoadingIndicator oldWidget) {
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
    // 가장 큰 outerRadius 찾기
    double maxRadius = widget.size / 2;
    for (var config in widget.outerConfigs) {
      if (config.outerRadius > maxRadius) {
        maxRadius = config.outerRadius;
      }
    }

    return SizedBox(
      width: maxRadius * 2,
      height: maxRadius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer indicators (역순으로 그려서 첫 번째가 위에)
          ...widget.outerConfigs.reversed.map((config) {
            return LoadingOuterIndicator(
              outerRadius: config.outerRadius,
              innerRadius: config.innerRadius,
              elevation: config.elevation,
              borderColor: config.borderColor,
              borderWidth: config.borderWidth,
              strokeCap: config.strokeCap,
              fillColor: config.fillColor,
              fragments: config.fragments,
              fragmentsSpaceLength: config.fragmentsSpaceLength,
              controller: _controller,
            );
          }),
          // Inner indicator (중앙)
          LoadingInnerIndicator(
            size: widget.size,
            rotationSpeed: widget.rotationSpeed,
            child: widget.innerChild,
          ),
        ],
      ),
    );
  }
}