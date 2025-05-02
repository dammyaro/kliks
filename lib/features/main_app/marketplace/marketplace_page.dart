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
          crossAxisAlignment: CrossAxisAlignment.center, // Align content horizontally to the center
          children: [
            SizedBox(height: 60.h), // Spacing from the top

            // "Marketplace" Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Marketplace",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20.sp,
                        fontFamily: 'Metropolis-ExtraBold',
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 100.h), // Spacing below the title

            // First "COMING SOON!!" Text
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
            SizedBox(height: 10.h), // Spacing between texts

            // Second "COMING SOON!!" Text
            Text(
              "COMING SOON!!",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 30.sp,
                    fontFamily: 'Metropolis-Black',
                    color: const Color(0xffbbd953),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h), // Spacing between texts

            // Third "COMING SOON!!" Text
            Text(
              "COMING SOON!!",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 30.sp,
                    fontFamily: 'Metropolis-Black',
                    color: const Color.fromARGB(255, 235, 192, 206), // Bright shade of pink
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h), // Spacing below the texts

            // "Spend your reward points" Text
            Text(
              "Spend your reward points",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h), // Spacing below the text
          ],
        ),
      ),
    );
  }
}
