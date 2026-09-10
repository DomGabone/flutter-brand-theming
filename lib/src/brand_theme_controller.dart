import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'brand_id.dart';
import 'brand_theme_factory.dart';

class BrandThemeController extends ChangeNotifier
    implements ValueListenable<ThemeData> {
  BrandThemeController({BrandId initial = BrandId.aurora})
    : _brand = initial,
      _theme = BrandThemeFactory.build(initial);

  BrandId _brand;
  ThemeData _theme;
  int _rebuilds = 0;

  BrandId get brand => _brand;

  @override
  ThemeData get value => _theme;

  int get rebuildCount => _rebuilds;

  void select(BrandId brand) {
    if (brand == _brand) return;
    _brand = brand;
    _theme = BrandThemeFactory.build(brand);
    _rebuilds++;
    notifyListeners();
  }

  void selectFromCode(String? code) => select(BrandId.fromCode(code));
}

class BrandThemeScope extends StatelessWidget {
  const BrandThemeScope({
    super.key,
    required this.controller,
    required this.builder,
  });

  final BrandThemeController controller;
  final Widget Function(BuildContext context, ThemeData theme) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: controller,
      builder: (context, theme, _) => builder(context, theme),
    );
  }
}
