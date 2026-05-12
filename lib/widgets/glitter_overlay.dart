import 'package:flutter/material.dart';
import 'dart:math' as math;

class GlitterOverlay extends StatefulWidget {
  final Widget child;
  final bool isAnimating;

  const GlitterOverlay({
    super.key,
    required this.child,
    this.isAnimating = false,
  });

  @override
  State<GlitterOverlay> createState() => _GlitterOverlayState();
}

class _GlitterOverlayState extends State<GlitterOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(GlitterOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnimating) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.white.withValues(alpha: 0.0),
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.4),
                Colors.white.withValues(alpha: 0.6),
                Colors.white.withValues(alpha: 0.4),
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.2, 0.45, 0.5, 0.55, 0.8, 1.0],
              transform: _SlidingGradientTransform(_controller.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Stack(
            alignment: Alignment.center,
            children: [
              widget.child,
              // Adding a second layer for "glittering" spots
              IgnorePointer(
                child: CustomPaint(
                  painter: _GlitterPainter(
                    progress: _controller.value,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  size: Size.infinite,
                ),
              ),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double progress;

  const _SlidingGradientTransform(this.progress);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    // We want to slide it from bottom-left to top-right.
    // The progress goes from 0 to 1 and then reverses.
    // We offset it so that at 0 it's starting to enter from bottom-left,
    // and at 1 it's leaving through top-right.
    final double offset = (progress * 2 - 1);
    return Matrix4.translationValues(
      offset * bounds.width,
      -offset * bounds.height,
      0,
    );
  }
}

class _GlitterPainter extends CustomPainter {
  final double progress;
  final Color color;

  _GlitterPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final random = math.Random(42); // Fixed seed for consistent dots

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      // Each dot has its own phase
      final phase = random.nextDouble();
      final opacity = (math.sin((progress + phase) * 2 * math.pi) + 1) / 2;

      if (opacity > 0.8) {
        final radius = random.nextDouble() * 2 + 1;
        canvas.drawCircle(
          Offset(x, y),
          radius,
          paint..color = color.withValues(alpha: (opacity - 0.8) * 5 * color.a),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_GlitterPainter oldDelegate) => true;
}
