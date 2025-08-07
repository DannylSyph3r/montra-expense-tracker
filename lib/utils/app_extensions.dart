// Application Extensions
import "dart:developer" as dev_tools show log;
import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";

// Log Extension - Call .log() on any object
extension Log on Object {
  void log() => dev_tools.log(toString());
}

// Call .dismissKeyboard on any widget to dismiss the keyboard
extension DismissKeyboard on Widget {
  void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}

const ext = 0;
final formatCurrency =
    NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');

// Formats the amount and returns a formatted amount
String formatPrice(String amount) {
  return formatCurrency.format(num.parse(amount)).toString();
}

// String Casing Extensions - Format strings with different case styles
extension StringCasingExtension on String {
  String? camelCase() => toBeginningOfSentenceCase(this);
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
  String? trimToken() => contains(":") ? split(":")[1].trim() : this;
  String? trimSpaces() => replaceAll(" ", "");
  String removeSpacesAndLower() => replaceAll(' ', '').toLowerCase();
}

// Text Styling Extension - Create styled text widgets with Inter font
extension StyledTextExtension on String {
  Widget txt({
    double? size,
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    F? fontW,
  }) {
    return Builder(
      builder: (BuildContext context) => Text(
        this,
        overflow: overflow,
        textAlign: textAlign,
        maxLines: maxLines,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            height: height,
            fontSize: size ?? 14.sp,
            color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: switch (fontW) {
              F.w1 => FontWeight.w100,
              F.w2 => FontWeight.w200,
              F.w3 => FontWeight.w300,
              F.w4 => FontWeight.w400,
              F.w5 => FontWeight.w500,
              F.w6 => FontWeight.w600,
              F.w7 => FontWeight.w700,
              F.w8 => FontWeight.w800,
              _ => fontWeight,
            },
            fontStyle: fontStyle,
            decoration: decoration,
          ),
        ),
      ),
    );
  }
}

// Image Path Extensions - Generate image file paths
extension ImagePath on String {
  String get png => 'lib/assets/images/$this.png';
  String get jpg => 'lib/assets/images/$this.jpg';
  String get gif => 'lib/assets/images/$this.gif';
}

// Icon Path Extensions - Generate icon file paths
extension IconPath on String {
  String get iconPng => 'lib/assets/icons/$this.png';
  String get iconSvg => 'lib/assets/icons/$this.svg';
}

// Number Extensions for Integers - Calculate percentages
extension NumExtensions on int {
  num addPercentage(num v) => this + ((v / 100) * this);
  num getPercentage(num v) => ((v / 100) * this);
}

// Number Extensions for Numeric Types - Calculate percentages
extension NumExtensionss on num {
  num addPercentage(num v) => this + ((v / 100) * this);
  num getPercentage(num v) => ((v / 100) * this);
}

// void openUrl({String? url}) {
//   launchUrl(Uri.parse("http://$url"));
// }

// void openMailApp({String? receiver, String? title, String? body}) {
//   launchUrl(Uri.parse("mailto:$receiver?subject=$title&body=$body"));
// }

// Widget Extensions for Numeric Types - Create sized boxes and padding
extension WidgetExtensionss on num {
  Widget get sbH => SizedBox(
        height: h,
      );

  Widget get sbW => SizedBox(
        width: w,
      );

  EdgeInsetsGeometry get padV => EdgeInsets.symmetric(vertical: h);

  EdgeInsetsGeometry get padH => EdgeInsets.symmetric(horizontal: w);
}

// Widget Extensions for Double - Create sized boxes and padding with all directions
extension WidgetExtensions on double {
  Widget get sbH => SizedBox(
        height: h,
      );

  Widget get sbW => SizedBox(
        width: w,
      );

  EdgeInsetsGeometry get padA => EdgeInsets.all(this);

  EdgeInsetsGeometry get padV => EdgeInsets.symmetric(vertical: h);

  EdgeInsetsGeometry get padH => EdgeInsets.symmetric(horizontal: w);
}

// Image Asset Extension - Create Image widgets from asset paths
extension ImageExtension on String {
  Image myImage({
    Color? color,
    double? height,
    double? width,
    BoxFit? fit,
  }) {
    return Image.asset(
      this,
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }
}

// Duration Extension - Create Duration objects from integers
extension DurationExtension on int {
  Duration duration({
    int days = 0,
    int hrs = 0,
    int mins = 0,
    int secs = 0,
    int ms = 0,
    int microsecs = 0,
  }) {
    return Duration(
      days: days,
      hours: hrs,
      minutes: mins,
      seconds: secs,
      milliseconds: ms,
      microseconds: microsecs,
    );
  }
}

// InkWell Tap Extension - Add tap gestures with Material Design ripple effects
extension InkWellExtension on Widget {
  InkWell tap({
    required GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    BorderRadius? borderRadius,
    Color? splashColor = Colors.transparent,
    Color? highlightColor = Colors.transparent,
  }) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius ?? BorderRadius.circular(12.r),
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: this,
    );
  }
}

// Gesture Tap Extension
extension GestureTap on Widget {
  GestureDetector gestureTap({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: this,
    );
  }
}

// Alignment Extension - Easily align widgets in different positions
extension AlignExtension on Widget {
  Align align(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  Align alignCenter() {
    return Align(
      alignment: Alignment.center,
      child: this,
    );
  }

  Align alignCenterLeft() {
    return Align(
      alignment: Alignment.centerLeft,
      child: this,
    );
  }

  Align alignCenterRight() {
    return Align(
      alignment: Alignment.centerRight,
      child: this,
    );
  }

  Align alignTopCenter() {
    return Align(
      alignment: Alignment.topCenter,
      child: this,
    );
  }

  Align alignBottomCenter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: this,
    );
  }

  Align alignBottomLeft() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: this,
    );
  }

  Align alignBottomRight() {
    return Align(
      alignment: Alignment.bottomRight,
      child: this,
    );
  }

  Align alignTopRight() {
    return Align(
      alignment: Alignment.topRight,
      child: this,
    );
  }

  Align alignTopLeft() {
    return Align(
      alignment: Alignment.topLeft,
      child: this,
    );
  }
}

// Widget Animation Extension
extension WidgetAnimation on Widget {
  Animate fadeInFromTop({
    Duration? delay,
    Duration? animatiomDuration,
    Offset? offset,
  }) =>
      animate(delay: delay ?? 500.ms)
          .move(
            duration: animatiomDuration ?? 500.ms,
            begin: offset ?? const Offset(0, -1),
          )
          .fade(duration: animatiomDuration ?? 500.ms);

  Animate fadeInFromBottom({
    Duration? delay,
    Duration? animatiomDuration,
    Offset? offset,
  }) =>
      animate(delay: delay ?? 500.ms)
          .move(
            duration: animatiomDuration ?? 500.ms,
            begin: offset ?? const Offset(0, 10),
          )
          .fade(duration: animatiomDuration ?? 500.ms);

  Animate fadeIn({
    Duration? delay,
    Duration? animatiomDuration,
    Curve? curve,
  }) =>
      animate(delay: delay ?? 500.ms).fade(
        duration: animatiomDuration ?? 500.ms,
        curve: curve ?? Curves.decelerate,
      );
}

// Font Weight Enum
enum F {
  w1,
  w2,
  w3,
  w4,
  w5,
  w6,
  w7,
  w8,
}

// ValueNotifier Creation Extension - Create ValueNotifier from any value
extension ValueNotifierExtension<T> on T {
  ValueNotifier<T> get notifier {
    return ValueNotifier<T>(this);
  }
}

// ValueNotifier Builder Extension - Create reactive widgets from ValueNotifier
extension ValueNotifierBuilderExtension<T> on ValueNotifier<T> {
  Widget sync({
    required Widget Function(BuildContext context, T value, Widget? child)
        builder,
  }) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: builder,
    );
  }
}

// Multiple Listenable Builder Extension - Listen to multiple ValueNotifiers
extension ListenableBuilderExtension on List<Listenable> {
  Widget syncPro({
    required Widget Function(BuildContext context, Widget? child) builder,
  }) {
    return ListenableBuilder(
      listenable: Listenable.merge(this),
      builder: builder,
    );
  }
}