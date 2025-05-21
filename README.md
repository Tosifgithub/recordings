Recordings App

This is a Flutter application that allows users to record, save, and play audio recordings. The app features a grid view of recordings with play/pause and delete functionality.

Prerequisites

Before running the project, ensure you have the following tools and configurations set up:

1. Flutter SDK





Version: Flutter 3.22.3



Installation:





Download and install Flutter 3.22.3 from the official Flutter website or use a version manager like fvm:

fvm install 3.22.3
fvm use 3.22.3



Verify the installation:

flutter --version



Ensure the output shows Flutter 3.22.3.

2. Dart SDK





The required Dart SDK version is bundled with Flutter 3.22.3 (Dart 3.4.3).



Verify the Dart version:

dart --version

3. Android Studio





Version: Android Studio Giraffe | 2022.3.1 Patch 4



Installation:





Download and install Android Studio Giraffe (2022.3.1 Patch 4) from the official Android Studio website.



Configure the Android SDK and an emulator or connect a physical Android device.



Flutter Plugin:





Install the Flutter plugin in Android Studio via File > Settings > Plugins > Marketplace > Search for "Flutter" > Install.



The Dart plugin will be installed automatically with the Flutter plugin.

4. Dependencies

The project uses the following dependencies (as specified in pubspec.yaml):





just_audio: ^0.9.40 (for audio playback)



permission_handler: ^11.0.0 (for requesting runtime permissions)



record: ^4.4.4 (for audio recording)



shared_preferences: ^2.0.0 (for persistent storage)



http: ^1.0.0 (for HTTP requests)



intl: ^0.18.0 (for internationalization and formatting)

These dependencies will be automatically installed when you run flutter pub get.

Setup Instructions





Clone the Repository:





Clone this project to your local machine:

git clone <repository-url>
cd recordings1



Install Dependencies:





Run the following command to install all required dependencies:

flutter pub get



Configure Permissions (Android):





The app requires audio recording and storage permissions due to the record and shared_preferences packages. Add the following permissions in android/app/src/main/AndroidManifest.xml:

<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />



For Android 13+ (API 33+), storage permissions are more granular. The permission_handler package will handle runtime permission requests, but ensure these permissions are declared.



Note: The logs indicate you're using a TECNO BG6h device running Android 33, so ensure these permissions are granted when prompted.



Configure Permissions (iOS):





For iOS, add the following keys in ios/Runner/Info.plist to request microphone access:

<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access to record audio.</string>



Handle Runtime Permissions:





The permission_handler package is used to request permissions at runtime. Ensure your app requests the following permissions:





Microphone permission (required by record for audio recording).



Storage permissions (required for saving recordings, if targeting Android versions below 13).



When the app runs for the first time, it will prompt the user to grant these permissions. If denied, the app may not function correctly. Users can manually enable them in device settings:





Android: Settings > Apps > Recordings App > Permissions > Microphone > Allow.



iOS: Settings > Privacy > Microphone > Recordings App > Enable.



Set Up an Emulator or Device:





Emulator:





Open Android Studio > AVD Manager > Create or start an emulator (e.g., Pixel 6 API 33).



Ensure the emulator has a microphone enabled.



Physical Device:





Connect your Android device via USB.



Enable USB debugging in Settings > Developer Options > USB Debugging.



Verify the device is recognized:

flutter devices

Running the Project





Run the App:





Ensure your emulator is running or your device is connected.



Run the following command in the project directory:

flutter run



This will build and launch the app on your selected device.



Debugging:





If you encounter issues, check the debug console for errors.



Common issues and fixes:





Flutter Version Mismatch: Ensure you're using Flutter 3.22.3 (flutter --version).



Permission Denied: Verify that audio recording permissions are granted.



Audio Playback Issues: Ensure the just_audio package is compatible with your device (logs show AndroidXMedia3/1.4.1). Consider updating to the latest version if needed:

flutter pub add just_audio



HTTP Requests Failing: The http package requires internet permission (already added to AndroidManifest.xml). Ensure your device/emulator has an active internet connection.

Project Structure





lib/features/recordings/: Contains the core functionality of the app.





models/recording.dart: Defines the Recording model.



screens/record_screen.dart: Screen for recording audio.



recording_tab.dart: Displays the list of recordings with play/pause and delete functionality.



assets/: Contains static assets like emptyState.png.

Features





Record audio using the device’s microphone (record package).



Save recordings to local storage using shared_preferences.



Display recordings in a grid view with play/pause and delete buttons.



Play audio recordings with a responsive play/pause button (just_audio package).



Request runtime permissions for microphone and storage (permission_handler package).



Support for HTTP requests (http package, if used for remote data).



Internationalization and formatting support (intl package).

Troubleshooting





App Crashes on Launch:





Check if all permissions are granted.



Ensure the Flutter and Android Studio versions match the requirements.



Audio Not Recording:





Verify that microphone permissions are granted.



Ensure the record package is compatible with your device (version 4.4.4).



Audio Not Playing:





Verify that the audio file exists at the path stored in shared_preferences.



Check for errors in the debug console related to just_audio.



Button Not Toggling:





The play/pause button issue has been fixed in the latest code. Ensure you’re using the updated recording_tab.dart file.



Permission Requests Not Showing:





Ensure permission_handler is correctly integrated. Check the debug console for permission-related errors.

Additional Notes





The app has been tested on a TECNO BG6h device running Android 33, as per the provided logs.



The http package is included but not used in the provided recording_tab.dart code. If you plan to make HTTP requests, ensure your app has internet access and handles network errors appropriately.



The intl package is included for internationalization. If your app uses date/time formatting, ensure the intl version matches your Flutter version for compatibility.



Ensure your development environment matches the specified versions to avoid compatibility issues.