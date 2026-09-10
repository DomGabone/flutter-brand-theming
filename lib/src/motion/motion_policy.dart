import 'package:flutter/material.dart';

class MotionPolicy {
  const MotionPolicy._();

  static const Duration enter = Duration(milliseconds: 300);
  static const Duration exit = Duration(milliseconds: 220);

  static bool shouldReduce(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    if (media == null) return false;
    return media.disableAnimations || media.accessibleNavigation;
  }

  static Duration durationFor(BuildContext context, Duration full) {
    return shouldReduce(context) ? Duration.zero : full;
  }

  static Widget softTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(curved);
    final scale = Tween<double>(begin: 0.99, end: 1.0).animate(curved);

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: slide,
        child: ScaleTransition(scale: scale, child: child),
      ),
    );
  }
}
