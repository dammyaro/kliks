import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserInformationPage extends StatelessWidget {
  const UserInformationPage({super.key});

  Widget _infoTile({
    required BuildContext context,
    required String label,
    required Widget valueWidget,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h), // Increased vertical padding
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp,
                  fontFamily: 'Metropolis-Regular',
                ),
              ),
            ),
            valueWidget,
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: theme.iconTheme.color?.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomNavBar(title: 'User Information'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          children: [
            SizedBox(height: 5.h),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.profile == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final profile = authProvider.profile!;
                final email = profile['email'] as String? ?? 'N/A';
                final dobString = profile['dob'] as String?;
                print(dobString);
                String formattedDob = 'N/A';
                if (dobString != null) {
                  try {
                    final dob = DateTime.parse(dobString);
                    formattedDob = DateFormat('dd MMM yyyy').format(dob);
                  } catch (e) {
                    formattedDob = 'Invalid Date';
                  }
                }

                return Column(
                  children: [
                    _infoTile(
                      context: context,
                      label: 'Email',
                      valueWidget: Text(
                        email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp,
                          fontFamily: 'Metropolis-Regular',
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                          ),
                          isScrollControlled: true,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 24.w,
                                right: 24.w,
                                top: 32.h,
                                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const HandleBar(),
                                  SizedBox(height: 24.h),
                                  Icon(Icons.email_outlined, size: 50.sp, color: theme.iconTheme.color),
                                  SizedBox(height: 24.h),
                                  Text(
                                    'Your email address\n$email',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 18.sp,
                                      fontFamily: 'Metropolis-SemiBold',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'This email is linked to your account and can only be seen by you, do you want to change it?',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 13.sp,
                                      color: theme.hintColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 32.h),
                                  CustomButton(
                                    text: 'Yes, change email',
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/update-email');
                                    },
                                    backgroundColor: const Color(0xffbbd953),
                                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14.sp,
                                      fontFamily: 'Metropolis-SemiBold',
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  CustomButton(
                                    text: 'No, cancel',
                                    onPressed: () => Navigator.pop(context),
                                   backgroundColor: Colors.transparent,
                                    hasBorder: true,
                                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14.sp,
                                      fontFamily: 'Metropolis-SemiBold',
                                      color: theme.hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    _infoTile(
                      context: context,
                      label: 'Date of birth',
                      valueWidget: Text(
                        formattedDob,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp,
                          fontFamily: 'Metropolis-Regular',
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/update-dob');
                      },
                    ),
                    _infoTile(
                      context: context,
                      label: 'Password',
                      valueWidget: Icon(
                        Icons.lock_outline,
                        color: theme.iconTheme.color?.withOpacity(0.5),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/update-password');
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}