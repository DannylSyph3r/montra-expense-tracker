// import 'package:flutter/material.dart';

// void goBack(BuildContext context) {
//   // killKeyboard(context);
//   Navigator.of(context).pop();
// }

// void goTo({
//   required BuildContext context,
//   required Widget view,
//   VoidCallback? thenWhat,
// }) {
//   Navigator.of(context)
//       .push(
//     MaterialPageRoute(builder: (context) => view),
//   )
//       .then((value) {
//     thenWhat?.call();
//   });
// }

// void goToAndReset({
//   required BuildContext context,
//   required Widget view,
// }) {
//   Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(
//         builder: (context) => view,
//       ),
//       (route) => false);
// }

// void goToAndReplace({
//   required BuildContext context,
//   required Widget view,
// }) {
//   Navigator.of(context).pushReplacement(
//     CustomPageRoute(view),
//   );
// }

// void popUntilFirst(BuildContext context) {
//   Navigator.of(context).popUntil((route) => route.isFirst);
// }

// class CustomPageRoute<T> extends PageRoute<T> {
//   CustomPageRoute(this.child);

//   final Widget child;

//   @override
//   Color get barrierColor => Colors.transparent;

//   @override
//   String get barrierLabel => '';

//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return SlideTransition(
//       position: Tween<Offset>(
//         begin: const Offset(1.0, 0.0), // Start position (from right)
//         end: Offset.zero, // End position (to center)
//       ).animate(animation),
//       child: child,
//     );
//   }

//   @override
//   bool get maintainState => true;

//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 200);
// }

import 'dart:ui';

import 'package:flutter/material.dart';

void goBack(BuildContext context) {
  // killKeyboard(context);
  Navigator.of(context).pop();
}

void goToUnanimated({
  required BuildContext context,
  required Widget view,
  VoidCallback? thenWhat,
}) {
  Navigator.of(context)
      .push(
    MaterialPageRoute(builder: (context) => view),
  )
      .then((value) {
    thenWhat?.call();
  });
}

void goToAndReplaceUnanimated({
  required BuildContext context,
  required Widget view,
  VoidCallback? thenWhat,
}) {
  Navigator.of(context)
      .pushReplacement(
    MaterialPageRoute(builder: (context) => view),
  )
      .then((value) {
    thenWhat?.call();
  });
}

void goTo({
  required BuildContext context,
  required Widget view,
  VoidCallback? thenWhat,
}) {
  Navigator.of(context)
      .push(
    CustomPageRoute(view),
  )
      .then((value) {
    thenWhat?.call();
  });
}

void goToAndReset({
  required BuildContext context,
  required Widget view,
}) {
  Navigator.of(context).pushAndRemoveUntil(
    CustomPageRoute(view), // Use CustomPageRoute instead of MaterialPageRoute
    (route) => false,
  );
}

void goToAndReplace({
  required BuildContext context,
  required Widget view,
}) {
  Navigator.of(context).pushReplacement(
    CustomPageRoute(view), // Use CustomPageRoute instead of MaterialPageRoute
  );
}

void popUntilFirst(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

class CustomPageRoute<T> extends PageRoute<T> {
  CustomPageRoute(this.child);

  final Widget child;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String get barrierLabel => '';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Stack(
      children: [
        //! slider animation

        // Container(
        //   color: Colors.transparent,
        //   child: BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        //     child: Container(
        //       color: Colors.white.withOpacity(0.3),
        //     ),
        //   ),
        // ),
        // Page content
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0), // Start position (from right)
            end: Offset.zero, // End position (to center)
          ).animate(animation),
          child: child,
        ),
      ],
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
