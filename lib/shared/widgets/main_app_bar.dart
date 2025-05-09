import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainAppBar extends StatelessWidget {
  final bool isGuest;

  const MainAppBar({super.key, this.isGuest = false}); 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10), 
      color: Theme.of(context).scaffoldBackgroundColor, 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? 'assets/k-logo-white.png'
                  : 'assets/k-logo.png',
              height: 30, 
            ),

            
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10), 
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0), 
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[200]
                      : Colors.grey[800], 
                  borderRadius: BorderRadius.circular(30), 
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none, 
                    hintText: 'Ontario, Canada', 
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                        ),
                    icon: const Icon(
                      Icons.search_outlined,
                      color: Colors.grey, 
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodySmall, 
                  textAlignVertical: TextAlignVertical.top, 
                ),
              ),
            ),

            
            if (!isGuest)
            GestureDetector(
              child: Image.asset(
                'assets/icons/avatar.png',
                height: 50, 
                width: 50, 
              ),
              onTap: () {
                Navigator.pushNamed(context, '/profile'); 
              },

            ),
          ],
        ),
      ),
    );
  }
}
