import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:kliks/core/routes.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/event_provider.dart';

class AnnouncementPage extends StatefulWidget {
  final String eventId;
  const AnnouncementPage({super.key, required this.eventId});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final List<String> _reasons = [
    'Registration',
    'Change Venue',
    'Change Time',
    'Cancel Event',
  ];
  String? _selectedReason;
  String? _locationValue;
  String _announcementNote = '';
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  bool _isSending = false;

  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.addListener(() {
      setState(() {
        _announcementNote = _noteController.text;
      });
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _showReasonSelector() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ReasonSelectorSheet(
          reasons: _reasons,
          selected: _selectedReason,
        );
      },
    );
    if (result != null) {
      setState(() {
        _selectedReason = result;
      });
    }
  }

  void _pickLocation() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.announcementLocation,
    );
    if (result != null) {
      final Map<String, dynamic> locationData = result as Map<String, dynamic>;
      setState(() {
        _locationValue = locationData['location'] as String;
      });
    }
  }

  Future<void> _sendAnnouncement() async {
    if (_selectedReason == null || _announcementNote.trim().isEmpty) return;
    setState(() => _isSending = true);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    print('Sending announcement: $_selectedReason');
    print('Location: $_locationValue');
    print('eventId: ${widget.eventId}');
    print('Announcement note: $_announcementNote');
    print('Start date: ${_startDate?.toIso8601String()}');
    print('End date: ${_endDate?.toIso8601String()}');
    print('Start time: ${_startTime?.format(context)}');
    print('End time: ${_endTime?.format(context)}');
    // Call the provider method to create the announcement
    final success = await eventProvider.createAnnouncement(
      eventId: widget.eventId,
      announcement: _selectedReason!,
      description: _announcementNote,
      startDate: _startDate?.toIso8601String(),
      endDate: _endDate?.toIso8601String(),
      lat: null, // Replace with actual lat if available
      lng: null, // Replace with actual lng if available
      location: _locationValue ?? '',
    );
    setState(() => _isSending = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
            child: Text('Announcement sent successfully!'),
          ),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
            child: Text('Failed to send announcement.'),
          ),
        ),
      );
    }
  }

  bool get _canSendAnnouncement {
    if (_selectedReason == 'Registration' ||
        _selectedReason == 'Cancel Event') {
      return _announcementNote.trim().isNotEmpty;
    } else if (_selectedReason == 'Change Venue') {
      return _locationValue != null &&
          _locationValue!.trim().isNotEmpty &&
          _announcementNote.trim().isNotEmpty;
    } else if (_selectedReason == 'Change Time') {
      return _announcementNote.trim().isNotEmpty &&
          _startDate != null &&
          _startTime != null &&
          _endDate != null &&
          _endTime != null;
    }
    return false;
  }

  Widget _buildDynamicContent() {
    if (_selectedReason == 'Change Venue') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 18.h),
          _SelectorBar(
            title: 'Location',
            value: _locationValue ?? 'Select location',
            onTap: _pickLocation,
          ),
          SizedBox(height: 18.h),
          _AnnouncementNoteField(controller: _noteController),
        ],
      );
    } else if (_selectedReason == 'Change Time') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _DateTimeField(
                  label: 'Start date',
                  value: _startDate,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _startDate = picked);
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _DateTimeField(
                  label: 'Start time',
                  value: _startTime,
                  isTime: true,
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => _startTime = picked);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _DateTimeField(
                  label: 'End date',
                  value: _endDate,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _endDate = picked);
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _DateTimeField(
                  label: 'End time',
                  value: _endTime,
                  isTime: true,
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => _endTime = picked);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          _AnnouncementNoteField(controller: _noteController),
        ],
      );
    } else if (_selectedReason == 'Cancel Event' ||
        _selectedReason == 'Registration') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 18.h),
          _AnnouncementNoteField(controller: _noteController),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomNavBar(title: 'Announcements'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              Text(
                'Updates on the event details\nwill be communicated to your guests',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13.sp,
                  color: theme.hintColor,
                  fontFamily: 'Metropolis-Regular',
                ),
              ),
              SizedBox(height: 24.h),
              _SelectorBar(
                title: 'Announcement reason',
                value: _selectedReason ?? 'Select reason',
                onTap: _showReasonSelector,
                isDropdown: true,
              ),
              _buildDynamicContent(),
              const Spacer(),
              CustomButton(
                text: 'Send announcement',
                onPressed: _canSendAnnouncement ? _sendAnnouncement : null,
                isLoading: _isSending,
                backgroundColor:
                    _canSendAnnouncement
                        ? const Color(0xffbbd953)
                        : Colors.grey[400],
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontFamily: 'Metropolis-SemiBold',
                  color: Colors.black,
                ),
                height: 44.h,
                borderRadius: 10,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectorBar extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool isDropdown;
  const _SelectorBar({
    required this.title,
    required this.value,
    required this.onTap,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10.sp,
                      color: theme.hintColor,
                      fontFamily: 'Metropolis-Regular',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp,
                      fontFamily: 'Metropolis-SemiBold',
                    ),
                  ),
                ],
              ),
            ),
            if (isDropdown)
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: theme.hintColor,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}

class _ReasonSelectorSheet extends StatefulWidget {
  final List<String> reasons;
  final String? selected;
  const _ReasonSelectorSheet({required this.reasons, this.selected});

  @override
  State<_ReasonSelectorSheet> createState() => _ReasonSelectorSheetState();
}

class _ReasonSelectorSheetState extends State<_ReasonSelectorSheet> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w, bottom: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HandleBar(),
          SizedBox(height: 16.h),
          Text(
            'Announcement reason',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15.sp,
              fontFamily: 'Metropolis-SemiBold',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Choose the reason you are making an update\nto this event detail',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11.sp,
              color: theme.hintColor,
            ),
          ),
          SizedBox(height: 18.h),
          ...widget.reasons.map(
            (reason) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: InkWell(
                onTap: () => setState(() => _selected = reason),
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    // color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color:
                          _selected == reason
                              ? const Color(0xffbbd953)
                              : theme.dividerColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          reason,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13.sp,
                            fontFamily: 'Metropolis-SemiBold',
                          ),
                        ),
                      ),
                      Icon(
                        _selected == reason
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color:
                            _selected == reason
                                ? const Color(0xffbbd953)
                                : theme.hintColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          CustomButton(
            text: 'Next',
            onPressed:
                _selected != null
                    ? () => Navigator.pop(context, _selected)
                    : null,
            backgroundColor:
                _selected != null ? const Color(0xffbbd953) : Colors.grey[400],
            textStyle: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontFamily: 'Metropolis-SemiBold',
              color: Colors.black,
            ),
            height: 44.h,
            borderRadius: 10,
          ),
        ],
      ),
    );
  }
}

class _AnnouncementNoteField extends StatelessWidget {
  final TextEditingController controller;
  const _AnnouncementNoteField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      minLines: 5,
      maxLines: 8,
      decoration: InputDecoration(
        hintText: 'Announcement note',
        hintStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.hintColor,
          fontSize: 13.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xffbbd953)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
      ),
      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  final String label;
  final dynamic value;
  final bool isTime;
  final VoidCallback onTap;
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onTap,
    this.isTime = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String display = '';
    if (value != null) {
      if (isTime && value is TimeOfDay) {
        display = value.format(context);
      } else if (!isTime && value is DateTime) {
        display =
            '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
      }
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10.sp,
                color: theme.hintColor,
                fontFamily: 'Metropolis-Regular',
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              display.isNotEmpty ? display : 'Select',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                fontFamily: 'Metropolis-SemiBold',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationSelectionPage extends StatelessWidget {
  const LocationSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: Center(
        child: Text(
          'Location selection UI goes here',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
