import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Word-by-word blur-in (from cinematic prompt spec).
class BlurText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final WrapAlignment alignment;
  final Duration staggerDelay;
  final Duration initialDelay;

  const BlurText({
    super.key,
    required this.text,
    this.style,
    this.alignment = WrapAlignment.center,
    this.staggerDelay = const Duration(milliseconds: 90),
    this.initialDelay = Duration.zero,
  });

  @override
  State<BlurText> createState() => _BlurTextState();
}

class _BlurTextState extends State<BlurText> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    final words = widget.text.split(' ');
    _controllers = List.generate(
      words.length,
      (_) => AnimationController(
          vsync: this, duration: const Duration(milliseconds: 700)),
    );
    _anims = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < _controllers.length; i++) {
        Future.delayed(
            widget.initialDelay + widget.staggerDelay * i,
            () { if (mounted) _controllers[i].forward(); });
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.text.split(' ');
    final fs = widget.style?.fontSize ?? 16.0;
    return Wrap(
      alignment: widget.alignment,
      runAlignment: WrapAlignment.center,
      runSpacing: fs * 0.1,
      children: List.generate(words.length, (i) {
        return AnimatedBuilder(
          animation: _anims[i],
          builder: (_, __) {
            final t = _anims[i].value;
            final double blur, opacity, dy;
            if (t <= 0.5) {
              final s = t / 0.5;
              blur = 10.0 - 5.0 * s;
              opacity = 0.5 * s;
              dy = 50.0 - 55.0 * s;
            } else {
              final s = (t - 0.5) / 0.5;
              blur = 5.0 - 5.0 * s;
              opacity = 0.5 + 0.5 * s;
              dy = -5.0 + 5.0 * s;
            }
            return Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, dy),
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                      sigmaX: blur, sigmaY: blur, tileMode: TileMode.decal),
                  child: Padding(
                    padding: EdgeInsets.only(right: fs * 0.28),
                    child: Text(words[i], style: widget.style),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
