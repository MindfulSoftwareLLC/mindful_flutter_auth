import 'dart:html' as html;

import 'package:firebase_auth/firebase_auth.dart';

/// Not sure if this is needed but might be useful
/// for robustness when signing in on web then loading Flutter
void signInWithToken() async {
  // Get token from sessionStorage
  final token = html.window.sessionStorage['firebaseAuthToken'];
  if (token != null) {
    print('Signing into flutter with token');
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final credential = firebaseAuth.currentUser != null
          ? firebaseAuth.currentUser!
              .getIdToken() // You can also get the current session
          : await firebaseAuth.signInWithCustomToken(token);

      print('User signed in: $credential');
    } catch (e) {
      print('Error signing in: $e');
    }
  }
}
