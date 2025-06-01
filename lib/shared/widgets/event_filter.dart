import 'package:flutter/material.dart';

class EventFilter extends StatefulWidget {
  const EventFilter({super.key});

  @override
  State<EventFilter> createState() => _EventFilterState();
}

class _EventFilterState extends State<EventFilter> {
  bool isNearbySelected = false; 
  bool isFollowingSelected = false; 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), 
      color: Theme.of(context).scaffoldBackgroundColor, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, 
        children: [
          
          GestureDetector(
            onTap: () {
              setState(() {
          isNearbySelected = !isNearbySelected; 
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
              decoration: BoxDecoration(
          color: isNearbySelected  ? Theme.of(context).primaryColor // Selected color (adapts to theme)
            : Theme.of(context).brightness == Brightness.light 
              ? Colors.grey[400] 
              : Colors.grey[700], // Unselected
          borderRadius: BorderRadius.circular(10), 
              ),
              child: Text(
          'Nearby Events',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
            color: isNearbySelected ? Theme.of(context).scaffoldBackgroundColor// Text color when selected
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.7), // Unselected
          ),
              ),
            ),
          ),

          
          const SizedBox(width: 15), 

          
          GestureDetector(
            onTap: () {
              setState(() {
          isFollowingSelected = !isFollowingSelected; 
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
              decoration: BoxDecoration(
          color: isFollowingSelected ? Theme.of(context).primaryColor // Selected color (adapts to theme)
          : Theme.of(context).brightness == Brightness.light 
              ? Colors.grey[400] 
              : Colors.grey[700], // Unselected
          borderRadius: BorderRadius.circular(10), 
              ),
              child: Text(
          'Following',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
            color: isFollowingSelected ? Theme.of(context).scaffoldBackgroundColor// Text color when selected
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.7), // Unselected
          ),
              ),
            ),
          ),

          
          const SizedBox(width: 15), 

          
          // GestureDetector(
          //   onTap: () {
              
          //     print('Filter icon clicked');
          //   },
          //   child: Container(
          //     padding: const EdgeInsets.all(10), 
          //     decoration: BoxDecoration(
          // color: Colors.grey[700], 
          // borderRadius: BorderRadius.circular(10), 
          //     ),
          //       child: Image.asset(
          //     'assets/icons/setting-4.png',
          //     width: 14,
          //     height: 14,
          //     ),
          //   ),
          // ),
        ],
        
      ),
    );
  }
}