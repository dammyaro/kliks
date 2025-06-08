import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateTimePage extends StatefulWidget {
  const DateTimePage({super.key});

  @override
  State<DateTimePage> createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  DateTime? _startDate = DateTime.now();
  TimeOfDay? _startTime = TimeOfDay.now();
  DateTime? _endDate = DateTime.now().add(const Duration(hours: 2));
  TimeOfDay? _endTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 2))
  );

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _startTime) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _endTime) {
      setState(() => _endTime = picked);
    }
  }

  Widget _buildDateTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    letterSpacing: -1,
                    fontFamily: 'Metropolis-Regular',
                  ),
            ),
            // Icon(
            //   label == 'Time' ? Icons.access_time : Icons.calendar_today_outlined,
            //   size: 20.sp,
            //   color: Colors.grey,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return ElevatedButton(
      onPressed: () {
        // Combine date and time for start
        DateTime? start;
        if (_startDate != null && _startTime != null) {
          start = DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
            _startTime!.hour,
            _startTime!.minute,
          ).toUtc();
        }
        // Combine date and time for end
        DateTime? end;
        if (_endDate != null && _endTime != null) {
          end = DateTime(
            _endDate!.year,
            _endDate!.month,
            _endDate!.day,
            _endTime!.hour,
            _endTime!.minute,
          ).toUtc();
        }
        Navigator.pop(context, {
          'eventStart': start?.toIso8601String() ?? '',
          'eventEnd': end?.toIso8601String() ?? '',
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffbbd953),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
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
                  _buildDoneButton(),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                'Set Time & Date',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 24.sp,
                      fontFamily: 'Metropolis-SemiBold',
                      letterSpacing: -1,
                    ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Provide information on when the\n'
                'event starts and ends',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
              ),
              SizedBox(height: 32.h),
              Text(
                'Event Starts on',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      fontFamily: 'Metropolis-SemiBold',
                      letterSpacing: -1,
                    ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              _buildDateTimeField(
                label: 'Date',
                value: _startDate != null 
                    ? DateFormat('MMM dd, yyyy').format(_startDate!)
                    : 'Select date',
                onTap: () => _selectStartDate(context),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Text(
                    'Time',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              _buildDateTimeField(
                label: 'Time',
                value: _startTime?.format(context) ?? 'Select time',
                onTap: () => _selectStartTime(context),
              ),
              SizedBox(height: 32.h),
              Text(
                'Event Ends on',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      fontFamily: 'Metropolis-SemiBold',
                      letterSpacing: -1,
                    ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              _buildDateTimeField(
                label: 'Date',
                value: _endDate != null 
                    ? DateFormat('MMM dd, yyyy').format(_endDate!)
                    : 'Select date',
                onTap: () => _selectEndDate(context),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Text(
                    'Time',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              _buildDateTimeField(
                label: 'Time',
                value: _endTime?.format(context) ?? 'Select time',
                onTap: () => _selectEndTime(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}