import 'package:expense_tracker_app/utils/widgets/curved_painter.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    30.sbH,
                    RowRailer(
                      middle: "Profile"
                          .txt18(color: Palette.whiteColor, fontW: F.w6),
                      rowPadding: 15.padH,
                    ),
                    50.sbH,
                    
                    // Profile Picture and Info
                    Column(
                      children: [
                        // Profile Picture
                        Container(
                          height: 100.h,
                          width: 100.h,
                          decoration: BoxDecoration(
                            color: Palette.whiteColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            PhosphorIconsBold.user,
                            size: 50.h,
                            color: Palette.montraPurple,
                          ),
                        ),
                        15.sbH,
                        
                        // User Name
                        "Minato Namikaze"
                            .txt18(
                                color: Palette.whiteColor,
                                fontW: F.w6)
                            .alignCenter(),
                        5.sbH,
                        
                        // User Handle/Email
                        "@minato.namikaze"
                            .txt14(
                                color: Palette.whiteColor.withOpacity(0.8),
                                fontW: F.w4)
                            .alignCenter(),
                      ],
                    ),
                    
                    CustomPaint(
                      size: Size(double.infinity, 40.h),
                      painter: CurvedPainter(),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Palette.whiteColor,
                            border: Border.all(
                                color: Palette.whiteColor, width: 1)),
                        constraints:
                            BoxConstraints(minHeight: height(context) - 250.h),
                        child: Padding(
                          padding: 15.padH,
                          child: Column(
                            children: [
                              30.sbH,
                              
                              // Profile Options
                              _buildProfileOptionTile(
                                icon: PhosphorIconsBold.user,
                                title: "Account",
                                subtitle: "Manage your account settings",
                                onTap: () {
                                  // Navigate to account settings
                                },
                              ),
                              15.sbH,
                              
                              _buildProfileOptionTile(
                                icon: PhosphorIconsBold.identificationCard,
                                title: "User Profile",
                                subtitle: "Edit your personal information",
                                onTap: () {
                                  // Navigate to user profile edit
                                },
                              ),
                              15.sbH,
                              
                              _buildProfileOptionTile(
                                icon: PhosphorIconsBold.download,
                                title: "Export Data",
                                subtitle: "Download your transaction data",
                                onTap: () {
                                  // Handle data export
                                },
                              ),
                              15.sbH,
                              
                              _buildProfileOptionTile(
                                icon: PhosphorIconsBold.signOut,
                                title: "Log Out",
                                subtitle: "Sign out of your account",
                                iconColor: Palette.redColor,
                                titleColor: Palette.redColor,
                                onTap: () {
                                  _showLogoutConfirmation(context);
                                },
                              ),
                              
                              40.sbH,
                              
                              // App Version Info
                              Container(
                                padding: 15.0.padA,
                                decoration: BoxDecoration(
                                  color: Palette.greyFill,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          PhosphorIconsBold.info,
                                          color: Palette.greyColor,
                                          size: 18.h,
                                        ),
                                        10.sbW,
                                        "App Information".txt14(fontW: F.w5),
                                      ],
                                    ),
                                    10.sbH,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        "Version".txt12(color: Palette.greyColor),
                                        "1.0.0".txt12(fontW: F.w5),
                                      ],
                                    ),
                                    5.sbH,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        "Build".txt12(color: Palette.greyColor),
                                        "1".txt12(fontW: F.w5),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              100.sbH,
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Palette.greyFill,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Container(
            height: 45.h,
            width: 45.h,
            decoration: BoxDecoration(
              color: (iconColor ?? Palette.montraPurple).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 22.h,
              color: iconColor ?? Palette.montraPurple,
            ),
          ),
          15.sbW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.txt16(
                  fontW: F.w5,
                  color: titleColor,
                ),
                4.sbH,
                subtitle.txt12(
                  color: Palette.greyColor,
                ),
              ],
            ),
          ),
          Icon(
            PhosphorIconsBold.caretRight,
            size: 18.h,
            color: Palette.greyColor,
          ),
        ],
      ),
    ).tap(onTap: onTap);
  }

void _showLogoutConfirmation(BuildContext context) {
    showCustomModal(
      context,
      modalHeight: 230.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            "Log Out".txt16(fontW: F.w6),
            15.sbH,
            "Are you sure you want to log out of your account?"
                .txt14(
                  color: Palette.greyColor,
                  textAlign: TextAlign.center,
                ),
            20.sbH,
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: Palette.greyFill,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: "Cancel".txt14(
                      color: Palette.greyColor,
                      fontW: F.w5,
                    ),
                  ),
                ),
                15.sbW,
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Handle logout logic here
                      // For example: navigate to login screen
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: Palette.redColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: "Log Out".txt14(
                      color: Palette.whiteColor,
                      fontW: F.w6,
                    ),
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