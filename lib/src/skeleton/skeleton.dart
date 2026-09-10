import 'package:flutter/material.dart';

import '../brand_tokens.dart';
import '../motion/motion_policy.dart';

class SkeletonShimmer extends StatefulWidget {
  const SkeletonShimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.period = const Duration(milliseconds: 1400),
  });

  final Widget child;
  final bool enabled;
  final Duration period;

  @override
  State<SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant SkeletonShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    final animate = widget.enabled && !MotionPolicy.shouldReduce(context);
    if (animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!animate && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.brandTokens;
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + 2.0 * t - 1.0, 0),
              end: Alignment(-1.0 + 2.0 * t + 1.0, 0),
              colors: [
                tokens.veilStrong,
                tokens.veil.withValues(alpha: 0.02),
                tokens.veilStrong,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 16, this.radius});

  final double? width;
  final double height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.brandTokens;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: tokens.veilStrong,
        borderRadius: BorderRadius.circular(radius ?? tokens.controlRadius / 2),
      ),
    );
  }
}

class SkeletonLines extends StatelessWidget {
  const SkeletonLines({
    super.key,
    this.lines = 3,
    this.lineHeight = 12,
    this.gap = 8,
    this.lastLineFraction = 0.6,
  });

  final int lines;
  final double lineHeight;
  final double gap;
  final double lastLineFraction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final full = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 240.0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < lines; i++) ...[
              SkeletonBox(
                width: i == lines - 1 ? full * lastLineFraction : full,
                height: lineHeight,
              ),
              if (i < lines - 1) SizedBox(height: gap),
            ],
          ],
        );
      },
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.showAvatar = true});

  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final tokens = context.brandTokens;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.panelRadius),
        border: Border.all(color: tokens.hairline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            const SkeletonBox(width: 44, height: 44, radius: 22),
            const SizedBox(width: 12),
          ],
          const Expanded(child: SkeletonLines()),
        ],
      ),
    );
  }
}
