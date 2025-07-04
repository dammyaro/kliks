import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:kliks/features/main_app/search/filter_options.dart';
import 'package:kliks/core/providers/search_filter_provider.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterPage extends StatefulWidget {
  const SearchFilterPage({super.key});

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  String? _selectedCategory;
  double _locationRange = 50;
  String _selectedAgeGroup = 'everyone';
  String _selectedGuests = 'anyone';
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  Future<List<dynamic>>? _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    final filterOptions = Provider.of<SearchFilterProvider>(context, listen: false).filterOptions;
    _selectedCategory = filterOptions.category;
    _locationRange = filterOptions.locationRange;
    _selectedAgeGroup = filterOptions.ageGroup;
    _selectedGuests = filterOptions.guests;
    _startDate = filterOptions.startDate;
    _startTime = filterOptions.startTime;
    _endDate = filterOptions.endDate;
    _endTime = filterOptions.endTime;
  }

  void _fetchCategories() {
    _categoriesFuture =
        Provider.of<EventProvider>(context, listen: false).getAllCategory();
  }

  void _clearFilters() {
    Provider.of<SearchFilterProvider>(context, listen: false).clearFilters();
    setState(() {
      _selectedCategory = null;
      _locationRange = 50;
      _selectedAgeGroup = 'everyone';
      _selectedGuests = 'anyone';
      _startDate = null;
      _startTime = null;
      _endDate = null;
      _endTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomNavBar(title: 'Search filters'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Search
            Text(
              'Search location',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13.sp,
                color: theme.hintColor,
              ),
            ),
            SizedBox(height: 6.h),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_outlined, color: theme.hintColor),
                hintText: 'Enter a location',
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 14.sp,
                  color: theme.hintColor,
                  fontFamily: 'Metropolis-Regular',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: theme.textTheme.bodyMedium?.color,
                fontFamily: 'Metropolis-Regular',
              ),
            ),
            SizedBox(height: 18.h),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            // Categories
            Text(
              'Categories',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13.sp,
                color: theme.hintColor,
              ),
            ),
            SizedBox(height: 6.h),
            FutureBuilder<List<dynamic>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffbbd953)),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error loading categories', style: theme.textTheme.bodySmall);
                } else {
                  final rawList = snapshot.data ?? [];
                  final categories = rawList
                      .map((item) => (item is Map && item['category'] != null) ? item['category'].toString() : null)
                      .where((cat) => cat != null && cat.isNotEmpty)
                      .toSet()
                      .toList();
                  if (_selectedCategory != null && !categories.contains(_selectedCategory)) {
                    _selectedCategory = null;
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedCategory,
                      hint: Text(
                        'All categories',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontFamily: 'Metropolis-Regular',
                        ),
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        color: Colors.black,
                        fontFamily: 'Metropolis-Regular',
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      items: categories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 13.sp,
                                    color: Colors.black,
                                    fontFamily: 'Metropolis-Regular',
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xffbbd953),
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 18.h),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            // Location Range
            Text(
              'Location Range',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: theme.hintColor,
                fontFamily: 'Metropolis-Medium',
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '${_locationRange.toInt()} kms',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: theme.textTheme.bodyMedium?.color,
                fontFamily: 'Metropolis-Regular',
              ),
            ),
            Slider(
              value: _locationRange,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_locationRange.toInt()} kms',
              onChanged: (value) {
                setState(() {
                  _locationRange = value;
                });
              },
              activeColor: const Color(0xffbbd953),
              inactiveColor: theme.dividerColor.withOpacity(0.2),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0', style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp, color: theme.hintColor)),
                  Text('50', style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp, color: theme.hintColor)),
                  Text('100', style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp, color: theme.hintColor)),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            // Age Group
            Text(
              'Age Group',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: theme.hintColor,
                fontFamily: 'Metropolis-Medium',
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Everyone',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: theme.textTheme.bodyMedium?.color,
                  fontFamily: 'Metropolis-Regular',
                ),
              ),
              value: _selectedAgeGroup == 'everyone',
              onChanged: (value) {
                if (value == true) {
                  setState(() {
                    _selectedAgeGroup = 'everyone';
                  });
                }
              },
              activeColor: const Color(0xffbbd953),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('18+ events',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: theme.textTheme.bodyMedium?.color,
                  fontFamily: 'Metropolis-Regular',
                ),
              ),
              value: _selectedAgeGroup == '18+',
              onChanged: (value) {
                if (value == true) {
                  setState(() {
                    _selectedAgeGroup = '18+';
                  });
                }
              },
              activeColor: const Color(0xffbbd953),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Kids events',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: theme.textTheme.bodyMedium?.color,
                  fontFamily: 'Metropolis-Regular',
                ),
              ),
              value: _selectedAgeGroup == 'kids',
              onChanged: (value) {
                if (value == true) {
                  setState(() {
                    _selectedAgeGroup = 'kids';
                  });
                }
              },
              activeColor: const Color(0xffbbd953),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            SizedBox(height: 18.h),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            // Guests
            Text(
              'Guests',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: theme.hintColor,
                fontFamily: 'Metropolis-Medium',
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Anyone',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: theme.textTheme.bodyMedium?.color,
                  fontFamily: 'Metropolis-Regular',
                ),
              ),
              value: _selectedGuests == 'anyone',
              onChanged: (value) {
                if (value == true) {
                  setState(() {
                    _selectedGuests = 'anyone';
                  });
                }
              },
              activeColor: const Color(0xffbbd953),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('People you follow',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: theme.textTheme.bodyMedium?.color,
                  fontFamily: 'Metropolis-Regular',
                ),
              ),
              value: _selectedGuests == 'following',
              onChanged: (value) {
                if (value == true) {
                  setState(() {
                    _selectedGuests = 'following';
                  });
                }
              },
              activeColor: const Color(0xffbbd953),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            SizedBox(height: 18.h),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            // Event Date
            Text(
              'Event Date',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: theme.hintColor,
                fontFamily: 'Metropolis-Medium',
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        labelStyle: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: theme.hintColor,
                          fontFamily: 'Metropolis-Regular',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                      ),
                      child: Text(
                        _startDate != null
                            ? DateFormat.yMd().format(_startDate!)
                            : 'Select date',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          color: theme.textTheme.bodyMedium?.color,
                          fontFamily: _startDate != null ? 'Metropolis-Medium' : 'Metropolis-Regular',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _startTime ?? TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          _startTime = time;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        labelStyle: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: theme.hintColor,
                          fontFamily: 'Metropolis-Regular',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                      ),
                      child: Text(
                        _startTime != null
                            ? _startTime!.format(context)
                            : 'Select time',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          color: theme.textTheme.bodyMedium?.color,
                          fontFamily: _startTime != null ? 'Metropolis-Medium' : 'Metropolis-Regular',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? _startDate ?? DateTime.now(),
                        firstDate: _startDate ?? DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        labelStyle: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: theme.hintColor,
                          fontFamily: 'Metropolis-Regular',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                      ),
                      child: Text(
                        _endDate != null
                            ? DateFormat.yMd().format(_endDate!)
                            : 'Select date',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          color: theme.textTheme.bodyMedium?.color,
                          fontFamily: _endDate != null ? 'Metropolis-Medium' : 'Metropolis-Regular',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _endTime ?? TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          _endTime = time;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        labelStyle: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: theme.hintColor,
                          fontFamily: 'Metropolis-Regular',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                      ),
                      child: Text(
                        _endTime != null
                            ? _endTime!.format(context)
                            : 'Select time',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          color: theme.textTheme.bodyMedium?.color,
                          fontFamily: _endTime != null ? 'Metropolis-Medium' : 'Metropolis-Regular',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            // Apply Filters Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: CustomButton(
                    text: 'Apply filters',
                    onPressed: () {
                      final filterOptions = FilterOptions(
                        category: _selectedCategory,
                        locationRange: _locationRange,
                        ageGroup: _selectedAgeGroup,
                        guests: _selectedGuests,
                        startDate: _startDate,
                        startTime: _startTime,
                        endDate: _endDate,
                        endTime: _endTime,
                      );
                      Provider.of<SearchFilterProvider>(context, listen: false)
                          .updateFilters(filterOptions);
                      Navigator.pop(context);
                    },
                    backgroundColor: const Color(0xffbbd953),
                    textStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      fontFamily: 'Metropolis-Medium',
                      color: Colors.black,
                    ),
                    height: 48.h,
                    borderRadius: 12.r,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: CustomButton(
                    text: 'Clear',
                    onPressed: _clearFilters,
                    backgroundColor: Colors.grey[300]!,
                    textColor: Colors.black,
                    textStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      fontFamily: 'Metropolis-Medium',
                      color: Colors.black,
                    ),
                    height: 48.h,
                    borderRadius: 12.r,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

