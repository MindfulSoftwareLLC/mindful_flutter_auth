import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/auth_providers.dart';

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen(
      {super.key,
      this.signInText = 'Sign in',
      this.logoAssetPath = 'images/logo.png'});
  final String signInText;
  final String logoAssetPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(fbAuthProvidersProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(signInText),
      ),
      body: SignInScreen(
        headerBuilder: (context, constraints, shrinkOffset) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(logoAssetPath),
            ),
          );
        },
        providers: authProviders,
        footerBuilder: (context, action) => const SignInAnonymouslyFooter(),
      ),
    );
  }
}

class SignInAnonymouslyFooter extends StatelessWidget {
  const SignInAnonymouslyFooter(
      {super.key, this.signInAnonymouslyText = 'Sign in anonymously'});
  final String signInAnonymouslyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('or'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        TextButton(
          onPressed: () => throw Exception(
              'Unimplemented'), //GetIt.I.read(firebaseAuthProvider).signInAnonymously(),
          child: Text(signInAnonymouslyText),
        ),
      ],
    );
  }
}
