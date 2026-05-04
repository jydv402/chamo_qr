import 'package:flutter/material.dart';

class AnimatedScannerFrame extends StatefulWidget {
  final double width;
  final double height;
  final double cornerLength;
  final double cornerWidth;
  final bool isScanning;

  const AnimatedScannerFrame({
    super.key,
    this.width = 250,
    this.height = 250,
    this.cornerLength = 32,
    this.cornerWidth = 4,
    this.isScanning = true,
  });

  @override
  State<AnimatedScannerFrame> createState() => _AnimatedScannerFrameState();
}

class _AnimatedScannerFrameState extends State<AnimatedScannerFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.isScanning) {
      _animationController.repeat(reverse: true);
    }

    // Margin from top/bottom inside the container
    const double margin = 24;
    // Height of the scanning line itself
    const double lineHeight = 4.0;

    // Animate from top margin to bottom margin
    _positionAnimation =
        Tween<double>(
          begin: margin,
          end: widget.height - margin - lineHeight,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOutSine,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedScannerFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning != oldWidget.isScanning) {
      if (widget.isScanning) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Corner accents
          _buildCorner(Alignment.topLeft),
          _buildCorner(Alignment.topRight),
          _buildCorner(Alignment.bottomLeft),
          _buildCorner(Alignment.bottomRight),

          // Animated scanning line
          AnimatedBuilder(
            animation: _positionAnimation,
            builder: (context, child) {
              return Positioned(
                top: _positionAnimation.value,
                left: 16,
                right: 16,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: widget.cornerLength,
        height: widget.cornerLength,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: _getBorder(alignment),
          borderRadius: _getBorderRadius(alignment),
        ),
      ),
    );
  }

  Border _getBorder(Alignment alignment) {
    BorderSide b = BorderSide(color: Colors.white, width: widget.cornerWidth);
    if (alignment == Alignment.topLeft) return Border(top: b, left: b);
    if (alignment == Alignment.topRight) return Border(top: b, right: b);
    if (alignment == Alignment.bottomLeft) {
      return Border(bottom: b, left: b);
    }
    return Border(bottom: b, right: b); // bottomRight
  }

  BorderRadius _getBorderRadius(Alignment alignment) {
    const r = Radius.circular(18);
    if (alignment == Alignment.topLeft) {
      return const BorderRadius.only(topLeft: r);
    }
    if (alignment == Alignment.topRight) {
      return const BorderRadius.only(topRight: r);
    }
    if (alignment == Alignment.bottomLeft) {
      return const BorderRadius.only(bottomLeft: r);
    }
    return const BorderRadius.only(bottomRight: r);
  }
}
