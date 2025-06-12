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

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  final ValueNotifier<bool> _biometricLoginNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _notificationsNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _biometricLoginNotifier.dispose();
    _notificationsNotifier.dispose();
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
        title: "Account Settings".txt18(fontW: F.w6),
        centerTitle: true,
      ),
      body: ListView(
        padding: 20.padH,
        children: [
          20.sbH,

          // Account Information Section
          _buildSectionHeader("Account Information"),
          15.sbH,
          _buildAccountInfoTile(
            icon: PhosphorIconsBold.envelope,
            title: "Email Address",
            subtitle: "minato@konoha.com",
            onTap: (){},
          ),
          10.sbH,
          _buildAccountInfoTile(
            icon: PhosphorIconsBold.shieldCheck,
            title: "Account Verification",
            subtitle: "Verified",
            showBadge: true,
            badgeColor: Palette.greenColor,
            onTap: null,
          ),
          10.sbH,
          _buildAccountInfoTile(
            icon: PhosphorIconsBold.crown,
            title: "Account Type",
            subtitle: "Premium",
            showBadge: true,
            badgeColor: Palette.montraPurple,
            onTap: () => _showAccountTypeInfo(),
          ),

          30.sbH,

          // Security & Authentication Section
          _buildSectionHeader("Security & Authentication"),
          15.sbH,
          _buildAccountInfoTile(
            icon: PhosphorIconsBold.lock,
            title: "Change Password",
            subtitle: "Update your account password",
            onTap: () => _showChangePasswordModal(),
          ),
          10.sbH,
          _buildToggleTile(
            icon: PhosphorIconsBold.fingerprint,
            title: "Biometric Login",
            subtitle: "Use fingerprint or face ID to login",
            valueNotifier: _biometricLoginNotifier,
          ),

          30.sbH,

          // Notifications Section
          _buildSectionHeader("Notifications"),
          15.sbH,
          _buildToggleTile(
            icon: PhosphorIconsBold.bell,
            title: "Push Notifications",
            subtitle: "Receive notifications about transactions and budgets",
            valueNotifier: _notificationsNotifier,
          ),

          30.sbH,

          // Subscription & Billing Section
          _buildSectionHeader("Subscription & Billing"),
          15.sbH,
          _buildAccountInfoTile(
            icon: PhosphorIconsBold.creditCard,
            title: "Plan Details",
            subtitle: "Premium - Monthly",
            onTap: () => _showPlanDetailsModal(),
          ),
          10.sbH,
          _buildAccountInfoTile(
            icon: PhosphorIconsBold.receipt,
            title: "Billing History",
            subtitle: "View past invoices and payments",
            onTap: () => _showBillingHistoryModal(),
          ),

          30.sbH,

          // Data & Privacy Section
          _buildSectionHeader("Data & Privacy"),
          15.sbH,
          _buildAccountInfoTile(
            icon: PhosphorIconsBold.trash,
            title: "Delete Account",
            subtitle: "Permanently delete your account and all data",
            titleColor: Palette.redColor,
            onTap: () => _showDeleteAccountModal(),
          ),

          50.sbH,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return title.txt16(fontW: F.w6, color: Palette.blackColor);
  }

  Widget _buildAccountInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? titleColor,
    bool showBadge = false,
    Color? badgeColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Palette.greyFill,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: BoxDecoration(
              color: Palette.montraPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 20.h,
              color: Palette.montraPurple,
            ),
          ),
          15.sbW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: title.txt14(
                        fontW: F.w5,
                        color: titleColor ?? Palette.blackColor,
                      ),
                    ),
                    if (showBadge) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: badgeColor?.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: subtitle.txt(
                          size: 11.sp,
                          color: badgeColor,
                          fontW: F.w6,
                        ),
                      ),
                    ],
                  ],
                ),
                if (!showBadge) ...[
                  4.sbH,
                  subtitle.txt12(color: Palette.greyColor),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            Icon(
              PhosphorIconsBold.caretRight,
              size: 16.h,
              color: Palette.greyColor,
            ),
          ],
        ],
      ),
    ).tap(onTap: onTap);
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required ValueNotifier<bool> valueNotifier,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Palette.greyFill,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: BoxDecoration(
              color: Palette.montraPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 20.h,
              color: Palette.montraPurple,
            ),
          ),
          15.sbW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.txt14(fontW: F.w5),
                4.sbH,
                subtitle.txt12(color: Palette.greyColor),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: valueNotifier,
            builder: (context, value, child) {
              return Switch(
                value: value,
                onChanged: (newValue) {
                  valueNotifier.value = newValue;
                },
                activeColor: Palette.montraPurple,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEditPhoneModal() {
    final TextEditingController phoneController = TextEditingController(text: "+234 (0) 123 456 7890");
    
    showCustomModal(
      context,
      modalHeight: 250.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Edit Phone Number".txt16(fontW: F.w6),
            20.sbH,
            TextInputWidget(
              controller: phoneController,
              hintText: "Phone Number",
              keyboardType: TextInputType.phone,
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
                      Navigator.pop(context);
                      showBanner(
                        context: context,
                        theMessage: "Phone number updated successfully",
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

  void _showAccountTypeInfo() {
    showCustomModal(
      context,
      modalHeight: 450.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Premium Account".txt16(fontW: F.w6),
                15.sbH,
                "Your premium account includes:".txt14(color: Palette.greyColor),
                10.sbH,
                _buildFeatureItem("Unlimited transactions"),
                _buildFeatureItem("Export data functionality"),
                _buildFeatureItem("Priority customer support"),
                _buildFeatureItem("Custom categories"),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  text: "Manage Subscription",
                  onTap: () => Navigator.pop(context),
                ),
                20.sbH,
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            PhosphorIconsBold.check,
            size: 16.h,
            color: Palette.greenColor,
          ),
          10.sbW,
          feature.txt12(),
        ],
      ),
    );
  }

  void _showChangePasswordModal() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    
    showCustomModal(
      context,
      modalHeight: 400.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Change Password".txt16(fontW: F.w6),
            20.sbH,
            TextInputWidget(
              controller: currentPasswordController,
              hintText: "Current Password",
              obscuretext: true,
            ),
            10.sbH,
            TextInputWidget(
              controller: newPasswordController,
              hintText: "New Password",
              obscuretext: true,
            ),
            10.sbH,
            TextInputWidget(
              controller: confirmPasswordController,
              hintText: "Confirm New Password",
              obscuretext: true,
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
                    text: "Update",
                    onTap: () {
                      Navigator.pop(context);
                      showBanner(
                        context: context,
                        theMessage: "Password updated successfully",
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

  void _showPlanDetailsModal() {
    showCustomModal(
      context,
      modalHeight: 300.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Plan Details".txt16(fontW: F.w6),
            20.sbH,
            Container(
              padding: 15.0.padA,
              decoration: BoxDecoration(
                color: Palette.montraPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Premium Plan".txt14(fontW: F.w6),
                      "N2,500/month".txt14(fontW: F.w6, color: Palette.montraPurple),
                    ],
                  ),
                  10.sbH,
                  "Next billing date: January 15, 2025".txt12(color: Palette.greyColor),
                  "Payment method: •••• 4567".txt12(color: Palette.greyColor),
                ],
              ),
            ),
            20.sbH,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: "Update Payment",
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBillingHistoryModal() {
    showCustomModal(
      context,
      modalHeight: 450.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Billing History".txt16(fontW: F.w6),
            20.sbH,
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (context, index) => 10.sbH,
                itemBuilder: (context, index) {
                  final dates = ["Dec 15, 2024", "Nov 15, 2024", "Oct 15, 2024"];
                  final amounts = ["N2,500", "N2,500", "N2,500"];
                  return Container(
                    padding: 12.0.padA,
                    decoration: BoxDecoration(
                      color: Palette.greyFill,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Premium Plan".txt12(fontW: F.w5),
                            dates[index].txt(size:11.sp, color: Palette.greyColor),
                          ],
                        ),
                        amounts[index].txt12(fontW: F.w6),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountModal() {
    showCustomModal(
      context,
      modalHeight: 450.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsBold.warning,
              size: 48.h,
              color: Palette.redColor,
            ),
            15.sbH,
            "Delete Account?".txt18(fontW: F.w6, color: Palette.redColor),
            15.sbH,
            "This action cannot be undone. All your data including transactions, budgets, and account information will be permanently deleted."
                .txt14(
              color: Palette.greyColor,
              textAlign: TextAlign.center,
            ),
            20.sbH,
            "Type 'DELETE' to confirm:".txt12(color: Palette.greyColor),
            10.sbH,
            TextInputWidget(
              controller: TextEditingController(),
              hintText: "Type DELETE here",
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
                    text: "Delete Account",
                    onTap: () {
                      Navigator.pop(context);
                      // Handle account deletion
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