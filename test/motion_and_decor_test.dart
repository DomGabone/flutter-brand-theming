import 'package:brand_theming/brand_theming.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MotionPolicy', () {
    testWidgets('reduz movimento quando o sistema pede', (tester) async {
      late bool reduced;
      late Duration duration;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              reduced = MotionPolicy.shouldReduce(context);
              duration = MotionPolicy.durationFor(context, MotionPolicy.enter);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(reduced, isTrue);
      expect(duration, Duration.zero);
    });

    testWidgets('sem MediaQuery nao reduz', (tester) async {
      late bool reduced;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            reduced = MotionPolicy.shouldReduce(context);
            return const SizedBox();
          },
        ),
      );
      expect(reduced, isFalse);
    });

    test('SoftPageRoute zera a duracao quando reduzido', () {
      final route = SoftPageRoute<void>(
        builder: (_) => const SizedBox(),
        reduceMotion: true,
      );
      expect(route.transitionDuration, Duration.zero);
      expect(route.reverseTransitionDuration, Duration.zero);

      final animated = SoftPageRoute<void>(
        builder: (_) => const SizedBox(),
        reduceMotion: false,
      );
      expect(animated.transitionDuration, MotionPolicy.enter);
    });
  });

  group('SeededRandom', () {
    test('mesma semente produz a mesma sequencia', () {
      final a = SeededRandom(42);
      final b = SeededRandom(42);
      for (var i = 0; i < 50; i++) {
        expect(a.nextDouble(), b.nextDouble());
      }
    });

    test('sementes diferentes divergem e valores ficam no intervalo', () {
      final a = SeededRandom(1);
      final b = SeededRandom(2);
      var equal = 0;
      for (var i = 0; i < 20; i++) {
        final x = a.nextDouble();
        final y = b.nextDouble();
        expect(x, inInclusiveRange(0.0, 1.0));
        if (x == y) equal++;
        expect(a.nextInt(7), inInclusiveRange(0, 6));
      }
      expect(equal, lessThan(20));
    });

    test('semente nao positiva e normalizada em vez de travar', () {
      expect(() => SeededRandom(0).nextBool(), returnsNormally);
      expect(() => SeededRandom(-9).nextInt(3), returnsNormally);
    });
  });

  group('CircuitTracesPainter', () {
    test('shouldRepaint reage a qualquer parametro visual', () {
      const base = CircuitTracesPainter(color: Colors.teal);
      expect(
        base.shouldRepaint(const CircuitTracesPainter(color: Colors.teal)),
        isFalse,
      );
      expect(
        base.shouldRepaint(
          const CircuitTracesPainter(color: Colors.teal, seed: 3),
        ),
        isTrue,
      );
      expect(
        base.shouldRepaint(const CircuitTracesPainter(color: Colors.red)),
        isTrue,
      );
      expect(
        base.shouldRepaint(
          const CircuitTracesPainter(color: Colors.teal, traceCount: 9),
        ),
        isTrue,
      );
    });

    testWidgets('background pinta sem erro e ignora toques', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 200,
            height: 200,
            child: CircuitTracesBackground(color: Colors.teal),
          ),
        ),
      );
      expect(find.byType(IgnorePointer), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  group('Skeleton', () {
    testWidgets('SkeletonLines respeita a quantidade e a ultima linha curta', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: BrandThemeFactory.build(BrandId.aurora),
          home: const Scaffold(
            body: SizedBox(width: 200, child: SkeletonLines(lines: 4)),
          ),
        ),
      );
      final boxes = tester
          .widgetList<SkeletonBox>(find.byType(SkeletonBox))
          .toList();
      expect(boxes.length, 4);
      expect(boxes.last.width, closeTo(120, 0.5));
      expect(boxes.first.width, closeTo(200, 0.5));
    });

    testWidgets('shimmer nao anima com movimento reduzido', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            theme: BrandThemeFactory.build(BrandId.coral),
            home: const Scaffold(body: SkeletonShimmer(child: SkeletonCard())),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('shimmer anima quando permitido', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: BrandThemeFactory.build(BrandId.coral),
          home: const Scaffold(body: SkeletonShimmer(child: SkeletonCard())),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.hasRunningAnimations, isTrue);
    });
  });
}
