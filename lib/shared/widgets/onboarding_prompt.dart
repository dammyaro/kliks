import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/small_button.dart'; 
import 'package:kliks/shared/widgets/two_step_bottom_sheet.dart'; 

class OnboardingPrompt extends StatelessWidget {
  final VoidCallback onContinue;

  const OnboardingPrompt({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width, 
      child: Container(
        padding: EdgeInsets.all(20.w), 
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h), 
        decoration: BoxDecoration(
          color: const Color(0xffBBD953), 
          borderRadius: BorderRadius.circular(12.r), 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          mainAxisSize: MainAxisSize.min, 
          children: [
            Text(
              "You're almost done!",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'Metropolis-SemiBold',
                    letterSpacing: -1,
                    fontSize: 20.sp, 
                    color: Colors.black, 
                    
                  ),
            ),
            SizedBox(height: 8.h), 
            Text(
              "Hi, let's get you a personalized experience on Kliks\nPlease continue by providing some details.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black.withOpacity(0.9),
                    letterSpacing: 0,
                    fontSize: 13.sp, 
                  ),
            ),
            SizedBox(height: 10.h), 
            Align(
              alignment: Alignment.centerLeft, 
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3, 
                child: SmallButton(
                  text: 'Continue',
                  onPressed: () => _showBottomSheet(context), 
                  backgroundColor: Colors.black, 
                  textColor: Colors.white, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)), 
      ),
      builder: (context) {
        return const TwoStepBottomSheet();
      },
    );
  }
}