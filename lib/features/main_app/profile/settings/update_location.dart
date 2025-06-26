import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/core/routes.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

class UpdateLocationPage extends StatefulWidget {
  const UpdateLocationPage({super.key});

  @override
  State<UpdateLocationPage> createState() => _UpdateLocationPageState();
}

class _UpdateLocationPageState extends State<UpdateLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  String _location = 'Ontario, Canada';
  double? _lat;
  double? _lng;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set initial location, lat, lng from user profile if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = Provider.of<AuthProvider>(context, listen: false).profile;
      setState(() {
        _location = (profile != null && profile['location'] != null && profile['location'].toString().isNotEmpty)
            ? profile['location']
            : 'Ontario, Canada';
        _lat = profile != null && profile['lat'] != null ? (profile['lat'] as num?)?.toDouble() : null;
        _lng = profile != null && profile['lng'] != null ? (profile['lng'] as num?)?.toDouble() : null;
      });
      // Check if we received location data from My Location page
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          _location = args['location'] ?? _location;
          _lat = args['lat'] ?? _lat;
          _lng = args['lng'] ?? _lng;
        });
      }
    });
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = false;
      if (_lat != null && _lng != null && _location.isNotEmpty) {
        success = await authProvider.updateLocation(
          lat: _lat!,
          lng: _lng!,
          location: _location,
        );
      } else {
        // fallback: update only location if lat/lng not available
        success = await authProvider.updateProfile(field: 'location', value: _location);
      }

      setState(() {
        _isLoading = false;
      });

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                child: Text('Location updated successfully!'),
              ),
            ),
          );
          Navigator.pop(context, {'location': _location});
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                child: Text('Failed to update location. Please try again.'),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              child: Text('An error occurred. Please try again.'),
            ),
          ),
        );
      }
    }
  }

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
            // TextFormWidget(
            //   name: 'search_location',
            //   controller: _searchController,
            //   labelText: 'Location',
            //   prefixIcon: Icon(Icons.search_outlined, color: theme.iconTheme.color?.withOpacity(0.5)),
            //   onChanged: (val) {
            //     // Optionally handle search logic here
            //   },
            // ),
            // SizedBox(height: 28.h),
            Text(
              'Your Location',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13.sp,
                fontFamily: 'Metropolis-SemiBold',
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.pushNamed(context, AppRoutes.myLocation);
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _location = result['location'] ?? 'Ontario, Canada';
                    _lat = result['lat'];
                    _lng = result['lng'];
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: theme.iconTheme.color, size: 22.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _location,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          fontFamily: 'Metropolis-SemiBold',
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color, size: 16.sp),
                  ],
                ),
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Continue',
              onPressed: _updateProfile,
              isLoading: _isLoading,
              backgroundColor: const Color(0xffbdd953),
            ),
          ],
        ),
      ),
    );
  }
}