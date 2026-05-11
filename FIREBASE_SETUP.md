# Firebase Setup Guide for CollabHub

This project is configured with Firebase for authentication and data management.

## Firebase Configuration

The Firebase configuration is stored in `lib/firebase_options.dart` with the following credentials:

```
Project ID: dbmsproject-651dd
API Key: AIzaSyAGHejP0LBYqhea1P1RbKVkePlp_te143g
Auth Domain: dbmsproject-651dd.firebaseapp.com
Storage Bucket: dbmsproject-651dd.firebasestorage.app
```

## Installation Steps

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Initialize FlutterFire (if not already done)
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Run the App
```bash
flutter run
```

## Features

### Authentication Service
The app includes an `AuthService` class (`lib/services/auth_service.dart`) that provides:

- **signUp**: Create a new account with email and password
- **signIn**: Login with email and password
- **signOut**: Logout the current user
- **resetPassword**: Send password reset email
- **getCurrentUser**: Get the current authenticated user
- **isUserAuthenticated**: Check if a user is logged in
- **authStateChanges**: Listen to auth state changes

### Usage Example

```dart
final authService = AuthService();

// Sign up
try {
  final userCredential = await authService.signUp(
    email: 'user@university.edu',
    password: 'password123',
  );
} catch (e) {
  print('Error: $e');
}

// Sign in
try {
  final userCredential = await authService.signIn(
    email: 'user@university.edu',
    password: 'password123',
  );
} catch (e) {
  print('Error: $e');
}

// Sign out
await authService.signOut();

// Check authentication
bool isLoggedIn = authService.isUserAuthenticated();
```

## Platform-Specific Setup

### Android
The Firebase setup is automatically configured. Make sure your `android/build.gradle` has:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### iOS
Run the following to set up Firebase for iOS:
```bash
cd ios
pod install --repo-update
cd ..
```

### Web
Firebase is automatically configured for web. No additional setup needed beyond `flutter pub get`.

## Security Rules

Remember to set up appropriate Firestore security rules in your Firebase console:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Troubleshooting

### "Firebase app not initialized" error
Make sure `main()` is async and initializes Firebase:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### Missing Firebase files
Run `flutterfire configure` to generate platform-specific Firebase configuration files.

## Next Steps

1. Set up Firestore database rules in Firebase Console
2. Enable authentication methods (Email/Password, Google, etc.)
3. Configure storage buckets for file uploads
4. Set up user profiles in Firestore

For more information, visit [Firebase Documentation](https://firebase.flutter.dev/)
