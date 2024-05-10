import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../mindful_flutter_auth.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({super.key, this.profileText = 'Profile'});
  final String profileText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return ProfileScreen(
      appBar: AppBar(
        title: Text(profileText),
      ),
      providers: authProviders,
    );
  }
}
