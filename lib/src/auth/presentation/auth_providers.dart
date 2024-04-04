import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

//part 'auth_providers.g.dart';

// @Riverpod(keepAlive: true)
// List<AuthProvider<AuthListener, AuthCredential>> authProviders(
//     AuthProvidersRef ref) {
//   return [EmailAuthProvider(), GoogleProvider(clientId: '')];
// }

final authStateProvider = StreamProvider<AuthState?>(
  (ref) => Supabase.instance.client.auth.onAuthStateChange,
);
//
// final actionCodeSettings = ActionCodeSettings(
//   url: 'https://flutterfire-e2e-tests.supabaseapp.com',
//   handleCodeInApp: true,
//   androidMinimumVersion: '1',
//   androidPackageName: 'io.flutter.plugins.supabase_ui.supabase_ui_example',
//   iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
// );
// final emailLinkProviderConfig = EmailLinkAuthProvider(
//   actionCodeSettings: actionCodeSettings,
// );
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initializeApp(options: DefaultSupabaseOptions.currentPlatform);
//
//   SupabaseUIAuth.configureProviders([
//     EmailAuthProvider(),
//     emailLinkProviderConfig,
//     PhoneAuthProvider(),
//     GoogleProvider(clientId: GOOGLE_CLIENT_ID),
//     AppleProvider(),
//     FacebookProvider(clientId: FACEBOOK_CLIENT_ID),
//     TwitterProvider(
//       apiKey: TWITTER_API_KEY,
//       apiSecretKey: TWITTER_API_SECRET_KEY,
//       redirectUri: TWITTER_REDIRECT_URI,
//     ),
//   ]);
//
//   runApp(const SupabaseAuthUIExample());
// }
