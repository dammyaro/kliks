import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kliks/shared/widgets/button.dart';

class TransactionFilterPage extends StatefulWidget {
  const TransactionFilterPage({super.key});

  @override
  State<TransactionFilterPage> createState() => _TransactionFilterPageState();
}

class _TransactionFilterPageState extends State<TransactionFilterPage> {
  final List<String> categories = [
    'All points',
    'Kyc points',
    'Reward points',
    'Spent points',
    'Received points',
  ];
  String selectedCategory = 'All points';
  double points = 500;
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Filters',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 16.sp,
            fontFamily: 'Metropolis-Medium',
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Section
            Text(
              'Category',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: theme.hintColor,
                fontFamily: 'Metropolis-Medium',
              ),
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 12.h,
              children: List.generate(categories.length, (i) {
                final cat = categories[i];
                final isSelected = selectedCategory == cat;
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 16.w * 2 - 10.w) / 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xffbbd953) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? const Color(0xffbbd953) : theme.dividerColor.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          color: isSelected ? Colors.black : theme.textTheme.bodyMedium?.color,
                          fontFamily: isSelected ? 'Metropolis-Medium' : 'Metropolis-Regular',
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 28.h),
            Divider(color: theme.dividerColor.withOpacity(0.5), indent: 0, endIndent: 0, thickness: 1),
            // Points Section
            Text(
              'Points',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: theme.hintColor,
                fontFamily: 'Metropolis-Medium',
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '${points.toInt()} pts',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: theme.textTheme.bodyMedium?.color,
                fontFamily: 'Metropolis-Regular',
              ),
            ),
            Slider(
              value: points,
              min: 0,
              max: 1000,
              divisions: 1000,
              label: '${points.toInt()} pts',
              onChanged: (value) {
                setState(() {
                  points = value;
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
                  Text('500', style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp, color: theme.hintColor)),
                  Text('1000', style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp, color: theme.hintColor)),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Divider(color: theme.dividerColor.withOpacity(0.5), indent: 0, endIndent: 0, thickness: 1),
            // Date Section
            Text(
              'Transaction Date',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: theme.hintColor,
                fontFamily: 'Metropolis-Medium',
              ),
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
                        firstDate: DateTime(2000),
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
                          borderRadius: BorderRadius.circular(8.r),
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
                          borderRadius: BorderRadius.circular(8.r),
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
                        firstDate: _startDate ?? DateTime(2000),
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
                          borderRadius: BorderRadius.circular(8.r),
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
                          borderRadius: BorderRadius.circular(8.r),
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
            SizedBox(height: 36.h),
            // Apply Filters Button
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: CustomButton(
                  text: 'Apply filters',
                  onPressed: () {
                    // Apply filters logic
                  },
                  backgroundColor: const Color(0xffbbd953),
                  textColor: Colors.black,
                  textStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    fontFamily: 'Metropolis-Medium',
                    color: Colors.black,
                  ),
                  height: 40.h,
                  borderRadius: 12.r,
                ),
              ),
            ),
            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }
}
