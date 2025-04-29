import 'package:flutter/material.dart';
import 'package:kliks/shared/widgets/main_app_bar.dart';
import 'package:kliks/shared/widgets/event_filter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: MainAppBar(),
      body: Column(
        children: [
          SizedBox(height: 40.h), // Responsive spacing from the top
          EventFilter(),
          // const Center(
          //   child: Text('Home Page Content'),
          // ),
        ],

      ),
     
    );
  }
}