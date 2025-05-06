import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final String text;
  final String imagePath; 
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
        elevation: 0, 
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
        foregroundColor: Colors.black, 
        side: const BorderSide(width: 1, color: Color(0xFF3B3B3B)), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), 
        ),
        minimumSize: const Size(double.infinity, 60), 
        
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 24, 
            width: 24,  
          ),
          const SizedBox(width: 10), 
          Flexible(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16, 
                
                color: Theme.of(context).primaryColor, 
              ),
              overflow: TextOverflow.ellipsis, 
            ),
          ),
        ],
      ),
    );
  }
}