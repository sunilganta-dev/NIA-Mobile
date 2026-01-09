import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // --------------------------------------------------------
  // EMAIL + PASSWORD LOGIN
  // --------------------------------------------------------
  static Future<User?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // --------------------------------------------------------
  // REGISTER USER
  // --------------------------------------------------------
  static Future<User?> register(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send verification email
      await cred.user?.sendEmailVerification();

      return cred.user;
    } catch (e) {
      print("Register Error: $e");
      return null;
    }
  }

  // --------------------------------------------------------
  // RESET PASSWORD EMAIL
  // --------------------------------------------------------
  static Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("Reset Password Error: $e");
      return false;
    }
  }

  // --------------------------------------------------------
  // GOOGLE LOGIN
  // --------------------------------------------------------
  static Future<User?> googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null; // user cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCred =
          await _auth.signInWithCredential(credential);

      return userCred.user;
    } catch (e) {
      print("Google Login Error: $e");
      return null;
    }
  }

  // --------------------------------------------------------
  // FACEBOOK LOGIN 
  // --------------------------------------------------------
  static Future<User?> facebookLogin() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        print("Facebook login failed: ${result.status}");
        return null;
      }

      final accessToken = result.accessToken;
      if (accessToken == null) return null;

      final facebookAuthCredential =
          FacebookAuthProvider.credential(accessToken.token);

      UserCredential userCred =
          await FirebaseAuth.instance.signInWithCredential(
        facebookAuthCredential,
      );

      return userCred.user;
    } catch (e) {
      print("Facebook Login Error: $e");
      return null;
    }
  }

  // --------------------------------------------------------
  // LOGOUT (GOOGLE + FACEBOOK)
  // --------------------------------------------------------
  static Future<void> logout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}
