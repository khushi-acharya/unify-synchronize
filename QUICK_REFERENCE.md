# Quick Reference Guide

## 🚀 Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on specific device
flutter run -d chrome          # Web
flutter run -d emulator-5554   # Android emulator
flutter run -d iPhone          # iOS simulator
```

## 📱 App Navigation Flow

```
Start App
    ↓
AuthWrapper checks auth state
    ↓
    ├─→ If logged in → Home Page
    │
    └─→ If logged out → Login Page
            ↓
            ├─→ Enter credentials → Login
            ├─→ Click "Sign up" → Sign Up Page
            └─→ Click "Forgot Password?" → Forgot Password Page
```

## 🔑 Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point, routing, login UI |
| `lib/firebase_options.dart` | Firebase configuration |
| `lib/services/auth_service.dart` | Authentication logic |
| `lib/pages/home_page.dart` | Dashboard/home screen |
| `lib/pages/sign_up_page.dart` | Account creation page |
| `lib/pages/forgot_password_page.dart` | Password reset page |
| `pubspec.yaml` | Dependencies and project config |

## 🎯 Common Tasks

### Test with Sample Credentials

You can create a test account or use:
- Email: `test@university.edu`
- Password: `Test123456`

### Add a New Page

1. Create file: `lib/pages/new_page.dart`
2. Extend `StatelessWidget` or `StatefulWidget`
3. Add route in `MyApp`:
   ```dart
   routes: {
     '/new-page': (context) => const NewPage(),
   }
   ```
4. Navigate to it:
   ```dart
   Navigator.of(context).pushNamed('/new-page');
   ```

### Modify Theme Colors

Edit `lib/main.dart` in the `ThemeData`:
```dart
colorScheme: ColorScheme.dark(
  primary: const Color(0xFF83d4d9),      // Change this
  secondary: const Color(0xFF6ad7dd),    // Or this
  // ...
)
```

### Use AuthService in Other Pages

```dart
import 'package:dbms_project/services/auth_service.dart';

class MyPage extends StatelessWidget {
  final AuthService _authService = AuthService();
  
  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();
    
    return Scaffold(
      body: Center(
        child: Text('Welcome, ${user?.email}'),
      ),
    );
  }
}
```

### Check Authentication State

```dart
StreamBuilder<User?>(
  stream: AuthService().authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  },
)
```

## 🛠️ Debugging

### Enable Debug Mode
```bash
flutter run --debug
```

### Hot Reload (Update UI without restarting)
- Android Studio: Click reload button or press `r`
- VS Code: Press `r`

### Hot Restart (Full app restart)
- Android Studio/VS Code: Press `R`

### View Logs
```bash
flutter logs
```

### Flutter Doctor (Check setup)
```bash
flutter doctor
```

## 📦 Adding New Dependencies

```bash
# Add dependency
flutter pub add package_name

# Or edit pubspec.yaml manually and run
flutter pub get
```

## 🔒 Security Best Practices

1. **Never commit sensitive data:**
   - Don't commit Firebase keys to version control
   - Use `.env` files or secure vaults

2. **Validate user input:**
   - Email format validation
   - Password strength requirements
   - Sanitize all inputs

3. **Use Firebase Security Rules:**
   - Restrict database access
   - Only allow authenticated users
   - Validate data on the server

4. **Enable HTTPS:**
   - All Firebase communication is encrypted
   - Always use HTTPS in production

## 🐛 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Gradle build failed" | Run `flutter clean` then `flutter pub get` |
| "App won't load" | Check `flutter doctor` output |
| "Firebase not initialized" | Ensure `main()` is async |
| "Pods install failed" | `cd ios && pod install --repo-update && cd ..` |
| "Hot reload not working" | Do `r` for hot reload or `R` for hot restart |

## 📊 Build for Production

### Android
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS
```bash
flutter build ios --release
# Follow Xcode prompts to upload to App Store
```

### Web
```bash
flutter build web --release
# Output: build/web/
```

### Windows
```bash
flutter build windows --release
# Output: build/windows/runner/Release/
```

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Create Widget Test
```dart
testWidgets('Login button exists', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  expect(find.text('LOG IN'), findsOneWidget);
});
```

## 📚 Resources

- 📖 [Firebase Flutter Docs](https://firebase.flutter.dev/)
- 📖 [Flutter Official Docs](https://flutter.dev/docs)
- 🎥 [Flutter YouTube Channel](https://www.youtube.com/flutterdev)
- 💬 [Flutter Discord Community](https://discord.gg/flutter)

---

**Happy Coding! 🚀**
