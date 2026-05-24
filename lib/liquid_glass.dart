import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlass extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? tint;

  const LiquidGlass({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.tint,
  });

  @override
  Widget build(BuildContext context) => _GlassBox(
        borderRadius: borderRadius ?? BorderRadius.circular(9999),
        blur: 8,
        bgColor: tint ?? Colors.white.withOpacity(0.04),
        borderStops: const [0.45, 0.15, 0.0, 0.0, 0.15, 0.45],
        padding: padding,
        width: width,
        height: height,
        child: child,
      );
}

class LiquidGlassStrong extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? tint;

  const LiquidGlassStrong({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.tint,
  });

  @override
  Widget build(BuildContext context) => _GlassBox(
        borderRadius: borderRadius ?? BorderRadius.circular(9999),
        blur: 40,
        bgColor: tint ?? Colors.white.withOpacity(0.07),
        borderStops: const [0.5, 0.2, 0.0, 0.0, 0.2, 0.5],
        padding: padding,
        child: child,
      );
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final double blur;
  final Color bgColor;
  final List<double> borderStops;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const _GlassBox({
    required this.child,
    required this.borderRadius,
    required this.blur,
    required this.bgColor,
    required this.borderStops,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: bgColor,
          ),
          child: CustomPaint(
            painter: _BorderPainter(
                borderRadius: borderRadius, stops: borderStops),
            child: padding != null
                ? Padding(padding: padding!, child: child)
                : child,
          ),
        ),
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final List<double> stops;
  const _BorderPainter({required this.borderRadius, required this.stops});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: stops.map((o) => Colors.white.withOpacity(o)).toList(),
        stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawRRect(borderRadius.toRRect(rect), paint);
  }

  @override
  bool shouldRepaint(_BorderPainter old) => false;
}
