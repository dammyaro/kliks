import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/shared/widgets/button.dart';

class UpdateLocationPage extends StatefulWidget {
  const UpdateLocationPage({super.key});

  @override
  State<UpdateLocationPage> createState() => _UpdateLocationPageState();
}

class _UpdateLocationPageState extends State<UpdateLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  final String _location = 'Ontario, Canada';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNavBar(title: 'Location'),
            SizedBox(height: 2.h),
            TextFormWidget(
              name: 'search_location',
              controller: _searchController,
              labelText: 'Location',
              prefixIcon: Icon(Icons.search_outlined, color: theme.iconTheme.color?.withOpacity(0.5)),
              onChanged: (val) {
                // Optionally handle search logic here
              },
            ),
            SizedBox(height: 28.h),
            Text(
              'Your Location',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13.sp,
                fontFamily: 'Metropolis-SemiBold',
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: theme.iconTheme.color, size: 22.sp),
                  SizedBox(width: 12.w),
                  Text(
                    _location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      fontFamily: 'Metropolis-SemiBold',
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Continue',
              onPressed: () {
                // Handle continue logic
              },
              backgroundColor: const Color(0xffbdd953),
            ),
          ],
        ),
      ),
    );
  }
}