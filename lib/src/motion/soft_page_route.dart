import 'package:flutter/material.dart';

import 'motion_policy.dart';

class SoftPageRoute<T> extends PageRouteBuilder<T> {
  SoftPageRoute({
    required WidgetBuilder builder,
    required bool reduceMotion,
    super.settings,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) =>
             builder(context),
         transitionDuration: reduceMotion ? Duration.zero : MotionPolicy.enter,
         reverseTransitionDuration: reduceMotion
             ? Duration.zero
             : MotionPolicy.exit,
         transitionsBuilder: reduceMotion
             ? _noTransition
             : MotionPolicy.softTransition,
       );

  static SoftPageRoute<T> of<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) {
    return SoftPageRoute<T>(
      builder: builder,
      reduceMotion: MotionPolicy.shouldReduce(context),
      settings: settings,
    );
  }

  static Widget _noTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}
