import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/small_button.dart'; // Import the CustomButton widget

class OnboardingPrompt extends StatelessWidget {
  final VoidCallback onContinue;

  const OnboardingPrompt({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1, // Reduce width to 90% of the screen
      // height: MediaQuery.of(context).size.width * 0.5,
      child: Container(
        padding: EdgeInsets.all(20.w), // Adjust padding inside the box
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h), // Add margin around the box
        decoration: BoxDecoration(
          color: const Color(0xffBBD953), // Use the app's primary color
          borderRadius: BorderRadius.circular(12.r), // Rounded edges
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
          mainAxisSize: MainAxisSize.min, // Reduce height to fit content
          children: [
            Text(
              "You're almost done!",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'Metropolis-SemiBold',
                    letterSpacing: -1,
                    fontSize: 20.sp, // Adjust font size
                    color: Colors.black, // Black text color
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8.h), // Spacing between main text and subtext
            Text(
                "Hi, let's get you a personalized experience on Kliks\nPlease continue by providing some details.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black.withOpacity(0.9),
                    letterSpacing: -1,
                    fontSize: 13.sp, // Adjust font size
                  ),
            ),
            SizedBox(height: 10.h), // Spacing before the button
            Align(
              alignment: Alignment.centerLeft, // Align the button to the left
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3, // Reduce button width to 40% of the screen
                child: SmallButton(
                  text: 'Continue',
                  onPressed: onContinue, // Trigger the provided callback
                  backgroundColor: Colors.black, // Black background color
                  textColor: Colors.white, // White text color
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}