import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart';

class CreateEventBottomSheet extends StatelessWidget {
  const CreateEventBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // 50% of screen height
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular bar with plus icon
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xffbbd953),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.black, size: 30),
          ),
          SizedBox(height: 20.h),

          // Main text and subtext
          Text(
            "Create event for 1 POINT",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 15.sp,
            letterSpacing: 0,
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
                  ? Colors.grey[900]
                  : Colors.grey[200],
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
                "1,000",
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
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.grey[200],
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

          // Buttons
          Column(
            children: [
              // Yes, Create event button
              CustomButton(
          text: "Yes, Create event",
            onPressed: () {
            // Navigator.pop(context);
              Navigator.pushNamed(context, '/new-event');
          },
          backgroundColor: const Color(0xffbbd953),
          textColor: Colors.black,
          textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                fontFamily: 'Metropolis-SemiBold',
              ),
              ),
              SizedBox(height: 10.h),
              // No, Cancel button
              CustomButton(
          text: "No, Cancel",
          onPressed: () {
            // Add your logic here
            Navigator.pop(context);
          },
          backgroundColor: Colors.transparent,
          textColor: Colors.black,
          // constraints: BoxConstraints.tightFor(height: 50.h),
          hasBorder: true,
          textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                 fontFamily: 'Metropolis-SemiBold',
              ),
              ),
            ],
          ),
        ],
        
      ),
    );
  }
}