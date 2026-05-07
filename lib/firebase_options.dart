import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Firebase configuration for CollabHub project
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAGHejP0LBYqhea1P1RbKVkePlp_te143g",
    authDomain: "dbmsproject-651dd.firebaseapp.com",
    projectId: "dbmsproject-651dd",
    storageBucket: "dbmsproject-651dd.firebasestorage.app",
    messagingSenderId: "323623480798",
    appId: "1:323623480798:web:0a4530b87250948294c14f",
    measurementId: "G-ERB0GE66ZJ",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAGHejP0LBYqhea1P1RbKVkePlp_te143g",
    appId: "1:323623480798:android:0a4530b87250948294c14f",
    messagingSenderId: "323623480798",
    projectId: "dbmsproject-651dd",
    storageBucket: "dbmsproject-651dd.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAGHejP0LBYqhea1P1RbKVkePlp_te143g",
    appId: "1:323623480798:ios:0a4530b87250948294c14f",
    messagingSenderId: "323623480798",
    projectId: "dbmsproject-651dd",
    storageBucket: "dbmsproject-651dd.firebasestorage.app",
    iosBundleId: "com.example.dbmsProject",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyAGHejP0LBYqhea1P1RbKVkePlp_te143g",
    appId: "1:323623480798:macos:0a4530b87250948294c14f",
    messagingSenderId: "323623480798",
    projectId: "dbmsproject-651dd",
    storageBucket: "dbmsproject-651dd.firebasestorage.app",
    iosBundleId: "com.example.dbmsProject",
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "AIzaSyAGHejP0LBYqhea1P1RbKVkePlp_te143g",
    appId: "1:323623480798:windows:0a4530b87250948294c14f",
    messagingSenderId: "323623480798",
    projectId: "dbmsproject-651dd",
    storageBucket: "dbmsproject-651dd.firebasestorage.app",
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: "AIzaSyAGHejP0LBYqhea1P1RbKVkePlp_te143g",
    appId: "1:323623480798:linux:0a4530b87250948294c14f",
    messagingSenderId: "323623480798",
    projectId: "dbmsproject-651dd",
    storageBucket: "dbmsproject-651dd.firebasestorage.app",
  );
}
