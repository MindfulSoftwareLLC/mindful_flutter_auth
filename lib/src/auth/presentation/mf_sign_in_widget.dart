import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful_flutter_auth/mindful_flutter_auth.dart';
import 'package:mindful_flutter_util/mindful_flutter_util.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'mf_supa_magic_auth.dart';

/*
                      onConfirmSignup: (p0, p1) {
                        if (kDebugMode) {
                          print('On confirm signup $p0, $p1');
                        }
                        return null;
                      },
                      onResendCode: (SignupData signupData) {
                        if (kDebugMode) {
                          print('TODO remove me');
                        }
                        return null;
                      },
                      onLogin: (LoginData loginData) {
                        if (kDebugMode) {
                          print('on login $loginData');
                        }
                        return null;
                      },

 */
/// The callback triggered after signup
/// The result is an error message, callback successes if message is null
typedef SignupErrorCallback = Future<void>? Function(dynamic);

class MFSignInWidget extends StatefulWidget {
  final String emailRedirectTo;
  final String title;
  final dynamic logo;
  final bool showSnackBarOnSuccess;
  final VoidCallback? onSuccess;
  final SignupErrorCallback? onError;

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

  /// The initial Iso Code for the widget to show using [LoginUserType.intlPhone].
  /// if not specified. This field will show ['US'] by default.
  final String? initialIsoCode;

  final String? continueWithMagicLinkText;

  final String? enterEmailText;

  final bool clipLogo;

  final Map<String, dynamic> userMetaData;

  const MFSignInWidget(
      {super.key,
      required this.emailRedirectTo,
      required this.title,
      required this.logo,
      //this.onSubmitAnimationCompleted,
      required this.userMetaData,
      required this.onSuccess,
      required this.onError,
      this.logoTag,
      this.titleTag,
      this.savedEmail = '',
      this.children,
      this.scrollable = false,
      this.headerWidget,
      this.initialIsoCode,
      this.continueWithMagicLinkText,
      this.enterEmailText,
      this.clipLogo = false,
      this.showSnackBarOnSuccess = true});

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
    return ProviderScope(
      child: Column(
        children: [
          widget.title.isEmpty ? SizedBox.fromSize() : Subtitle1(widget.title),
          logoWidget!,
          MFSupaMagicAuth(
            redirectUrl: widget.emailRedirectTo,
            showSnackBarOnSuccess: widget.showSnackBarOnSuccess,
            localization: SupaMagicAuthLocalization(
              enterEmail: widget.enterEmailText ?? 'Enter your email',
              continueWithMagicLink: widget.continueWithMagicLinkText ??
                  'Sign in/Sign up fast with a Magic Link',
            ),
            onSuccess: () {
              print('Auth success');
              if (widget.onSuccess != null) widget.onSuccess!();
            },
            onError: (error) {
              print('Auth error $error');
              if (widget.onError != null) widget.onError!(error);
            },
            metadata: widget.userMetaData,
          ),
        ],
      ),
    );
    // return FlutterLogin(
    //   title: widget.title,
    //   logo: widget.logo,
    //   footer: widget.footer,
    //   userType: widget.userType,
    //   loginProviders: widget.loginProviders,
    //   messages: widget.messages,
    //   theme: widget.theme,
    //   //onSubmitAnimationCompleted: widget.onSubmitAnimationCompleted,
    //   logoTag: widget.logoTag,
    //   titleTag: widget.titleTag,
    //   showDebugButtons: widget.showDebugButtons,
    //   additionalSignupFields: widget.additionalSignupFields,
    //   onSwitchToAdditionalFields: widget.onSwitchToAdditionalFields,
    //   confirmSignupRequired: widget.confirmSignupRequired,
    //   confirmSignupKeyboardType: widget.confirmSignupKeyboardType,
    //   onResendCode: widget.onResendCode,
    //   savedEmail: widget.savedEmail,
    //   savedPassword: widget.savedPassword,
    //   termsOfService: widget.termsOfService,
    //   initialAuthMode: widget.initialAuthMode,
    //   children: widget.children,
    //   scrollable: widget.scrollable,
    //   headerWidget: widget.headerWidget,
    //   initialIsoCode: widget.initialIsoCode,
    //   onLogin: _login,
    //   onSignup: _signUp,
    //   onConfirmSignup: _onConfirmSignUp,
    //   onSubmitAnimationCompleted: () {
    //     context.go('/');
    //   },
    //   onRecoverPassword: _recoverPassword,
    // );
  }
}
//
// class SignInMagicLinkFooter extends ConsumerWidget {
//   const SignInMagicLinkFooter({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Column(
//       children: [
//         const SizedBox(height: 8),
//         Row(
//           children: const [
//             Expanded(child: Divider()),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8.0),
//               child: Text('or'),
//             ),
//             Expanded(child: Divider()),
//           ],
//         ),
//         TextButton(
//           onPressed: () => ref
//               .read(authRepositoryProvider)
//               .signInWithOtp(email: 'michael@mindfulnomad.org'),
//           child: const Text('Sign with email magic link.'),
//         ),
//       ],
//     );
//   }
// }
