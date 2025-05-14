import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:flutter/cupertino.dart'; 

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
            // SizedBox(height: 80.h), 

            
            if (_currentStep == 0)
              // SizedBox(height: 80.h), 
              Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                    SizedBox(height: 80.h), 
                    Icon(
                    CupertinoIcons.device_phone_portrait,
                    size: 80.w,
                    color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5), 
                    ),
                  SizedBox(height: 40.h), 

                  
                  Text(
                    "To use location services, allow Kliks to access your location",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14.sp,
                          
                          fontFamily: 'Metropolis-SemiBold',
                        ),
                    textAlign: TextAlign.center, 
                  ),
                  SizedBox(height: 20.h), 

                  
                  CustomButton(
                    text: "Allow Location Access",
                    onPressed: () {
                      setState(() {
                        _currentStep = 1; 
                      });
                    },
                    textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Metropolis-ExtraBold',
                        ),
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
                    SizedBox(height: 20.h),
                    Text(
                      "Select your interests",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                            fontFamily: 'Metropolis-ExtraBold',
                            letterSpacing: -1, 
                          ),
                      textAlign: TextAlign.start, 
                    ),
                    SizedBox(height: 5.h), 

                    
                    Text(
                      "This will let us know what kind of events \nto show you",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 15.sp,
                          ),
                      textAlign: TextAlign.start, 
                    ),
                    SizedBox(height: 40.h), 

                    
                    Wrap(
                      spacing: 10.w, 
                      runSpacing: 10.h, 
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
                                    ? Colors.grey[800] 
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20.r), 
                              ),
                              child: Text(
                                interest,
                                style: TextStyle(
                                  fontSize: 12.sp, 
                                  // fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                  color: _selectedInterests.contains(interest)
                                      ? Colors.white 
                                      : Colors.black, 
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
                          textStyle: TextStyle(
                            fontSize: 12.sp, 
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Metropolis-Regular',
                          ),
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
                          textStyle: TextStyle(
                            fontSize: 12.sp, 
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Metropolis-Regular',
                          ),
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