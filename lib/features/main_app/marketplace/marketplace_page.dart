import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

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
                  "Marketplace",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18.sp,
                        fontFamily: 'Metropolis-ExtraBold',
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 100.h), 

            
            Opacity(
              opacity: 0.4,
              child: Text(
                "COMING SOON!!",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 30.sp,
                      fontFamily: 'Metropolis-Black',
                      color: const Color(0xffbbd953),
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.h), 

            
            Text(
              "COMING SOON!!",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 30.sp,
                    fontFamily: 'Metropolis-Black',
                    color: const Color(0xffbbd953),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h), 

            
            Text(
              "COMING SOON!!",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 30.sp,
                    fontFamily: 'Metropolis-Black',
                    color: const Color.fromARGB(255, 235, 192, 206), 
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h), 

            
            Text(
              "Spend your reward points",
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
