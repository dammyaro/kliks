import 'package:flutter/material.dart';

class EventFilter extends StatefulWidget {
  const EventFilter({super.key});

  @override
  State<EventFilter> createState() => _EventFilterState();
}

class _EventFilterState extends State<EventFilter> {
  bool isNearbySelected = true; // Track if "Near by Events" is selected
  bool isFollowingSelected = false; // Track if "Following" is selected

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Add padding
      color: Theme.of(context).scaffoldBackgroundColor, // Match the theme's background
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
        children: [
          // "Near by Events" Button
          GestureDetector(
            onTap: () {
              setState(() {
                isNearbySelected = !isNearbySelected;
              });
            },
            child: Row(
              children: [
                Icon(
                  Icons.filter_alt_outlined,
                  color: isNearbySelected ? Theme.of(context).primaryColor : Colors.grey,
                ),
                const SizedBox(width: 5), // Spacing between icon and text
                Text(
                  'Near by Events',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isNearbySelected ? FontWeight.bold : FontWeight.normal,
                    color: isNearbySelected ? Theme.of(context).primaryColor : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // "Following" Button
          GestureDetector(
            onTap: () {
              setState(() {
                isFollowingSelected = !isFollowingSelected;
              });
            },
            child: Row(
              children: [
                Icon(
                  Icons.filter_alt_outlined,
                  color: isFollowingSelected ? Theme.of(context).primaryColor : Colors.grey,
                ),
                const SizedBox(width: 5), // Spacing between icon and text
                Text(
                  'Following',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isFollowingSelected ? FontWeight.bold : FontWeight.normal,
                    color: isFollowingSelected ? Theme.of(context).primaryColor : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}