import 'package:firebase_auth/firebase_auth.dart' as fbAuth
    hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:mindful_flutter_util/mindful_flutter_util.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../mindful_flutter_auth.dart';

/// The callback triggered after signup
/// The result is an error message, callback successes if message is null
typedef SignupErrorCallback = Future<void>? Function(dynamic);

enum LoginService { supabase, firebase }

class MFSignInWidget extends StatefulWidget {
  final String title;
  final dynamic logo;
  final List<MFOAuthProvider> socialProviders;
  final void Function(Object? user) onSuccess;
  final SignupErrorCallback? onError;
  final LoginService loginService;

  /// Called after the submit animation's completed. Put your route transition
  /// logic here. Recommend to use with [logoTag] and [titleTag]
  //final VoidCallback? onSubmitAnimationCompleted;

  /// Hero tag for logo image. If not specified, it will simply fade out when
  /// changing route
  final String? logoTag;

  /// Hero tag for title text. Need to specify `LoginTheme.beforeHeroFontSize`
  /// and `LoginTheme.afterHeroFontSize` if you want different font size before
  /// and after hero animation
  final String? titleTag;

  /// Prefilled (ie. saved from previous session) value at startup for username
  /// (Auth class calls username email, therefore we use savedEmail here aswell)
  final String savedEmail;

  /// Supply custom widgets to the auth stack such as a custom logo widget
  final List<Widget>? children;

  /// If set to true, make the login window scrollable when overflowing instead
  /// of resizing the window.
  /// Default: false
  final bool scrollable;

  /// A widget that can be placed on top of the loginCard.
  final Widget? headerWidget;

  final String? enterEmailText;

  final bool clipLogo;

  final Map<String, dynamic> userMetaData;
  final String redirectUrl;

  final bool showSnackBarOnSuccess;
  final bool showSnackBarOnError;
  final String checkYourEmailText;
  final String unexpectedErrorText;
  final String googleWebClientId;
  final String? nativeGoogleWebClientId;
  final String? nativeGoogleIosClientId;
  final Map<String, dynamic>? metadata;
  final List<AuthProvider> providers;

  const MFSignInWidget({
    super.key,
    this.loginService =
        LoginService.firebase, //not supporting supabase right now
    required this.providers,
    required this.socialProviders,
    required this.googleWebClientId,
    this.nativeGoogleWebClientId,
    this.nativeGoogleIosClientId,
    required this.redirectUrl,
    required this.title,
    required this.logo,
    required this.userMetaData,
    required this.onSuccess,
    required this.onError,
    this.logoTag,
    this.titleTag,
    this.savedEmail = '',
    this.children,
    this.scrollable = false,
    this.headerWidget,
    this.enterEmailText,
    this.clipLogo = false,
    this.showSnackBarOnSuccess = true,
    this.showSnackBarOnError = true,
    this.unexpectedErrorText = 'Unexpected Error:',
    this.checkYourEmailText = 'Check your email for a link to log in',
    this.metadata = const {},
  });

  @override
  State<StatefulWidget> createState() => MFSignInWidgetState();
}

class MFSignInWidgetState extends State<MFSignInWidget> {
  @override
  Widget build(BuildContext context) {
    Widget? logoWidget;
    if (widget.logo is Widget) {
      logoWidget = widget.logo;
    } else if (widget.logo is String) {
      logoWidget = SizedBox(
          height: 150,
          child: Image.network(
            widget.logo,
            fit: BoxFit.scaleDown,
          ));
    } else {
      logoWidget = SizedBox.fromSize();
    }
    if (widget.clipLogo) {
      logoWidget = ClipRRect(
          borderRadius: BorderRadius.circular(999), child: logoWidget);
    }
    return Column(
      children: [
        widget.title.isEmpty ? SizedBox.fromSize() : Subtitle1(widget.title),
        logoWidget!,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 150,
            width: 400,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoogleSignInButton(
                  clientId: widget.googleWebClientId,
                  loadingIndicator: CircularProgressIndicator(),
                ),
              )
            ]),
            // SignInScreen(
            //   providers: widget.providers,
            // ),
          ),
        )
        // MFOAuthLoginButtons(
        //   nativeGoogleWebClientId: widget.nativeGoogleWebClientId,
        //   nativeGoogleIosClientId: widget.nativeGoogleIosClientId,
        //   onOAuthCallback: (provider) {
        //     print('OAuth success');
        //     if (widget.onSuccess != null) widget.onSuccess!(null);
        //   },
        //   metadata: {},
        //   loginService: widget.loginService,
        //   socialProviders: widget.socialProviders,
        //   onSuccess: widget.onSuccess,
        // ),
        // MFMagicLinkLogin(
        //   onSendMagicLink: (String email) {
        //     try {
        //       sendMagicLink(email);
        //       print('Auth success');
        //       if (widget.onSuccess != null) widget.onSuccess!(null);
        //     } catch (e) {
        //       print('Auth error $e');
        //       if (widget.onError != null) widget.onError!(e);
        //     }
        //     return;
        //   },
        //   metadata: widget.userMetaData,
        // ),
      ],
    );
  }

  void sendMagicLink(String email) async {
    try {
      switch (widget.loginService) {
        case LoginService.supabase:
          {
            await signInWithFirebaseOtp(email);
            break;
          }
        case LoginService.firebase:
          {
            await sendSignInLinkToEmail(email);
            break;
          }
      }
      if (context.mounted && widget.showSnackBarOnSuccess) {
        context.displaySnackBar(widget.checkYourEmailText);
      }
    } on AuthException catch (error) {
      if (widget.onError == null && context.mounted) {
        context.showErrorSnackBar(error.message);
      } else {
        widget.onError?.call(error);
      }
    } catch (error, stack) {
      debugPrint('Error signing in with Otp/magic email link: $error');
      debugPrintStack(stackTrace: stack);
      if (widget.onError == null &&
          context.mounted &&
          widget.showSnackBarOnError) {
        context.showErrorSnackBar('${widget.unexpectedErrorText}: $error');
      } else {
        widget.onError?.call(error);
      }
    }
  }

  Future<void> sendSignInLinkToEmail(String email) {
    try {
      return fbAuth.FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: fbAuth.ActionCodeSettings(
            url: widget.redirectUrl, handleCodeInApp: true),
      );
    } catch (e, s) {
      print(
          'Error signing in $email in with firebase email with redirectUrl ${widget.redirectUrl}: $e');
      rethrow;
    }
  }

  Future<void> signInWithFirebaseOtp(String email) {
    try {
      return fbAuth.FirebaseAuth.instance.signInWithEmailLink(
        email: email,
        emailLink: widget.redirectUrl,
      );
    } catch (e, s) {
      print('Error signging in with firebase otp: $e');
      rethrow;
    }
  }

  Future<void> signInWithSupabaseOtp(String email) {
    return supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: widget.redirectUrl,
      data: widget.metadata,
    );
  }
}
