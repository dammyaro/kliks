import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart';
// Import for BackdropFilter
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

class CreateEventBottomSheet extends StatelessWidget {
  const CreateEventBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<AuthProvider>(context).profile;
    final availablePoints = profile?['points'] ?? 0;
    return Stack(
      children: [
        // Blurred background with increased intensity
        // BackdropFilter(
        //   filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Increased blur intensity
        //   child: Container(
        //     color: Colors.black.withOpacity(0.1), // Optional dimming effect
        //   ),
        // ),
        // Bottom sheet content
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            
            height: MediaQuery.of(context).size.height * 0.77, // 75% of screen height
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[200]
                  : Colors.grey[900],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Add swipe-down indicator
                // Container(
                //   width: 30.w,
                //   height: 3.h,
                //   margin: EdgeInsets.only(bottom: 16.h),
                //   decoration: BoxDecoration(
                //     color: Colors.grey[400]?.withOpacity(0.7),
                //     borderRadius: BorderRadius.circular(2.5.r),
                //   ),
                // ),
                const HandleBar(),
                SizedBox(height: 30.h),

                // Circular bar with plus icon
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffbbd953),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 30,
                      weight: 900, // For Material 3, makes the icon thicker. If not supported, fallback to a custom icon or use a bold font.
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Main text and subtext
                Text(
                  "Create event for 1 POINT",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16.sp,
                        letterSpacing: -1,
                        fontFamily: 'Metropolis-SemiBold',
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  "Are you sure you want to proceed?",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontFamily: 'Metropolis-Regular',
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),

                // Grey bar with points information
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[850]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Available points
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Available points",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Metropolis-SemiBold',
                                  letterSpacing: 0,
                                ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            availablePoints.toString(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 16.sp,
                                  fontFamily: 'Metropolis-ExtraBold',
                                ),
                          ),
                        ],
                      ),
                      // Required points
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Required points",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Metropolis-SemiBold',
                                  letterSpacing: 0,
                                ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "1",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 16.sp,
                                  fontFamily: 'Metropolis-ExtraBold',
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                Container(
                  padding: EdgeInsets.all(22.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[850]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/k-logo.png',
                        width: 30.w,
                        height: 30.h,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          "Attend events with rewards to earn\nmore points",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12.sp,
                                fontFamily: 'Metropolis-SemiBold',
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                const Spacer(),
                // Yes, Create event button
                CustomButton(
                  text: "Yes, Create event",
                  onPressed: () {
                    Navigator.pushNamed(context, '/new-event');
                  },
                  backgroundColor: const Color(0xffbbd953),
                  textColor: Colors.black,
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontFamily: 'Metropolis-Medium',
                        color: Colors.black,
                      ),
                ),
                SizedBox(height: 10.h),
                // No, Cancel button
                CustomButton(
                  text: "No, Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.transparent,
                  textColor: Colors.black,
                  hasBorder: true,
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontFamily: 'Metropolis-Medium',
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}