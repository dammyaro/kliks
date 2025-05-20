import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_avatar/random_avatar.dart';

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[200]
                          : Colors.grey[800],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Ontario, Canada',

                    hintStyle: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      letterSpacing: 0,
                      fontFamily: 'Metropolis-Medium',
                      color: Colors.grey[500],
                    ),
                    icon: const Icon(Icons.search_outlined, color: Colors.grey),
                  ),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Metropolis-Medium',
                    letterSpacing: 0,
                    color: Colors.grey[500],
                  ),
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ),

            if (!isGuest)
              GestureDetector(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  child: RandomAvatar(
                  DateTime.now().toString(),
                  height: 50,
                  width: 50,
                  ),
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
