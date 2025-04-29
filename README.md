# Kliks

Kliks is an event management tool built with Flutter. It allows users to discover, manage, and participate in events seamlessly. The app is designed to provide a personalized experience for users, making event management simple and efficient.

---

## Features

- Discover nearby events and follow your interests.
- Personalized onboarding for a tailored experience.
- Intuitive UI with responsive design.
- Cross-platform support for Android and iOS.

---

## Prerequisites

Before running the project, ensure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0.0 or later)
- Android Studio or Xcode (for Android and iOS development)
- A device emulator or a physical device for testing

---

## Installation

### 1. Install Flutter

#### On Windows:
1. Download the Flutter SDK from [Flutter for Windows](https://docs.flutter.dev/get-started/install/windows).
2. Extract the downloaded file to a directory (e.g., `C:\flutter`).
3. Add Flutter to your system's PATH:
   - Open **Environment Variables**.
   - Add the `flutter/bin` directory to the PATH variable.
4. Run the following command in a terminal to verify the installation:
   ```bash
   flutter doctor
   ```

#### On macOS:
1. Download the Flutter SDK from [Flutter for macOS](https://docs.flutter.dev/get-started/install/macos).
2. Extract the downloaded file to a directory (e.g., `~/flutter`).
3. Add Flutter to your system's PATH:
   - Open the terminal and edit your shell configuration file (`.zshrc` or `.bash_profile`).
   - Add the following line:
     ```bash
     export PATH="$PATH:`pwd`/flutter/bin"
     ```
   - Save and reload the terminal.
4. Run the following command in a terminal to verify the installation:
   ```bash
   flutter doctor
   ```

---

### 2. Clone the Repository

Clone the Kliks repository to your local machine:
```bash
git clone https://github.com/your-username/kliks.git
cd kliks
```

---

### 3. Install Dependencies

Run the following command to install the required dependencies:
```bash
flutter pub get
```

---

## Running the Project

### On Android (Windows/macOS):
1. Ensure you have an Android emulator running or a physical Android device connected.
2. Run the following command to start the app:
   ```bash
   flutter run
   ```

### On iOS (macOS only):
1. Ensure you have Xcode installed and set up.
2. Open the iOS simulator or connect a physical iOS device.
3. Run the following command to start the app:
   ```bash
   flutter run
   ```

---

## Development Notes

- Use `flutter doctor` to check for any missing dependencies or issues in your development environment.
- For hot reload during development, press `r` in the terminal while the app is running.

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Flutter Codelabs](https://docs.flutter.dev/codelabs)

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
