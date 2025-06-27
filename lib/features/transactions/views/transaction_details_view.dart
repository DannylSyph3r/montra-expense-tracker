import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/dotted_divider.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/serrated_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionsDetailsView extends StatefulWidget {
  final String transactionAmount;
  final String transactionType; // "Income" or "Expense"
  final String category;
  final String time;
  final String date;
  final String description;
  final List<String>? attachmentImages; // Optional list of image paths
  final VoidCallback? onDelete; // Optional delete callback

  const TransactionsDetailsView({
    super.key,
    required this.transactionAmount,
    required this.transactionType,
    required this.category,
    required this.time,
    required this.date,
    required this.description,
    this.attachmentImages,
    this.onDelete,
  });

  @override
  State<TransactionsDetailsView> createState() =>
      _TransactionsDetailsViewState();
}

class _TransactionsDetailsViewState extends State<TransactionsDetailsView> {
  final ValueNotifier<int> _imageCarouselIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _imageCarouselIndexNotifier.dispose();
    super.dispose();
  }

  // Helper method to get transaction type color and icon
  Color get _transactionTypeColor {
    return widget.transactionType.toLowerCase() == 'income'
        ? Colors.green
        : Colors.red;
  }

  // Helper method to format amount with commas
  String _formatAmountWithCommas(String amount) {
    // Remove any existing formatting and extract the number
    String cleanAmount = amount.replaceAll(RegExp(r'[^\d.]'), '');

    if (cleanAmount.isEmpty) return amount;

    // Split by decimal point
    List<String> parts = cleanAmount.split('.');
    String wholePart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Add commas to whole number part
    String formattedWhole = '';
    for (int i = 0; i < wholePart.length; i++) {
      if (i > 0 && (wholePart.length - i) % 3 == 0) {
        formattedWhole += ',';
      }
      formattedWhole += wholePart[i];
    }

    // Get currency symbol from original amount
    String currencySymbol = amount.replaceAll(RegExp(r'[\d.,\s]'), '');

    return '$currencySymbol$formattedWhole$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Palette.montraPurple,
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
                        middle: "Transaction Details"
                            .txt16(color: Palette.whiteColor, fontW: F.w5),
                        trailing: widget.onDelete != null
                            ? const Icon(PhosphorIconsFill.trash,
                                    color: Palette.whiteColor)
                                .tap(onTap: () {
                                showCustomModal(context,
                                    modalHeight: 230.h,
                                    child: Padding(
                                      padding: 15.padH,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          "Remove this Transaction?".txt16(),
                                          15.sbH,
                                          AppTexts.removeTransactionConfirmation
                                              .txt14(
                                                  color: Palette.greyColor,
                                                  textAlign: TextAlign.center),
                                          20.sbH,
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: AppButton(
                                                      color: Palette
                                                          .montraPurple
                                                          .withOpacity(0.2),
                                                      text: "No",
                                                      textColor:
                                                          Palette.montraPurple,
                                                      onTap: () {
                                                        goBack(context);
                                                      })),
                                              15.sbW,
                                              Expanded(
                                                  child: AppButton(
                                                      text: "Yes",
                                                      onTap: () {
                                                        goBack(context);
                                                        widget.onDelete?.call();
                                                      })),
                                            ],
                                          )
                                        ],
                                      ),
                                    ));
                              })
                            : const SizedBox.shrink(),
                      ),
                      50.sbH,
                      // Responsive amount display
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child:
                              _formatAmountWithCommas(widget.transactionAmount)
                                  .txt(
                            size: 30.sp,
                            fontW: F.w8,
                            color: Palette.whiteColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      30.sbH
                    ],
                  ),
                  Column(
                    children: [
                      245.sbH,
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
                          minHeight: widget.attachmentImages != null &&
                                  widget.attachmentImages!.isNotEmpty
                              ? height(context) -
                                  250.h // Full height when carousel present
                              : height(context) -
                                  450.h, // Reduced height when no carousel
                          minWidth: double.infinity,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          child: Column(
                            children: [
                              DottedLineDivider(
                                color: Palette.offGrey,
                                dashWidth: 7.w,
                                dashSpace: 8.w,
                              ),
                              20.sbH, // Reduced from 30.sbH

                              // Transaction Type
                              _buildDetailRow(
                                label: "Type",
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      PhosphorIconsFill.circle,
                                      color: _transactionTypeColor,
                                      size: 14.sp,
                                    ),
                                    5.sbW,
                                    widget.transactionType.txt14(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Category
                              _buildDetailRow(
                                label: "Category",
                                content: widget.category.txt14(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ),

                              // Time
                              _buildDetailRow(
                                label: "Time",
                                content: widget.time.txt14(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ),

                              // Date - Responsive layout for long dates
                              _buildResponsiveDetailItem(
                                label: "Date",
                                value: widget.date,
                              ),

                              20.sbH, // Reduced from 30.sbH
                              DottedLineDivider(
                                color: Palette.offGrey,
                                dashWidth: 7.w,
                                dashSpace: 8.w,
                              ),
                              20.sbH, // Reduced from 30.sbH

                              // Description - Responsive layout for long descriptions
                              _buildResponsiveDetailItem(
                                label: "Description",
                                value: widget.description,
                                maxLines: 5,
                              ),

                              // Transaction Amount
                              _buildDetailRow(
                                label: "Transaction Amount",
                                content: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerRight,
                                  child: _formatAmountWithCommas(
                                          widget.transactionAmount)
                                      .txt(
                                    size: 14.sp,
                                    fontW: F.w8,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),

                              // Attachments - only show section if images exist
                              if (widget.attachmentImages != null &&
                                  widget.attachmentImages!.isNotEmpty) ...[
                                20.sbH, // Reduced from 30.sbH
                                DottedLineDivider(
                                  color: Palette.offGrey,
                                  dashWidth: 7.w,
                                  dashSpace: 8.w,
                                ),
                                20.sbH, // Reduced from 30.sbH
                                "Attachment"
                                    .txt14(
                                        color: Palette.greyColor, fontW: F.w6)
                                    .alignCenterLeft(),
                                10.sbH,
                                _buildAttachmentCarousel(),
                                20.sbH, // Reduced spacing after carousel
                              ] else ...[
                                // Minimal spacing when no attachments
                                15.sbH,
                              ],

                              DottedLineDivider(
                                color: Palette.offGrey,
                                dashWidth: 7.w,
                                dashSpace: 8.w,
                              ),
                              15.sbH, // Reduced final spacing
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
  }

  // Regular detail row for shorter content
  Widget _buildDetailRow({
    required String label,
    required Widget content,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h), // Reduced from 10.h
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.txt14(
            color: Palette.greyColor,
            fontW: F.w6,
          ),
          10.sbW,
          Flexible(
            child: content,
          ),
        ],
      ),
    );
  }

  // Responsive detail item that switches to column layout for long content
  Widget _buildResponsiveDetailItem({
    required String label,
    required String value,
    int maxLines = 3,
  }) {
    // Calculate if text would be too long for row layout
    final textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    textPainter.layout(maxWidth: 200.w); // Approximate available width
    final wouldOverflow = textPainter.didExceedMaxLines;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: wouldOverflow || value.length > 50
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label.txt14(
                  color: Palette.greyColor,
                  fontW: F.w6,
                ),
                8.sbH,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Palette.greyFill.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Palette.greyColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: value.txt14(
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label.txt14(
                  color: Palette.greyColor,
                  fontW: F.w6,
                ),
                10.sbW,
                Flexible(
                  child: value.txt14(
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAttachmentCarousel() {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: FlutterCarousel(
          items: widget.attachmentImages!.map((imagePath) {
            return imagePath.contains('http')
                ? Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    height: 180.h,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Palette.greyFill,
                        child: Icon(
                          PhosphorIconsBold.imageSquare,
                          color: Palette.greyColor,
                          size: 40.h,
                        ),
                      );
                    },
                  )
                : imagePath.contains('assets/')
                    ? Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        height: 180.h,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Palette.greyFill,
                            child: Icon(
                              PhosphorIconsBold.imageSquare,
                              color: Palette.greyColor,
                              size: 40.h,
                            ),
                          );
                        },
                      )
                    : AppGraphics.invoice.jpg.myImage(
                        fit: BoxFit.cover,
                        height: 180.h,
                        width: double.infinity,
                      );
          }).toList(),
          options: CarouselOptions(
            autoPlay: widget.attachmentImages!.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            viewportFraction: 1.0,
            initialPage: 0,
            showIndicator: widget.attachmentImages!.length > 1,
            height: 180.h,
            onPageChanged: (int index, CarouselPageChangedReason reason) {
              _imageCarouselIndexNotifier.value = index;
            },
          ),
        ),
      ),
    );
  }
}
