import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventFilter extends StatefulWidget {
  final Function(String) onFilterChanged;
  const EventFilter({super.key, required this.onFilterChanged});

  @override
  State<EventFilter> createState() => _EventFilterState();
}

class _EventFilterState extends State<EventFilter> {
  String selected = 'none';

  void select(String filter) {
    setState(() => selected = filter);
    widget.onFilterChanged(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), 
      color: Theme.of(context).scaffoldBackgroundColor, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, 
        children: [
          
          GestureDetector(
            onTap: () => select(selected == 'nearby' ? 'none' : 'nearby'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
              decoration: BoxDecoration(
          color: selected == 'nearby' ? const Color(0xffbbd953) : Colors.grey[700],
          borderRadius: BorderRadius.circular(30), 
              ),
              child: Text(
          'Nearby Events',
          style: TextStyle(
            fontSize: 10.sp,
            // 
            fontFamily: 'Metropolis-Medium',
            letterSpacing: 0,
            color: selected == 'nearby' ? Colors.black : Colors.white,
          ),
              ),
            ),
          ),

          
          const SizedBox(width: 15), 

          
          GestureDetector(
            onTap: () => select(selected == 'following' ? 'none' : 'following'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
              decoration: BoxDecoration(
          color: selected == 'following' ? const Color(0xffbbd953) : Colors.grey[700],
          borderRadius: BorderRadius.circular(30), 
              ),
              child: Text(
          'Following',
          style: TextStyle(
            fontSize: 10.sp,
            // fontWeight: FontWeight.bold,
            fontFamily: 'Metropolis-Medium',
            letterSpacing: 0,
            color: selected == 'following' ? Colors.black : Colors.white,
          ),
              ),
            ),
          ),

          
          const SizedBox(width: 15), 


          GestureDetector(
            onTap: () => select(selected == 'live' ? 'none' : 'live'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: selected == 'live' ? const Color(0xffbbd953) : Colors.grey[700],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Live',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'Metropolis-Medium',
                  letterSpacing: 0,
                  color: selected == 'live' ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),

          
          const SizedBox(width: 15), 

          
          // GestureDetector(
          //   onTap: () => select(selected == 'attending' ? 'none' : 'attending'),
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
          //     decoration: BoxDecoration(
          // color: selected == 'attending' ? Theme.of(context).primaryColor // Selected color (adapts to theme)
          // : Theme.of(context).brightness == Brightness.light 
          //     ? Colors.grey[400] 
          //     : Colors.grey[700], // Unselected
          // borderRadius: BorderRadius.circular(10), 
          //     ),
          //     child: Text(
          // 'Attending',
          // style: TextStyle(
          //   fontSize: 10.sp,
          //   fontWeight: FontWeight.bold,
          //   letterSpacing: 0,
          //   color: selected == 'attending' ? Theme.of(context).scaffoldBackgroundColor// Text color when selected
          //   : Theme.of(context).colorScheme.onSurface.withOpacity(0.7), // Unselected
          // ),
          //     ),
          //   ),
          // ),

          
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