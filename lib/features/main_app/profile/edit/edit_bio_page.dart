import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';

class EditBioPage extends StatelessWidget {
  const EditBioPage({super.key});

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
                  'Bio',
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
              'Tell us about yourself',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp,
                  fontFamily: 'Metropolis-SemiBold',
                ),
              ),
              SizedBox(height: 20.h),
              StatefulBuilder(
              builder: (context, setState) {
                int wordCount = _nameController.text.trim().isEmpty
                  ? 0
                  : _nameController.text.trim().split(RegExp(r'\s+')).length;
                return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormWidget(
                  controller: _nameController,
                  labelText: 'Bio',
                  name: 'bio',
                  multiline: true,
                  onChanged: (val) {
                    setState(() {});
                  },
                  ),
                  SizedBox(height: 10.h),
                  Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$wordCount/200',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      ),
                  ),
                  ),
                ],
                );
              },
              ),
            ],
            
          ),
        ),
      ),
    );
  }
}