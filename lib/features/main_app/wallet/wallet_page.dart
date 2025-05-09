import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h), 

            
            Text(
              "Available Points",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h), 

            
            Text(
              "1,000",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 50.sp,
                    fontFamily: 'Metropolis-ExtraBold',
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h), 

            
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  
                  Image.asset(
                    'assets/k-logo.png',
                    width: 40.w,
                    height: 40.h,
                  ),
                  SizedBox(width: 12.w), 

                  
                  Expanded(
                    child: Text(
                      "Attend events with rewards to earn\nmore points",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h), 

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               

                
                Text(
                  "Recent Transactions",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                ),

                 
                Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/icons/setting-4.png'
                      : 'assets/icons/setting-4.png',
                  width: 24.w,
                  height: 24.h,
                ),
              ],
            ),
            SizedBox(height: 40.h), 

            
            Opacity(
              opacity: 0.5,
              child: Icon(
              Icons.bookmark_outline,
              size: 40.w,
              color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
              ),
            ),
            SizedBox(height: 10.h), 

            
            Text(
              "No Transactions to show",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18.sp,
                    height: 1.5,
                    letterSpacing: -1,
                    fontFamily: 'Metropolis-SemiBold',
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h), 

            
            Opacity(
              opacity: 0.6,
              child: Text(
                "Details on your point earning and\nspending will show here",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}