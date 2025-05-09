import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            SizedBox(height: 20.h), 

            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Activity",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18.sp,
                        fontFamily: 'Metropolis-ExtraBold',
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 100.h), 

             
            Text(
              "No activity",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20.sp,
                    color: Colors.grey[300],
                    fontFamily: 'Metropolis-SemiBold',
                  ),
              textAlign: TextAlign.center,
            ),

            
            Text(
              "Start using the to see activities",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h), 
          ],
        ),
      ),
    );
  }
}
