import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/snack_bar.dart';
import 'package:expense_tracker_app/utils/type_defs.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
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
  final List<IconData> availableIcons = [
    PhosphorIconsBold.heart,
    PhosphorIconsBold.star,
    PhosphorIconsBold.house,
    PhosphorIconsBold.car,
    PhosphorIconsBold.coffee,
    PhosphorIconsBold.gameController,
    PhosphorIconsBold.book,
    PhosphorIconsBold.musicNote,
    PhosphorIconsBold.camera,
    PhosphorIconsBold.bicycle,
    PhosphorIconsBold.airplane,
    PhosphorIconsBold.gift,
    PhosphorIconsBold.pawPrint,
    PhosphorIconsBold.tree,
    PhosphorIconsBold.lightning,
    PhosphorIconsBold.moon,
    PhosphorIconsBold.fire,
    PhosphorIconsBold.leaf,
    PhosphorIconsBold.flower,
    PhosphorIconsBold.hamburger,
    PhosphorIconsBold.wine,
    PhosphorIconsBold.umbrella,
    PhosphorIconsBold.palette,
    PhosphorIconsBold.trophy,
  ];

  // Available colors for custom categories
  final List<Color> availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
    Colors.deepPurple,
    Colors.lightGreen,
  ];

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
        title: "Custom Categories".txt18(fontW: F.w6),
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
                  color: Palette.montraPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border:
                      Border.all(color: Palette.montraPurple.withOpacity(0.3)),
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
                        "Custom Categories"
                            .txt16(fontW: F.w6, color: Palette.montraPurple),
                      ],
                    ),
                    10.sbH,
                    "Create personalized categories for your unique spending habits. Add custom icons and colors to make tracking more intuitive."
                        .txt12(color: Palette.greyColor),
                  ],
                ),
              ),

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
                                        .withOpacity(0.2),
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
                                          .txt16(fontW: F.w5),
                                      4.sbH,
                                      "Custom category"
                                          .txt12(color: Palette.greyColor),
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
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Icon(
                                        PhosphorIconsBold.pencil,
                                        size: 16.h,
                                        color: Palette.montraPurple,
                                      ),
                                    ).tap(
                                        onTap: () => _showEditCategoryModal(
                                            category, index)),
                                    10.sbW,
                                    Container(
                                      height: 35.h,
                                      width: 35.h,
                                      decoration: BoxDecoration(
                                        color:
                                            Palette.redColor.withOpacity(0.1),
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
              color: Palette.montraPurple.withOpacity(0.3),
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
      ).tap(onTap: () => _showAddCategoryModal()),
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
            "No Custom Categories Yet".txt18(fontW: F.w6),
            10.sbH,
            "Create personalized categories to better organize your expenses and income."
                .txt14(
              color: Palette.greyColor,
              textAlign: TextAlign.center,
            ),
            30.sbH,
            AppButton(
              text: "Create First Category",
              onTap: () => _showAddCategoryModal(),
              spanScreen: false,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryModal() {
    _showCategoryModal();
  }

  void _showEditCategoryModal(Map<String, dynamic> category, int index) {
    _showCategoryModal(
      existingCategory: category,
      isEditing: true,
      editIndex: index,
    );
  }

  void _showCategoryModal({
    Map<String, dynamic>? existingCategory,
    bool isEditing = false,
    int? editIndex,
  }) {
    final TextEditingController categoryNameController = TextEditingController(
      text: existingCategory?['name'] ?? '',
    );
    final ValueNotifier<IconData?> selectedIconNotifier =
        ValueNotifier<IconData?>(
      existingCategory?['icon'],
    );
    final ValueNotifier<Color?> selectedColorNotifier = ValueNotifier<Color?>(
      existingCategory?['color'],
    );

    showCustomModal(
      context,
      modalHeight: 650.h,
      child: Padding(
        padding: 15.padH,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "${isEditing ? 'Edit' : 'Add'} Custom Category"
                  .txt18(fontW: F.w6),
              20.sbH,

              // Category Name Input
              "Category Name".txt14(fontW: F.w5),
              8.sbH,
              TextInputWidget(
                controller: categoryNameController,
                hintText: "Enter category name",
                maxLength: 20,
              ),
              15.sbH,

              // Icon Selection
              "Choose Icon".txt14(fontW: F.w5),
              8.sbH,
              Container(
                height: 120.h,
                decoration: BoxDecoration(
                  color: Palette.greyFill,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ValueListenableBuilder<IconData?>(
                  valueListenable: selectedIconNotifier,
                  builder: (context, selectedIcon, child) {
                    return GridView.builder(
                      padding: 8.0.padA,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                      ),
                      itemCount: availableIcons.length,
                      itemBuilder: (context, index) {
                        final icon = availableIcons[index];
                        final isSelected = selectedIcon == icon;

                        return Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Palette.montraPurple.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.r),
                            border: isSelected
                                ? Border.all(color: Palette.montraPurple)
                                : null,
                          ),
                          child: Icon(
                            icon,
                            size: 20.h,
                            color: isSelected
                                ? Palette.montraPurple
                                : Palette.greyColor,
                          ),
                        ).tap(onTap: () {
                          selectedIconNotifier.value = icon;
                        });
                      },
                    );
                  },
                ),
              ),
              15.sbH,

              // Color Selection
              "Choose Color".txt14(fontW: F.w5),
              8.sbH,
              Container(
                height: 80.h,
                decoration: BoxDecoration(
                  color: Palette.greyFill,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ValueListenableBuilder<Color?>(
                  valueListenable: selectedColorNotifier,
                  builder: (context, selectedColor, child) {
                    return GridView.builder(
                      padding: 8.0.padA,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                      ),
                      itemCount: availableColors.length,
                      itemBuilder: (context, index) {
                        final color = availableColors[index];
                        final isSelected = selectedColor == color;

                        return Container(
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: Palette.blackColor, width: 3)
                                : Border.all(
                                    color: Palette.greyColor, width: 1),
                          ),
                          child: isSelected
                              ? Icon(
                                  PhosphorIconsBold.check,
                                  size: 14.h,
                                  color: Palette.whiteColor,
                                )
                              : null,
                        ).tap(onTap: () {
                          selectedColorNotifier.value = color;
                        });
                      },
                    );
                  },
                ),
              ),
              20.sbH,

              // Buttons
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
                    child: ListenableBuilder(
                      listenable: Listenable.merge([
                        categoryNameController,
                        selectedIconNotifier,
                        selectedColorNotifier,
                      ]),
                      builder: (context, child) {
                        final isEnabled =
                            categoryNameController.text.isNotEmpty &&
                                selectedIconNotifier.value != null &&
                                selectedColorNotifier.value != null;

                        return AppButton(
                          isEnabled: isEnabled,
                          text: isEditing ? "Update Category" : "Add Category",
                          onTap: isEnabled
                              ? () {
                                  final categoryData = {
                                    'name': categoryNameController.text,
                                    'icon': selectedIconNotifier.value!,
                                    'color': selectedColorNotifier.value!,
                                  };

                                  final updatedList =
                                      List<Map<String, dynamic>>.from(
                                          _customCategoriesNotifier.value);

                                  if (isEditing && editIndex != null) {
                                    updatedList[editIndex] = categoryData;
                                  } else {
                                    updatedList.add(categoryData);
                                  }

                                  _customCategoriesNotifier.value = updatedList;

                                  Navigator.pop(context);
                                  showBanner(
                                    context: context,
                                    theMessage:
                                        "${isEditing ? 'Category updated' : 'Category added'} successfully",
                                    theType: NotificationType.success,
                                  );
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
              20.sbH,
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> category) {
    showCustomModal(
      context,
      modalHeight: 200.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            "Delete Category?".txt16(fontW: F.w6),
            15.sbH,
            "Are you sure you want to delete '${category['name']}'? This action cannot be undone."
                .txt14(
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
