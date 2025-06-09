import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';

class EntranceRequirementPage extends StatefulWidget {
  const EntranceRequirementPage({super.key});

  @override
  State<EntranceRequirementPage> createState() => _EntranceRequirementPageState();
}

class _EntranceRequirementPageState extends State<EntranceRequirementPage> {
  bool _activated = false;
  final TextEditingController _pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    _buildDoneButton(onPressed: () => Navigator.pop(context)),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  'Entry Requirements',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    letterSpacing: 0,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.left,
                ),
                // SizedBox(height: 8.h),
                Text(
                  'Set up the number of points to be required from guests if activated',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    color: Theme.of(context).hintColor,
                    fontFamily: 'Metropolis-Regular',
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 24.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[900]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activate Entry Points",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Metropolis-SemiBold',
                                  letterSpacing: 0,
                                ),
                          ),
                          Switch(
                            value: _activated,
                            onChanged: (val) {
                              setState(() {
                                _activated = val;
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xff27ae60),
                            
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Each guests will be required to give the stated\npoints up to get a spot in the event",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // Points text field
                AbsorbPointer(
                  absorbing: !_activated,
                  child: Opacity(
                    opacity: _activated ? 1.0 : 0.5,
                    child: TextFormWidget(
                      name: 'points',
                      controller: _pointsController,
                      labelText: 'Points',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoneButton({required VoidCallback onPressed}) {
    return TextButton(
      onPressed: () {
        int points = int.tryParse(_pointsController.text) ?? 1;
        if (!_activated) points = 0;
        Navigator.pop(context, {
          'isRequirePoints': _activated,
          'attendEventPoint': points,
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffbbd953),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
      child: Text(
        'Done',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black,
              fontSize: 12.sp,
              fontFamily: 'Metropolis-Medium',
              letterSpacing: 0,
            ),
      ),
    );
  }
}