import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Sign up with email and password
  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else {
        throw 'Authentication failed: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Sign in with email and password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        throw 'Invalid email address.';
      } else if (e.code == 'user-disabled') {
        throw 'The user account has been disabled.';
      } else {
        throw 'Authentication failed: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw 'Error signing out: $e';
    }
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw 'Error: ${e.message}';
    } catch (e) {
      throw 'Error sending password reset email: $e';
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Check if user is authenticated
  bool isUserAuthenticated() {
    return _firebaseAuth.currentUser != null;
  }

  /// Get user email
  String? getUserEmail() {
    return _firebaseAuth.currentUser?.email;
  }

  /// Listen to authentication state changes
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
