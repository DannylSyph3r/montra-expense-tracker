import 'package:expense_tracker_app/features/onboarding/widgets/option_seletion_tile.dart';
import 'package:expense_tracker_app/features/transactions/models/budget_model.dart';
import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/snack_bar.dart';
import 'package:expense_tracker_app/utils/type_defs.dart';
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
  final TextEditingController _budgetAmountController = TextEditingController();
  final TextEditingController _budgetDescriptionController =
      TextEditingController();
  final TextEditingController _budgetPeriodController = TextEditingController();

  final ValueNotifier<String> _balanceNotifier = ValueNotifier<String>("0.00");
  final ValueNotifier<DateTime> _selectedDateNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<bool> _isRecurringNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<TransactionCategory?> _selectedCategoryNotifier =
      ValueNotifier<TransactionCategory?>(null);
  final ValueNotifier<BudgetPeriod?> _selectedPeriodNotifier =
      ValueNotifier<BudgetPeriod?>(null);

  @override
  void initState() {
    super.initState();
    _budgetAmountController.addListener(_updateBalance);
  }

  @override
  void dispose() {
    _budgetCategoryController.dispose();
    _budgetAmountController.dispose();
    _budgetDescriptionController.dispose();
    _budgetPeriodController.dispose();
    _balanceNotifier.dispose();
    _selectedDateNotifier.dispose();
    _isRecurringNotifier.dispose();
    _selectedCategoryNotifier.dispose();
    _selectedPeriodNotifier.dispose();
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

  DateTime _calculateEndDate(DateTime startDate, BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.weekly:
        return startDate.add(const Duration(days: 6));
      case BudgetPeriod.monthly:
        return DateTime(startDate.year, startDate.month + 1, 0);
      case BudgetPeriod.quarterly:
        final currentQuarter = (startDate.month - 1) ~/ 3;
        return DateTime(startDate.year, (currentQuarter + 1) * 3 + 1, 0);
      case BudgetPeriod.yearly:
        return DateTime(startDate.year, 12, 31);
      case BudgetPeriod.custom:
        return startDate.add(const Duration(days: 30)); // Default 30 days
    }
  }

  void _createBudget() {
    // Validate inputs
    if (_selectedCategoryNotifier.value == null) {
      showBanner(
        context: context,
        theMessage: "Please select a category",
        theType: NotificationType.failure,
      );
      return;
    }

    if (_budgetAmountController.text.isEmpty) {
      showBanner(
        context: context,
        theMessage: "Please enter budget amount",
        theType: NotificationType.failure,
      );
      return;
    }

    if (_selectedPeriodNotifier.value == null) {
      showBanner(
        context: context,
        theMessage: "Please select budget period",
        theType: NotificationType.failure,
      );
      return;
    }

    final amount =
        double.tryParse(_budgetAmountController.text.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      showBanner(
        context: context,
        theMessage: "Please enter a valid amount",
        theType: NotificationType.failure,
      );
      return;
    }

    // Show success and navigate back
    showBanner(
      context: context,
      theMessage: "Budget created successfully!",
      theType: NotificationType.success,
    );

    // Navigate back to finances view
    goBack(context);
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
                      middle: "Create a Budget"
                          .txt16(color: Palette.whiteColor, fontW: F.w5),
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
                          border:
                              Border.all(color: Palette.whiteColor, width: 1)),
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

                            // Category Selection
                            TextInputWidget(
                              onTap: () {
                                showCustomModal(context,
                                    modalHeight: 730.h,
                                    child: ListView.builder(
                                      padding: 15.padH,
                                      shrinkWrap: true,
                                      itemCount: TransactionCategory
                                              .getExpenseCategories()
                                          .length,
                                      itemBuilder: (context, index) {
                                        final category = TransactionCategory
                                            .getExpenseCategories()[index];
                                        return OptionSelectionListTile(
                                          leadingIconColor: category.color,
                                          leadingIcon: category.icon,
                                          interactiveTrailing: false,
                                          titleFontSize: 15.sp,
                                          titleLabel: category.label,
                                          onTileTap: () {
                                            _selectedCategoryNotifier.value =
                                                category;
                                            _budgetCategoryController.text =
                                                category.label;
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
                              controller: _budgetCategoryController,
                              suffixIcon: Padding(
                                padding: 15.padH,
                                child: Icon(PhosphorIconsRegular.caretDown,
                                    size: 20.h, color: Palette.textFieldGrey),
                              ),
                            ),
                            5.sbH,

                            // Amount Input
                            TextInputWidget(
                              hintText: "Amount",
                              hintTextSize: 14.sp,
                              inputtedTextSize: 14.sp,
                              keyboardType: TextInputType.number,
                              onChanged: (value) => _updateBalance(),
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
                                            PhosphorIconsBold.currencyNgn,
                                            color: Palette.greyColor,
                                            size: 20.h,
                                          ))),
                                ),
                              ),
                              suffixIcon: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 12.5.w),
                                child: const Icon(PhosphorIconsFill.xCircle,
                                        color: Palette.greyColor)
                                    .tap(onTap: () {
                                  _budgetAmountController.clear();
                                  _updateBalance();
                                }),
                              ),
                              controller: _budgetAmountController,
                            ),
                            5.sbH,

                            // Description Input
                            TextInputWidget(
                              maxLength: 50,
                              hintText: "Description (Optional)",
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
                              controller: _budgetDescriptionController,
                            ),
                            5.sbH,

                            // Period Selection
                            TextInputWidget(
                              onTap: () {
                                showCustomModal(context,
                                    modalHeight: 350.h,
                                    child: ListView.builder(
                                      padding: 15.padH,
                                      shrinkWrap: true,
                                      itemCount: BudgetPeriod.values
                                          .where(
                                              (p) => p != BudgetPeriod.custom)
                                          .length,
                                      itemBuilder: (context, index) {
                                        final periods = BudgetPeriod.values
                                            .where(
                                                (p) => p != BudgetPeriod.custom)
                                            .toList();
                                        final period = periods[index];
                                        final icons = [
                                          PhosphorIconsFill.calendarX,
                                          PhosphorIconsFill.calendarBlank,
                                          PhosphorIconsFill.calendarPlus,
                                          PhosphorIconsFill.calendarCheck,
                                        ];

                                        return OptionSelectionListTile(
                                          leadingIcon: icons[index],
                                          interactiveTrailing: false,
                                          titleFontSize: 15.sp,
                                          titleLabel:
                                              period.name.toCapitalized(),
                                          onTileTap: () {
                                            _selectedPeriodNotifier.value =
                                                period;
                                            _budgetPeriodController.text =
                                                period.name.toCapitalized();
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    ));
                              },
                              isTextFieldEnabled: false,
                              hintText: "Budget Period",
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
                                            PhosphorIconsFill.clockClockwise,
                                            color: Palette.greyColor,
                                            size: 20.h,
                                          ))),
                                ),
                              ),
                              controller: _budgetPeriodController,
                              suffixIcon: Padding(
                                padding: 15.padH,
                                child: Icon(PhosphorIconsRegular.caretDown,
                                    size: 20.h, color: Palette.textFieldGrey),
                              ),
                            ),
                            15.sbH,

                            // Start Date Selection
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
                                          color: Palette.greyColor, width: 1)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2099),
                                  );
                                  if (picked != null &&
                                      picked != selectedDate) {
                                    _selectedDateNotifier.value = picked;
                                  }
                                });
                              },
                            ),
                            15.sbH,

                            // Recurring Toggle
                            ValueListenableBuilder<bool>(
                              valueListenable: _isRecurringNotifier,
                              builder: (context, isRecurring, _) {
                                return Container(
                                  width: double.infinity,
                                  padding: 15.padH,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.r)),
                                      border: Border.all(
                                          color: Palette.greyColor, width: 1)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            PhosphorIconsFill.repeat,
                                            color: Palette.greyColor,
                                            size: 20.h,
                                          ),
                                          15.sbW,
                                          "Recurring Budget".txt(size: 14.sp),
                                        ],
                                      ),
                                      Switch(
                                        value: isRecurring,
                                        onChanged: (value) {
                                          _isRecurringNotifier.value = value;
                                        },
                                        activeColor: Palette.montraPurple,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            20.sbH,

                            // Budget Period Info Card
                            ValueListenableBuilder<BudgetPeriod?>(
                              valueListenable: _selectedPeriodNotifier,
                              builder: (context, period, _) {
                                if (period == null)
                                  return const SizedBox.shrink();

                                final endDate = _calculateEndDate(
                                    _selectedDateNotifier.value, period);
                                final durationDays = endDate
                                        .difference(_selectedDateNotifier.value)
                                        .inDays +
                                    1;

                                return Container(
                                  width: double.infinity,
                                  padding: 12.0.padA,
                                  decoration: BoxDecoration(
                                    color: Palette.montraPurple
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                        color: Palette.montraPurple
                                            .withValues(alpha: 0.3)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            PhosphorIconsBold.info,
                                            color: Palette.montraPurple,
                                            size: 16.h,
                                          ),
                                          8.sbW,
                                          "Budget Period".txt12(
                                            color: Palette.montraPurple,
                                            fontW: F.w6,
                                          ),
                                        ],
                                      ),
                                      8.sbH,
                                      "Duration: $durationDays days".txt(
                                          size: 11.sp,
                                          color: Palette.greyColor),
                                      "End Date: ${DateFormat('dd MMM, yyyy').format(endDate)}"
                                          .txt(
                                              size: 11.sp,
                                              color: Palette.greyColor),
                                      if (_isRecurringNotifier.value) ...[
                                        4.sbH,
                                        "This budget will automatically renew when it expires"
                                            .txt(
                                          size: 11.sp,
                                          color: Palette.greyColor,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                            30.sbH,

                            // Create Budget Button
                            ListenableBuilder(
                              listenable: Listenable.merge([
                                _selectedCategoryNotifier,
                                _selectedPeriodNotifier,
                                _balanceNotifier,
                              ]),
                              builder: (context, child) {
                                final isEnabled =
                                    _selectedCategoryNotifier.value != null &&
                                        _selectedPeriodNotifier.value != null &&
                                        _budgetAmountController
                                            .text.isNotEmpty &&
                                        (double.tryParse(_budgetAmountController
                                                    .text
                                                    .replaceAll(',', '')) ??
                                                0) >
                                            0;

                                return AppButton(
                                  isEnabled: isEnabled,
                                  color: Palette.montraPurple,
                                  text: "Create Budget",
                                  onTap: _createBudget,
                                );
                              },
                            )
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