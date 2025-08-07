import 'package:dotted_border/dotted_border.dart';
import 'package:expense_tracker_app/features/onboarding/widgets/option_seletion_tile.dart';
import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
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

  // Generate transaction type options directly from enum
  List<Map<String, dynamic>> get transactionTypeOptions => [
        {
          'icon': PhosphorIconsFill.coins,
          'label': 'Income',
          'type': TransactionType.income
        },
        {
          'icon': PhosphorIconsFill.signOut,
          'label': 'Expense',
          'type': TransactionType.expense
        },
      ];

  // Convert TransactionCategory enum to expected format
  List<Map<String, dynamic>> _getFilteredCategories() {
    final selectedType = _selectedTransactionTypeNotifer.value;

    if (selectedType == null) {
      return [];
    }

    List<TransactionCategory> categories =
        selectedType == TransactionType.income
            ? TransactionCategory.getIncomeCategories()
            : TransactionCategory.getExpenseCategories();

    return categories
        .map((category) => {
              'name': category.label,
              'icon': category.icon,
              'color': category.color,
              'category': category,
            })
        .toList();
  }

  void _onTransactionTypeChanged() {
    if (_transactionCategoryController.text.isNotEmpty) {
      final selectedType = _selectedTransactionTypeNotifer.value;
      if (selectedType != null) {
        final validCategories = _getFilteredCategories();
        final currentCategoryName = _transactionCategoryController.text;
        final isValidCategory =
            validCategories.any((cat) => cat['name'] == currentCategoryName);

        if (!isValidCategory) {
          _transactionCategoryController.clear();
        }
      }
    }
  }

  void _onInvoiceScan() {
    showModalBottomSheet(
      context: context,
      builder: (context) => DocPickerModalBottomSheet(
        headerText: "Attach an Invoice",
        descriptionText:
            "Take a photo of your invoice. Select images from your gallery",
        onTakeDocPicture: () {
          goBack(context);
          // TODO: Add receipt scanning logic here
          // This will eventually process the image and navigate to add transaction with pre-filled data
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _transactionAmountController.addListener(_updateBalance);

    // Clear category when transaction type changes if it's not valid
    _selectedTransactionTypeNotifer.addListener(_onTransactionTypeChanged);
  }

  @override
  void dispose() {
    _selectedTransactionTypeNotifer.removeListener(_onTransactionTypeChanged);
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
                              middle: "$transactionText Transaction".txt(
                                  size: 16.sp,
                                  color: Palette.whiteColor,
                                  fontW: F.w5),
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
                                      Flexible(
                                        child: "N$balance".txt(
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
                                        showCustomModal(
                                          context,
                                          modalHeight: 180.h,
                                          child: ListView.builder(
                                            padding: 15.padH,
                                            shrinkWrap: true,
                                            itemCount:
                                                transactionTypeOptions.length,
                                            itemBuilder: (context, index) {
                                              return OptionSelectionListTile(
                                                leadingIcon:
                                                    transactionTypeOptions[
                                                            index]['icon']
                                                        as IconData,
                                                interactiveTrailing: false,
                                                titleFontSize: 15.sp,
                                                titleLabel:
                                                    transactionTypeOptions[
                                                            index]['label']
                                                        as String,
                                                onTileTap: () {
                                                  _selectedTransactionTypeNotifer
                                                          .value =
                                                      transactionTypeOptions[
                                                              index]['type']
                                                          as TransactionType;
                                                  _transactionTypeController
                                                          .text =
                                                      transactionTypeOptions[
                                                          index]['label'];
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      isTextFieldEnabled: false,
                                      hintText: " Transaction Type",
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
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      controller: _transactionTypeController,
                                      suffixIcon: Padding(
                                        padding: 15.padH,
                                        child: Icon(
                                          PhosphorIconsRegular.caretDown,
                                          size: 20.h,
                                          color: Palette.textFieldGrey,
                                        ),
                                      ),
                                    ),
                                    10.sbH,

                                    // Category Selection - Conditional based on transaction type
                                    ValueListenableBuilder<TransactionType?>(
                                      valueListenable:
                                          _selectedTransactionTypeNotifer,
                                      builder: (context, selectedType, child) {
                                        final isEnabled = selectedType != null;
                                        final filteredCategories =
                                            _getFilteredCategories();

                                        return TextInputWidget(
                                          onTap: isEnabled
                                              ? () {
                                                  // Clear category if it's not valid for the new transaction type
                                                  if (_transactionCategoryController
                                                      .text.isNotEmpty) {
                                                    final currentCategoryName =
                                                        _transactionCategoryController
                                                            .text;
                                                    final isValidCategory =
                                                        filteredCategories.any(
                                                            (cat) =>
                                                                cat['name'] ==
                                                                currentCategoryName);

                                                    if (!isValidCategory) {
                                                      _transactionCategoryController
                                                          .clear();
                                                    }
                                                  }

                                                  showCustomModal(
                                                    context,
                                                    modalHeight: 730.h,
                                                    child: Column(
                                                      children: [
                                                        // Modal header
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15.w),
                                                          child: Text(
                                                            selectedType ==
                                                                    TransactionType
                                                                        .income
                                                                ? 'Select Income Category'
                                                                : 'Select Expense Category',
                                                            style: TextStyle(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Palette
                                                                  .blackColor,
                                                            ),
                                                          ),
                                                        ),

                                                        // Categories list
                                                        Expanded(
                                                          child:
                                                              ListView.builder(
                                                            padding: 15.padH,
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                filteredCategories
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return OptionSelectionListTile(
                                                                leadingIconColor:
                                                                    filteredCategories[index]
                                                                            [
                                                                            'color']
                                                                        as Color,
                                                                leadingIcon: filteredCategories[
                                                                            index]
                                                                        ['icon']
                                                                    as IconData,
                                                                interactiveTrailing:
                                                                    false,
                                                                titleFontSize:
                                                                    15.sp,
                                                                titleLabel: filteredCategories[
                                                                            index]
                                                                        ['name']
                                                                    as String,
                                                                onTileTap: () {
                                                                  _transactionCategoryController
                                                                          .text =
                                                                      filteredCategories[
                                                                              index]
                                                                          [
                                                                          'name'];
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              : null,
                                          isTextFieldEnabled: false,
                                          hintText: selectedType == null
                                              ? "Select transaction type"
                                              : "Category",
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
                                                    PhosphorIconsFill.tag,
                                                    color: isEnabled
                                                        ? Palette.greyColor
                                                        : Palette.greyColor
                                                            .withValues(alpha: 0.5),
                                                    size: 20.h,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          controller:
                                              _transactionCategoryController,
                                          suffixIcon: Padding(
                                            padding: 15.padH,
                                            child: Icon(
                                              PhosphorIconsRegular.caretDown,
                                              size: 20.h,
                                              color: isEnabled
                                                  ? Palette.textFieldGrey
                                                  : Palette.textFieldGrey
                                                      .withValues(alpha: 0.5),
                                            ),
                                          ),
                                        );
                                      },
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
                                                PhosphorIconsFill.currencyNgn,
                                                color: Palette.greyColor,
                                                size: 20.h,
                                              ),
                                            ),
                                          ),
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
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      controller:
                                          _transactionDescriptionController,
                                    ),
                                    10.sbH,

                                    // Date Selection
                                    ValueListenableBuilder<DateTime>(
                                      valueListenable: _selectedDateNotifier,
                                      builder: (context, selectedDate, _) {
                                        return TextInputWidget(
                                          isTextFieldEnabled: false,
                                          hintText: "Date & Time",
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
                                                    PhosphorIconsFill.calendar,
                                                    color: Palette.greyColor,
                                                    size: 20.h,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          controller: TextEditingController(
                                            text: DateFormat('dd/MM/yyyy HH:mm')
                                                .format(selectedDate),
                                          ),
                                          onTap: () async {
                                            // First show date picker
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: selectedDate,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2099),
                                            );

                                            if (pickedDate != null) {
                                              // Then show time picker with smaller text/numbers
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime:
                                                    TimeOfDay.fromDateTime(
                                                        selectedDate),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      timePickerTheme:
                                                          TimePickerThemeData(
                                                        // Make the hour/minute numbers smaller
                                                        hourMinuteTextStyle:
                                                            TextStyle(
                                                          fontSize: 40
                                                              .sp, // Reduced from default (~60sp)
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        // Make the AM/PM text smaller
                                                        dayPeriodTextStyle:
                                                            TextStyle(
                                                          fontSize: 12
                                                              .sp, // Reduced from default (~16sp)
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        // Customize other elements if needed
                                                        dialTextStyle:
                                                            TextStyle(
                                                          fontSize: 14
                                                              .sp, // Numbers on the clock dial
                                                        ),
                                                        helpTextStyle:
                                                            TextStyle(
                                                          fontSize: 12
                                                              .sp, // "Select time" text
                                                        ),
                                                      ),
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                              );

                                              if (pickedTime != null) {
                                                // Combine date and time
                                                final newDateTime = DateTime(
                                                  pickedDate.year,
                                                  pickedDate.month,
                                                  pickedDate.day,
                                                  pickedTime.hour,
                                                  pickedTime.minute,
                                                );
                                                _selectedDateNotifier.value =
                                                    newDateTime;
                                              } else {
                                                // If user cancels time picker, just update with date and keep current time
                                                final newDateTime = DateTime(
                                                  pickedDate.year,
                                                  pickedDate.month,
                                                  pickedDate.day,
                                                  selectedDate.hour,
                                                  selectedDate.minute,
                                                );
                                                _selectedDateNotifier.value =
                                                    newDateTime;
                                              }
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    10.sbH,

                                    // File attachment section
                                    DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(12.r),
                                      dashPattern: const [8, 4],
                                      color: Palette.greyColor.withValues(alpha: 0.4),
                                      strokeWidth: 1.5,
                                      child: Container(
                                        width: double.infinity,
                                        padding: 20.0.padA,
                                        decoration: BoxDecoration(
                                          color: Palette.greyColor
                                              .withValues(alpha: 0.05),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              PhosphorIconsFill.paperclip,
                                              color: Palette.greyColor,
                                              size: 32.h,
                                            ),
                                            8.sbH,
                                            "Attach Invoice".txt(
                                              size: 14.sp,
                                              color: Palette.greyColor,
                                              fontW: F.w5,
                                            ),
                                            4.sbH,
                                            "Optional".txt(
                                              size: 12.sp,
                                              color: Palette.greyColor
                                                  .withValues(alpha: 0.7),
                                            ),
                                          ],
                                        ),
                                      ).tap(onTap: () {
                                        _onInvoiceScan();
                                      }),
                                    ),
                                    30.sbH,

                                    // Transaction Information Card
                                    Container(
                                      width: double.infinity,
                                      padding: 15.0.padA,
                                      decoration: BoxDecoration(
                                        color: backgroundColor.withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border: Border.all(
                                            color: backgroundColor
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
                                                color: backgroundColor,
                                                size: 16.h,
                                              ),
                                              8.sbW,
                                              "Transaction Details".txt(
                                                size: 12.sp,
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
                                        final isEnabled =
                                            _transactionTypeController
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
