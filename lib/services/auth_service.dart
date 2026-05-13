import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  /// Sign up with email and password
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Check if user is authenticated
  bool isUserAuthenticated() {
    return _auth.currentUser != null;
  }

  /// Listen to auth state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  /// Get user email
  String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  /// Handle Firebase auth errors
  static String _handleAuthError(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Try another login method.';
      case 'too-many-requests':
        return 'Too many login attempts. Try again later.';
      default:
        return 'Authentication error. Please try again.';
    }
  }
}
