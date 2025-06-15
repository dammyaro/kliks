import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/event_provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<String> _selectedCategories = [];

  List<String> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final cats = await eventProvider.getAllCategory();
    setState(() {
      _categories = cats.map<String>((cat) {
        if (cat is String) return cat;
        if (cat is Map && cat['category'] != null) return cat['category'].toString();
        return '';
      }).where((cat) => cat.isNotEmpty).toList();
      _isLoading = false;
    });
  }

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
                      'Select event category',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontFamily: 'Metropolis-SemiBold',
                        
                      ),
                    ),
                    _buildDoneButton(onPressed: () => Navigator.pop(context)),
                  ],
                ),
                SizedBox(height: 20.h),

              _isLoading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: const Color(0xffbbd953),
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 0.h,
                        color: Colors.grey.withOpacity(0),
                      ),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategories.isNotEmpty && _selectedCategories.first == category;
                        return _buildCategoryItem(
                          context,
                          category: category,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedCategories
                                ..clear()
                                ..add(category);
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
      onPressed: () {
        // Return the first selected category, or empty string if none
        Navigator.pop(context, _selectedCategories.isNotEmpty ? _selectedCategories.first : '');
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
              width: 14.w,
              height: 14.h,
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
                      size: 12.sp,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                category,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      fontFamily: 'Metropolis-Regular',
                      
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}