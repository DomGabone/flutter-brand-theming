import 'package:brand_theming/brand_theming.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BrandTokens', () {
    test('lerp interpola cores e escalares e troca a marca na metade', () {
      final a = BrandThemeFactory.tokensFor(BrandId.aurora);
      final b = BrandThemeFactory.tokensFor(
        BrandId.coral,
      ).copyWith(panelRadius: 30);

      final quarter = a.lerp(b, 0.25);
      final threeQuarters = a.lerp(b, 0.75);

      expect(quarter.brand, BrandId.aurora);
      expect(threeQuarters.brand, BrandId.coral);
      expect(quarter.panelRadius, closeTo(21, 0.001));
      expect(quarter.accent, Color.lerp(a.accent, b.accent, 0.25));
    });

    test('lerp com tipo diferente devolve o proprio token', () {
      final a = BrandThemeFactory.tokensFor(BrandId.basalto);
      expect(identical(a.lerp(null, 0.5), a), isTrue);
    });

    test('copyWith preserva o que nao foi informado', () {
      final base = BrandTokens.fallback;
      final copy = base.copyWith(accent: const Color(0xFF123456));
      expect(copy.accent, const Color(0xFF123456));
      expect(copy.ink, base.ink);
      expect(copy.panelRadius, base.panelRadius);
    });

    testWidgets('extension no contexto cai no fallback sem tema', (
      tester,
    ) async {
      late BrandTokens seen;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            seen = context.brandTokens;
            return const SizedBox();
          },
        ),
      );
      expect(seen, BrandTokens.fallback);
    });
  });

  group('BrandId', () {
    test('fromCode aceita maiusculas e espacos, com fallback', () {
      expect(BrandId.fromCode(' CORAL '), BrandId.coral);
      expect(BrandId.fromCode('desconhecida'), BrandId.aurora);
      expect(
        BrandId.fromCode(null, fallback: BrandId.basalto),
        BrandId.basalto,
      );
    });
  });
}
