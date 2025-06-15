import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/core/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:kliks/core/services/media_service.dart';
import 'package:confetti/confetti.dart';
import 'package:image_cropper/image_cropper.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({super.key});

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  XFile? _coverImage;
  bool _isLoading = false;
  final bool _isUploadingCover = false;
  List<XFile> _otherMediaFiles = [];

  // Placeholder/defaults for other required fields
  String _selectedCategory = '';
  
  int _attendeeLimit = 0; //100
  int? _ageMin;
  int? _ageMax;
  double? _lat;
  double? _lng;
  String _whoCanAttend = '';
  String _ageLimit = '';
  String _location = '';
  final int _numberAttendeesLimit = 0;
  String _startDate = DateTime.now().toIso8601String();
  String _endDate = DateTime.now().add(Duration(hours: 2)).toIso8601String();
  final String _bannerImageUrl = '';
  List<String> _otherImageUrls = [];
  List<String> _invitedUserIds = [];
  
  
  bool _isRequirePoints = false;
  int _attendEventPoint = 0;

  // Subtitles for clickable areas
  String _locationSubtitle = 'Where is it happening?';
  String _categorySubtitle = 'Choose event category';
  String _dateTimeSubtitle = 'When is it happening';
  String _entranceRequirementSubtitle = 'Activate entrance points';
  String _otherMediaSubtitle = 'Add other images related to this event';
  String _inviteGuestsSubtitle = 'Who can attend this event';

  String get _guestsSubtitle {
    List<String> parts = [];
    if (_whoCanAttend.isNotEmpty) parts.add(_whoCanAttend);
    if (_ageLimit.isNotEmpty) parts.add(_ageLimit);
    if (_attendeeLimit > 0) parts.add('$_attendeeLimit guests');
    return parts.isNotEmpty ? parts.join(', ') : 'Who can attend this event';
  }

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Crop the image to 1024x1024
      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 1024,
        maxHeight: 1024,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Banner',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Banner',
            aspectRatioLockEnabled: true,
            minimumAspectRatio: 1.0,
          ),
        ],
      );
      if (cropped != null) {
        setState(() {
          _coverImage = XFile(cropped.path);
        });
      } else {
        // User cancelled cropping
        return;
      }
    }
  }

  Future<void> _createEvent() async {
    if (_eventNameController.text.isEmpty || _eventDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Please fill all required fields'))),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      // Upload cover image if picked
      String bannerImageUrl = '';
      if (_coverImage != null) {
        final mediaService = MediaService();
        bannerImageUrl = await mediaService.uploadProfilePicture(
          file: File(_coverImage!.path),
          folderName: 'event_banners',
        ) ?? '';
      }

      // Upload other media files if picked
      List<String> otherImageUrls = [];
      if (_otherMediaFiles.isNotEmpty) {
        final mediaService = MediaService();
        for (final file in _otherMediaFiles) {
          final url = await mediaService.uploadProfilePicture(
            file: File(file.path),
            folderName: 'event_media',
          );
          if (url != null) otherImageUrls.add(url);
        }
      }

      await Provider.of<EventProvider>(context, listen: false).createEvent(
        title: _eventNameController.text, //check
        description: _eventDescriptionController.text, //check
        category: _selectedCategory, //check
        numberAttendesLimit: _attendeeLimit, //check
        ageLimitMin: _ageMin, //check
        ageLimitMax: _ageMax, //check
        whoCanAttend: _whoCanAttend, //check
        startDate: _startDate, //check
        endDate: _endDate, //check
        bannerImageUrl: bannerImageUrl, //check
        otherImageUrl: otherImageUrls, //check
        lat: _lat,
        lng: _lng,
        location: _location,
        isRequirePoints: _isRequirePoints, //check
        attendEventPoint: _attendEventPoint, //check
      );
      if (mounted) {
        await showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) {
            return _ConfettiSuccessModal(
              eventTitle: _eventNameController.text,
              onProfileTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
              },
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Failed to create event'))),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFormComplete =
        _eventNameController.text.isNotEmpty && 
        _eventDescriptionController.text.isNotEmpty && 
        _selectedCategory.isNotEmpty &&
        _categorySubtitle != 'Choose event category' &&
        _location.isNotEmpty &&
        _locationSubtitle != 'Where is it happening?' &&
        _lat != null &&
        _lng != null &&
        _startDate.isNotEmpty &&
        _endDate.isNotEmpty &&
        _dateTimeSubtitle != 'When is it happening' &&
        // _otherImageUrls.isNotEmpty &&
        _otherMediaSubtitle != 'Add other images related to this event' &&
        // _invitedUserIds.isNotEmpty &&
        // _inviteGuestsSubtitle != 'Add guests to this event' &&
        // _bannerImageUrl.isNotEmpty &&
        _whoCanAttend.isNotEmpty &&
        _whoCanAttend != '' &&
        _ageLimit.isNotEmpty &&
        _ageLimit.toLowerCase() != 'who can attend this event' &&
        _attendeeLimit > 0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with back button and title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "New Event",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18.sp,
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'Metropolis-SemiBold',
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder for alignment
                ],
              ),
              SizedBox(height: 20.h),

              // Cover image button or image
              _coverImage == null
                  ? ElevatedButton.icon(
                      onPressed: _pickCoverImage,
                      icon: Icon(Icons.add, color: Colors.black),
                      label: Text(
                        "Cover Image (1024x1024)",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        textStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
                        backgroundColor: const Color(0xffbbd953).withAlpha(255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: _pickCoverImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.file(
                              File(_coverImage!.path),
                              width: double.infinity,
                              height: 180.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 180.h,
                            color: Colors.black.withOpacity(0.2),
                            child: Center(
                              child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 40.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 20.h),

              // Event name text field
              TextFormWidget(
                name: 'event_name',
                controller: _eventNameController,
                labelText: 'Enter event name',
              ),
              SizedBox(height: 20.h),

              // Event description text area
              TextFormWidget(
                name: 'event_description',
                controller: _eventDescriptionController,
                labelText: 'Event description',
                keyboardType: TextInputType.multiline,
                multiline: true,
              ),
              SizedBox(height: 20.h),

              // List of clickable areas
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.people_outlined,
                title: "Guests",
                subtitle: _guestsSubtitle,
                onTap: () async {
                  final result = await Navigator.pushNamed(context, AppRoutes.guests);
                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      _whoCanAttend = result['whoCanAttend'] ?? _whoCanAttend;
                      _ageLimit = result['ageLimit'] ?? _ageLimit;
                      _attendeeLimit = result['numberAttendeesLimit'] ?? _attendeeLimit;
                      // Calculate ageMin and ageMax from ageLimit
                      if (_ageLimit.toLowerCase().contains('all')) {
                        _ageMin = 0;
                        _ageMax = 60;
                      } else if (_ageLimit.toLowerCase().contains('18')) {
                        _ageMin = 18;
                        _ageMax = 60;
                      } else if (_ageLimit.toLowerCase().contains('children')) {
                        _ageMin = 0;
                        _ageMax = 18;
                      }
                    });
                  }
                },
              ),
              Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
              ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.settings_outlined,
                title: "Category",
                subtitle: _categorySubtitle,
                onTap: () async {
                  final result = await Navigator.pushNamed(context, AppRoutes.category);
                  if (result != null && result is String && result.isNotEmpty) {
                    setState(() {
                      _selectedCategory = result;
                      _categorySubtitle = result;
                    });
                  }
                },
              ),
              Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
              ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.location_on_outlined,
                title: "Location",
                subtitle: _locationSubtitle,
                onTap: () async {
                  final result = await Navigator.pushNamed(context, AppRoutes.location);
                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      _location = result['location'] ?? _location;
                      _lat = result['lat'] ?? _lat;
                      _lng = result['lng'] ?? _lng;
                      _locationSubtitle = _location.isNotEmpty ? _location : 'Where is it happening?';
                    });
                  }
                },
              ),
              Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
              ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.date_range_outlined,
                title: "Date and Time",
                subtitle: _dateTimeSubtitle,
                onTap: () async {
                  final result = await Navigator.pushNamed(context, AppRoutes.dateTime);
                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      _startDate = result['eventStart'] ?? _startDate;
                      _endDate = result['eventEnd'] ?? _endDate;
                      // Format for display
                      try {
                        final start = DateTime.tryParse(_startDate);
                        final end = DateTime.tryParse(_endDate);
                        if (start != null && end != null) {
                          final startStr = DateFormat('EEE, d MMM yyyy, h:mm a').format(start.toLocal());
                          final endStr = DateFormat('h:mm a').format(end.toLocal());
                          _dateTimeSubtitle = '$startStr - $endStr';
                        } else {
                          _dateTimeSubtitle = 'When is it happening';
                        }
                      } catch (_) {
                        _dateTimeSubtitle = 'When is it happening';
                      }
                    });
                  }
                },
              ),
              Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
              ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.phone_outlined,
                title: "Entrance requirement (optional)",
                subtitle: _entranceRequirementSubtitle,
                onTap: () async {
                  final result = await Navigator.pushNamed(context, AppRoutes.entranceRequirement);
                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      _isRequirePoints = result['isRequirePoints'] ?? false;
                      _attendEventPoint = result['attendEventPoint'] ?? 0;
                      if (_isRequirePoints && _attendEventPoint > 0) {
                        _entranceRequirementSubtitle = 'Entry points: $_attendEventPoint';
                      } else {
                        _entranceRequirementSubtitle = 'Activate entrance points';
                      }
                    });
                  }
                },
              ),
              Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
              ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.perm_media_outlined,
                title: "Other media",
                subtitle: _otherMediaSubtitle,
                onTap: () async {
                  final result = await Navigator.pushNamed(context, AppRoutes.otherMedia);
                  if (result != null && result is List<XFile>) {
                    setState(() {
                      _otherMediaFiles = result;
                      _otherImageUrls = [];
                      if (_otherMediaFiles.isNotEmpty) {
                        _otherMediaSubtitle = '${_otherMediaFiles.length} image${_otherMediaFiles.length > 1 ? 's' : ''}';
                      } else {
                        _otherMediaSubtitle = 'Add other images related to this event';
                      }
                    });
                  }
                },
              ),
              Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
              ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.person_add_alt_outlined,
                title: "Invite guests (optional)",
                subtitle: _inviteGuestsSubtitle,
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.inviteGuests,
                    arguments: _invitedUserIds,
                  );
                  if (result != null && result is List) {
                    setState(() {
                      _invitedUserIds = List<String>.from(result);
                      if (_invitedUserIds.isNotEmpty) {
                        _inviteGuestsSubtitle = '${_invitedUserIds.length} guest${_invitedUserIds.length > 1 ? 's' : ''}';
                      } else {
                        _inviteGuestsSubtitle = 'Who can attend this event';
                      }
                    });
                  }
                },
              ),
              Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: 20.h + MediaQuery.of(context).viewPadding.bottom,
          top: 10.h,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 40.h,
          child: CustomButton(
            text: "Create Event",
            onPressed: isFormComplete ? _createEvent : null,
            backgroundColor: isFormComplete
                ? const Color(0xffbbd953)
                : Colors.grey[400],
            textColor: Colors.black,
            isLoading: _isLoading,
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              fontFamily: 'Metropolis-Medium',
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClickableArea(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
     onTap: () {
      print("$title clicked"); // Debugging print statement
      onTap();
    },
    behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
                Icon(
                icon,
                size: 20.sp,
                color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xffbbd953).withOpacity(0.4)
                  : Colors.black.withOpacity(0.4),
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 15.sp,
                      fontFamily: 'Metropolis-Medium',
                      letterSpacing: 0,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Render subtitle as a single chip for Location and Date and Time, as multiple chips for others
                  (title == 'Guests' && subtitle != _inviteGuestsSubtitle)
                    ? Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: [
                          for (final part in subtitle.split(','))
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[800],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                part.trim(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  color: _subtitleTextColor(context),
                                ),
                              ),
                            ),
                        ],
                      )
                    : ((title == 'Location' && subtitle != 'Where is it happening?') ||
                        (title == 'Date and Time' && subtitle != 'When is it happening') ||
                        (title == 'Category' && subtitle != 'Choose event category') ||
                        (title == 'Other media' && subtitle != 'Add other images related to this event') ||
                        (title == 'Invite guests (optional)' && subtitle != 'Who can attend this event') ||
                        (title == 'Entrance requirement (optional)' && subtitle != 'Activate entrance points'))
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[800],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              subtitle,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12.sp,
                                color: _subtitleTextColor(context),
                              ),
                            ),
                          )
                        : Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                ],
              ),
            ],
          ),
          Icon(
            Icons.navigate_next,
            size: 24,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Color _subtitleTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white.withOpacity(0.95) : Colors.grey[700]!;
  }
}

class _ConfettiSuccessModal extends StatefulWidget {
  final String eventTitle;
  final VoidCallback onProfileTap;
  const _ConfettiSuccessModal({required this.eventTitle, required this.onProfileTap});

  @override
  State<_ConfettiSuccessModal> createState() => _ConfettiSuccessModalState();
}

class _ConfettiSuccessModalState extends State<_ConfettiSuccessModal> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double modalHeight = MediaQuery.of(context).size.height * 0.75;
    return SizedBox(
      height: modalHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: 0.08,
            numberOfParticles: 30,
            maxBlastForce: 20,
            minBlastForce: 8,
            gravity: 0.2,
            colors: const [
              Color(0xffbbd953),
              Colors.pink,
              Colors.blue,
              Colors.orange,
              Colors.purple,
            ],
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "You're all set!",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith( 
                      fontSize: 16.sp,
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'Metropolis-SemiBold',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: 12),
                  Text(
                    'Congratulations, you have created an event\n titled ${widget.eventTitle}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 10.sp,
                      fontFamily: 'Metropolis-Regular',
                      color: Colors.black.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Share to',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.facebook, color: Color(0xFF4267B2), size: 28),
                            SizedBox(width: 16.w),
                            Icon(Icons.alternate_email, color: Colors.black, size: 28), // X (Twitter) placeholder
                            SizedBox(width: 16.w),
                            Icon(Icons.camera_alt, color: Color(0xFFE1306C), size: 28), // Instagram placeholder
                            SizedBox(width: 16.w),
                            Icon(
                              Icons.chat_bubble, // Placeholder for WhatsApp
                              color: Color(0xFF25D366),
                              size: 28,
                            ),
                            SizedBox(width: 16.w),
                            Icon(Icons.send, color: Color(0xFF0088cc), size: 28), // Telegram placeholder
                          ],
                        ),
                        SizedBox(height: 18),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          'or share link',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'https://kliks.app/event/12345',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12.h,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  // Copy to clipboard logic
                                  // Clipboard.setData(ClipboardData(text: 'https://kliks.app/event/12345'));
                                },
                                child: Icon(Icons.copy, size: 18, color: Colors.black.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomButton(
                    text: 'View my profile',
                    onPressed: widget.onProfileTap,
                    backgroundColor: const Color(0xffbbd953),
                    textColor: Colors.black,
                    textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14.h,
                      fontFamily: 'Metropolis-SemiBold',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
