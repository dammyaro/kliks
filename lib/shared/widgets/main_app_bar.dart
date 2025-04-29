import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Remove the default back button
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Match the theme's background
      elevation: 0, // Remove shadow
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          // Left: Logo
          Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? 'assets/k-logo-white.png'
                : 'assets/k-logo.png',
            height: 30, // Adjust logo height
          ),

          // Middle: Search Bar
            Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10), // Add horizontal margin
              padding: const EdgeInsets.symmetric(horizontal: 10), // Add padding inside the text box
              decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[200]
                : Colors.grey[800], // Background color based on theme
              borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none, // Remove border
                hintText: 'Ontario, Canada', // Placeholder text
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey, // Placeholder text color
                  ),
                icon: const Icon(
                Icons.search_outlined,
                color: Colors.grey, // Icon color
                ),
              ),
              style: Theme.of(context).textTheme.bodySmall, // Text style
              ),
            ),
            ),

          // Right: Avatar Icon
          const Icon(
            Icons.account_circle_outlined,
            size: 50, // Adjust icon size
            color: Colors.grey, // Icon color
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56); // Standard AppBar height
}