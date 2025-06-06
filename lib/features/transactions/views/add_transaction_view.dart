import 'package:dotted_border/dotted_border.dart';
import 'package:expense_tracker_app/shared/txn_defs.dart';
import 'package:expense_tracker_app/features/onboarding/widgets/option_seletion_tile.dart';
import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/doc_picker_modalsheet.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/serrated_painter.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({super.key});

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  final TextEditingController _transactionTypeController =
      TextEditingController();
  final TextEditingController _transactionCategoryController =
      TextEditingController();
  final TextEditingController _transactionAmountController =
      TextEditingController();
  final TextEditingController _transactionDescriptionController =
      TextEditingController();
  final ValueNotifier<TransactionType?> _selectedTransactionTypeNotifer =
      ValueNotifier<TransactionType?>(null);
  final ValueNotifier<String> _balanceNotifier = ValueNotifier<String>("0.00");
  final ValueNotifier<DateTime> _selectedDateNotifier =
      ValueNotifier<DateTime>(DateTime.now());

  @override
  void initState() {
    super.initState();
    _transactionAmountController.addListener(_updateBalance);
  }

  @override
  void dispose() {
    _transactionTypeController.dispose();
    _transactionCategoryController.dispose();
    _transactionAmountController.dispose();
    _transactionDescriptionController.dispose();
    _balanceNotifier.dispose();
    _selectedDateNotifier.dispose();
    super.dispose();
  }

  void _updateBalance() {
    final amountText = _transactionAmountController.text;
    double amount = double.tryParse(amountText.replaceAll(',', '')) ?? 0.0;
    String formattedAmount =
        NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2)
            .format(amount);
    _balanceNotifier.value = formattedAmount;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _selectedTransactionTypeNotifer,
        builder: (context, txnType, child) {
          String transactionText = "Add";
          Color backgroundColor = Palette.montraPurple;

          if (txnType == TransactionType.income) {
            transactionText = "Add Income";
            backgroundColor = Colors.green;
          } else if (txnType == TransactionType.expense) {
            transactionText = "Add Expense";
            backgroundColor = Colors.red;
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: backgroundColor,
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
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
                              middle: "$transactionText Transaction".txt16(
                                  color: Palette.whiteColor, fontW: F.w5),
                            ),
                            40.sbH,
                            Padding(
                              padding: 50.padH,
                              child: ValueListenableBuilder<String>(
                                valueListenable: _balanceNotifier,
                                builder: (context, balance, _) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        PhosphorIconsBold.currencyNgn,
                                        color: Palette.whiteColor,
                                        size: 30.sp,
                                      ),
                                      3.sbW,
                                      Flexible(
                                        child: balance.txt(
                                          size: 30.sp,
                                          fontW: F.w8,
                                          color: Palette.whiteColor,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            30.sbH
                          ],
                        ),
                        Column(
                          children: [
                            200.sbH,
                            CustomPaint(
                              size: Size(double.infinity, 60.h),
                              painter: SerratedPainter(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Palette.whiteColor,
                                  border: Border.all(
                                      color: Palette.whiteColor, width: 1)),
                              constraints: BoxConstraints(
                                minHeight: height(context) - 250.h,
                                minWidth: double.infinity,
                              ),
                              child: Padding(
                                padding: 20.padH,
                                child: Column(
                                  children: [
                                    20.sbH,

                                    // Transaction Type Selection
                                    TextInputWidget(
                                      onTap: () {
                                        showCustomModal(context,
                                            modalHeight: 180.h,
                                            child: ListView.builder(
                                              padding: 15.padH,
                                              shrinkWrap: true,
                                              itemCount: transactionType.length,
                                              itemBuilder: (context, index) {
                                                return OptionSelectionListTile(
                                                  leadingIcon:
                                                      transactionType[index]
                                                          ['icon'] as IconData,
                                                  interactiveTrailing: false,
                                                  titleFontSize: 15.sp,
                                                  titleLabel:
                                                      transactionType[index]
                                                          ['label'] as String,
                                                  onTileTap: () {
                                                    _selectedTransactionTypeNotifer
                                                            .value =
                                                        transactionType[index]
                                                                ['type']
                                                            as TransactionType;
                                                    _transactionTypeController
                                                            .text =
                                                        transactionType[index]
                                                            ['label'];

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
                                      controller: _transactionTypeController,
                                      suffixIcon: Padding(
                                        padding: 15.padH,
                                        child: Icon(
                                            PhosphorIconsRegular.caretDown,
                                            size: 20.h,
                                            color: Palette.textFieldGrey),
                                      ),
                                    ),
                                    10.sbH,

                                    // Category Selection
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
                                                    _transactionCategoryController
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
                                          _transactionCategoryController,
                                      suffixIcon: Padding(
                                        padding: 15.padH,
                                        child: Icon(
                                            PhosphorIconsRegular.caretDown,
                                            size: 20.h,
                                            color: Palette.textFieldGrey),
                                      ),
                                    ),
                                    10.sbH,

                                    // Amount Input
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
                                          _transactionAmountController.clear();
                                          _updateBalance();
                                        }),
                                      ),
                                      controller: _transactionAmountController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (p0) {
                                        _updateBalance();
                                      },
                                    ),
                                    10.sbH,

                                    // Description Input
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
                                          _transactionDescriptionController,
                                    ),
                                    10.sbH,

                                    // Invoice Attachment
                                    DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(15.r),
                                      padding: EdgeInsets.zero,
                                      color: Palette.greyColor,
                                      strokeWidth: 1,
                                      dashPattern: const [5, 5],
                                      child: Container(
                                        width: double.infinity,
                                        height: 50.h,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              PhosphorIconsFill.plusCircle,
                                              color: Palette.greyColor,
                                              size: 20.h,
                                            ),
                                            15.sbW,
                                            Text(
                                              "Attach Invoice",
                                              style: TextStyle(fontSize: 14.sp),
                                            )
                                          ],
                                        ),
                                      ),
                                    ).tap(onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            DocPickerModalBottomSheet(
                                          headerText:
                                              "Invoice Photo",
                                          descriptionText: AppTexts
                                              .invoiceAttachementInstructions,
                                          onTakeDocPicture: () {
                                            goBack(context);
                                          },
                                        ),
                                      );
                                    }),
                                    10.sbH,

                                    // Date Selection
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

                                    // Transaction Information Card
                                    Container(
                                      width: double.infinity,
                                      padding: 15.0.padA,
                                      decoration: BoxDecoration(
                                        color: backgroundColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                        border: Border.all(
                                            color: backgroundColor
                                                .withOpacity(0.3)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                PhosphorIconsBold.info,
                                                color: backgroundColor,
                                                size: 16.h,
                                              ),
                                              8.sbW,
                                              "Transaction Details".txt12(
                                                color: backgroundColor,
                                                fontW: F.w6,
                                              ),
                                            ],
                                          ),
                                          8.sbH,
                                          "All fields are required to create a transaction."
                                              .txt(
                                                  size: 11.sp,
                                                  color: Palette.greyColor),
                                          "Attaching an invoice is optional but recommended for record keeping."
                                              .txt(
                                                  size: 11.sp,
                                                  color: Palette.greyColor),
                                        ],
                                      ),
                                    ),
                                    20.sbH,

                                    // Log Transaction Button
                                    ListenableBuilder(
                                      listenable: Listenable.merge([
                                        _transactionTypeController,
                                        _transactionCategoryController,
                                        _transactionAmountController,
                                        _transactionDescriptionController,
                                      ]),
                                      builder: (context, child) {
                                        final isEnabled = _transactionTypeController
                                                .text.isNotEmpty &&
                                            _transactionCategoryController
                                                .text.isNotEmpty &&
                                            _transactionAmountController
                                                .text.isNotEmpty &&
                                            _transactionDescriptionController
                                                .text.isNotEmpty;

                                        return AppButton(
                                          isEnabled: isEnabled,
                                          color: backgroundColor,
                                          text: "Log Transaction",
                                          onTap: () {},
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Transform.scale(
                              scaleY: -1,
                              child: CustomPaint(
                                size: Size(double.infinity, 60.h),
                                painter: SerratedPainter(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}