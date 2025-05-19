import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditGenderPage extends StatelessWidget {
  const EditGenderPage({super.key});

  static final ValueNotifier<String> _selectedGender = ValueNotifier<String>('');

  Widget _buildDoneButton({required BuildContext context, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffbbd953),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      ),
      child: Text(
        'Update',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black,
              fontSize: 10.sp,
              fontFamily: 'Metropolis-SemiBold',
              letterSpacing: 0,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with back, title, and update button
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Gender',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18.sp,
                              fontFamily: 'Metropolis-SemiBold',
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                  ),
                  _buildDoneButton(
                    context: context,
                    onPressed: () {
                      // Handle done action
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Text(
                'What gender are you?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      fontFamily: 'Metropolis-SemiBold',
                    ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Gender',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 13.sp,
                      fontFamily: 'Metropolis-Regular',
                      color: Colors.grey,
                    ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () async {
                  final genders = ['Male', 'Female', 'Non binary'];
                  final selectedGender = await showModalBottomSheet<String>(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose your gender',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 16.sp,
                                fontFamily: 'Metropolis-SemiBold',
                                ),
                            ),
                            SizedBox(height: 20.h),
                            ...genders.map((gender) {
                              return ListTile(
                                title: Text(gender),
                                onTap: () => Navigator.pop(context, gender),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  );
                  if (selectedGender != null) {
                    _selectedGender.value = selectedGender;
                  }
                },
                child: ValueListenableBuilder<String>(
                  valueListenable: _selectedGender,
                  builder: (context, value, _) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.transparent, // Transparent background
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value.isEmpty ? 'Select Gender' : value,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 15.sp,
                                  color: value.isEmpty ? Colors.grey : Colors.black,
                                ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}