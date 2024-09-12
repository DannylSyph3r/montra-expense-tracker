import 'package:dotted_border/dotted_border.dart';
import 'package:expense_tracker_app/features/home/widgets/curved_painter.dart';
import 'package:expense_tracker_app/features/onboarding/widgets/option_seletion_tile.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  final List<Map<String, dynamic>> transactionType = [
    {'icon': PhosphorIconsFill.coins, 'label': 'Income'},
    {'icon': PhosphorIconsFill.signOut, 'label': 'Expense'},
  ];
  final List<Map<String, dynamic>> transactionCategories = [
    {
      'name': 'Cash Outflow',
      'icon': PhosphorIconsFill.signOut,
      'color': Colors.redAccent,
    },
    {
      'name': 'Groceries',
      'icon': PhosphorIconsFill.shoppingCart,
      'color': Colors.lightGreen,
    },
    {
      'name': 'Rent/Mortgage',
      'icon': PhosphorIconsFill.houseLine,
      'color': Colors.brown,
    },
    {
      'name': 'Utilities',
      'icon': PhosphorIconsFill.plug,
      'color': Colors.amber,
    },
    {
      'name': 'Transportation',
      'icon': PhosphorIconsFill.carSimple,
      'color': Colors.cyan,
    },
    {
      'name': 'Dining Out',
      'icon': PhosphorIconsFill.pizza,
      'color': Colors.deepOrange,
    },
    {
      'name': 'Health & Fitness',
      'icon': PhosphorIconsFill.heartbeat,
      'color': Colors.lightBlue,
    },
    {
      'name': 'Entertainment & Subscriptions',
      'icon': PhosphorIconsFill.filmSlate,
      'color': Colors.purpleAccent,
    },
    {
      'name': 'Shopping',
      'icon': PhosphorIconsFill.shoppingBag,
      'color': Colors.pinkAccent,
    },
    {
      'name': 'Insurance',
      'icon': PhosphorIconsFill.shield,
      'color': Colors.lightBlueAccent,
    },
    {
      'name': 'Salary/Wages',
      'icon': PhosphorIconsFill.briefcase,
      'color': Colors.deepPurpleAccent,
    },
    {
      'name': 'Cash Inflow',
      'icon': PhosphorIconsFill.coins,
      'color': Colors.green,
    },
  ];

  @override
  void dispose() {
    _transactionTypeController.dispose();
    _transactionCategoryController.dispose();
    _transactionAmountController.dispose();
    _transactionDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.montraPurple.withOpacity(0.94),
      body: CustomScrollView(
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
                          color: Palette.whiteColor),
                      middle: "Add Transaction"
                          .txt16(color: Palette.whiteColor, fontW: F.w5),
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
                  top: 230,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: 25.padH,
                      child: Container(
                        height: 450.h,
                        padding: 15.0.padA,
                        decoration: BoxDecoration(
                          color: Palette.whiteColor,
                          borderRadius: BorderRadius.circular(30.r),
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
                                    modalHeight: 180.h,
                                    child: ListView.builder(
                                      padding: 15.padH,
                                      shrinkWrap: true,
                                      itemCount: transactionType.length,
                                      itemBuilder: (context, index) {
                                        return OptionSelectionListTile(
                                          leadingIcon: transactionType[index]
                                              ['icon'] as IconData,
                                          interactiveTrailing: false,
                                          titleFontSize: 15.sp,
                                          titleLabel: transactionType[index]
                                              ['label'] as String,
                                          onTileTap: () {
                                            _transactionTypeController.text =
                                                transactionType[index]['label'];
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
                                child: Icon(PhosphorIconsRegular.caretDown,
                                    size: 20.h, color: Palette.textFieldGrey),
                              ),
                            ),
                            5.sbH,
                            TextInputWidget(
                              onTap: () {
                                showCustomModal(context,
                                    modalHeight: 730.h,
                                    child: ListView.builder(
                                      padding: 15.padH,
                                      shrinkWrap: true,
                                      itemCount: transactionCategories.length,
                                      itemBuilder: (context, index) {
                                        return OptionSelectionListTile(
                                          leadingIconColor:
                                              transactionCategories[index]
                                                  ['color'] as Color,
                                          leadingIcon:
                                              transactionCategories[index]
                                                  ['icon'] as IconData,
                                          interactiveTrailing: false,
                                          titleFontSize: 15.sp,
                                          titleLabel:
                                              transactionCategories[index]
                                                  ['name'] as String,
                                          onTileTap: () {
                                            _transactionCategoryController
                                                    .text =
                                                transactionCategories[index]
                                                    ['name'];
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
                              controller: _transactionCategoryController,
                              suffixIcon: Padding(
                                padding: 15.padH,
                                child: Icon(PhosphorIconsRegular.caretDown,
                                    size: 20.h, color: Palette.textFieldGrey),
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
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                color: Palette.montraPurple,
                                                width: 1.5))),
                                    height: 26.h,
                                    width: 26.h,
                                    child: Center(
                                        child: Padding(
                                      padding: 4.0.padH,
                                      child: "N"
                                          .txt14(
                                              fontW: F.w6,
                                              color: Palette.greyColor)
                                          .alignCenterLeft(),
                                    )),
                                  ),
                                ),
                                controller: _transactionAmountController,
                                keyboardType: TextInputType.number),
                            5.sbH,
                            TextInputWidget(
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
                              controller: _transactionDescriptionController,
                            ),
                            5.sbH,
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
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      PhosphorIconsFill.plusCircle,
                                      color: Palette.greyColor,
                                      size: 20.h,
                                    ),
                                    15.sbW,
                                    Text(
                                      "Attach Invoice Image",
                                      style: TextStyle(fontSize: 14.sp),
                                    )
                                  ],
                                ),
                              ),
                            ).tap(onTap: () {}),
                            15.sbH,
                            Container(
                              width: double.infinity,
                              height: 50.h,
                              padding: 15.padH,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.r)),
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
                                  "Tue, 22 Feb, 2024".txt(size: 14.sp)
                                ],
                              ),
                            ).tap(onTap: () {}),
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
