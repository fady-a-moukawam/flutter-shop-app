import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Check if the route is the initial route
    final isInitialRoute = ModalRoute.of(context)?.isFirst ?? false;

    // If it's the initial route, use the default MaterialPageRoute transition
    if (isInitialRoute) {
      return super
          .buildTransitions(context, animation, secondaryAnimation, child);
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );

    //another variant
    //  return ScaleTransition(
    //   scale: animation,
    //   child: child,
    // );
  }
}

// class CustomPageTransitionBuilder extends PageTransitionsBuilder {
//   @override
//   Widget buildTransitions<T>(
//       PageRoute<T> route,
//       BuildContext context,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation,
//       Widget child) {
//     // Check if the route is the initial route
//     final isInitialRoute = ModalRoute.of(context)?.isFirst ?? false;

//     // If it's the initial route, use the default MaterialPageRoute transition
//     if (isInitialRoute) {
//       return child;
//     }

//     return FadeTransition(
//       opacity: animation,
//       child: child,
//     );
//   }
// }

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Custom transition logic here
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // For iOS, use CupertinoPageRoute wrapped in CupertinoPageTransitionsBuilder
      return CupertinoPageTransitionsBuilder().buildTransitions<T>(
        route,
        context,
        animation,
        secondaryAnimation,
        child,
      );
    } else {
      // For Android and other platforms, use your custom transition.
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    }
  }
}
