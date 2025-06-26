import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MyLocationPage extends StatefulWidget {
  const MyLocationPage({super.key});

  @override
  State<MyLocationPage> createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  Timer? _debounce;
  Timer? _reverseGeocodeDebounce;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  bool _isLoadingLocation = true;

  LatLng _currentCenter = const LatLng(51.509364, -0.128928); // Default to London
  final List<Marker> _markers = [];
  Map<String, dynamic>? _selectedLocationData;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndSetInitialView();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    _debounce?.cancel();
    _reverseGeocodeDebounce?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocationAndSetInitialView() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _isLoadingLocation = false;
          });
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _currentCenter = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _onSearchChanged(StateSetter sheetSetState) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _searchLocations(_searchController.text, sheetSetState);
      } else {
        sheetSetState(() {
          _searchResults = [];
        });
      }
    });
  }

  void _searchLocations(String query, StateSetter sheetSetState) async {
    sheetSetState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=jsonv2');
      final response = await http.get(url, headers: {
        'User-Agent': 'com.example.kliks',
      });

      if (response.statusCode == 200 && mounted) {
        sheetSetState(() {
          _searchResults =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        sheetSetState(() => _searchResults = []);
      }
    } catch (e) {
      sheetSetState(() => _searchResults = []);
    } finally {
      if (mounted) {
        sheetSetState(() => _isLoading = false);
      }
    }
  }

  void _handleMapTap(TapPosition tapPosition, LatLng latlng) {
    if (_reverseGeocodeDebounce?.isActive ?? false) {
      _reverseGeocodeDebounce!.cancel();
    }
    // Clear previous search results if any
    _searchController.clear();
    _searchResults = [];

    // Update marker on map immediately
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          width: 150.0,
          height: 150.0,
          point: latlng,
          child: _CustomMapMarker(),
        ),
      );
      // Show temporary loading state
      _selectedLocationData = {
        'location': 'Loading address...',
        'lat': latlng.latitude,
        'lng': latlng.longitude,
      };
    });

    _reverseGeocodeDebounce = Timer(const Duration(milliseconds: 500), () {
      _reverseGeocode(latlng);
    });
  }

  void _reverseGeocode(LatLng latlng) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${latlng.latitude}&lon=${latlng.longitude}');
      final response = await http.get(url, headers: {
        'User-Agent': 'com.example.kliks',
      });

      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        final displayName = data['display_name'] ?? 'Unknown location';
        setState(() {
          _selectedLocationData = {
            'location': displayName,
            'lat': latlng.latitude,
            'lng': latlng.longitude,
          };
        });
      } else {
        if (mounted) {
          setState(() {
            _selectedLocationData?['location'] = 'Could not find address';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _selectedLocationData?['location'] = 'Could not find address';
        });
      }
    }
  }

  void _showLocationSheet() {
    _searchController.clear();
    _searchResults = [];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter sheetSetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  const HandleBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => _onSearchChanged(sheetSetState),
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(CupertinoIcons.search,
                            color: Colors.grey, size: 20.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: theme.brightness == Brightness.light
                            ? Colors.grey[200]
                            : Colors.grey[800],
                        hintText: 'Search for a location',
                        hintStyle: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11.sp,
                        ),
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.separated(
                            itemCount: _searchResults.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: theme.dividerColor.withOpacity(0.2),
                              indent: 20.w,
                              endIndent: 20.w,
                            ),
                            itemBuilder: (context, index) {
                              final loc = _searchResults[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    loc['display_name'] ?? 'Unknown',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 13.sp,
                                      color: theme.textTheme.bodyLarge?.color?.withOpacity(0.85),
                                    ),
                                  ),
                                  onTap: () {
                                    final lat = double.tryParse(loc['lat'] ?? '');
                                    final lon = double.tryParse(loc['lon'] ?? '');

                                    if (lat != null && lon != null) {
                                      final newCenter = LatLng(lat, lon);
                                      _mapController.move(newCenter, 15.0);

                                      setState(() {
                                        _markers.clear();
                                        _markers.add(
                                          Marker(
                                            width: 150.0,
                                            height: 150.0,
                                            point: newCenter,
                                            child: _CustomMapMarker(),
                                          ),
                                        );
                                        _selectedLocationData = {
                                          'location': loc['display_name'],
                                          'lat': lat,
                                          'lng': lon,
                                        };
                                      });

                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _isLoadingLocation
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentCenter,
                  initialZoom: 16.0,
                  onTap: _handleMapTap,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.kliks',
                  ),
                  MarkerLayer(markers: _markers),
                ],
              ),
              Positioned(
                top: 60.h,
                left: 20.w,
                right: 20.w,
                child: Row(
                  children: [
                    Material(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12.r),
                      elevation: 2.0,
                      shadowColor: Colors.black.withOpacity(0.1),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showLocationSheet,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.map,
                                  color: Colors.grey, size: 22.sp),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  _selectedLocationData?['location'] ??
                                      'Search for a location',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 12.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_selectedLocationData != null)
                Positioned(
                  bottom: 30.h,
                  left: 20.w,
                  right: 20.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(_selectedLocationData);
                    },
                    child: Text(
                      'Confirm Location',
                      style: TextStyle(
                        color: const Color(0xff000000),
                        fontSize: 16,
                        fontFamily: 'Metropolis-SemiBold',
                      ),
                    ),
                  ),
                ),
            ],
          );
  }
}

class _CustomMapMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xffa0a788).withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xffa0a788),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.transparent, width: 2),
            ),
            alignment: Alignment.center,
            child: const Icon(
              CupertinoIcons.location_solid,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
} 