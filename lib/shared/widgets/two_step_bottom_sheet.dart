import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:geolocator/geolocator.dart';

class TwoStepBottomSheet extends StatefulWidget {
  const TwoStepBottomSheet({super.key});

  @override
  State<TwoStepBottomSheet> createState() => _TwoStepBottomSheetState();
}

class _TwoStepBottomSheetState extends State<TwoStepBottomSheet> {
  int _currentStep = 0; 
  final List<String> _selectedInterests = [];
  bool _isLoading = false;
  bool _locationAllowed = false;
  List<dynamic> _interests = [];
  bool _isFetchingCategories = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isFetchingCategories = true;
    });
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    try {
      final categories = await eventProvider.getAllCategory();
      setState(() {
        print(categories);
        _interests = categories;
        _isFetchingCategories = false;
      });
    } catch (e) {
      setState(() {
        _isFetchingCategories = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch interests: $e')),
      );
    }
  }

  Future<void> _handleAllowLocation() async {
    setState(() {
      _isLoading = true;
    });
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Location permissions are permanently denied. Please enable them in settings.'))),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Location permission denied'))),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      setState(() {
        _locationAllowed = true;
        _currentStep = 1;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Error requesting location: $e'))),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9, 
      child: Padding(
        padding: EdgeInsets.all(20.h), 
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              const HandleBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, 
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
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
                  ),
                  SizedBox(width: 30.h), 
                  Expanded(
                    flex: 3,
                    child: SizedBox(
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
              if (_currentStep == 0)
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
                            fontSize: 16.sp,
                            fontFamily: 'Metropolis-ExtraBold',
                          ),
                      textAlign: TextAlign.center, 
                    ),
                    SizedBox(height: 20.h), 
                    CustomButton(
                      text: _isLoading ? "Allowing..." : "Allow Location Access",
                      onPressed: _isLoading ? null : _handleAllowLocation,
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Metropolis-ExtraBold',
                            color: Colors.black,
                          ),
                      backgroundColor: const Color(0xffbbd953), 
                      textColor: Colors.black, 
                    ),
                  ],
                )
              else if (_currentStep == 1)
                _isFetchingCategories 
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
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
                        for (var interest in _interests)
                          if (interest['category'] != null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (interest['category'] != null) {
                                  if (_selectedInterests.contains(interest['category'])) {
                                    _selectedInterests.remove(interest['category']); 
                                  } else {
                                    _selectedInterests.add(interest['category']); 
                                  }
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: _selectedInterests.contains(interest['category'])
                                    ? Colors.grey[800] 
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20.r), 
                              ),
                              child: Text(
                                interest['category'],
                                style: TextStyle(
                                  fontSize: 12.sp, 
                                  letterSpacing: 0,
                                  color: _selectedInterests.contains(interest['category'])
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
                            text: "Update",
                            isLoading: _isLoading,
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                    final success = await authProvider.updateCategories(
                                      categories: _selectedInterests,
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (success) {
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Failed to update interests'))),
                                      );
                                    }
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
      ),
    );
  }
}