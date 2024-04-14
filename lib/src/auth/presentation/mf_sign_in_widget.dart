import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful_flutter_auth/mindful_flutter_auth.dart';
import 'package:mindful_flutter_auth/src/auth/data/supabase_auth_repository.dart';
import 'package:mindful_flutter_util/mindful_flutter_util.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MFSignInWidget extends ConsumerStatefulWidget {
  final String title;

  //The [ImageProvider] (like [AssetImage]) or asset path [String] for the logo image to be displayed
  final dynamic logo;
  final String? footer;
  final LoginUserType userType;
  final List<LoginProvider> loginProviders;
  final RecoverCallback? onRecoverPassword;
  final LoginMessages? messages;
  final LoginTheme? theme;

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

  /// Display the debug buttons to quickly forward/reverse login animations. In
  /// release mode, this will be overrided to false regardless of the value
  /// passed in
  final bool showDebugButtons;

  /// This List contains the additional signup fields.
  /// By setting this, after signup another card with a form for additional user data is shown
  final List<UserFormField>? additionalSignupFields;

  /// Called when the user hit the submit button when in sign up mode, before
  /// additionalSignupFields are shown
  /// Optional
  final BeforeAdditionalFieldsCallback? onSwitchToAdditionalFields;
  final ConfirmRecoverCallback? onConfirmRecover;
  final ConfirmSignupCallback? onConfirmSignup;
  final bool confirmSignupRequired;
  final LoginCallback? onLogin;
  final SignupCallback? onSignupData;
  final AdditionalFieldsCallback? onAdditionalFields;
  final BeforeAdditionalFieldsCallback? onBeforeAdditionalFields;
  final ProviderNeedsSignUpCallback? onProviderNeedsSignUp;
  final ProviderAuthCallback? onProviderAuth;
  final ProviderDirectCallback? onProviderDirectCallback;
  final RecoverCallback? onRecover;
  final ConfirmSignupCallback? onConfirmSignupCallback;
  final ConfirmSignupRequiredCallback? onConfirmSignupRequired;
  final ConfirmRecoverCallback? onConfirmRecoverCallback;

  /// Sets [TextInputType] of sign up confirmation form.
  ///
  /// Defaults to [TextInputType.text].
  final TextInputType? confirmSignupKeyboardType;

  /// Called when the user hits the resend code button in confirm signup mode
  /// Only when onConfirmSignup is set
  final SignupCallback? onResendCode;

  /// Prefilled (ie. saved from previous session) value at startup for username
  /// (Auth class calls username email, therefore we use savedEmail here aswell)
  final String savedEmail;

  /// Prefilled (ie. saved from previous session) value at startup for password (applies both
  /// to Auth class password and confirmation password)
  final String savedPassword;

  /// List of terms of service to be listed during registration. On onSignup callback LoginData contains a list of TermOfServiceResult
  final List<TermOfService> termsOfService;

  /// The initial auth mode for the widget to show. This defaults to [AuthMode.login]
  /// if not specified. This field can allow you to show the sign up state by default.
  final AuthMode initialAuthMode;

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

  const MFSignInWidget({
    super.key,
    required this.title,
    required this.logo,
    this.footer,
    this.onRecoverPassword,
    this.messages,
    this.theme,
    //this.onSubmitAnimationCompleted,
    this.loginProviders = const [],
    this.userType = LoginUserType.email,
    this.logoTag,
    this.titleTag,
    this.showDebugButtons = false,
    this.additionalSignupFields,
    required this.onResendCode,
    this.savedEmail = '',
    this.savedPassword = '',
    this.termsOfService = const <TermOfService>[],
    this.initialAuthMode = AuthMode.login,
    this.children,
    this.scrollable = false,
    this.headerWidget,
    this.initialIsoCode,
    this.continueWithMagicLinkText,
    this.enterEmailText,
    required this.onLogin,
    this.onConfirmRecover,
    this.onConfirmSignup,
    this.confirmSignupRequired = true,
    this.onConfirmRecoverCallback,
    this.onSignupData,
    this.onSwitchToAdditionalFields,
    this.confirmSignupKeyboardType,
    this.onAdditionalFields,
    this.onBeforeAdditionalFields,
    this.onProviderNeedsSignUp,
    this.onProviderAuth,
    this.onProviderDirectCallback,
    this.onRecover,
    this.onConfirmSignupCallback,
    this.onConfirmSignupRequired,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SupabaseSignInScreenState();
}

class SupabaseSignInScreenState extends ConsumerState<MFSignInWidget> {
  bool _isSubmitting = false;

  Future<String?> _login(LoginData data) async {
    debugPrint('login Name: ${data.name}, Password: ${data.password}');
    try {
      setState(() {
        _isSubmitting = true;
      });

      await ref.read(authRepositoryProvider).signInWithPassword(
            email: data.name,
            password: data.password,
          );

      if (mounted) {
        context.pop();
      }
      return null;
    } on AuthException catch (authException) {
      print(authException.message);
      return authException.message;
    } catch (e) {
      var message = e.toString();
      context.showAlert(message);
      return message;
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<String?> _signUp(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    try {
      setState(() {
        _isSubmitting = true;
      });

      await ref.read(authRepositoryProvider).signUp(
            email: data.name,
            password: data.password ?? '',
          );

      if (mounted) {
        context.pop();
      }
      return null;
    } on AuthException catch (authException) {
      print(authException.message);
      return authException.message;
    } catch (e) {
      var message = e.toString();
      context.showAlert(message);
      return message;
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _onConfirmRecover() async {}
  Future<String?> _recoverPassword(String name) async {
    debugPrint('Recover password Name: ${name}');
    return null;
  }

  Future<String?> _createAccount() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      // await ref.read(onboardingRepositoryProvider).signUp(
      //       email: _emailCtrl.text,
      //       password: _passwordCtrl.text,
      //       username: _usernameCtrl.text,
      //     );
      //
      // if (mounted) {
      //   context.push(
      //     '/verification',
      //     extra: VerificationPageParams(
      //       email: _emailCtrl.text,
      //       password: _passwordCtrl.text,
      //       username: _usernameCtrl.text,
      //     ),
      //   );
      // }
    } on AuthException catch (authException) {
      print(authException.message);
      return authException.message;
    } catch (e) {
      var message = e.toString();
      context.showAlert(message);
      return message;
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<String?>? _onConfirmSignUp(String p1, LoginData loginData) async {
    debugPrint('onCOnfrimSignup p1: $p1, loginData: $loginData');
    try {
      setState(() {
        _isSubmitting = true;
      });
      //TODO - confirm not sign in
      String result = await ref.read(authRepositoryProvider).signInWithPassword(
          email: loginData.name, password: loginData.password);

      if (mounted) {
        context.pop();
      }
      // extra processins, maybe too complicated and should be removed.
      if (widget.onConfirmSignup != null) {
        widget.onConfirmSignup!(p1, loginData);
      }
      return result;
    } on AuthException catch (authException) {
      print(authException.message);
      return authException.message;
    } catch (e) {
      var message = e.toString();
      context.showAlert(message);
      return message;
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProviders = ref.watch(authRepositoryProvider);
    var colorTheme = Theme.of(context).colorScheme;
    Widget? logoWidget;
    if (widget.logo is Widget) {
      logoWidget = widget.logo;
    } else if (widget.logo is String) {
      logoWidget = SizedBox(
          height: 150,
          child: Image.asset(
            widget.logo,
            fit: BoxFit.scaleDown,
          ));
    } else {
      logoWidget = SizedBox.fromSize();
    }
    return ProviderScope(
      child: Column(
        children: [
          '${widget.title}'.isEmpty
              ? SizedBox.fromSize()
              : Subtitle1(widget.title),
          logoWidget!,
          SupaMagicAuth(
            localization: SupaMagicAuthLocalization(
              enterEmail: widget.enterEmailText ?? 'Enter your email',
              continueWithMagicLink: widget.continueWithMagicLinkText ??
                  'Sign in/Sign up fast with a Magic Link',
            ),
            onSuccess: (Session response) {
              print('Auth success $response');
            },
            onError: (error) {
              print('Auth error $error');
            },
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
