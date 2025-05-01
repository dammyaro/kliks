import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  final bool isGuest;

  const MainAppBar({super.key, this.isGuest = false}); // Default isGuest to false

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10), // Add vertical padding
      color: Theme.of(context).scaffoldBackgroundColor, // Match the theme's background
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), // Add horizontal padding
        child: Row(
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0), // Reduce vertical padding inside the text box
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[200]
                      : Colors.grey[800], // Background color based on theme
                  borderRadius: BorderRadius.circular(30), // Rounded corners
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
                  textAlignVertical: TextAlignVertical.center, // Center text vertically
                ),
              ),
            ),

            // Right: Avatar Image (Only show if not a guest)
            if (!isGuest)
              Image.asset(
                'assets/icons/avatar.png',
                height: 50, // Adjust image height
                width: 50, // Adjust image width
              ),
          ],
        ),
      ),
    );
  }
}
