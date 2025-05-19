import 'package:flutter/material.dart';
import 'package:kliks/features/main_app/main_app_page.dart';
import 'package:kliks/features/onboarding/auth/email_verification_page.dart';
import 'package:kliks/features/onboarding/auth/login_page.dart';
import 'package:kliks/features/onboarding/auth/signup_page.dart';
import 'package:kliks/features/onboarding/onboarding_page.dart';
import 'package:kliks/features/onboarding/splash_screen.dart';
import 'package:kliks/features/guest_app/guest_app_page.dart';
import 'package:kliks/features/main_app/profile/profile_page.dart';
import 'package:kliks/features/main_app/events/new_event_page.dart';
import 'package:kliks/features/main_app/events/guests/guests_page.dart';
import 'package:kliks/features/main_app/events/invite_guests/invite_guests_page.dart';
import 'package:kliks/features/main_app/events/other_media/other_media_page.dart';
import 'package:kliks/features/main_app/events/location/location_page.dart';
import 'package:kliks/features/main_app/events/date_time/date_time_page.dart';
import 'package:kliks/features/main_app/events/entrance_requirement/entrance_requirement_page.dart';
import 'package:kliks/features/main_app/events/category/category_page.dart';
import 'package:kliks/features/main_app/profile/edit/edit_profile_page.dart';
import 'package:kliks/features/main_app/profile/edit/edit_bio_page.dart';
import 'package:kliks/features/main_app/profile/edit/edit_gender_page.dart';
import 'package:kliks/features/main_app/profile/edit/edit_name_page.dart';
import 'package:kliks/features/main_app/profile/edit/edit_username_page.dart';
import 'package:kliks/features/main_app/profile/settings/settings_page.dart';
import 'package:kliks/features/main_app/profile/settings/account_privacy.dart';
import 'package:kliks/features/main_app/profile/settings/notifications.dart';



class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String emailVerification = '/email-verification';
  static const String mainApp = '/main-app';
  static const String guestApp = '/guestApp';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String editBio = '/edit-bio';
  static const String editGender = '/edit-gender';
  static const String editName = '/edit-name';
  static const String editUsername = '/edit-username';
  static const String newEvent = '/new-event';
  static const String guests = '/guests';
  static const String inviteGuests = '/invite-guests';
  static const String otherMedia = '/other-media';
  static const String location = '/location';
  static const String dateTime = '/date-time';
  static const String entranceRequirement = '/entrance-requirement';
  static const String category = '/category';
  static const String profileSettings = '/settings';
  static const String accountPrivacy = '/account-privacy';
  static const String notifications = '/notifications';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case emailVerification:
        return MaterialPageRoute(builder: (_) => const EmailVerificationPage());
      case mainApp:
        return MaterialPageRoute(builder: (_) => const MainAppPage());
      case guestApp:
        return MaterialPageRoute(builder: (_) => const GuestAppPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());
      case profileSettings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case editBio:
        return MaterialPageRoute(builder: (_) => const EditBioPage());
      case editGender:
        return MaterialPageRoute(builder: (_) => const EditGenderPage());
      case editName:
        return MaterialPageRoute(builder: (_) => const EditNamePage());
      case editUsername:
        return MaterialPageRoute(builder: (_) => const EditUsernamePage());
      case newEvent:
        return MaterialPageRoute(builder: (_) => const NewEventPage());
      case guests:
        return MaterialPageRoute(builder: (_) => const GuestsPage());
      case inviteGuests:
        return MaterialPageRoute(builder: (_) => const InviteGuestsPage());
      case otherMedia:
        return MaterialPageRoute(builder: (_) => const OtherMediaPage());
      case location:
        return MaterialPageRoute(builder: (_) => const LocationPage());
      case dateTime:
        return MaterialPageRoute(builder: (_) => const DateTimePage());
      case entranceRequirement:
        return MaterialPageRoute(builder: (_) => const EntranceRequirementPage());
      case category:
        return MaterialPageRoute(builder: (_) => const CategoryPage());
      case accountPrivacy:
        return MaterialPageRoute(builder: (_) => const AccountPrivacyPage());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ));
    }
  }
}