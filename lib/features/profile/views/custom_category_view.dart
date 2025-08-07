import 'package:expense_tracker_app/features/profile/views/create_category_view.dart';
import 'package:expense_tracker_app/shared/category_resources.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/snack_bar.dart';
import 'package:expense_tracker_app/utils/type_defs.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomCategoriesView extends StatefulWidget {
  const CustomCategoriesView({super.key});

  @override
  State<CustomCategoriesView> createState() => _CustomCategoriesViewState();
}

class _CustomCategoriesViewState extends State<CustomCategoriesView> {
  final ValueNotifier<List<Map<String, dynamic>>> _customCategoriesNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([
    {
      'name': 'Hobbies',
      'icon': PhosphorIconsBold.gameController,
      'color': Colors.purple,
    },
    {
      'name': 'Pet Care',
      'icon': PhosphorIconsBold.pawPrint,
      'color': Colors.orange,
    },
  ]);

  // Available icons for custom categories
  final List<IconData> availableIcons = CategoryResources.availableIcons;

  // Available colors for custom categories
  final List<Color> availableColors = CategoryResources.availableColors;

  @override
  void dispose() {
    _customCategoriesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsBold.arrowLeft,
              color: Palette.blackColor),
          onPressed: () => goBack(context),
        ),
        title: "Custom Categories".txt(size: 18.sp, fontW: F.w6),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _customCategoriesNotifier,
        builder: (context, customCategories, child) {
          return Column(
            children: [
              // Header Section
              Container(
                margin: 20.padH,
                padding: 20.0.padA,
                decoration: BoxDecoration(
                  color: Palette.montraPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border:
                      Border.all(color: Palette.montraPurple.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          PhosphorIconsBold.info,
                          color: Palette.montraPurple,
                          size: 20.h,
                        ),
                        10.sbW,
                        "Custom Categories".txt(
                            size: 16.sp,
                            fontW: F.w6,
                            color: Palette.montraPurple),
                      ],
                    ),
                    10.sbH,
                    "Create personalized categories for your unique spending habits. Add custom icons and colors to make tracking more intuitive."
                        .txt(size: 12.sp, color: Palette.greyColor),
                  ],
                ),
              ),
              20.sbH,

              // Categories List
              Expanded(
                child: customCategories.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: 20.padH,
                        itemCount: customCategories.length,
                        itemBuilder: (context, index) {
                          final category = customCategories[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: 16.0.padA,
                            decoration: BoxDecoration(
                              color: Palette.greyFill,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                // Category Icon
                                Container(
                                  height: 45.h,
                                  width: 45.h,
                                  decoration: BoxDecoration(
                                    color: (category['color'] as Color)
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(
                                    category['icon'] as IconData,
                                    size: 22.h,
                                    color: category['color'] as Color,
                                  ),
                                ),
                                15.sbW,

                                // Category Name
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (category['name'] as String)
                                          .txt(size: 16.sp, fontW: F.w5),
                                      4.sbH,
                                      "Custom category".txt(
                                          size: 12.sp,
                                          color: Palette.greyColor),
                                    ],
                                  ),
                                ),

                                // Actions
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 35.h,
                                      width: 35.h,
                                      decoration: BoxDecoration(
                                        color: Palette.montraPurple
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Icon(
                                        PhosphorIconsBold.pencil,
                                        size: 16.h,
                                        color: Palette.montraPurple,
                                      ),
                                    ).tap(
                                        onTap: () => _navigateToEditCategory(
                                            category, index)),
                                    10.sbW,
                                    Container(
                                      height: 35.h,
                                      width: 35.h,
                                      decoration: BoxDecoration(
                                        color:
                                            Palette.redColor.withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Icon(
                                        PhosphorIconsBold.trash,
                                        size: 16.h,
                                        color: Palette.redColor,
                                      ),
                                    ).tap(
                                        onTap: () =>
                                            _showDeleteConfirmation(category)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        height: 56.h,
        width: 56.h,
        decoration: BoxDecoration(
          color: Palette.montraPurple,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Palette.montraPurple.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          PhosphorIconsBold.plus,
          color: Palette.whiteColor,
          size: 24.h,
        ),
      ).tap(onTap: () => _navigateToAddCategory()),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: 40.padH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80.h,
              width: 80.h,
              decoration: const BoxDecoration(
                color: Palette.greyFill,
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIconsBold.folderOpen,
                size: 40.h,
                color: Palette.greyColor,
              ),
            ),
            20.sbH,
            "No Custom Categories Yet".txt(size: 18.sp, fontW: F.w6),
            10.sbH,
            "Create personalized categories to better organize your expenses and income."
                .txt(
              size: 14.sp,
              color: Palette.greyColor,
              textAlign: TextAlign.center,
            ),
            30.sbH,
            AppButton(
              text: "Create First Category",
              onTap: () => _navigateToAddCategory(),
              spanScreen: false,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddCategory() {
    goTo(
      context: context,
      view: CreateCategoryView(
        availableIcons: availableIcons,
        availableColors: availableColors,
        onCategoryCreated: (categoryData) {
          final updatedList =
              List<Map<String, dynamic>>.from(_customCategoriesNotifier.value);
          updatedList.add(categoryData);
          _customCategoriesNotifier.value = updatedList;

          // Store context reference before async gap
          final currentContext = context;
          Future.delayed(const Duration(milliseconds: 200), () {
            // Check if widget is still mounted before using context
            if (mounted) {
              showBanner(
                context: currentContext,
                theMessage: "Category added successfully",
                theType: NotificationType.success,
              );
            }
          });
        },
      ),
    );
  }

  void _navigateToEditCategory(Map<String, dynamic> category, int index) {
    goTo(
      context: context,
      view: CreateCategoryView(
        availableIcons: availableIcons,
        availableColors: availableColors,
        existingCategory: category,
        isEditing: true,
        onCategoryCreated: (categoryData) {
          final updatedList =
              List<Map<String, dynamic>>.from(_customCategoriesNotifier.value);
          updatedList[index] = categoryData;
          _customCategoriesNotifier.value = updatedList;

          // Store context reference before async gap
          final currentContext = context;
          Future.delayed(const Duration(milliseconds: 200), () {
            // Check if widget is still mounted before using context
            if (mounted) {
              showBanner(
                context: currentContext,
                theMessage: "Category updated successfully",
                theType: NotificationType.success,
              );
            }
          });
        },
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> category) {
    showCustomModal(
      context,
      modalHeight: 230.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            "Delete Category?".txt(size: 16.sp, fontW: F.w6),
            15.sbH,
            "Are you sure you want to delete '${category['name']}'? This action cannot be undone."
                .txt(
              size: 14.sp,
              color: Palette.greyColor,
              textAlign: TextAlign.center,
            ),
            20.sbH,
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
                    color: Palette.redColor,
                    text: "Delete",
                    onTap: () {
                      final updatedList = List<Map<String, dynamic>>.from(
                          _customCategoriesNotifier.value);
                      updatedList.remove(category);
                      _customCategoriesNotifier.value = updatedList;

                      Navigator.pop(context);
                      showBanner(
                        context: context,
                        theMessage: "Category deleted successfully",
                        theType: NotificationType.success,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
