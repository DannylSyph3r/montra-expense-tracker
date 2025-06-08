import 'dart:io';
import 'package:expense_tracker_app/features/onboarding/widgets/option_seletion_tile.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class UserProfileEditView extends StatefulWidget {
  const UserProfileEditView({super.key});

  @override
  State<UserProfileEditView> createState() => _UserProfileEditViewState();
}

class _UserProfileEditViewState extends State<UserProfileEditView> {
  final TextEditingController _usernameController = TextEditingController(text: "minato_namikaze");
  final TextEditingController _bioController = TextEditingController(text: "Fourth Hokage of Konoha Village. Love ramen and protecting the village.");
  final TextEditingController _countryController = TextEditingController(text: "Nigeria");
  final TextEditingController _currencyController = TextEditingController(text: "Nigerian Naira (NGN)");
  final TextEditingController _languageController = TextEditingController(text: "English");

  final ValueNotifier<DateTime> _birthdateNotifier = ValueNotifier<DateTime>(DateTime(1995, 5, 15));
  final ValueNotifier<File?> _profileImageNotifier = ValueNotifier<File?>(null);

  final List<String> countries = [
    "Nigeria", "Ghana", "Kenya", "South Africa", "Egypt",
    "United States", "United Kingdom", "Canada", "Australia"
  ];

  final List<String> currencies = [
    "Nigerian Naira (NGN)", "US Dollar (USD)", "British Pound (GBP)",
    "Euro (EUR)", "Ghanaian Cedi (GHS)", "Kenyan Shilling (KES)"
  ];

  final List<String> languages = [
    "English", "French", "Spanish", "German", "Portuguese", "Arabic"
  ];

  final List<String> categories = [
    "Groceries", "Transportation", "Entertainment", "Shopping",
    "Utilities", "Health & Fitness", "Dining Out", "Travel",
    "Education", "Insurance", "Personal Care", "Gifts"
  ];

  final ValueNotifier<List<String>> _selectedCategoriesNotifier = ValueNotifier<List<String>>([
    "Groceries", "Transportation", "Entertainment", "Shopping", "Utilities"
  ]);

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _countryController.dispose();
    _currencyController.dispose();
    _languageController.dispose();
    _birthdateNotifier.dispose();
    _profileImageNotifier.dispose();
    _selectedCategoriesNotifier.dispose();
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
          icon: const Icon(PhosphorIconsBold.arrowLeft, color: Palette.blackColor),
          onPressed: () => goBack(context),
        ),
        title: "Edit Profile".txt18(fontW: F.w6),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: "Save".txt14(color: Palette.montraPurple, fontW: F.w6),
          ),
        ],
      ),
      body: ListView(
        padding: 20.padH,
        children: [
          20.sbH,

          // Personal Information Section
          _buildSectionHeader("Personal Information"),
          20.sbH,

          // Profile Picture
          Center(
            child: Stack(
              children: [
                ValueListenableBuilder<File?>(
                  valueListenable: _profileImageNotifier,
                  builder: (context, profileImage, child) {
                    return Container(
                      height: 100.h,
                      width: 100.h,
                      decoration: BoxDecoration(
                        color: Palette.greyFill,
                        shape: BoxShape.circle,
                        image: profileImage != null
                            ? DecorationImage(
                                image: FileImage(profileImage),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: profileImage == null
                          ? Icon(
                              PhosphorIconsBold.user,
                              size: 40.h,
                              color: Palette.greyColor,
                            )
                          : null,
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 32.h,
                    width: 32.h,
                    decoration: BoxDecoration(
                      color: Palette.montraPurple,
                      shape: BoxShape.circle,
                      border: Border.all(color: Palette.whiteColor, width: 2),
                    ),
                    child: Icon(
                      PhosphorIconsBold.camera,
                      size: 16.h,
                      color: Palette.whiteColor,
                    ),
                  ).tap(onTap: _showImagePickerModal),
                ),
              ],
            ),
          ),
          30.sbH,

          // Username
          "Username".txt14(fontW: F.w5),
          8.sbH,
          TextInputWidget(
            controller: _usernameController,
            hintText: "Enter username",
            prefix: Padding(
              padding: 12.5.padA,
              child: Icon(
                PhosphorIconsBold.at,
                color: Palette.greyColor,
                size: 20.h,
              ),
            ),
          ),
          15.sbH,

          // Bio
          "Bio".txt14(fontW: F.w5),
          8.sbH,
          TextInputWidget(
            controller: _bioController,
            height: 120.h,
            hintText: "Tell us about yourself",
            maxLines: 5,
            maxLength: 80,
            prefix: Padding(
              padding: 12.5.padA,
              child: Icon(
                PhosphorIconsBold.notepad,
                color: Palette.greyColor,
                size: 20.h,
              ),
            ),
          ),
          15.sbH,

          // Country
          "Country".txt14(fontW: F.w5),
          8.sbH,
          TextInputWidget(
            onTap: () => _showCountryPicker(),
            isTextFieldEnabled: false,
            controller: _countryController,
            hintText: "Select country",
            prefix: Padding(
              padding: 12.5.padA,
              child: Icon(
                PhosphorIconsBold.globe,
                color: Palette.greyColor,
                size: 20.h,
              ),
            ),
            suffixIcon: Padding(
              padding: 15.padH,
              child: Icon(
                PhosphorIconsRegular.caretDown,
                size: 20.h,
                color: Palette.textFieldGrey,
              ),
            ),
          ),
          15.sbH,

          // Birthdate
          "Date of Birth".txt14(fontW: F.w5),
          8.sbH,
          ValueListenableBuilder<DateTime>(
            valueListenable: _birthdateNotifier,
            builder: (context, birthdate, child) {
              return Container(
                width: double.infinity,
                height: 50.h,
                padding: 15.padH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: Palette.greyColor, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIconsBold.calendar,
                      color: Palette.greyColor,
                      size: 20.h,
                    ),
                    15.sbW,
                    DateFormat('MMMM dd, yyyy').format(birthdate).txt(size: 14.sp),
                  ],
                ),
              ).tap(onTap: () => _selectBirthdate());
            },
          ),

          30.sbH,

          // Preferences Section
          _buildSectionHeader("Preferences"),
          20.sbH,

          // Default Currency
          "Default Currency".txt14(fontW: F.w5),
          8.sbH,
          TextInputWidget(
            onTap: () => _showCurrencyPicker(),
            isTextFieldEnabled: false,
            controller: _currencyController,
            hintText: "Select currency",
            prefix: Padding(
              padding: 12.5.padA,
              child: Icon(
                PhosphorIconsBold.currencyCircleDollar,
                color: Palette.greyColor,
                size: 20.h,
              ),
            ),
            suffixIcon: Padding(
              padding: 15.padH,
              child: Icon(
                PhosphorIconsRegular.caretDown,
                size: 20.h,
                color: Palette.textFieldGrey,
              ),
            ),
          ),

          30.sbH,

          // Financial Preferences Section
          _buildSectionHeader("Financial Preferences"),
          20.sbH,

          // Category Customization
          "Active Categories".txt14(fontW: F.w5),
          8.sbH,
          "Select categories you frequently use for transactions".txt12(color: Palette.greyColor),
          15.sbH,
          _buildCategoryCustomization(),

          50.sbH,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return title.txt16(fontW: F.w6, color: Palette.blackColor);
  }

  Widget _buildCategoryCustomization() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _selectedCategoriesNotifier,
      builder: (context, selectedCategories, child) {
        return Container(
          padding: 15.0.padA,
          decoration: BoxDecoration(
            color: Palette.greyFill,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "${selectedCategories.length} categories selected".txt12(color: Palette.greyColor),
                  "Edit".txt12(color: Palette.montraPurple, fontW: F.w6).tap(
                    onTap: () => _showCategorySelectionModal(),
                  ),
                ],
              ),
              10.sbH,
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: selectedCategories.map((category) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Palette.montraPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Palette.montraPurple.withOpacity(0.3)),
                    ),
                    child: category.txt12(color: Palette.montraPurple, fontW: F.w5),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImagePickerModal() {
    showCustomModal(
      context,
      modalHeight: 200.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          children: [
            "Change Profile Picture".txt16(fontW: F.w6),
            20.sbH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  icon: PhosphorIconsBold.camera,
                  label: "Camera",
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildImageOption(
                  icon: PhosphorIconsBold.image,
                  label: "Gallery",
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                _buildImageOption(
                  icon: PhosphorIconsBold.trash,
                  label: "Remove",
                  onTap: () => _removeImage(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          height: 60.h,
          width: 60.h,
          decoration: BoxDecoration(
            color: Palette.montraPurple.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24.h,
            color: Palette.montraPurple,
          ),
        ).tap(onTap: onTap),
        8.sbH,
        label.txt12(),
      ],
    );
  }

  void _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    
    if (image != null) {
      _profileImageNotifier.value = File(image.path);
    }
  }

  void _removeImage() {
    Navigator.pop(context);
    _profileImageNotifier.value = null;
  }

  void _showCountryPicker() {
    showCustomModal(
      context,
      modalHeight: 400.h,
      child: ListView.builder(
        padding: 15.padH,
        itemCount: countries.length,
        itemBuilder: (context, index) {
          return OptionSelectionListTile(
            leadingIcon: PhosphorIconsBold.globe,
            interactiveTrailing: false,
            titleLabel: countries[index],
            onTileTap: () {
              _countryController.text = countries[index];
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  void _showCurrencyPicker() {
    showCustomModal(
      context,
      modalHeight: 400.h,
      child: ListView.builder(
        padding: 15.padH,
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          return OptionSelectionListTile(
            leadingIcon: PhosphorIconsBold.currencyCircleDollar,
            interactiveTrailing: false,
            titleLabel: currencies[index],
            onTileTap: () {
              _currencyController.text = currencies[index];
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  void _showLanguagePicker() {
    showCustomModal(
      context,
      modalHeight: 400.h,
      child: ListView.builder(
        padding: 15.padH,
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return OptionSelectionListTile(
            leadingIcon: PhosphorIconsBold.translate,
            interactiveTrailing: false,
            titleLabel: languages[index],
            onTileTap: () {
              _languageController.text = languages[index];
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  void _showCategorySelectionModal() {
    final ValueNotifier<List<String>> tempSelectedNotifier = 
        ValueNotifier<List<String>>(List.from(_selectedCategoriesNotifier.value));

    showCustomModal(
      context,
      modalHeight: 500.h,
      child: Padding(
        padding: 15.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Select Categories".txt16(fontW: F.w6),
            10.sbH,
            "Choose categories you use most frequently".txt12(color: Palette.greyColor),
            20.sbH,
            Expanded(
              child: ValueListenableBuilder<List<String>>(
                valueListenable: tempSelectedNotifier,
                builder: (context, tempSelected, child) {
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = tempSelected.contains(category);
                      
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: 12.0.padA,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Palette.montraPurple.withOpacity(0.1)
                              : Palette.greyFill,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSelected 
                                ? Palette.montraPurple 
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected 
                                  ? PhosphorIconsBold.checkSquare
                                  : PhosphorIconsRegular.square,
                              color: isSelected 
                                  ? Palette.montraPurple 
                                  : Palette.greyColor,
                              size: 20.h,
                            ),
                            15.sbW,
                            category.txt14(
                              color: isSelected 
                                  ? Palette.montraPurple 
                                  : Palette.blackColor,
                              fontW: isSelected ? F.w5 : F.w4,
                            ),
                          ],
                        ),
                      ).tap(onTap: () {
                        if (isSelected) {
                          tempSelected.remove(category);
                        } else {
                          tempSelected.add(category);
                        }
                        tempSelectedNotifier.value = List.from(tempSelected);
                      });
                    },
                  );
                },
              ),
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
                    text: "Save",
                    onTap: () {
                      _selectedCategoriesNotifier.value = tempSelectedNotifier.value;
                      Navigator.pop(context);
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

  void _selectBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthdateNotifier.value,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      _birthdateNotifier.value = picked;
    }
  }

  void _saveProfile() {
    // Validate and save profile data
    if (_usernameController.text.isEmpty) {
      showBanner(
        context: context,
        theMessage: "Username is required",
        theType: NotificationType.failure,
      );
      return;
    }

    // Save profile logic here
    showBanner(
      context: context,
      theMessage: "Profile updated successfully",
      theType: NotificationType.success,
    );
    
    goBack(context);
  }
}