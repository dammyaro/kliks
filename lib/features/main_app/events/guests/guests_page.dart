import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';

class GuestsPage extends StatefulWidget {
  const GuestsPage({super.key});

  @override
  State<GuestsPage> createState() => _GuestsPageState();
}

class _GuestsPageState extends State<GuestsPage> {
  String _guestType = 'Everyone';
  String _ageGroup = 'All ages';
  final TextEditingController _guestCountController = TextEditingController();

  final List<String> _guestTypes = [
    'Everyone',
    'Verified users only',
    'Invited only',
    'My followers only',
    'Male only',
    'Female only',
    'Non binary only',
  ];

  final List<String> _ageGroups = ['All ages', '18+ guests', 'Children'];

  void _showGuestTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose your guest type',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 17.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        letterSpacing: -1,
                      ),
                    ),
                    _buildDoneButton(onPressed: () => Navigator.pop(context)),
                  ],
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: ListView(
                    children: _guestTypes.map(
                      (type) => ListTile(
                        title: Row(
                          children: [
                            Text(
                              type,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              fontFamily: 'Metropolis-Regular',
                              letterSpacing: 0,
                              ),
                            ),
                            SizedBox(width: 5.h),
                            if (type == 'Verified users only')
                              Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Icon(
                                  Icons.verified,
                                  size: 16.sp,
                                  color: Colors.green,
                                ),
                              ),
                           
                          ],
                        ),
                        onTap: () {
                          setState(() => _guestType = type);
                          Navigator.pop(context);
                        },
                      ),
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAgeGroupBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose age group',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 17.sp,
                      fontFamily: 'Metropolis-SemiBold',
                      letterSpacing: -1,
                    ),
                  ),
                  _buildDoneButton(onPressed: () => Navigator.pop(context)),
                ],
              ),
              SizedBox(height: 20.h),
              ..._ageGroups.map(
                (group) => ListTile(
                    title: Text(
                    group,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontFamily: 'Metropolis-Regular',
                      letterSpacing: -1,
                    ),
                    ),
                  onTap: () {
                    setState(() => _ageGroup = group);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDoneButton({required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: () {
        int count = int.tryParse(_guestCountController.text) ?? 0;
        Navigator.pop(context, {
          'whoCanAttend': _guestType,
          'ageLimit': _ageGroup,
          'numberAttendeesLimit': count,
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
          fontSize: 14.sp,
          fontFamily: 'Metropolis-SemiBold',
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String title,
    required String value,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontFamily: 'Metropolis-Regular',
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_drop_down, size: 24.sp),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: 24.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                    _buildDoneButton(
                      onPressed: () {
                        // Handle done action
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  'Guests',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 20.sp,
                  fontFamily: 'Metropolis-SemiBold',
                  letterSpacing: -0.5,
                ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Who can attend this event?',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
                ),
                SizedBox(height: 24.h),
                _buildDropdownField(
                  title: 'Guest Type',
                  value: _guestType,
                  subtitle: 'Guest',
                  onTap: _showGuestTypeBottomSheet,
                ),
                SizedBox(height: 16.h),
                _buildDropdownField(
                  title: 'Age Group',
                  value: _ageGroup,
                  subtitle: 'Age group',
                  onTap: _showAgeGroupBottomSheet,
                ),
                SizedBox(height: 16.h),
                TextFormWidget(
                  name: 'guestCount',
                  controller: _guestCountController,
                  labelText: 'Number of guests',
                  keyboardType: TextInputType.number,
                  contentHeight: 25.h,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of guests';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _guestCountController.dispose();
    super.dispose();
  }
}
