# Kliks - Flutter Social Event App

Kliks is a mobile application built with Flutter that allows users to discover, create, and share events. It's designed to be a social platform where users can connect with friends, see what events they are attending, and stay updated with real-time notifications.

## Features

- **Event Discovery:** Browse and search for events happening around you.
- **Event Creation:** Easily create and manage your own public or private events.
- **Social Feed:** See a feed of events that your friends are interested in or attending.
- **User Profiles:** Customize your profile, follow friends, and see their activity.
- **Real-time Notifications:** Get notified about event updates, friend requests, and more, powered by Firebase Cloud Messaging.
- **Event Check-in:** Check in to events to let your friends know you're there.
- **Saved Events:** Keep a list of events you're interested in.
- **Light & Dark Mode:** The app supports both light and dark themes.

## Tech Stack & Architecture

This project is built with Flutter and utilizes a number of libraries and services to deliver a rich user experience.

- **State Management:** `provider` is used for state management, providing a simple and efficient way to manage the app's state.
- **Backend:** Firebase is used for the backend, including:
    - **Firebase Authentication:** For user sign-in and authentication.
    - **Firebase Cloud Messaging (FCM):** For push notifications.
    - **Firebase Core:** For core Firebase integration.
- **Navigation:** A custom routing solution is implemented in `lib/core/routes.dart` to handle navigation within the app.
- **Dependency Injection:** `get_it` is used for service locator/dependency injection.
- **HTTP Client:** `dio` is used for making HTTP requests to external APIs.
- **Local Storage:** `shared_preferences` and `flutter_secure_storage` are used for persisting data locally on the device.
- **UI:**
    - `flutter_screenutil`: For adapting screen and font size to different screen sizes.
    - `flutter_svg`: For rendering SVG images.
    - `cached_network_image`: To show images from the internet and keep them in the cache directory.
- **Mapping:** `flutter_map` and `geolocator` are used for map and location-based features.

## Project Structure

The project follows a feature-based structure, with code organized as follows:

```
lib/
├── core/
│   ├── di/               # Dependency injection setup
│   ├── providers/        # State management providers
│   ├── services/         # Business logic services
│   ├── theme_config.dart # App theme configuration
│   └── routes.dart       # Navigation routes
├── features/
│   ├── auth/             # Authentication-related widgets and logic
│   ├── events/           # Event creation, discovery, and details
│   ├── home/             # The main home screen
│   └── profile/          # User profile and settings
├── shared/
│   └── widgets/          # Reusable widgets used across multiple features
└── main.dart             # App entry point
```

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK: Make sure you have the Flutter SDK installed. You can find instructions on the [Flutter website](https://flutter.dev/docs/get-started/install).
- An editor like VS Code or Android Studio.

### Installation

1. **Clone the repo**
   ```sh
   git clone https://github.com/dammyaro/kliks.git
   ```
2. **Install packages**
   ```sh
   flutter pub get
   ```
3. **Set up Firebase**
   - Create a new Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/).
   - Follow the instructions to add an Android and/or iOS app to your Firebase project.
   - Download the `google-services.json` file for Android and place it in the `android/app` directory.
   - Download the `GoogleService-Info.plist` file for iOS and place it in the `ios/Runner` directory.
4. **Run the app**
   ```sh
   flutter run
   ```

## Dependencies

Here are some of the key dependencies used in this project:

| Package                  | Description                               |
| ------------------------ | ----------------------------------------- |
| `provider`               | State management                          |
| `dio`                    | HTTP client                               |
| `get_it`                 | Service locator for dependency injection  |
| `firebase_core`          | Core Firebase integration                 |
| `firebase_auth`          | Firebase Authentication                   |
| `firebase_messaging`     | Firebase Cloud Messaging (FCM)            |
| `flutter_screenutil`     | Screen adaptation                         |
| `flutter_secure_storage` | Secure local storage                      |
| `geolocator`             | Geolocation services                      |
| `flutter_map`            | A versatile mapping library for Flutter   |
| `cached_network_image`   | Caching for network images                |
| `shimmer`                | Shimmer effect for loading placeholders   |

For a full list of dependencies, see the `pubspec.yaml` file.

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request