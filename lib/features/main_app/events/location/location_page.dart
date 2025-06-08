import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:flutter/cupertino.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _sheetOpen = false;

  // Mocked sample location data
  String _selectedLocation = '';
  double? _selectedLat;
  double? _selectedLng;

  final List<Map<String, dynamic>> _mockLocations = [
    {
      'name': 'Central Park, New York',
      'lat': 40.785091,
      'lng': -73.968285,
    },
    {
      'name': 'Golden Gate Park, San Francisco',
      'lat': 37.76904,
      'lng': -122.483519,
    },
    {
      'name': 'Hyde Park, London',
      'lat': 51.507268,
      'lng': -0.16573,
    },
    {
      'name': 'Ueno Park, Tokyo',
      'lat': 35.715298,
      'lng': 139.773037,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLocationSheet();
    });
  }

  void _showLocationSheet() async {
    if (_sheetOpen) return;
    setState(() => _sheetOpen = true);
    final theme = Theme.of(context);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        final double sheetHeight = MediaQuery.of(context).size.height * 0.65;
        return SizedBox(
          height: sheetHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HandleBar(),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? Colors.grey[200]
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      Icon(CupertinoIcons.search, color: Colors.grey, size: 22.sp),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          enabled: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Where are Klikers?',
                            hintStyle: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  SizedBox(width: 24.w),
                  Icon(Icons.history, color: Colors.grey, size: 22.sp),
                  SizedBox(width: 10.w),
                  Text('Recently searched',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              // Mocked location selection
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Locations',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 120.h,
                      child: ListView.builder(
                        itemCount: _mockLocations.length,
                        itemBuilder: (context, index) {
                          final loc = _mockLocations[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              loc['name'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 13.sp,
                                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.85),
                              ),
                            ),
                            subtitle: Text(
                              'Lat: ${loc['lat']}, Lng: ${loc['lng']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedLocation = loc['name'];
                                  _selectedLat = loc['lat'];
                                  _selectedLng = loc['lng'];
                                });
                                Navigator.of(context).pop();
                                Navigator.of(this.context).pop({
                                  'location': loc['name'],
                                  'lat': loc['lat'],
                                  'lng': loc['lng'],
                                });
                              },
                              child: Text('Select', style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (_selectedLocation.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Text(
                    'Selected: $_selectedLocation (Lat: $_selectedLat, Lng: $_selectedLng)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
    setState(() {
      _sheetOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map placeholder
          Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: double.infinity,
            child: const Center(child: Text('Map goes here', style: TextStyle(fontSize: 20))),
          ),
          if (!_sheetOpen)
            Positioned(
              top: 52.h,
              right: 16.w,
              child: GestureDetector(
                onTap: _showLocationSheet,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    CupertinoIcons.search,
                    size: 24.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          if (!_sheetOpen)
            Positioned(
              top: 52.h,
              left: 16.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_back,
                    size: 24.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}