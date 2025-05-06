import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart'; 

class TwoStepBottomSheet extends StatefulWidget {
  const TwoStepBottomSheet({super.key});

  @override
  State<TwoStepBottomSheet> createState() => _TwoStepBottomSheetState();
}

class _TwoStepBottomSheetState extends State<TwoStepBottomSheet> {
  int _currentStep = 0; 
  final List<String> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9, 
      child: Padding(
        padding: EdgeInsets.all(20.h), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3, 
                  height: 3.h,
                  child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                    _currentStep = 0; 
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_currentStep == 0 || _currentStep == 1)
                      ? const Color(0xffbbd953) 
                      : Colors.grey[300], 
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r), 
                    ),
                    padding: EdgeInsets.symmetric(vertical: 3.h), 
                  ),
                  child: const SizedBox.shrink(), 
                  ),
                ),
                SizedBox(width: 30.h), 

                
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3, 
                  height: 3.h,
                  child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                    _currentStep = 1; 
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentStep == 1
                      ? const Color(0xffbbd953) 
                      : Colors.grey[300], 
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r), 
                    ),
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                  ),
                  child: const SizedBox.shrink(), 
                  ),
                ),

                
                Spacer(), 
                Text(
                  '${_currentStep + 1}/2',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: 80.h), 

            
            if (_currentStep == 0)
              Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  
                  Icon(
                    Icons.phone_iphone_outlined,
                    size: 80.w,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white, 
                  ),
                  SizedBox(height: 40.h), 

                  
                  Text(
                    "To use location services, allow Kliks to access your location",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Metropolis-ExtraBold',
                        ),
                    textAlign: TextAlign.center, 
                  ),
                  SizedBox(height: 40.h), 

                  
                  CustomButton(
                    text: "Allow Location Access",
                    onPressed: () {
                      setState(() {
                        _currentStep = 1; 
                      });
                    },
                    backgroundColor: const Color(0xffbbd953), 
                    textColor: Colors.black, 
                  ),
                ],
              )

            else if (_currentStep == 1)
              Column(
                mainAxisAlignment: MainAxisAlignment.start, 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  
                  Text(
                    "Select your interests",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 28.sp,
                          fontFamily: 'Metropolis-ExtraBold',
                        ),
                    textAlign: TextAlign.start, 
                  ),
                  SizedBox(height: 10.h), 

                  
                  Text(
                    "This will let us know what kind of events \nto show you",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16.sp,
                        ),
                    textAlign: TextAlign.start, 
                  ),
                  SizedBox(height: 40.h), 

                  
                  Wrap(
                    spacing: 10.w, 
                    runSpacing: 20.h, 
                    alignment: WrapAlignment.start, 
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
                                _selectedInterests.remove(interest); 
                              } else {
                                _selectedInterests.add(interest); 
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: _selectedInterests.contains(interest)
                                  ? Colors.white 
                                  : Colors.grey[800], 
                              borderRadius: BorderRadius.circular(20.r), 
                            ),
                            child: Text(
                              interest,
                              style: TextStyle(
                                fontSize: 14.sp, 
                                fontWeight: FontWeight.bold,
                                color: _selectedInterests.contains(interest)
                                    ? Colors.black 
                                    : Colors.white, 
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 40.h), 

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      
                        SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4, 
                        child: CustomButton(
                          text: "Do this later",
                          onPressed: () {
                          Navigator.pop(context); 
                          },
                          backgroundColor: Colors.grey[600]!, 
                          textColor: Colors.white, 
                        ),
                      ),
                      SizedBox(width: 10.w), 

                      
                        SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4, 
                        child: CustomButton(
                          text: "Next",
                          onPressed: () {
                          
                          Navigator.pop(context); 
                          },
                          backgroundColor: const Color(0xffbbd953), 
                          textColor: Colors.black, 
                        
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