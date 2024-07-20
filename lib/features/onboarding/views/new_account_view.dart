import 'package:expense_tracker_app/features/onboarding/views/confirmation_view.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/appbar.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/list_tile.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NewAccountView extends StatefulWidget {
  const NewAccountView({super.key});

  @override
  State<NewAccountView> createState() => _NewAccountViewState();
}

class _NewAccountViewState extends State<NewAccountView> {
  final TextEditingController _clusterNameController = TextEditingController();
  final TextEditingController _clusterStartingAmountController =
      TextEditingController();
  final TextEditingController _clusterTypeController = TextEditingController();
  final ValueNotifier<String> _balanceNotifier = ValueNotifier<String>("₦ 0.00");
  final ValueNotifier<bool> _isKeyboardVisible = ValueNotifier<bool>(false);

  final List<String> accountTypes = ["Bank", "Card", "Fintech Wallet"];
  final List<IconData> leadingIcons = [
    PhosphorIconsFill.bank,
    PhosphorIconsFill.cardholder,
    PhosphorIconsFill.wallet
  ];

  @override
  void initState() {
    super.initState();
    _clusterStartingAmountController.addListener(_updateBalance);
  }

  @override
  void dispose() {
    _clusterNameController.dispose();
    _clusterStartingAmountController.dispose();
    _clusterTypeController.dispose();
    _balanceNotifier.dispose();
    _isKeyboardVisible.dispose();
    super.dispose();
  }

  void didChangeMetrics() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    _isKeyboardVisible.value = bottomInset > 0;
  }

  void _updateBalance() {
    final amountText = _clusterStartingAmountController.text;
    double amount = double.tryParse(amountText.replaceAll(',', '')) ?? 0.0;
    String formattedAmount =
        NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2)
            .format(amount);
    _balanceNotifier.value = "₦ $formattedAmount";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Add New Account",
          fontSize: 16.sp,
          fontColor: Palette.whiteColor,
          iconColor: Palette.whiteColor,
          fontWeight: FontWeight.w600,
          context: context,
          toolbarHeight: 40.h,
          color: Colors.transparent,
          isTitleCentered: true),
      backgroundColor: Palette.montraPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: 20.padH,
            child: Column(
              children: [
                "Balance"
                    .txt20(fontW: F.w6, color: Palette.textFieldGrey)
                    .alignCenterLeft(),
                ValueListenableBuilder<String>(
                  valueListenable: _balanceNotifier,
                  builder: (context, balance, _) {
                    return balance
                        .txt(
                            size: 50.sp,
                            fontW: F.w6,
                            color: Palette.whiteColor,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis)
                        .alignCenterLeft();
                  },
                ),
              ],
            ),
          ),
          10.sbH,
          _isKeyboardVisible.sync(builder: (context, isKeyboardVisible, child) {
            return AnimatedContainer(
              duration: 500.milliseconds,
              height: isKeyboardVisible
                  ? height(context) /
                      2.0 // Adjusted height when keyboard is visible
                  : height(context) / 2.5, // Default height
              decoration: BoxDecoration(
                color: Palette.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.r),
                  topRight: Radius.circular(35.r),
                ),
              ),
              child: Padding(
                padding: 15.padH,
                child: Column(
                  children: [
                    30.sbH,
                    TextInputWidget(
                      hintText: AppTexts.clusterNameFieldHint,
                      controller: _clusterNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9\s]'),
                        ),
                      ],
                    ),
                    TextInputWidget(
                      onTap: () {
                        Future.delayed(400.milliseconds, () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0.r),
                                ),
                                child: SizedBox(
                                  height: 250.h,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 5.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        10.sbH,
                                        Container(
                                          height: 5.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            color: Palette.montraPurple,
                                          ),
                                        ),
                                        20.sbH,
                                        "Select Cluster Account Type"
                                            .txt16(fontWeight: FontWeight.w600),
                                        20.sbH,
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: accountTypes.length,
                                            itemBuilder: (context, index) {
                                              final String accountTypeDisplay =
                                                  accountTypes[index];
                                              final IconData leadingIcon =
                                                  leadingIcons[index];
                                              return OptionSelectionListTile(
                                                leadingIcon: leadingIcon,
                                                interactiveTrailing: false,
                                                titleFontSize: 15.sp,
                                                titleLabel: accountTypeDisplay,
                                                onTileTap: () {
                                                  _clusterTypeController.text =
                                                      accountTypeDisplay;
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                      },
                      isTextFieldEnabled: false,
                      hintText: AppTexts.clusterAccountType,
                      controller: _clusterTypeController,
                      suffixIcon: Padding(
                        padding: 15.padH,
                        child: Icon(PhosphorIconsRegular.caretDown,
                            size: 20.h, color: Palette.textFieldGrey),
                      ),
                    ),
                    TextInputWidget(
                      hintText: AppTexts.clusterStartingBalance,
                      controller: _clusterStartingAmountController,
                      keyboardType: TextInputType.number,
                      onChanged: (p0) {
                        _updateBalance();
                      },
                    ),
                    20.sbH,
                    AppButton(
                      onTap: () {
                        goTo(
                            context: context,
                            view: const ClusterConfirmationView());
                      },
                      text: "Continue",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    40.sbH,
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
