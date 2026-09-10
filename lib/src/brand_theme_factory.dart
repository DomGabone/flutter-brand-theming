import 'package:flutter/material.dart';

import 'brand_id.dart';
import 'brand_tokens.dart';

class BrandThemeFactory {
  const BrandThemeFactory._();

  static const Color _ink = Color(0xFF0F172A);
  static const Color _white = Color(0xFFFFFFFF);

  static const Map<BrandId, Color> accents = <BrandId, Color>{
    BrandId.aurora: Color(0xFF6D28D9),
    BrandId.basalto: Color(0xFF0F766E),
    BrandId.coral: Color(0xFFBE123C),
  };

  static BrandTokens tokensFor(BrandId brand) {
    final accent = accents[brand]!;
    return BrandTokens.fallback.copyWith(
      brand: brand,
      accent: accent,
      accentTint: accent.withValues(alpha: 0.13),
    );
  }

  static ThemeData build(BrandId brand) {
    final tokens = tokensFor(brand);

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: tokens.canvas,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: tokens.neutralAction,
        onPrimary: _white,
        secondary: tokens.accent,
        onSecondary: tokens.onAccent,
        error: tokens.negative,
        onError: _white,
        surface: tokens.canvas,
        onSurface: tokens.ink,
      ),
    );

    final panelShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(tokens.panelRadius),
      side: BorderSide(color: tokens.hairline),
    );
    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(tokens.controlRadius),
    );
    OutlineInputBorder inputBorder(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(tokens.controlRadius),
      borderSide: BorderSide(color: color),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.canvas,
        foregroundColor: tokens.ink,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(color: tokens.hairline),
      cardTheme: CardThemeData(
        color: tokens.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: panelShape,
      ),
      textTheme: _textTheme(base.textTheme, tokens),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.surfaceMuted.withValues(alpha: 0.75),
        hintStyle: TextStyle(color: tokens.inkMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: inputBorder(tokens.hairline),
        enabledBorder: inputBorder(tokens.hairline),
        focusedBorder: inputBorder(tokens.neutralAction.withValues(alpha: 0.7)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 52)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return tokens.neutralAction.withValues(alpha: 0.4);
            }
            if (states.contains(WidgetState.pressed)) {
              return Color.alphaBlend(
                _white.withValues(alpha: 0.1),
                tokens.neutralAction,
              );
            }
            return tokens.neutralAction;
          }),
          foregroundColor: const WidgetStatePropertyAll(_white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.controlRadius + 2),
            ),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
          foregroundColor: WidgetStatePropertyAll(tokens.ink),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            final alpha = states.contains(WidgetState.pressed) ? 0.6 : 0.3;
            return tokens.veilStrong.withValues(alpha: alpha);
          }),
          side: WidgetStateProperty.resolveWith((states) {
            final focused =
                states.contains(WidgetState.focused) ||
                states.contains(WidgetState.hovered);
            return BorderSide(
              color: focused
                  ? tokens.neutralAction.withValues(alpha: 0.5)
                  : tokens.hairline,
            );
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.controlRadius + 2),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tokens.ink,
          shape: controlShape,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? tokens.neutralAction
              : tokens.veilStrong;
        }),
        checkColor: const WidgetStatePropertyAll(_white),
        side: BorderSide(color: tokens.hairline),
      ),
      iconTheme: IconThemeData(color: tokens.ink),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: tokens.canvasRaised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
        indicatorColor: tokens.accent.withValues(alpha: 0.16),
        indicatorShape: const StadiumBorder(),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? tokens.accent : tokens.inkMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? tokens.accent : tokens.inkMuted,
            size: selected ? 24 : 22,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tokens.accent,
        foregroundColor: tokens.onAccent,
        elevation: 3,
        shape: const StadiumBorder(),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: tokens.canvasRaised,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        dragHandleColor: tokens.hairline,
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: tokens.canvasRaised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: panelShape,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _ink,
        contentTextStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _white,
        ),
        actionTextColor: _white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: tokens.surfaceMuted,
        selectedColor: tokens.accent.withValues(alpha: 0.18),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: tokens.ink,
        ),
        side: BorderSide(color: tokens.hairline),
        shape: const StadiumBorder(),
      ),
      extensions: <ThemeExtension<dynamic>>[tokens],
    );
  }

  static TextTheme _textTheme(TextTheme base, BrandTokens tokens) {
    return base.copyWith(
      displayLarge: TextStyle(
        fontSize: 52,
        height: 1.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.6,
        color: tokens.ink,
      ),
      headlineMedium: TextStyle(
        fontSize: 30,
        height: 1.1,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        color: tokens.ink,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: tokens.ink,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: tokens.ink,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.45, color: tokens.ink),
      bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: tokens.inkMuted),
      bodySmall: TextStyle(fontSize: 12, height: 1.4, color: tokens.inkMuted),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: tokens.ink,
      ),
    );
  }
}
