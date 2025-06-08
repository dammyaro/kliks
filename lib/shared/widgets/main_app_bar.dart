import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';
import 'package:kliks/shared/widgets/profile_picture.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MainAppBar extends StatefulWidget {
  final bool isGuest;
  

  const MainAppBar({super.key, this.isGuest = false});

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  String _locationText = 'Ontario, Canada';
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      // LocationPermission permission = await Geolocator.checkPermission();
      // if (permission == LocationPermission.denied) {
      //   permission = await Geolocator.requestPermission();
      // }
      // if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      //   setState(() {
      //     _locationText = 'Location permission denied';
      //     _isLoadingLocation = false;
      //   });
      //   return;
      // }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _locationText = '${place.locality ?? ''}, ${place.country ?? ''}'.trim().replaceAll(RegExp(r'^,|,$'), '');
        });
      } else {
        setState(() {
          _locationText = 'Location not found';
        });
      }
    } catch (e) {
      setState(() {
        _locationText = 'Location error';
      });
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<AuthProvider>(context).profile;
    final profilePictureFileName = profile?['image'];
    final userId = profile?['id'] ?? '';
    // final fullName = profile?['fullname'] ?? 'Kliks User';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? 'assets/k-logo-white.png'
                  : 'assets/k-logo.png',
              height: 30,
            ),

            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name != '/search') {
                    Navigator.pushNamed(context, '/search');
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[200]
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_outlined, color: Colors.grey),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _isLoadingLocation ? 'Getting location...' : _locationText,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12.sp,
                                letterSpacing: 0,
                                fontFamily: 'Metropolis-Medium',
                                color: Colors.grey[500],
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (!widget.isGuest)
              GestureDetector(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  child: ProfilePicture(
                    fileName: profilePictureFileName,
                    userId: userId,
                    size: 50,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
          ],
        ),
      ),
    );
  }
}
