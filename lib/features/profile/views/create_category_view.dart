import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CreateCategoryView extends StatefulWidget {
  final List<IconData> availableIcons;
  final List<Color> availableColors;
  final Map<String, dynamic>? existingCategory;
  final bool isEditing;
  final Function(Map<String, dynamic>) onCategoryCreated;

  const CreateCategoryView({
    super.key,
    required this.availableIcons,
    required this.availableColors,
    this.existingCategory,
    this.isEditing = false,
    required this.onCategoryCreated,
  });

  @override
  State<CreateCategoryView> createState() => _CreateCategoryViewState();
}

class _CreateCategoryViewState extends State<CreateCategoryView> {
  late final TextEditingController _categoryNameController;
  late final ValueNotifier<IconData?> _selectedIconNotifier;
  late final ValueNotifier<Color?> _selectedColorNotifier;

  @override
  void initState() {
    super.initState();
    _categoryNameController = TextEditingController(
      text: widget.existingCategory?['name'] ?? '',
    );
    _selectedIconNotifier = ValueNotifier<IconData?>(
      widget.existingCategory?['icon'],
    );
    _selectedColorNotifier = ValueNotifier<Color?>(
      widget.existingCategory?['color'],
    );
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _selectedIconNotifier.dispose();
    _selectedColorNotifier.dispose();
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
        title: "${widget.isEditing ? 'Edit' : 'Create'} Category"
            .txt(size: 18.sp, fontW: F.w6),
        centerTitle: true,
      ),
      body: ListView(
        padding: 20.padH,
        children: [
          20.sbH,

          // Category Name Input
          "Category Name".txt(size: 16.sp, fontW: F.w6),
          10.sbH,
          TextInputWidget(
            controller: _categoryNameController,
            hintText: "Enter category name",
            maxLength: 20,
            prefix: Padding(
              padding: 12.5.padA,
              child: Icon(
                PhosphorIconsBold.tag,
                color: Palette.greyColor,
                size: 20.h,
              ),
            ),
          ),
          30.sbH,

          // Icon Selection
          "Choose Icon".txt(size: 16.sp, fontW: F.w6),
          10.sbH,
          "Select an icon that represents your category"
              .txt(size: 12.sp, color: Palette.greyColor),
          15.sbH,
          ValueListenableBuilder<IconData?>(
            valueListenable: _selectedIconNotifier,
            builder: (context, selectedIcon, child) {
              return Container(
                padding: 15.0.padA,
                decoration: BoxDecoration(
                  color: Palette.greyFill,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    // Preview selected icon
                    if (selectedIcon != null) ...[
                      Container(
                        height: 60.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          color: (_selectedColorNotifier.value ??
                                  Palette.montraPurple)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          selectedIcon,
                          size: 30.h,
                          color: _selectedColorNotifier.value ??
                              Palette.montraPurple,
                        ),
                      ),
                      15.sbH,
                    ],

                    // Icon grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 1,
                      ),
                      itemCount: widget.availableIcons.length,
                      itemBuilder: (context, index) {
                        final icon = widget.availableIcons[index];
                        final isSelected = selectedIcon == icon;

                        return Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Palette.montraPurple.withValues(alpha: 0.2)
                                : Palette.whiteColor,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: isSelected
                                  ? Palette.montraPurple
                                  : Palette.greyColor.withValues(alpha: 0.3),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            icon,
                            size: 24.h,
                            color: isSelected
                                ? Palette.montraPurple
                                : Palette.greyColor,
                          ),
                        ).tap(onTap: () {
                          _selectedIconNotifier.value = icon;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          30.sbH,

          // Color Selection
          "Choose Color".txt(size: 16.sp, fontW: F.w6),
          10.sbH,
          "Pick a color that helps you identify this category quickly"
              .txt(size: 12.sp, color: Palette.greyColor),
          15.sbH,
          ValueListenableBuilder<Color?>(
            valueListenable: _selectedColorNotifier,
            builder: (context, selectedColor, child) {
              return Container(
                padding: 15.0.padA,
                decoration: BoxDecoration(
                  color: Palette.greyFill,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    // Preview selected color
                    if (selectedColor != null) ...[
                      Row(
                        children: [
                          Container(
                            height: 40.h,
                            width: 40.h,
                            decoration: BoxDecoration(
                              color: selectedColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Palette.greyColor, width: 2),
                            ),
                          ),
                          15.sbW,
                          "Selected Color".txt(size: 14.sp, fontW: F.w5),
                        ],
                      ),
                      15.sbH,
                    ],

                    // Color grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 1,
                      ),
                      itemCount: widget.availableColors.length,
                      itemBuilder: (context, index) {
                        final color = widget.availableColors[index];
                        final isSelected = selectedColor == color;

                        return Container(
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Palette.blackColor
                                  : Palette.greyColor.withValues(alpha: 0.3),
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child: isSelected
                              ? Icon(
                                  PhosphorIconsBold.check,
                                  size: 16.h,
                                  color: color.computeLuminance() > 0.5
                                      ? Palette.blackColor
                                      : Palette.whiteColor,
                                )
                              : null,
                        ).tap(onTap: () {
                          _selectedColorNotifier.value = color;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          40.sbH,

          // Save Button
          ListenableBuilder(
            listenable: Listenable.merge([
              _categoryNameController,
              _selectedIconNotifier,
              _selectedColorNotifier,
            ]),
            builder: (context, child) {
              final isEnabled = _categoryNameController.text.isNotEmpty &&
                  _selectedIconNotifier.value != null &&
                  _selectedColorNotifier.value != null;

              return AppButton(
                isEnabled: isEnabled,
                text: widget.isEditing ? "Update Category" : "Create Category",
                onTap: isEnabled ? _saveCategory : null,
              );
            },
          ),
          30.sbH,
        ],
      ),
    );
  }

  void _saveCategory() {
    final categoryData = {
      'name': _categoryNameController.text,
      'icon': _selectedIconNotifier.value!,
      'color': _selectedColorNotifier.value!,
    };

    // Navigate back first, then show the success message
    goBack(context);

    // Use a small delay to ensure navigation completes before showing banner
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onCategoryCreated(categoryData);
    });
  }
}
