import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'brand_id.dart';

@immutable
class BrandTokens extends ThemeExtension<BrandTokens> {
  const BrandTokens({
    required this.brand,
    required this.canvas,
    required this.canvasRaised,
    required this.surface,
    required this.surfaceMuted,
    required this.veil,
    required this.veilStrong,
    required this.ink,
    required this.inkMuted,
    required this.hairline,
    required this.accent,
    required this.onAccent,
    required this.accentTint,
    required this.neutralAction,
    required this.positive,
    required this.caution,
    required this.negative,
    required this.shadow,
    required this.heroStart,
    required this.heroEnd,
    required this.panelRadius,
    required this.controlRadius,
    required this.veilOpacity,
    required this.veilBlur,
  });

  final BrandId brand;
  final Color canvas;
  final Color canvasRaised;
  final Color surface;
  final Color surfaceMuted;
  final Color veil;
  final Color veilStrong;
  final Color ink;
  final Color inkMuted;
  final Color hairline;
  final Color accent;
  final Color onAccent;
  final Color accentTint;
  final Color neutralAction;
  final Color positive;
  final Color caution;
  final Color negative;
  final Color shadow;
  final Color heroStart;
  final Color heroEnd;
  final double panelRadius;
  final double controlRadius;
  final double veilOpacity;
  final double veilBlur;

  static const BrandTokens fallback = BrandTokens(
    brand: BrandId.aurora,
    canvas: Color(0xFFFCFCFD),
    canvasRaised: Color(0xFFF1F3F7),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF1F3F7),
    veil: Color(0x0F0F172A),
    veilStrong: Color(0x1A0F172A),
    ink: Color(0xFF0F172A),
    inkMuted: Color(0xB30F172A),
    hairline: Color(0x220F172A),
    accent: Color(0xFF6D28D9),
    onAccent: Color(0xFFFFFFFF),
    accentTint: Color(0x226D28D9),
    neutralAction: Color(0xFF0F172A),
    positive: Color(0xFF047857),
    caution: Color(0xFFB45309),
    negative: Color(0xFFB91C1C),
    shadow: Color(0x1F0F172A),
    heroStart: Color(0xFFF5F6FA),
    heroEnd: Color(0xFFFFFFFF),
    panelRadius: 18,
    controlRadius: 14,
    veilOpacity: 0.07,
    veilBlur: 18,
  );

  @override
  BrandTokens copyWith({
    BrandId? brand,
    Color? canvas,
    Color? canvasRaised,
    Color? surface,
    Color? surfaceMuted,
    Color? veil,
    Color? veilStrong,
    Color? ink,
    Color? inkMuted,
    Color? hairline,
    Color? accent,
    Color? onAccent,
    Color? accentTint,
    Color? neutralAction,
    Color? positive,
    Color? caution,
    Color? negative,
    Color? shadow,
    Color? heroStart,
    Color? heroEnd,
    double? panelRadius,
    double? controlRadius,
    double? veilOpacity,
    double? veilBlur,
  }) {
    return BrandTokens(
      brand: brand ?? this.brand,
      canvas: canvas ?? this.canvas,
      canvasRaised: canvasRaised ?? this.canvasRaised,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      veil: veil ?? this.veil,
      veilStrong: veilStrong ?? this.veilStrong,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      hairline: hairline ?? this.hairline,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentTint: accentTint ?? this.accentTint,
      neutralAction: neutralAction ?? this.neutralAction,
      positive: positive ?? this.positive,
      caution: caution ?? this.caution,
      negative: negative ?? this.negative,
      shadow: shadow ?? this.shadow,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
      panelRadius: panelRadius ?? this.panelRadius,
      controlRadius: controlRadius ?? this.controlRadius,
      veilOpacity: veilOpacity ?? this.veilOpacity,
      veilBlur: veilBlur ?? this.veilBlur,
    );
  }

  @override
  BrandTokens lerp(ThemeExtension<BrandTokens>? other, double t) {
    if (other is! BrandTokens) return this;
    return BrandTokens(
      brand: t < 0.5 ? brand : other.brand,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      canvasRaised: Color.lerp(canvasRaised, other.canvasRaised, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      veil: Color.lerp(veil, other.veil, t)!,
      veilStrong: Color.lerp(veilStrong, other.veilStrong, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentTint: Color.lerp(accentTint, other.accentTint, t)!,
      neutralAction: Color.lerp(neutralAction, other.neutralAction, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      caution: Color.lerp(caution, other.caution, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      heroStart: Color.lerp(heroStart, other.heroStart, t)!,
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t)!,
      panelRadius: lerpDouble(panelRadius, other.panelRadius, t)!,
      controlRadius: lerpDouble(controlRadius, other.controlRadius, t)!,
      veilOpacity: lerpDouble(veilOpacity, other.veilOpacity, t)!,
      veilBlur: lerpDouble(veilBlur, other.veilBlur, t)!,
    );
  }
}

extension BrandTokensContext on BuildContext {
  BrandTokens get brandTokens =>
      Theme.of(this).extension<BrandTokens>() ?? BrandTokens.fallback;
}
