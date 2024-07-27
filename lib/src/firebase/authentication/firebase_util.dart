import 'package:firebase_auth/firebase_auth.dart';

signInWithFirebaseGoogleProvider() {
  FirebaseAuth.instance.signInWithProvider(
    OAuthProvider('google.com'),
  );
}
