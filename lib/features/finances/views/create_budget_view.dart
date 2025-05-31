import 'package:expense_tracker_app/features/onboarding/widgets/option_seletion_tile.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/shared/txn_defs.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/curved_painter.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CreateBudgetView extends StatefulWidget {
  const CreateBudgetView({super.key});

  @override
  State<CreateBudgetView> createState() => _CreateBudgetViewState();
}

class _CreateBudgetViewState extends State<CreateBudgetView> {
  final TextEditingController _budgetCategoryController =
      TextEditingController();
  final TextEditingController _budgetAmountController =
      TextEditingController();
  final TextEditingController _budgetDescriptionController =
      TextEditingController();
  final TextEditingController _budgetRecurringController = TextEditingController();
  final ValueNotifier<String> _balanceNotifier = ValueNotifier<String>("0.00");
  final ValueNotifier<DateTime> _selectedDateNotifier =
      ValueNotifier<DateTime>(DateTime.now());

  void initState() {
    super.initState();
    _budgetAmountController.addListener(_updateBalance);
  }

  @override
  void dispose() {
    _budgetCategoryController.dispose();
    _budgetAmountController.dispose();
    _budgetDescriptionController.dispose();
    _balanceNotifier.dispose();
    _selectedDateNotifier.dispose();
    super.dispose();
  }

  void _updateBalance() {
    final amountText = _budgetAmountController.text;
    double amount = double.tryParse(amountText.replaceAll(',', '')) ?? 0.0;
    String formattedAmount =
        NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2)
            .format(amount);
    _balanceNotifier.value = formattedAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Palette.montraPurple,
              body: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Positioned(
                          top: -5,
                          left: -5,
                          child: AppGraphics.eclipses.png.myImage(
                            height: 200.h,
                          ),
                        ),
                        Column(
                          children: [
                            50.sbH,
                            RowRailer(
                              rowPadding: 20.padH,
                              leading: const Icon(PhosphorIconsBold.arrowLeft,
                                      color: Palette.whiteColor)
                                  .tap(onTap: () {
                                goBack(context);
                              }),
                              middle: "Create a Budget".txt16(
                                  color: Palette.whiteColor, fontW: F.w5),
                            ),
                            80.sbH,
                            Padding(
                              padding: 50.padH,
                              child: ValueListenableBuilder<String>(
                                valueListenable: _balanceNotifier,
                                builder: (context, balance, _) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        PhosphorIconsBold.currencyNgn,
                                        color: Palette.whiteColor,
                                        size: 28.sp,
                                      ),
                                      3.sbW,
                                      Expanded(
                                        child: balance
                                            .txt(
                                                size: 28.sp,
                                                fontW: F.w8,
                                                color: Palette.whiteColor,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis)
                                            .alignCenterLeft(),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            260.sbH,
                            CustomPaint(
                              size: Size(double.infinity, 50.h),
                              painter: CurvedPainter(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Palette.whiteColor,
                                  border: Border.all(
                                      color: Palette.whiteColor, width: 1)),
                              constraints: BoxConstraints(
                                  minHeight: height(context) - 250.h,
                                  minWidth: double.infinity),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 210,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: 25.padH,
                              child: Container(
                                padding: 15.0.padA,
                                decoration: BoxDecoration(
                                  color: Palette.whiteColor,
                                  borderRadius: BorderRadius.circular(25.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 10,
                                      blurRadius: 20,
                                      offset: const Offset(5, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    10.sbH,
                                    TextInputWidget(
                                      onTap: () {
                                        showCustomModal(context,
                                            modalHeight: 730.h,
                                            child: ListView.builder(
                                              padding: 15.padH,
                                              shrinkWrap: true,
                                              itemCount:
                                                  transactionCategories.length,
                                              itemBuilder: (context, index) {
                                                return OptionSelectionListTile(
                                                  leadingIconColor:
                                                      transactionCategories[
                                                              index]['color']
                                                          as Color,
                                                  leadingIcon:
                                                      transactionCategories[
                                                              index]['icon']
                                                          as IconData,
                                                  interactiveTrailing: false,
                                                  titleFontSize: 15.sp,
                                                  titleLabel:
                                                      transactionCategories[
                                                              index]['name']
                                                          as String,
                                                  onTileTap: () {
                                                    _budgetCategoryController
                                                            .text =
                                                        transactionCategories[
                                                            index]['name'];
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              },
                                            ));
                                      },
                                      isTextFieldEnabled: false,
                                      hintText: "Category",
                                      hintTextSize: 14.sp,
                                      inputtedTextSize: 14.sp,
                                      prefix: Padding(
                                        padding: 12.5.padA,
                                        child: Container(
                                          decoration: const BoxDecoration(),
                                          height: 26.h,
                                          width: 26.h,
                                          child: Center(
                                              child: Padding(
                                                  padding: 4.0.padH,
                                                  child: Icon(
                                                    PhosphorIconsBold.list,
                                                    color: Palette.greyColor,
                                                    size: 20.h,
                                                  ))),
                                        ),
                                      ),
                                      controller:
                                         _budgetCategoryController,
                                      suffixIcon: Padding(
                                        padding: 15.padH,
                                        child: Icon(
                                            PhosphorIconsRegular.caretDown,
                                            size: 20.h,
                                            color: Palette.textFieldGrey),
                                      ),
                                    ),
                                    5.sbH,
                                    TextInputWidget(
                                      hintText: "Amount",
                                      hintTextSize: 14.sp,
                                      inputtedTextSize: 14.sp,
                                      prefix: Padding(
                                        padding: 12.5.padA,
                                        child: Container(
                                          decoration: const BoxDecoration(),
                                          height: 26.h,
                                          width: 26.h,
                                          child: Center(
                                              child: Padding(
                                                  padding: 4.0.padH,
                                                  child: Icon(
                                                    PhosphorIconsBold
                                                        .currencyNgn,
                                                    color: Palette.greyColor,
                                                    size: 20.h,
                                                  ))),
                                        ),
                                      ),
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.5.w),
                                        child: const Icon(
                                                PhosphorIconsFill.xCircle,
                                                color: Palette.greyColor)
                                            .tap(onTap: () {
                                          _budgetAmountController.clear();
                                        }),
                                      ),
                                      controller: _budgetAmountController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (p0) {
                                        _updateBalance();
                                      },
                                    ),
                                    5.sbH,
                                    TextInputWidget(
                                      maxLength: 30,
                                      hintText: "Description",
                                      hintTextSize: 14.sp,
                                      inputtedTextSize: 14.sp,
                                      prefix: Padding(
                                        padding: 12.5.padA,
                                        child: Container(
                                          decoration: const BoxDecoration(),
                                          height: 26.h,
                                          width: 26.h,
                                          child: Center(
                                              child: Padding(
                                                  padding: 4.0.padH,
                                                  child: Icon(
                                                    PhosphorIconsFill.article,
                                                    color: Palette.greyColor,
                                                    size: 20.h,
                                                  ))),
                                        ),
                                      ),
                                      controller:
                                          _budgetDescriptionController,
                                    ),
                                    15.sbH,
                                    TextInputWidget(
                                      onTap: () {
                                        showCustomModal(context,
                                            modalHeight: 300.h,
                                            child: ListView.builder(
                                              padding: 15.padH,
                                              shrinkWrap: true,
                                              itemCount: transactionType.length,
                                              itemBuilder: (context, index) {
                                                return OptionSelectionListTile(
                                                  leadingIcon:
                                                      budgetTypes[index]
                                                          ['icon'] as IconData,
                                                  interactiveTrailing: false,
                                                  titleFontSize: 15.sp,
                                                  titleLabel:
                                                      budgetTypes[index]
                                                          ['label'] as String,
                                                  onTileTap: () {

                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              },
                                            ));
                                      },
                                      isTextFieldEnabled: false,
                                      hintText: "Type",
                                      hintTextSize: 14.sp,
                                      inputtedTextSize: 14.sp,
                                      prefix: Padding(
                                        padding: 12.5.padA,
                                        child: Container(
                                          decoration: const BoxDecoration(),
                                          height: 26.h,
                                          width: 26.h,
                                          child: Center(
                                              child: Padding(
                                                  padding: 4.0.padH,
                                                  child: Icon(
                                                    PhosphorIconsFill.money,
                                                    color: Palette.greyColor,
                                                    size: 20.h,
                                                  ))),
                                        ),
                                      ),
                                      controller: _budgetRecurringController,
                                      suffixIcon: Padding(
                                        padding: 15.padH,
                                        child: Icon(
                                            PhosphorIconsRegular.caretDown,
                                            size: 20.h,
                                            color: Palette.textFieldGrey),
                                      ),
                                    ),
                                    15.sbH,
                                    ValueListenableBuilder<DateTime>(
                                      valueListenable: _selectedDateNotifier,
                                      builder: (context, selectedDate, _) {
                                        return Container(
                                          width: double.infinity,
                                          height: 50.h,
                                          padding: 15.padH,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.r)),
                                              border: Border.all(
                                                  color: Palette.greyColor,
                                                  width: 1)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                PhosphorIconsFill.calendarBlank,
                                                color: Palette.greyColor,
                                                size: 20.h,
                                              ),
                                              15.sbW,
                                              DateFormat('E, dd MMM, yyyy')
                                                  .format(selectedDate)
                                                  .txt(size: 14.sp)
                                            ],
                                          ),
                                        ).tap(onTap: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: selectedDate,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2099),
                                          );
                                          if (picked != null &&
                                              picked != selectedDate) {
                                            _selectedDateNotifier.value =
                                                picked;
                                          }
                                        });
                                      },
                                    ),
                                    30.sbH,
                                    AppButton(
                                        // isEnabled: _transactionTypeController
                                        //         .text.isNotEmpty &&
                                        //     _transactionCategoryController
                                        //         .text.isNotEmpty &&
                                        //     _transactionAmountController
                                        //         .text.isNotEmpty &&
                                        //     _transactionDescriptionController
                                        //         .text.isNotEmpty,
                                        color: Palette.montraPurple,
                                        text: "Create Budget",
                                        onTap: () {})
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
  }
}