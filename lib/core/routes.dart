import 'package:flutter/material.dart';
import 'package:kliks/features/main_app/main_app_page.dart';
import 'package:kliks/features/onboarding/auth/email_verification_page.dart';
import 'package:kliks/features/onboarding/auth/login_page.dart';
import 'package:kliks/features/onboarding/auth/signup_page.dart';
import 'package:kliks/features/onboarding/onboarding_page.dart';
import 'package:kliks/features/onboarding/profile_setup_page.dart';
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
import 'package:kliks/features/main_app/profile/settings/blocked_accounts.dart';
import 'package:kliks/features/main_app/profile/settings/contact_support.dart';
import 'package:kliks/features/main_app/profile/settings/about_kliks.dart';
import 'package:kliks/features/main_app/profile/settings/user_information/user_information.dart';
import 'package:kliks/features/main_app/profile/settings/user_information/update_email.dart';
import 'package:kliks/features/main_app/profile/settings/user_information/update_dob.dart';
import 'package:kliks/features/main_app/profile/settings/update_location.dart';
import 'package:kliks/features/main_app/profile/settings/user_information/update_password.dart';
import 'package:kliks/features/main_app/profile/requests/follow_requests.dart';
import 'package:kliks/features/main_app/profile/people.dart';
import 'package:kliks/features/main_app/profile/settings/verification/selfie_verification.dart';
import 'package:kliks/features/main_app/search/search_page.dart';
import 'package:kliks/features/main_app/profile/user_profile_page.dart';
import 'package:kliks/features/main_app/events/event_detail_page.dart';
import 'package:kliks/features/main_app/events/organizer_event_detail_page.dart';
import 'package:kliks/features/main_app/events/invite_guests/organizer_invite_guests_page.dart';
import 'package:kliks/features/main_app/announcements/announcement_page.dart';
import 'package:kliks/features/main_app/announcements/announcement_location_page.dart';
import 'package:kliks/features/main_app/profile/settings/my_location_page.dart';
import 'package:kliks/features/main_app/events/location/event_locator_page.dart';
import 'package:kliks/features/main_app/search/search_filter_page.dart';
import 'package:kliks/features/main_app/wallet/transaction_filter_page.dart';

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
  static const String blockedAccounts = '/blocked-accounts';
  static const String contactSupport = '/contact-support';
  static const String aboutKliks = '/about-kliks';
  static const String userInformation = '/user-information';
  static const String updateEmail = '/update-email';
  static const String updateDob = '/update-dob';
  static const String updateLocation = '/update-location';
  static const String updatePassword = '/update-password';
  static const String followRequests = '/follow-requests';
  static const String people = '/people';
  static const String selfieVerification = '/selfie-verification';
  static const String search = '/search';
  static const String userProfile = '/user-profile';
  static const String eventDetail = '/event-detail';
  static const String organizerEventDetail = '/organizer-event-detail';
  static const String profileSetup = '/profile-setup';
  static const String organizerInviteGuests = '/organizer-invite-guests';
  static const String announcement = '/announcement';
  static const String announcementLocation = '/announcement-location';
  static const String myLocation = '/my-location';
  static const String eventLocator = '/event-locator';
  static const String searchFilter = '/search-filter';
  static const String transactionFilter = '/transaction-filter';

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
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MainAppPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
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
      case blockedAccounts:
        return MaterialPageRoute(builder: (_) => const BlockedAccountsPage());
      case contactSupport:
        return MaterialPageRoute(builder: (_) => const ContactSupportPage());
      case aboutKliks:
        return MaterialPageRoute(builder: (_) => const AboutKliksPage());
      case userInformation:
        return MaterialPageRoute(builder: (_) => const UserInformationPage());
      case updateEmail:
        return MaterialPageRoute(builder: (_) => const UpdateEmailPage());
      case updateDob:
        return MaterialPageRoute(builder: (_) => const UpdateDobPage());
      case updateLocation:
        return MaterialPageRoute(builder: (_) => const UpdateLocationPage());
      case updatePassword:
        return MaterialPageRoute(builder: (_) => const UpdatePasswordPage());
      case followRequests:
        return MaterialPageRoute(builder: (_) => const FollowRequestsPage());
      case people:
        return MaterialPageRoute(builder: (_) => const PeoplePage());
      case selfieVerification:
        return MaterialPageRoute(builder: (_) => const SelfieVerificationPage());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case userProfile:
        return MaterialPageRoute(builder: (_) => UserProfilePage(userData: settings.arguments as Map<String, dynamic>));
      case eventDetail:
        return MaterialPageRoute(builder: (_) => EventDetailPage(eventId: settings.arguments as String));
      case organizerEventDetail:
        return MaterialPageRoute(builder: (_) => OrganizerEventDetailPage(eventId: settings.arguments as String));
      case profileSetup:
        return MaterialPageRoute(builder: (_) => const ProfileSetupPage());
      case organizerInviteGuests:
        return MaterialPageRoute(
          builder: (_) => const OrganizerInviteGuestsPage(),
          settings: settings,
        );
      case announcement:
        return MaterialPageRoute(builder: (_) => AnnouncementPage(eventId: settings.arguments as String));
      case announcementLocation:
        return MaterialPageRoute(builder: (_) => const AnnouncementLocationPage());
      case myLocation:
        return MaterialPageRoute(builder: (_) => const MyLocationPage());
      case eventLocator:
        return MaterialPageRoute(builder: (_) => const EventLocatorPage());
      case searchFilter:
        return MaterialPageRoute(builder: (_) => const SearchFilterPage());
      case transactionFilter:
        return MaterialPageRoute(builder: (_) => const TransactionFilterPage());
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