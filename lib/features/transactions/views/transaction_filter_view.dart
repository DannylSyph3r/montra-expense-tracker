import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionFilterView extends StatefulWidget {
  const TransactionFilterView({super.key});

  @override
  State<TransactionFilterView> createState() => _TransactionFilterViewState();
}

class _TransactionFilterViewState extends State<TransactionFilterView> {
  // Filter state
  final ValueNotifier<String?> _selectedQuickFilterNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<TransactionType?> _selectedTypeNotifier =
      ValueNotifier<TransactionType?>(null);
  final ValueNotifier<String?> _selectedSortNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<Set<TransactionCategory>> _selectedCategoriesNotifier =
      ValueNotifier<Set<TransactionCategory>>({});

  @override
  void dispose() {
    _selectedQuickFilterNotifier.dispose();
    _selectedTypeNotifier.dispose();
    _selectedSortNotifier.dispose();
    _selectedCategoriesNotifier.dispose();
    super.dispose();
  }

  // Helper method to get categories filtered by type
  List<TransactionCategory> _getFilteredCategories(TransactionType? type) {
    if (type == null) return [];

    final filteredCategories = <TransactionCategory>[];
    final seenCategories = <TransactionCategory>{};

    for (var transaction in transactions) {
      if (transaction.transactionType == type &&
          !seenCategories.contains(transaction.transactionCategory)) {
        filteredCategories.add(transaction.transactionCategory);
        seenCategories.add(transaction.transactionCategory);
      }
    }

    // Sort alphabetically for consistent ordering
    filteredCategories.sort((a, b) => a.label.compareTo(b.label));

    return filteredCategories;
  }

  void _resetFilters() {
    _selectedQuickFilterNotifier.value = null;
    _selectedTypeNotifier.value = null;
    _selectedSortNotifier.value = null;
    _selectedCategoriesNotifier.value = {};
  }

  void _applyFilters() {
    // TODO: Implement filter logic
    goBack(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: 20.padH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickFiltersSection(),
                  _buildSectionDivider(),
                  _buildTransactionTypeSection(),
                  _buildSectionDivider(),
                  _buildSortBySection(),
                  _buildSectionDivider(),
                  _buildCategorySection(),
                  100.sbH,
                ],
              ),
            ),
          ),
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => goBack(context),
        icon: Icon(
          PhosphorIconsBold.arrowLeft,
          color: Palette.blackColor,
          size: 24.h,
        ),
      ),
      title: "Filter Transactions".txt18(fontW: F.w6),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: _resetFilters,
          child: "Reset".txt14(
            color: Palette.montraPurple,
            fontW: F.w6,
          ),
        ),
        10.sbW,
      ],
    );
  }

  Widget _buildSectionDivider() {
    return Column(
      children: [
        25.sbH,
        Divider(
          color: Palette.greyColor.withOpacity(0.2),
          thickness: 1,
          height: 1,
        ),
        25.sbH,
      ],
    );
  }

  Widget _buildQuickFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIconsBold.clockClockwise,
              size: 20.h,
              color: Palette.montraPurple,
            ),
            8.sbW,
            "Quick Filters".txt18(fontW: F.w6),
          ],
        ),
        8.sbH,
        "Filter transactions by common time periods".txt12(
          color: Palette.greyColor,
        ),
        15.sbH,
        Wrap(
          spacing: 12.w,
          runSpacing: 10.h,
          children: ["Today", "This Week", "This Month", "All"]
              .map((filter) => _buildQuickFilterChip(filter))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTransactionTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIconsBold.arrowsLeftRight,
              size: 20.h,
              color: Palette.montraPurple,
            ),
            8.sbW,
            "Transaction Type".txt18(fontW: F.w6),
          ],
        ),
        8.sbH,
        "Choose between income and expense transactions".txt12(
          color: Palette.greyColor,
        ),
        15.sbH,
        Row(
          children: [
            Expanded(
              child: _buildTypeChip(
                  TransactionType.income, "Income", PhosphorIconsBold.trendUp),
            ),
            12.sbW,
            Expanded(
              child: _buildTypeChip(TransactionType.expense, "Expense",
                  PhosphorIconsBold.trendDown),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIconsBold.sortAscending,
              size: 20.h,
              color: Palette.montraPurple,
            ),
            8.sbW,
            "Sort By".txt18(fontW: F.w6),
          ],
        ),
        8.sbH,
        "Order transactions by date or amount".txt12(
          color: Palette.greyColor,
        ),
        15.sbH,
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            _buildSortChip("Newest", PhosphorIconsBold.calendarPlus),
            _buildSortChip("Oldest", PhosphorIconsBold.calendarMinus),
            _buildSortChip("Highest", PhosphorIconsBold.arrowUp),
            _buildSortChip("Lowest", PhosphorIconsBold.arrowDown),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return ValueListenableBuilder<TransactionType?>(
      valueListenable: _selectedTypeNotifier,
      builder: (context, selectedType, child) {
        final filteredCategories = _getFilteredCategories(selectedType);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<Set<TransactionCategory>>(
              valueListenable: _selectedCategoriesNotifier,
              builder: (context, selectedCategories, child) {
                return Row(
                  children: [
                    Icon(
                      PhosphorIconsBold.tag,
                      size: 20.h,
                      color: Palette.montraPurple,
                    ),
                    8.sbW,
                    "Categories".txt18(fontW: F.w6),
                    if (selectedCategories.isNotEmpty) ...[
                      10.sbW,
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Palette.montraPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: "${selectedCategories.length} selected".txt(
                          size: 10.sp,
                          color: Palette.montraPurple,
                          fontW: F.w6,
                        ),
                      ),
                    ]
                  ],
                );
              },
            ),
            8.sbH,
            "Filter by spending categories. You can select multiple categories."
                .txt12(
              color: Palette.greyColor,
            ),
            15.sbH,
            _buildCategoryContent(selectedType, filteredCategories),
          ],
        );
      },
    );
  }

  Widget _buildCategoryContent(TransactionType? selectedType,
      List<TransactionCategory> filteredCategories) {
    if (selectedType == null) {
      return _buildEmptyState(
        icon: PhosphorIconsBold.tag,
        title: "Select Transaction Type",
        subtitle: "Choose income or expense to view available categories",
      );
    }

    if (filteredCategories.isEmpty) {
      return _buildEmptyState(
        icon: PhosphorIconsBold.warningCircle,
        title: "No Categories Found",
        subtitle: "No transactions exist for the selected type",
      );
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: filteredCategories
          .map((category) => _buildCategoryChip(category))
          .toList(),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Palette.greyFill,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Palette.greyColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40.h,
            color: Palette.greyColor,
          ),
          12.sbH,
          title.txt16(
            color: Palette.blackColor,
            fontW: F.w6,
            textAlign: TextAlign.center,
          ),
          6.sbH,
          subtitle.txt12(
            color: Palette.greyColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterChip(String filter) {
    return ValueListenableBuilder<String?>(
      valueListenable: _selectedQuickFilterNotifier,
      builder: (context, selectedFilter, child) {
        final bool isSelected = selectedFilter == filter;

        return GestureDetector(
          onTap: () {
            _selectedQuickFilterNotifier.value = isSelected ? null : filter;
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? Palette.montraPurple : Palette.greyFill,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected
                    ? Palette.montraPurple
                    : Palette.greyColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Text(
              filter,
              style: TextStyle(
                color: isSelected ? Palette.whiteColor : Palette.blackColor,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeChip(TransactionType type, String label, IconData icon) {
    return ValueListenableBuilder<TransactionType?>(
      valueListenable: _selectedTypeNotifier,
      builder: (context, selectedType, child) {
        final bool isSelected = selectedType == type;

        return GestureDetector(
          onTap: () {
            _selectedTypeNotifier.value = isSelected ? null : type;
            if (!isSelected) {
              _selectedCategoriesNotifier.value = {};
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isSelected ? Palette.montraPurple : Palette.greyFill,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? Palette.montraPurple
                    : Palette.greyColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18.h,
                  color: isSelected ? Palette.whiteColor : Palette.greyColor,
                ),
                8.sbW,
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Palette.whiteColor : Palette.blackColor,
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortChip(String sort, IconData icon) {
    return ValueListenableBuilder<String?>(
      valueListenable: _selectedSortNotifier,
      builder: (context, selectedSort, child) {
        final bool isSelected = selectedSort == sort;

        return GestureDetector(
          onTap: () {
            _selectedSortNotifier.value = isSelected ? null : sort;
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? Palette.montraPurple : Palette.greyFill,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? Palette.montraPurple
                    : Palette.greyColor.withOpacity(0.2),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14.h,
                  color: isSelected ? Palette.whiteColor : Palette.greyColor,
                ),
                6.sbW,
                Text(
                  sort,
                  style: TextStyle(
                    color: isSelected ? Palette.whiteColor : Palette.blackColor,
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(TransactionCategory category) {
    return ValueListenableBuilder<Set<TransactionCategory>>(
      valueListenable: _selectedCategoriesNotifier,
      builder: (context, selectedCategories, child) {
        final bool isSelected = selectedCategories.contains(category);

        return GestureDetector(
          onTap: () {
            final newSelectedCategories =
                Set<TransactionCategory>.from(selectedCategories);
            if (isSelected) {
              newSelectedCategories.remove(category);
            } else {
              newSelectedCategories.add(category);
            }
            _selectedCategoriesNotifier.value = newSelectedCategories;
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? Palette.montraPurple : Palette.greyFill,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? Palette.montraPurple
                    : Palette.greyColor.withOpacity(0.2),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  category.icon,
                  size: 14.h,
                  color: isSelected ? Palette.whiteColor : category.color,
                ),
                6.sbW,
                Text(
                  category.label,
                  style: TextStyle(
                    color: isSelected ? Palette.whiteColor : Palette.blackColor,
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (isSelected) ...[
                  4.sbW,
                  Icon(
                    PhosphorIconsBold.check,
                    size: 12.h,
                    color: Palette.whiteColor,
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: 20.padH,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: AppButton(
          text: "Apply Filters",
          onTap: _applyFilters,
        ),
      ),
    );
  }
}
