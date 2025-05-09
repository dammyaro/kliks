import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/core/routes.dart';

class NewEventPage extends StatelessWidget {
  const NewEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with back button and title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "New Event",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Metropolis-ExtraBold',
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder for alignment
                ],
              ),
              SizedBox(height: 20.h),

              // Cover image button
              ElevatedButton.icon(
                onPressed: () {
                  // Add your logic here
                },
                icon: Icon(Icons.add, color: Colors.black),
                label: Text(
                  "Cover Image (800x600)",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  textStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
                  backgroundColor: const Color(0xffbbd953).withOpacity(1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Reduced border radius
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Event name text field
              TextFormWidget(
                name: 'event_name',
                controller: TextEditingController(),
                labelText: 'Enter event name',
              ),
              SizedBox(height: 20.h),

              // Event description text area
              TextFormWidget(
                name: 'event_description',
                controller: TextEditingController(),
                labelText: 'Event description',
                keyboardType: TextInputType.multiline,
                multiline: true,
              ),
              SizedBox(height: 20.h),

              // List of clickable areas
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.people_outlined,
                title: "Guests",
                subtitle: "Who can attend this event",
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.guests);
                  // print("Guests clicked");
                },
              ),
                Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
                ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.settings_outlined,
                title: "Category",
                subtitle: "Choose event category",
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.category);
                },
              ),

               Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
                ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.location_on_outlined,
                title: "Location",
                subtitle: "Where is it happening",
                onTap: () {
                 Navigator.pushReplacementNamed(context, AppRoutes.location);
                },
              ),

               Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
                ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.date_range_outlined,
                title: "Date and Time",
                subtitle: "When is it happening",
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.dateTime);
                },
              ),
               Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
                ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.phone_outlined,
                title: "Entrance requirement (optional)",
                subtitle: "Activate entrance points",
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.entranceRequirement);
                },
              ),
               Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
                ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.perm_media_outlined,
                title: "Other media",
                subtitle: "Add other images related to this event",
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.otherMedia);
                },
              ),
               Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
                ),
              SizedBox(height: 10.h),
              _buildClickableArea(
                context,
                icon: Icons.person_add_alt_outlined,
                title: "Invite guests (optional)",
                subtitle: "Add guests to this event",
                onTap: () {
                 Navigator.pushReplacementNamed(context, AppRoutes.inviteGuests);
                },
              ),
               Opacity(
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.1,
                child: Divider(height: 15.h),
                ),
              SizedBox(height: 30.h),

              // Create event button
              CustomButton(
                text: "Create Event",
                onPressed: () {
                  // Add your logic here
                },
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[700]
                  : Colors.grey[200],
                textColor: Colors.white,
                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  fontFamily: 'Metropolis-SemiBold',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClickableArea(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
     onTap: () {
      print("$title clicked"); // Debugging print statement
      onTap();
    },
    behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
                Icon(
                icon,
                size: 20.sp,
                color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xffbbd953).withOpacity(0.4)
                  : Colors.black.withOpacity(0.4),
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16.sp,
                      fontFamily: 'Metropolis-SemiBold',
                      letterSpacing: -1,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.color?.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(
            Icons.navigate_next,
            size: 24,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
