import 'package:flutter/material.dart';

import 'seeded_random.dart';

class CircuitTracesPainter extends CustomPainter {
  const CircuitTracesPainter({
    required this.color,
    this.opacity = 0.12,
    this.seed = 11,
    this.strokeWidth = 1.2,
    this.traceCount = 5,
  });

  final Color color;
  final double opacity;
  final int seed;
  final double strokeWidth;
  final int traceCount;

  @override
  void paint(Canvas canvas, Size size) {
    final random = SeededRandom(seed);
    final line = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final node = Paint()..color = color.withValues(alpha: opacity * 1.8);

    for (var t = 0; t < traceCount; t++) {
      final path = Path();
      var x = random.nextDouble() * size.width;
      var y = random.nextDouble() * size.height;
      path.moveTo(x, y);
      canvas.drawCircle(Offset(x, y), 2.2, node);

      final segments = 2 + random.nextInt(3);
      for (var s = 0; s < segments; s++) {
        final horizontal = random.nextBool();
        final span = horizontal ? size.width : size.height;
        final direction = random.nextBool() ? 1 : -1;
        final delta = (random.nextDouble() * 0.5 + 0.18) * span * direction;
        if (horizontal) {
          x = (x + delta).clamp(0.0, size.width);
        } else {
          y = (y + delta).clamp(0.0, size.height);
        }
        path.lineTo(x, y);
        final isLast = s == segments - 1;
        canvas.drawCircle(Offset(x, y), isLast ? 2.8 : 1.6, node);
      }
      canvas.drawPath(path, line);
    }
  }

  @override
  bool shouldRepaint(covariant CircuitTracesPainter old) =>
      old.color != color ||
      old.opacity != opacity ||
      old.seed != seed ||
      old.strokeWidth != strokeWidth ||
      old.traceCount != traceCount;
}

class CircuitTracesBackground extends StatelessWidget {
  const CircuitTracesBackground({
    super.key,
    required this.color,
    this.opacity = 0.12,
    this.seed = 11,
    this.traceCount = 5,
  });

  final Color color;
  final double opacity;
  final int seed;
  final int traceCount;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: CircuitTracesPainter(
          color: color,
          opacity: opacity,
          seed: seed,
          traceCount: traceCount,
        ),
        size: Size.infinite,
      ),
    );
  }
}
