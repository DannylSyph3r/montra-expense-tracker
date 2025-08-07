import 'dart:async';
import 'package:expense_tracker_app/features/onboarding/views/cluster_setup_view.dart';
import 'package:expense_tracker_app/features/auth/widgets/number_pad.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PinInputView extends StatefulWidget {
  const PinInputView({super.key});

  @override
  State<PinInputView> createState() => _PinInputViewState();
}

class _PinInputViewState extends State<PinInputView> {
  final TextEditingController _pinController = TextEditingController();
  final ValueNotifier<List<String>> _pinNotifier =
      ValueNotifier<List<String>>([]);
  final ValueNotifier<List<String>> _confirmPinNotifier =
      ValueNotifier<List<String>>([]);
  final ValueNotifier<bool> _isConfirming = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _pinStatus = ValueNotifier<String?>(null);

  Timer? _timer;

  @override
  void dispose() {
    _pinController.dispose();
    _pinNotifier.dispose();
    _confirmPinNotifier.dispose();
    _isConfirming.dispose();
    _pinStatus.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _resetPinState() {
    _pinNotifier.value = [];
    _confirmPinNotifier.value = [];
    _isConfirming.value = false;
    _pinStatus.value = null;
  }

  void _delayedResetPinState() {
    _timer?.cancel();
    _timer = Timer(1.seconds, () {
      _resetPinState();
    });
  }

  void _onNumberTap(String number) {
    if (_isConfirming.value) {
      if (number == '<') {
        if (_confirmPinNotifier.value.isNotEmpty) {
          _confirmPinNotifier.value = List.from(_confirmPinNotifier.value)
            ..removeLast();
        }
      } else {
        if (_confirmPinNotifier.value.length < 4) {
          _confirmPinNotifier.value = List.from(_confirmPinNotifier.value)
            ..add(number);
          if (_confirmPinNotifier.value.length == 4) {
            if (_confirmPinNotifier.value.join() == _pinNotifier.value.join()) {
              _pinStatus.value = "PIN confirmed";
              _delayedResetPinState();
              goTo(context: context, view: const ClusterSetupView());
            } else {
              _pinStatus.value = "Incorrect PIN";
              _delayedResetPinState();
            }
          }
        }
      }
    } else {
      if (number == '<') {
        if (_pinNotifier.value.isNotEmpty) {
          _pinNotifier.value = List.from(_pinNotifier.value)..removeLast();
        }
      } else {
        if (_pinNotifier.value.length < 4) {
          _pinNotifier.value = List.from(_pinNotifier.value)..add(number);
          if (_pinNotifier.value.length == 4) {
            _isConfirming.value = true;
            _confirmPinNotifier.value = [];
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          implyLeading: false,
          context: context,
          toolbarHeight: 40.h,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          isTitleCentered: true,
          color: Palette.montraPurple),
      backgroundColor: Palette.montraPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              [_isConfirming, _pinStatus].syncPro(builder: (context, child) {
                return Text(
                  _isConfirming.value
                      ? _pinStatus.value == "Incorrect PIN"
                          ? "Incorrect PIN :("
                          : _pinStatus.value == "PIN confirmed"
                              ? "PIN confirmed"
                              : "Ok. Re-type your PIN again."
                      : "Let's setup your PIN",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Palette.whiteColor,
                  ),
                ).alignTopCenter();
              }),
              30.sbH,
              _pinNotifier.sync(
                builder: (context, pin, child) {
                  return Visibility(
                    visible: !_isConfirming.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: 5.0.padA,
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: index < pin.length
                                  ? Palette.whiteColor
                                  : Palette.montraPurple,
                              shape: BoxShape.circle,
                              border: Border.all(color: Palette.whiteColor),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
              _confirmPinNotifier.sync(
                builder: (context, pin, child) {
                  final pinIncorrect = _pinStatus.value == "Incorrect PIN";
                  final childWidget = Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: 5.0.padA,
                        child: Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            color: index < pin.length
                                ? Palette.whiteColor
                                : Palette.montraPurple,
                            shape: BoxShape.circle,
                            border: Border.all(color: Palette.whiteColor),
                          ),
                        ),
                      );
                    }),
                  );

                  return Visibility(
                    visible: _isConfirming.value,
                    child: pinIncorrect
                        ? childWidget
                            .animate()
                            .shakeX(duration: 700.milliseconds, amount: 5)
                        : childWidget,
                  );
                },
              ),
            ],
          ),
          NumberPad(onNumberTap: _onNumberTap),
        ],
      ),
    );
  }
}
