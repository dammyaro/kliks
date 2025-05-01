import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TwoStepBottomSheet extends StatefulWidget {
  const TwoStepBottomSheet({super.key});

  @override
  State<TwoStepBottomSheet> createState() => _TwoStepBottomSheetState();
}

class _TwoStepBottomSheetState extends State<TwoStepBottomSheet> {
  int _currentStep = 0; // Track the current step

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9, // Set height to 80% of the screen
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Step Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2, // Total number of steps
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: _currentStep == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300], // Highlight current step
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h), // Spacing below the indicator

            // Step Content
            if (_currentStep == 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Step 1: Basic Information",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Please provide your basic information to continue.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentStep = 1; // Move to the next step
                      });
                    },
                    child: const Text("Next"),
                  ),
                ],
              )
            else if (_currentStep == 1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Step 2: Preferences",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Let us know your preferences to personalize your experience.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: const Text("Finish"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}