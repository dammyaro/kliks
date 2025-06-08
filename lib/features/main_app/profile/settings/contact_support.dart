import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/custom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final List<Map<String, String>> faqs = [
    {
      'main': 'How do i create an event in Kliks',
      'sub':
          'To create an event, log in to your account, go to the "Events" section, and click on "Create Event." Fill in the required details such as event name, date, time, and location.',
    },
    {
      'main': 'Can i sell tickets for my events through Kliks?',
      'sub':
          'To create an event, log in to your account, go to the "Events" section, and click on "Create Event." Fill in the required details such as event name, date, time, and location.',
    },
    {
      'main': 'How can I invite participants to my event?',
      'sub':
          'To create an event, log in to your account, go to the "Events" section, and click on "Create Event." Fill in the required details such as event name, date, time, and location.',
    },
    {
      'main': 'Is my data secure with Kliks?',
      'sub':
          'To create an event, log in to your account, go to the "Events" section, and click on "Create Event." Fill in the required details such as event name, date, time, and location.',
    },
    {
      'main': 'How can i get help if i encounter issues with Kliks?',
      'sub':
          'To create an event, log in to your account, go to the "Events" section, and click on "Create Event." Fill in the required details such as event name, date, time, and location.',
    },
  ];

  final List<bool> _faqOpen = List.generate(5, (_) => false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget supportTile({
      required IconData icon,
      required String label,
      required String value,
      VoidCallback? onTap,
    }) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 0.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(icon, color: theme.iconTheme.color?.withOpacity(0.7), size: 22.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        fontFamily: 'Metropolis-Regular',
                        color: theme.hintColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15.sp,
                        fontFamily: 'Metropolis-SemiBold',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget faqTile(int index, String main, String sub) {
      return Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _faqOpen[index] = !_faqOpen[index];
              });
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
              
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      main,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15.sp,
                        fontFamily: 'Metropolis-SemiBold',
                      ),
                    ),
                  ),
                  Icon(
                    _faqOpen[index]
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: theme.iconTheme.color?.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
          if (_faqOpen[index])
            Padding(
              padding: EdgeInsets.only(left: 0.w, right: 16.w, bottom: 16.h),
              child: Text(
                sub,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13.sp,
                  color: theme.hintColor,
                ),
              ),
            ),
          Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
        ],
      );
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNavBar(title: 'Contact support'),
              // SizedBox(height: 5.h),
              Text(
                'You can get in touch with us through the platforms below. Our team will reach out to you as soon as possible',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 14.sp,
                  color: theme.hintColor,
                ),
              ),
              SizedBox(height: 28.h),
              Text(
                'Support',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13.sp,
                  fontFamily: 'Metropolis-SemiBold',
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              SizedBox(height: 10.h),
              supportTile(
                icon: Icons.email_outlined,
                label: 'Email address',
                value: 'info@kliks.app',
                onTap: () async {
                  final uri = Uri(
                    scheme: 'mailto',
                    path: 'info@kliks.app',
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
              supportTile(
                icon: Icons.call_outlined,
                label: 'Phone number',
                value: '+14378602511',
                onTap: () async {
                  final uri = Uri(
                    scheme: 'tel',
                    path: '+14378602511',
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
              SizedBox(height: 28.h),
              Text(
                'Social media',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13.sp,
                  fontFamily: 'Metropolis-SemiBold',
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              SizedBox(height: 10.h),
              supportTile(
                icon: FontAwesomeIcons.linkedin,
                label: 'Linkedin',
                value: 'Kliks',
                onTap: () async {
                  final url = Uri.parse('https://linkedin.com/company/kliks');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              supportTile(
                icon: FontAwesomeIcons.instagram,
                label: 'Instagram',
                value: '@kliks.ca',
                onTap: () async {
                  final url = Uri.parse('https://instagram.com/kliks.ca');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              supportTile(
                icon: FontAwesomeIcons.facebook,
                label: 'Facebook',
                value: 'Kliks',
                onTap: () async {
                  final url = Uri.parse('https://facebook.com/kliks');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              SizedBox(height: 28.h),
              Text(
                'Faqs',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13.sp,
                  fontFamily: 'Metropolis-SemiBold',
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              SizedBox(height: 10.h),
              ...List.generate(
                faqs.length,
                (i) => faqTile(i, faqs[i]['main']!, faqs[i]['sub']!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}