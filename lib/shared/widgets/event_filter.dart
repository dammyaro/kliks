import 'package:flutter/material.dart';

class EventFilter extends StatefulWidget {
  const EventFilter({super.key});

  @override
  State<EventFilter> createState() => _EventFilterState();
}

class _EventFilterState extends State<EventFilter> {
  bool isNearbySelected = false; // Track if "Nearby Events" is selected
  bool isFollowingSelected = false; // Track if "Following" is selected

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), // Add vertical padding
      color: Theme.of(context).scaffoldBackgroundColor, // Match the theme's background
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the start
        children: [
          // "Nearby Events" Button
          GestureDetector(
            onTap: () {
              setState(() {
          isNearbySelected = !isNearbySelected; // Toggle selection
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add padding inside the button
              decoration: BoxDecoration(
          color: isNearbySelected ? Colors.white : Colors.grey[700], // Background color
          borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Text(
          'Nearby Events',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isNearbySelected ? Colors.black : Colors.grey[500], // Adjust text color
          ),
              ),
            ),
          ),

          // Space between buttons
          const SizedBox(width: 15), // Increased space between buttons

          // "Following" Button
          GestureDetector(
            onTap: () {
              setState(() {
          isFollowingSelected = !isFollowingSelected; // Toggle selection
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add padding inside the button
              decoration: BoxDecoration(
          color: isFollowingSelected ? Colors.white : Colors.grey[700], // Background color
          borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Text(
          'Following',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isFollowingSelected ? Colors.black : Colors.grey[500], // Adjust text color
          ),
              ),
            ),
          ),

          // Space between buttons
          const SizedBox(width: 15), // Increased space between buttons

          // Icon Button with Background
          GestureDetector(
            onTap: () {
              // Handle icon button click
              print('Filter icon clicked');
            },
            child: Container(
              padding: const EdgeInsets.all(10), // Add padding around the icon
              decoration: BoxDecoration(
          color: Colors.grey[700], // Background color (unselected version)
          borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
                child: Image.asset(
              'assets/icons/setting-4.png',
              width: 14,
              height: 14,
              ),
            ),
          ),
        ],
        
      ),
    );
  }
}