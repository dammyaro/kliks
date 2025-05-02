import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart'; // Import the CustomButton widget

class TwoStepBottomSheet extends StatefulWidget {
  const TwoStepBottomSheet({super.key});

  @override
  State<TwoStepBottomSheet> createState() => _TwoStepBottomSheetState();
}

class _TwoStepBottomSheetState extends State<TwoStepBottomSheet> {
  int _currentStep = 0; // Track the current step
  final List<String> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9, // Set height to 90% of the screen
      child: Padding(
        padding: EdgeInsets.all(20.h), // Apply padding of 20.h
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align content to the start vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // Step Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the start of the screen
              children: [
                // Step 1 Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3, // Set width to 30% of the screen size
                  height: 3.h,
                  child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                    _currentStep = 0; // Navigate to Step 1
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_currentStep == 0 || _currentStep == 1)
                      ? const Color(0xffbbd953) // Selected background color
                      : Colors.grey[300], // Unselected background color
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 3.h), // Reduced height to 3.h
                  ),
                  child: const SizedBox.shrink(), // Empty content
                  ),
                ),
                SizedBox(width: 30.h), // Space between buttons

                // Step 2 Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3, // Set width to 30% of the screen size
                  height: 3.h,
                  child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                    _currentStep = 1; // Navigate to Step 2
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentStep == 1
                      ? const Color(0xffbbd953) // Selected background color
                      : Colors.grey[300], // Unselected background color
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                  ),
                  child: const SizedBox.shrink(), // Empty content
                  ),
                ),

                // Step Progress Indicator (1/2 or 2/2)
                Spacer(), // Push the progress indicator to the extreme right
                Text(
                  '${_currentStep + 1}/2',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: 80.h), // Spacing below the indicator

            // Step Content
            if (_currentStep == 0)
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
                children: [
                  // Phone Icon
                  Icon(
                    Icons.phone_iphone_outlined,
                    size: 80.w,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white, // Adjust color based on theme
                  ),
                  SizedBox(height: 40.h), // Spacing below the icon

                  // Text
                  Text(
                    "To use location services, allow Kliks to access your location",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Metropolis-ExtraBold',
                        ),
                    textAlign: TextAlign.center, // Center text horizontally
                  ),
                  SizedBox(height: 40.h), // Spacing below the text

                  // Allow Location Access Button
                  CustomButton(
                    text: "Allow Location Access",
                    onPressed: () {
                      setState(() {
                        _currentStep = 1; // Move to the next step
                      });
                    },
                    backgroundColor: const Color(0xffbbd953), // Always use this background color
                    textColor: Colors.black, // Black text color
                  ),
                ],
              )

            else if (_currentStep == 1)
              Column(
                mainAxisAlignment: MainAxisAlignment.start, // Align content to the start vertically
                crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start horizontally
                children: [
                  // Big Text
                  Text(
                    "Select your interests",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 28.sp,
                          fontFamily: 'Metropolis-ExtraBold',
                        ),
                    textAlign: TextAlign.start, // Align text to the start
                  ),
                  SizedBox(height: 10.h), // Spacing below the big text

                  // Sub Text
                  Text(
                    "This will let us know what kind of events \nto show you",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16.sp,
                        ),
                    textAlign: TextAlign.start, // Align text to the start
                  ),
                  SizedBox(height: 40.h), // Spacing below the sub text

                  // List of Interests
                  Wrap(
                    spacing: 10.w, // Horizontal spacing between buttons
                    runSpacing: 20.h, // Vertical spacing between rows
                    alignment: WrapAlignment.start, // Align buttons to the start
                    children: [
                      for (var interest in [
                        "Social & Networking",
                        "Food & Drinks",
                        "Family & Parenting",
                        "Education & Learning",
                        "Environment and Nature",
                        "Health & Wellness",
                        "Technology & Science",
                        "Sport & Fitness",
                        "Travel & Adventure",
                        "Fashion & Beauty",
                        "Arts & Culture"
                      ])
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedInterests.contains(interest)) {
                                _selectedInterests.remove(interest); // Deselect if already selected
                              } else {
                                _selectedInterests.add(interest); // Select if not already selected
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: _selectedInterests.contains(interest)
                                  ? Colors.white // Selected background color
                                  : Colors.grey[800], // Unselected background color
                              borderRadius: BorderRadius.circular(20.r), // Rounded corners
                            ),
                            child: Text(
                              interest,
                              style: TextStyle(
                                fontSize: 14.sp, // Set text size to 14.sp
                                fontWeight: FontWeight.bold,
                                color: _selectedInterests.contains(interest)
                                    ? Colors.black // Selected text color
                                    : Colors.white, // Unselected text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 40.h), // Spacing below the list of interests

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space buttons evenly
                    children: [
                      // Left Button: "Do this later"
                        SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4, // Set width to 30% of the screen size
                        child: CustomButton(
                          text: "Do this later",
                          onPressed: () {
                          Navigator.pop(context); // Handle "Do this later" action
                          },
                          backgroundColor: Colors.grey[600]!, // Grey background color
                          textColor: Colors.white, // Black text color
                        ),
                      ),
                      SizedBox(width: 10.w), // Spacing between the buttons

                      // Right Button: "Continue"
                        SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4, // Set width to 30% of the screen size
                        child: CustomButton(
                          text: "Next",
                          onPressed: () {
                          // Handle "Continue" action
                          Navigator.pop(context); // Close the bottom sheet or navigate further
                          },
                          backgroundColor: const Color(0xffbbd953), // Green background color
                          textColor: Colors.black, // Black text color
                        
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}