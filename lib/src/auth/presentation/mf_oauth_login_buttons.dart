import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../mindful_flutter_auth.dart';

typedef OAuthCallback = Function(User? user);

/// UI component to create magic link login form
class MFOAuthLoginButtons extends StatefulWidget {
  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final OAuthCallback onOAuthCallback;

  final Map<String, dynamic> metadata;

  final bool showSnackBarOnSuccess;
  final String buttonText;
  final LoginService loginService;
  final String? nativeGoogleWebClientId;
  final String? nativeGoogleIosClientId;
  final List<MFOAuthProvider> socialProviders;
  final void Function(Object? user) onSuccess;

  const MFOAuthLoginButtons(
      {super.key,
      required this.socialProviders,
      required this.onSuccess,
      this.redirectUrl,
      required this.onOAuthCallback,
      required this.metadata,
      this.showSnackBarOnSuccess = true,
      this.buttonText = 'Sign in or Sign up.',
      required this.loginService,
      this.nativeGoogleWebClientId,
      this.nativeGoogleIosClientId});

  @override
  State<MFOAuthLoginButtons> createState() => _MFOAuthLoginButtonsState();
}

class _MFOAuthLoginButtonsState extends State<MFOAuthLoginButtons> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.loginService) {
      case LoginService.firebase:
        return FirebaseSocialsAuth(
          // nativeGoogleAuthConfig: NativeGoogleAuthConfig(
          //   webClientId: widget.nativeGoogleWebClientId,
          //   iosClientId: widget.nativeGoogleIosClientId,
          // ),
          socialProviders: widget.socialProviders,
          colored: true,
          redirectUrl: widget.redirectUrl,
          onSuccess: (User? user) {
            widget.onOAuthCallback(user);
          },
          onError: (error) {
            print('mf auth login buttons error: $error');
          },
        );
      // case LoginService.supabase:
      //   return SupaSocialsAuth(
      //     nativeGoogleAuthConfig: NativeGoogleAuthConfig(
      //       webClientId: widget.nativeGoogleWebClientId,
      //       iosClientId: widget.nativeGoogleIosClientId,
      //     ),
      //     socialProviders: [
      //       OAuthProvider.apple,
      //       OAuthProvider.google,
      //     ],
      //     colored: true,
      //     redirectUrl: widget.redirectUrl,
      //     onSuccess: (Session response) {
      //       //TODO widget.onOAuthCallback(response);
      //     },
      //     onError: (error) {
      //       print('mf auth login buttons error: $error');
      //     },
      //   );
      default:
        return Text('Unhandled provider ${widget.loginService.name}');
    }
  }
}
