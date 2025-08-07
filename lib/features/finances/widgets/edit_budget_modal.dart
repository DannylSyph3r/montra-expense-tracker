import 'package:expense_tracker_app/features/transactions/models/budget_model.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/snack_bar.dart';
import 'package:expense_tracker_app/utils/type_defs.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EditBudgetModal extends StatefulWidget {
  final Budget budget;
  final Function(Budget) onBudgetUpdated;

  const EditBudgetModal({
    super.key,
    required this.budget,
    required this.onBudgetUpdated,
  });

  @override
  State<EditBudgetModal> createState() => _EditBudgetModalState();
}

class _EditBudgetModalState extends State<EditBudgetModal> {
  late TextEditingController _budgetAmountController;
  late TextEditingController _budgetDescriptionController;
  late TextEditingController _budgetPeriodController;

  late ValueNotifier<String> _balanceNotifier;
  late ValueNotifier<DateTime> _selectedStartDateNotifier;
  late ValueNotifier<DateTime> _selectedEndDateNotifier;
  late ValueNotifier<BudgetPeriod?> _selectedPeriodNotifier;

  bool get hasSpentMoney => widget.budget.spentAmount > 0;
  bool get canEditAmount => !hasSpentMoney;
  bool get canEditPeriod => !hasSpentMoney;
  bool get canEditDates => !hasSpentMoney;

  @override
  void initState() {
    super.initState();

    _budgetAmountController = TextEditingController(
      text: widget.budget.amount.toStringAsFixed(0),
    );
    _budgetDescriptionController = TextEditingController(
      text: widget.budget.description,
    );
    _budgetPeriodController = TextEditingController(
      text: widget.budget.period.name.toCapitalized(),
    );

    _balanceNotifier = ValueNotifier<String>(
      NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2)
          .format(widget.budget.amount),
    );
    _selectedStartDateNotifier =
        ValueNotifier<DateTime>(widget.budget.startDate);
    _selectedEndDateNotifier = ValueNotifier<DateTime>(widget.budget.endDate);
    _selectedPeriodNotifier =
        ValueNotifier<BudgetPeriod?>(widget.budget.period);

    _budgetAmountController.addListener(_updateBalance);
  }

  @override
  void dispose() {
    _budgetAmountController.dispose();
    _budgetDescriptionController.dispose();
    _budgetPeriodController.dispose();
    _balanceNotifier.dispose();
    _selectedStartDateNotifier.dispose();
    _selectedEndDateNotifier.dispose();
    _selectedPeriodNotifier.dispose();
    super.dispose();
  }

  void _updateBalance() {
    final amountText = _budgetAmountController.text;
    double amount = double.tryParse(amountText.replaceAll(',', '')) ?? 0.0;
    String formattedAmount = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 2,
    ).format(amount);
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
        return _selectedEndDateNotifier
            .value; // Keep existing end date for custom
    }
  }

  void _updateEndDateFromPeriod() {
    if (_selectedPeriodNotifier.value != BudgetPeriod.custom) {
      _selectedEndDateNotifier.value = _calculateEndDate(
        _selectedStartDateNotifier.value,
        _selectedPeriodNotifier.value!,
      );
    }
  }

  void _updateBudget() {
    // Validate inputs
    if (_budgetAmountController.text.isEmpty) {
      showBanner(
        context: context,
        theMessage: "Please enter budget amount",
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

    // Create updated budget
    final updatedBudget = widget.budget.copyWith(
      amount: amount,
      description: _budgetDescriptionController.text.isEmpty
          ? '${_selectedPeriodNotifier.value!.name.toCapitalized()} ${widget.budget.category.label} budget'
          : _budgetDescriptionController.text,
      period: _selectedPeriodNotifier.value!,
      startDate: _selectedStartDateNotifier.value,
      endDate: _selectedEndDateNotifier.value,
    );

    // Call callback and close modal
    widget.onBudgetUpdated(updatedBudget);

    showBanner(
      context: context,
      theMessage: "Budget updated successfully!",
      theType: NotificationType.success,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 750.h,
      padding: 20.padH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: widget.budget.category.color.withValues(alpha: 0.25),
                ),
                child: Icon(
                  widget.budget.category.icon,
                  size: 20.h,
                  color: widget.budget.category.color,
                ),
              ),
              12.sbW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Edit Budget".txt(size: 16.sp, fontW: F.w6),
                    widget.budget.category.label
                        .txt(size: 12.sp, color: Palette.greyColor),
                  ],
                ),
              ),
            ],
          ),

          20.sbH,

          // Warning if money has been spent
          if (hasSpentMoney) ...[
            Container(
              padding: 12.0.padA,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsBold.warning,
                    size: 18.h,
                    color: Colors.orange,
                  ),
                  10.sbW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Limited Editing".txt(
                          size: 12.sp,
                          color: Colors.orange,
                          fontW: F.w6,
                        ),
                        "You've spent N${widget.budget.spentAmount.toStringAsFixed(0)} from this budget. Some fields are locked."
                            .txt(
                          size: 11.sp,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            15.sbH,
          ],

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Amount Field
                  _buildEditableField(
                    label: "Budget Amount",
                    canEdit: canEditAmount,
                    child: TextInputWidget(
                      controller: _budgetAmountController,
                      hintText: "Amount",
                      keyboardType: TextInputType.number,
                      isTextFieldEnabled: canEditAmount,
                      onChanged: (value) => _updateBalance(),
                      prefix: Padding(
                        padding: 12.5.padA,
                        child: Icon(
                          PhosphorIconsBold.currencyNgn,
                          color: canEditAmount
                              ? Palette.greyColor
                              : Palette.greyColor.withValues(alpha: 0.5),
                          size: 20.h,
                        ),
                      ),
                    ),
                  ),

                  15.sbH,

                  // Description Field (Always editable)
                  "Description".txt(size: 14.sp, fontW: F.w5).alignCenterLeft(),
                  8.sbH,
                  TextInputWidget(
                    controller: _budgetDescriptionController,
                    hintText: "Description",
                    maxLength: 50,
                    prefix: Padding(
                      padding: 12.5.padA,
                      child: Icon(
                        PhosphorIconsFill.article,
                        color: Palette.greyColor,
                        size: 20.h,
                      ),
                    ),
                  ),

                  15.sbH,

                  // Period Field
                  _buildEditableField(
                    label: "Budget Period",
                    canEdit: canEditPeriod,
                    child: TextInputWidget(
                      onTap: canEditPeriod ? _showPeriodPicker : null,
                      isTextFieldEnabled: false,
                      hintText: "Budget Period",
                      controller: _budgetPeriodController,
                      prefix: Padding(
                        padding: 12.5.padA,
                        child: Icon(
                          PhosphorIconsFill.clockClockwise,
                          color: canEditPeriod
                              ? Palette.greyColor
                              : Palette.greyColor.withValues(alpha: 0.5),
                          size: 20.h,
                        ),
                      ),
                      suffixIcon: canEditPeriod
                          ? Padding(
                              padding: 15.padH,
                              child: Icon(
                                PhosphorIconsRegular.caretDown,
                                size: 20.h,
                                color: Palette.textFieldGrey,
                              ),
                            )
                          : Padding(
                              padding: 15.padH,
                              child: Icon(
                                PhosphorIconsBold.lock,
                                size: 16.h,
                                color: Palette.greyColor.withValues(alpha: 0.5),
                              ),
                            ),
                    ),
                  ),

                  15.sbH,

                  // Date Fields (only for custom period)
                  ValueListenableBuilder<BudgetPeriod?>(
                    valueListenable: _selectedPeriodNotifier,
                    builder: (context, period, _) {
                      if (period != BudgetPeriod.custom) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          // Start Date
                          _buildEditableField(
                            label: "Start Date",
                            canEdit: canEditDates,
                            child: ValueListenableBuilder<DateTime>(
                              valueListenable: _selectedStartDateNotifier,
                              builder: (context, startDate, _) {
                                return Container(
                                  width: double.infinity,
                                  height: 50.h,
                                  padding: 15.padH,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(
                                      color: canEditDates
                                          ? Palette.greyColor
                                          : Palette.greyColor
                                              .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        PhosphorIconsFill.calendarBlank,
                                        color: canEditDates
                                            ? Palette.greyColor
                                            : Palette.greyColor
                                                .withValues(alpha: 0.5),
                                        size: 20.h,
                                      ),
                                      15.sbW,
                                      DateFormat('E, dd MMM, yyyy')
                                          .format(startDate)
                                          .txt(size: 14.sp),
                                      const Spacer(),
                                      if (!canEditDates)
                                        Icon(
                                          PhosphorIconsBold.lock,
                                          size: 16.h,
                                          color: Palette.greyColor
                                              .withValues(alpha: 0.5),
                                        ),
                                    ],
                                  ),
                                ).tap(
                                    onTap: canEditDates
                                        ? () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: startDate,
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2099),
                                            );
                                            if (picked != null) {
                                              _selectedStartDateNotifier.value =
                                                  picked;
                                            }
                                          }
                                        : null);
                              },
                            ),
                          ),

                          10.sbH,

                          // End Date
                          _buildEditableField(
                            label: "End Date",
                            canEdit: canEditDates,
                            child: ValueListenableBuilder<DateTime>(
                              valueListenable: _selectedEndDateNotifier,
                              builder: (context, endDate, _) {
                                return Container(
                                  width: double.infinity,
                                  height: 50.h,
                                  padding: 15.padH,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(
                                      color: canEditDates
                                          ? Palette.greyColor
                                          : Palette.greyColor
                                              .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        PhosphorIconsFill.calendarCheck,
                                        color: canEditDates
                                            ? Palette.greyColor
                                            : Palette.greyColor
                                                .withValues(alpha: 0.5),
                                        size: 20.h,
                                      ),
                                      15.sbW,
                                      DateFormat('E, dd MMM, yyyy')
                                          .format(endDate)
                                          .txt(size: 14.sp),
                                      const Spacer(),
                                      if (!canEditDates)
                                        Icon(
                                          PhosphorIconsBold.lock,
                                          size: 16.h,
                                          color: Palette.greyColor
                                              .withValues(alpha: 0.5),
                                        ),
                                    ],
                                  ),
                                ).tap(
                                    onTap: canEditDates
                                        ? () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: endDate,
                                              firstDate:
                                                  _selectedStartDateNotifier
                                                      .value
                                                      .add(const Duration(
                                                          days: 1)),
                                              lastDate: DateTime(2099),
                                            );
                                            if (picked != null) {
                                              _selectedEndDateNotifier.value =
                                                  picked;
                                            }
                                          }
                                        : null);
                              },
                            ),
                          ),

                          15.sbH,
                        ],
                      );
                    },
                  ),

                  // Recurring Info (Read-only)
                  Row(
                    children: [
                      Icon(
                        PhosphorIconsFill.repeat,
                        color: Palette.greyColor,
                        size: 20.h,
                      ),
                      12.sbW,
                      "Recurring Budget".txt(size: 14.sp, fontW: F.w5),
                      const Spacer(),
                      if (widget.budget.isRecurring)
                        "Yes".txt(
                          size: 14.sp,
                          color: Palette.greenColor,
                          fontW: F.w6,
                        )
                      else
                        "No".txt(
                          size: 12.sp,
                          color: Palette.greyColor,
                          fontW: F.w6,
                        ),
                    ],
                  ),

                  if (widget.budget.isRecurring) ...[
                    8.sbH,
                    "This budget will automatically renew when it expires"
                        .txt(
                          size: 11.sp,
                          color: Palette.greyColor,
                          fontStyle: FontStyle.italic,
                        )
                        .alignCenterLeft(),
                  ],

                  30.sbH,
                ],
              ),
            ),
          ),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  color: Palette.greyFill,
                  textColor: Palette.blackColor,
                  text: "Cancel",
                  onTap: () => Navigator.pop(context),
                ),
              ),
              15.sbW,
              Expanded(
                child: AppButton(
                  color: Palette.montraPurple,
                  text: "Save Changes",
                  onTap: () {},
                ),
              ),
            ],
          ),
          20.sbH
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required bool canEdit,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            label.txt(size: 14.sp, fontW: F.w5),
            if (!canEdit) ...[
              8.sbW,
              Icon(
                PhosphorIconsBold.lock,
                size: 14.h,
                color: Palette.greyColor.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),
        8.sbH,
        child,
      ],
    );
  }

  void _showPeriodPicker() {
    showCustomModal(
      context,
      modalHeight: 350.h,
      child: ListView.builder(
        padding: 15.padH,
        shrinkWrap: true,
        itemCount: BudgetPeriod.values.length,
        itemBuilder: (context, index) {
          final period = BudgetPeriod.values[index];
          final icons = [
            PhosphorIconsFill.calendarX,
            PhosphorIconsFill.calendarBlank,
            PhosphorIconsFill.calendarPlus,
            PhosphorIconsFill.calendarCheck,
            PhosphorIconsFill.clockClockwise,
          ];

          return ListTile(
            leading: Icon(icons[index], color: Palette.montraPurple),
            title: period.name.toCapitalized().txt(size: 14.sp),
            onTap: () {
              _selectedPeriodNotifier.value = period;
              _budgetPeriodController.text = period.name.toCapitalized();
              _updateEndDateFromPeriod();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
