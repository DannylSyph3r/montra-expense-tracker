import 'package:expense_tracker_app/features/onboarding/views/confirmation_view.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/appbar.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/list_tile.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final ValueNotifier<String> _balanceNotifier =
      ValueNotifier<String>("N 0.00");
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
    super.dispose();
  }

  void _updateBalance() {
    final amountText = _clusterStartingAmountController.text;
    double amount = double.tryParse(amountText.replaceAll(',', '')) ?? 0.0;
    String formattedAmount =
        NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2)
            .format(amount);
    _balanceNotifier.value = "N $formattedAmount";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          title: "Add New Account",
          fontSize: 16.sp,
          fontColor: Palette.whiteColor,
          iconColor: Palette.whiteColor,
          fontWeight: FontWeight.w600,
          context: context,
          color: Colors.transparent,
          isTitleCentered: true),
      backgroundColor: Palette.montraPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: 20.padH,
            child: Column(
              children: [
                "Balance"
                    .txt20(fontW: F.w6, color: Palette.whiteColor)
                    .alignCenterLeft(),
                ValueListenableBuilder<String>(
                  valueListenable: _balanceNotifier,
                  builder: (context, balance, _) {
                    return balance
                        .txt(
                            size: 45.sp,
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
          20.sbH,
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Palette.whiteColor,
              ),
              child: Padding(
                padding: 15.padH,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                            showCustomModal(context,
                                modalHeight: 230.h,
                                child: ListView.builder(
                                  padding: 15.padH,
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
                                ));
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
                      ],
                    ),
                    Column(
                      children: [
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
                        40.sbH
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
