//import 'package:firebase_ui_oauth_twitter/firebase_ui_oauth_twitter.dart';

// final authStateProvider = StreamProvider<User?>(
//   (ref) => FirebaseAuth.instance.authStateChanges(),
// );
//
// final actionCodeSettings = ActionCodeSettings(
//   url: 'https://flutterfire-e2e-tests.firebaseapp.com',
//   handleCodeInApp: true,
//   androidMinimumVersion: '1',
//   androidPackageName: 'io.flutter.plugins.firebase_ui.firebase_ui_example',
//   iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
// );
// final emailLinkProviderConfig = EmailLinkAuthProvider(
//   actionCodeSettings: actionCodeSettings,
// );
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   FirebaseUIAuth.configureProviders([
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
//   runApp(const FirebaseAuthUIExample());
// }
