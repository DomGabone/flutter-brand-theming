import 'dart:math' as math;

import 'package:brand_theming/brand_theming.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double _contrast(Color a, Color b) {
  double channel(double c) =>
      c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  double luminance(Color c) =>
      0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
  final la = luminance(a);
  final lb = luminance(b);
  final light = math.max(la, lb);
  final dark = math.min(la, lb);
  return (light + 0.05) / (dark + 0.05);
}

void main() {
  group('BrandThemeFactory', () {
    test(
      'cada marca tem accent proprio e o resto da paleta e compartilhado',
      () {
        final themes = {
          for (final b in BrandId.values) b: BrandThemeFactory.tokensFor(b),
        };
        final accents = themes.values.map((t) => t.accent).toSet();
        expect(accents.length, BrandId.values.length);
        final inks = themes.values.map((t) => t.ink).toSet();
        expect(inks.length, 1);
      },
    );

    test('todo accent passa em WCAG AA como texto branco sobre accent', () {
      for (final brand in BrandId.values) {
        final tokens = BrandThemeFactory.tokensFor(brand);
        final ratio = _contrast(tokens.accent, tokens.onAccent);
        expect(ratio, greaterThanOrEqualTo(4.5), reason: brand.label);
      }
    });

    test('ThemeData carrega a extension da marca correta', () {
      final theme = BrandThemeFactory.build(BrandId.basalto);
      final tokens = theme.extension<BrandTokens>();
      expect(tokens, isNotNull);
      expect(tokens!.brand, BrandId.basalto);
      expect(theme.colorScheme.secondary, tokens.accent);
      expect(theme.colorScheme.primary, tokens.neutralAction);
    });
  });

  group('BrandThemeController', () {
    test('so notifica e reconstroi quando a marca muda de fato', () {
      final controller = BrandThemeController();
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.select(BrandId.aurora);
      controller.selectFromCode('aurora');
      expect(notifications, 0);
      expect(controller.rebuildCount, 0);

      controller.select(BrandId.coral);
      controller.selectFromCode('coral');
      expect(notifications, 1);
      expect(controller.rebuildCount, 1);
      expect(controller.value.extension<BrandTokens>()!.brand, BrandId.coral);
    });
  });
}
