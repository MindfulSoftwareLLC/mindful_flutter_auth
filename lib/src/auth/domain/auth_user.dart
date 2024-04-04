import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/supabase_auth_repository.dart';

part 'auth_user.g.dart';

@riverpod
Stream<User?> authUser(AuthUserRef ref) async* {
  var authRepository = ref.read(authRepositoryProvider);
  final authStream = authRepository.authStateChanges();

  await for (final authState in authStream) {
    // the user can be non-null if the session is null when the user signs up
    // and hasn't yet validated.
    yield authState?.session?.user ?? authRepository.currentUser;
  }
}
