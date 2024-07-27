import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mindful_flutter_util/mindful_flutter_util.dart';

import '../../firebase/authentication/firebase_util.dart';

enum MFOAuthProvider {
  apple,
  azure,
  bitbucket,
  discord,
  facebook,
  figma,
  github,
  gitlab,
  google,
  kakao,
  keycloak,
  linkedin,
  linkedinOidc,
  notion,
  slack,
  spotify,
  twitch,
  twitter,
  workos,
}

extension on MFOAuthProvider {
  OAuthProvider get provider => switch (this) {
        MFOAuthProvider.apple => OAuthProvider("apple"),
        MFOAuthProvider.azure => OAuthProvider("microsoft"),
        MFOAuthProvider.bitbucket => OAuthProvider("bitbucket"),
        MFOAuthProvider.discord => OAuthProvider("discord"),
        MFOAuthProvider.facebook => OAuthProvider("facebook"),
        MFOAuthProvider.figma => OAuthProvider("figma"),
        MFOAuthProvider.github => OAuthProvider("github"),
        MFOAuthProvider.gitlab => OAuthProvider("gitlab"),
        MFOAuthProvider.google => OAuthProvider("google"),
        MFOAuthProvider.linkedin => OAuthProvider("linkedin"),
        MFOAuthProvider.slack => OAuthProvider("slack"),
        MFOAuthProvider.spotify => OAuthProvider("spotify"),
        MFOAuthProvider.twitch => OAuthProvider("twitch"),
        MFOAuthProvider.twitter => OAuthProvider("xTwitter"),
        _ => OAuthProvider("google"),
      };
  IconData get iconData => switch (this) {
        MFOAuthProvider.apple => FontAwesomeIcons.apple,
        MFOAuthProvider.azure => FontAwesomeIcons.microsoft,
        MFOAuthProvider.bitbucket => FontAwesomeIcons.bitbucket,
        MFOAuthProvider.discord => FontAwesomeIcons.discord,
        MFOAuthProvider.facebook => FontAwesomeIcons.facebook,
        MFOAuthProvider.figma => FontAwesomeIcons.figma,
        MFOAuthProvider.github => FontAwesomeIcons.github,
        MFOAuthProvider.gitlab => FontAwesomeIcons.gitlab,
        MFOAuthProvider.google => FontAwesomeIcons.google,
        MFOAuthProvider.linkedin => FontAwesomeIcons.linkedin,
        MFOAuthProvider.slack => FontAwesomeIcons.slack,
        MFOAuthProvider.spotify => FontAwesomeIcons.spotify,
        MFOAuthProvider.twitch => FontAwesomeIcons.twitch,
        MFOAuthProvider.twitter => FontAwesomeIcons.xTwitter,
        _ => Icons.close,
      };

  Color get btnBgColor => switch (this) {
        MFOAuthProvider.apple => Colors.black,
        MFOAuthProvider.azure => Colors.blueAccent,
        MFOAuthProvider.bitbucket => Colors.blue,
        MFOAuthProvider.discord => Colors.purple,
        MFOAuthProvider.facebook => const Color(0xFF3b5998),
        MFOAuthProvider.figma => const Color.fromRGBO(241, 77, 27, 1),
        MFOAuthProvider.github => Colors.black,
        MFOAuthProvider.gitlab => Colors.deepOrange,
        MFOAuthProvider.google => const Color(0xFFDE5246),
        MFOAuthProvider.kakao => const Color(0xFFFFE812),
        MFOAuthProvider.keycloak => const Color.fromRGBO(0, 138, 170, 1),
        MFOAuthProvider.linkedin => const Color.fromRGBO(0, 136, 209, 1),
        MFOAuthProvider.notion => const Color.fromRGBO(69, 75, 78, 1),
        MFOAuthProvider.slack => const Color.fromRGBO(74, 21, 75, 1),
        MFOAuthProvider.spotify => Colors.green,
        MFOAuthProvider.twitch => Colors.purpleAccent,
        MFOAuthProvider.twitter => Colors.black,
        MFOAuthProvider.workos => const Color.fromRGBO(99, 99, 241, 1),
        // ignore: unreachable_switch_case
        _ => Colors.black,
      };

  String get capitalizedName => name[0].toUpperCase() + name.substring(1);
}

enum SocialButtonVariant {
  /// Displays the social login buttons horizontally with icons.
  icon,

  /// Displays the social login buttons vertically with icons and text labels.
  iconAndText,
}

class SocialsAuthLocalization {
  final String successSignInMessage;
  final String unexpectedError;

  /// Overrides the name of the OAuth provider shown on the sign-in button.
  ///
  /// Defaults to `Continue with [ProviderName]`
  ///
  /// ```dart
  /// SupaSocialsAuth(
  ///   socialProviders: const [OAuthProvider.azure],
  ///   localization: const SupaSocialsAuthLocalization(
  ///     oAuthButtonLabels: {
  ///       OAuthProvider.azure: 'Microsoft (Azure)'
  ///     },
  ///   ),
  ///   onSuccess: (session) {
  ///     // sHandle success
  ///   },
  /// ),
  /// ```
  final Map<OAuthProvider, String> oAuthButtonLabels;

  final String continueWith;

  const SocialsAuthLocalization({
    this.successSignInMessage = 'Successfully signed in!',
    this.unexpectedError = 'An unexpected error occurred',
    this.continueWith = 'Continue with ',
    this.oAuthButtonLabels = const {},
  });
}

/// UI Component to create social login form
class FirebaseSocialsAuth extends StatefulWidget {
  /// Whether to use native Apple sign in on iOS and macOS
  final bool enableNativeAppleAuth;

  /// List of social providers to show in the form
  final List<MFOAuthProvider> socialProviders;

  /// Whether or not to color the social buttons in their respecful colors
  ///
  /// You can control the appearance through `ElevatedButtonTheme` when set to false.
  final bool colored;

  /// Whether or not to show the icon only or icon and text
  final SocialButtonVariant socialButtonVariant;

  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(User? user) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  /// Whether to show a SnackBar after a successful sign in
  final bool showSuccessSnackBar;

  /// OpenID scope(s) for provider authorization request (ex. '.default')
  final Map<OAuthProvider, String>? scopes;

  /// Parameters to include in provider authorization request (ex. {'prompt': 'consent'})
  final Map<OAuthProvider, Map<String, String>>? queryParams;

  /// Localization for the form
  final SocialsAuthLocalization localization;

  const FirebaseSocialsAuth({
    super.key,
    required this.socialProviders,
    required this.onSuccess,
    this.enableNativeAppleAuth = true,
    this.colored = true,
    this.redirectUrl,
    this.onError,
    this.socialButtonVariant = SocialButtonVariant.iconAndText,
    this.showSuccessSnackBar = true,
    this.scopes,
    this.localization = const SocialsAuthLocalization(),
    this.queryParams,
  });

  @override
  State<FirebaseSocialsAuth> createState() => _FirebaseSocialsAuthState();
}

class _FirebaseSocialsAuthState extends State<FirebaseSocialsAuth> {
  late final StreamSubscription<User?> _firebaseAuthStateSubscription;
/*
  /// Performs Google sign in on Android and iOS
  Future<AuthResponse> _nativeGoogleSignIn({
    required String? webClientId,
    required String? iosClientId,
  }) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw Exception('No Access Token found from Google sign in result.');
    }
    if (idToken == null) {
      throw Exception('No ID Token found from Google sign in result.');
    }

    return FirebaseAuth.instance.signInWithCustomToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  /// Performs Apple sign in on iOS or macOS
  Future<AuthResponse> _nativeAppleSignIn() async {
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated Apple sign in credential.');
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }
*/
  @override
  void initState() {
    super.initState();
    _firebaseAuthStateSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && mounted) {
        widget.onSuccess.call(user as User?);
        if (widget.showSuccessSnackBar) {
          context.displaySnackBar(widget.localization.successSignInMessage);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _firebaseAuthStateSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final providers = widget.socialProviders;
    //final googleAuthConfig = widget.nativeGoogleAuthConfig;
    final isNativeAppleAuthEnabled = widget.enableNativeAppleAuth;
    final coloredBg = widget.colored == true;

    if (providers.isEmpty) {
      return ErrorWidget(Exception('Social provider list cannot be empty'));
    }

    final authButtons = List.generate(
      providers.length,
      (index) {
        final socialProvider = providers[index];

        Color? foregroundColor = coloredBg ? Colors.white : null;
        Color? backgroundColor = coloredBg ? socialProvider.btnBgColor : null;
        Color? overlayColor = coloredBg ? Colors.white10 : null;

        Color? iconColor = coloredBg ? Colors.white : null;

        Widget iconWidget = SizedBox(
          height: 48,
          width: 48,
          child: Icon(
            socialProvider.iconData,
            color: iconColor,
          ),
        );
        if (socialProvider == MFOAuthProvider.google && coloredBg) {
          iconWidget = Image.asset(
            'assets/logos/google_light.png',
            package: 'supabase_auth_ui',
            width: 48,
            height: 48,
          );

          foregroundColor = Colors.black;
          backgroundColor = Colors.white;
          overlayColor = Colors.white;
        }

        switch (socialProvider) {
          case MFOAuthProvider.notion:
            iconWidget = Image.asset(
              'assets/logos/notion.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case MFOAuthProvider.kakao:
            iconWidget = Image.asset(
              'assets/logos/kakao.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case MFOAuthProvider.keycloak:
            iconWidget = Image.asset(
              'assets/logos/keycloak.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case MFOAuthProvider.workos:
            iconWidget = Image.asset(
              'assets/logos/workOS.png',
              package: 'supabase_auth_ui',
              color: coloredBg ? Colors.white : null,
              width: 48,
              height: 48,
            );
            break;
          default:
            break;
        }

        onAuthButtonPressed() async {
          try {
            // Check if native Google login should be performed
            /*
            TODO
            if (socialProvider == MFOAuthProvider.google.provider) {
              final webClientId = googleAuthConfig?.webClientId;
              final iosClientId = googleAuthConfig?.iosClientId;
              final shouldPerformNativeGoogleSignIn =
                  (webClientId != null && !kIsWeb && Platform.isAndroid) ||
                      (iosClientId != null && !kIsWeb && Platform.isIOS);
              if (shouldPerformNativeGoogleSignIn) {
                await _nativeGoogleSignIn(
                  webClientId: webClientId,
                  iosClientId: iosClientId,
                );
                return;
              }
            }

            // Check if native Apple login should be performed
            if (socialProvider == OAuthProvider.apple) {
              final shouldPerformNativeAppleSignIn =
                  (isNativeAppleAuthEnabled && !kIsWeb && Platform.isIOS) ||
                      (isNativeAppleAuthEnabled && !kIsWeb && Platform.isMacOS);
              if (shouldPerformNativeAppleSignIn) {
                await _nativeAppleSignIn();
                return;
              }
            }
             */

            // So bad but I'm just replacing this call with the fb one
            await signInWithFirebaseGoogleProvider();
          } on Exception catch (error) {
            var message = error.toString();
            print('auth exception: $error');
            handleError(context, message, error);
          } catch (error, s) {
            var message = '${widget.localization.unexpectedError}: $error';
            print('auth error: $error');
            print(s);
            handleError(context, message, error);
          }
        }

        final authButtonStyle = ButtonStyle(
          foregroundColor: WidgetStateProperty.all(foregroundColor),
          backgroundColor: WidgetStateProperty.all(backgroundColor),
          overlayColor: WidgetStateProperty.all(overlayColor),
          iconColor: WidgetStateProperty.all(iconColor),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: widget.socialButtonVariant == SocialButtonVariant.icon
              ? Material(
                  shape: const CircleBorder(),
                  elevation: 2,
                  color: backgroundColor,
                  child: InkResponse(
                    radius: 24,
                    onTap: onAuthButtonPressed,
                    child: iconWidget,
                  ),
                )
              : ElevatedButton.icon(
                  icon: iconWidget,
                  style: authButtonStyle,
                  onPressed: onAuthButtonPressed,
                  label: Text(
                      '${widget.localization.continueWith} ${socialProvider.capitalizedName}'),
                ),
        );
      },
    );

    return widget.socialButtonVariant == SocialButtonVariant.icon
        ? Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: authButtons,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: authButtons,
          );
  }

  void handleError(BuildContext context, String message, Object error) {
    if (widget.onError == null && context.mounted) {
      context.displayErrorSnackBar(message);
    } else {
      widget.onError?.call(error);
    }
  }
}
