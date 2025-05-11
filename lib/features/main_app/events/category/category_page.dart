import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<String> _selectedCategories = [];

  final List<String> _categories = [
    'Social & Networking',
    'Food & Drinks',
    'Family & Parenting',
    'Education & Learning',
    'Environment & Nature',
    'Health & Wellness',
    'Technology & Science',
    'Sport & Fitness',
    'Travel & Adventure',
    'Fashion & Beauty',
    'Arts & Culture'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with title and done button
              SizedBox(height: 20.h),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selevt event category',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        letterSpacing: -1,
                      ),
                    ),
                    _buildDoneButton(onPressed: () => Navigator.pop(context)),
                  ],
                ),
                SizedBox(height: 20.h),

              // Category selection list
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => Divider(
                  height: 0.h,
                  color: Colors.grey.withOpacity(0),
                ),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategories.contains(category);
                  return _buildCategoryItem(
                    context,
                    category: category,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedCategories.remove(category);
                        } else {
                          _selectedCategories.add(category);
                        }
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildDoneButton({required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
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

  Widget _buildCategoryItem(
    BuildContext context, {
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Checkbox on the left
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xff27ae60) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? const Color(0xff27ae60) : Colors.grey,
                  width: 1.5.w,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16.sp,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                category,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      fontFamily: 'Metropolis-Regular',
                      letterSpacing: -1,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}