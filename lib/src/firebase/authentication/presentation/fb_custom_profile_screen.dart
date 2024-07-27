import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/auth_providers.dart';

class FBCustomProfileScreen extends ConsumerWidget {
  const FBCustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(fbAuthProvidersProvider);
    return ProfileScreen(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      providers: authProviders,
    );
  }
}
