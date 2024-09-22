import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth/firebase_ui_oauth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

class MFGoogleSignInButton extends StatelessWidget {
  const MFGoogleSignInButton({
    super.key,
    required this.googleWebClientId,
    this.onSignedIn,
    this.width = 220.0,
    this.height = 40.0,
  });

  final SignedInCallback? onSignedIn;
  final String googleWebClientId;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(4),
      //   border: Border.all(color: Colors.grey.shade300),
      // ),
      child: Center(
        child: GoogleSignInButton(
          clientId: googleWebClientId,
          loadingIndicator: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          label: 'Sign in/up with Google',
          onSignedIn: _onSignIn,
        ),
      ),
    );
  }

  void _onSignIn(UserCredential credential) {
    if (onSignedIn != null) {
      onSignedIn!(credential);
    }
  }
}
