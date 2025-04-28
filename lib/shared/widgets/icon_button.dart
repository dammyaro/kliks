import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final String text;
  final String imagePath; // Path to the PNG image
  final VoidCallback onPressed;

  const IconButtonWidget({
    super.key,
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0, // Remove button elevation
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // White background for the button
        foregroundColor: Colors.black, // Black text color
        side: const BorderSide(width: 1, color: Color(0xFF3B3B3B)), // Border with width 1 and black color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        minimumSize: const Size(double.infinity, 50), // Full-width button
        
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ensure the Row takes up minimal space
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 24, // Set the height of the image
            width: 24,  // Set the width of the image
          ),
          const SizedBox(width: 10), // Add spacing between the image and text
          Flexible(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16, // Adjust font size as needed
                // fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor, // Black text color
              ),
              overflow: TextOverflow.ellipsis, // Handle text overflow
            ),
          ),
        ],
      ),
    );
  }
}