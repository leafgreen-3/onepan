import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';

enum SkeletonShape { rect, circle }

class AppSkeleton extends StatefulWidget {
  const AppSkeleton.rect({
    super.key,
    this.width,
    this.height,
    this.radius = AppRadii.md,
  })  : shape = SkeletonShape.rect,
        size = null;

  const AppSkeleton.circle({
    super.key,
    this.size,
  })  : shape = SkeletonShape.circle,
        width = null,
        height = null,
        radius = AppRadii.md;

  final SkeletonShape shape;
  final double? width;
  final double? height;
  final double? size; // for circle
  final double radius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.shimmerPeriod,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final base = scheme.surfaceContainerHigh;
    final highlight = scheme.surfaceContainerHighest;

    final Widget shape = widget.shape == SkeletonShape.circle
        ? Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: base,
              shape: BoxShape.circle,
            ),
          )
        : Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          );

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double t = _controller.value;
          final double dx = lerpDouble(
              AppEffects.shimmerTranslateStart, AppEffects.shimmerTranslateEnd, t);
          return ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: const Alignment(-1, 0),
                end: const Alignment(1, 0),
                colors: [
                  base,
                  highlight.withValues(
                      alpha: math.min(AppOpacity.max, AppOpacity.shimmerHighlight)),
                  base,
                ],
                stops: AppEffects.shimmerStops,
                transform: GradientTranslation(dx * rect.width),
              ).createShader(rect);
            },
            blendMode: BlendMode.srcATop,
            child: child,
          );
        },
        child: shape,
      ),
    );
  }

  double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

class GradientTranslation extends GradientTransform {
  const GradientTranslation(this.dx);
  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()..setTranslationRaw(dx, 0.0, 0.0);
  }
}
