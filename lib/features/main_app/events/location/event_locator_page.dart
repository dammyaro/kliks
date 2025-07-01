import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/core/models/event.dart';
import 'package:kliks/core/providers/event_provider.dart';
import 'package:kliks/shared/widgets/handle_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class EventLocatorPage extends StatefulWidget {
  const EventLocatorPage({super.key});

  @override
  State<EventLocatorPage> createState() => _EventLocatorPageState();
}

class _EventLocatorPageState extends State<EventLocatorPage> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  Timer? _debounce;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  bool _isLoadingLocation = true;

  LatLng _currentCenter = const LatLng(51.509364, -0.128928); // Default to London
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndSetInitialView();
    _fetchEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchEvents() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final events = await eventProvider.getEvents();
    setState(() {
      _markers.clear();
      for (var eventData in events) {
        final event = Event.fromJson(eventData);
        if (event.lat != null && event.lng != null) {
          _markers.add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(event.lat!, event.lng!),
              child: _EventMarker(
                imageUrl: event.bannerImageUrl,
              ),
            ),
          );
        }
      }
    });
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
                        hintText: 'Where are Klikers?',
                        hintStyle: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontFamily: 'Metropolis-Medium'
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
                                  leading: Icon(Icons.location_on_outlined, size: 30.sp),
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
            ],
          );
  }
}

class _EventMarker extends StatelessWidget {
  final String imageUrl;

  const _EventMarker({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}