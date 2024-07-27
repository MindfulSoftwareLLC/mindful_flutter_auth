import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:supabase_flutter/supabase_flutter.dart' as supaAuth;

/// Type defining a user ID from Firebase.
typedef UserID = String;

/// Simple class representing the user UID and email.
class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    this.supabaseUser,
    this.firebaseUser,
  }) : assert(supabaseUser != null || firebaseUser != null,
            'Either supabaseUser or firebaseUser must be non-null');
  final String uid;
  final String email;
  final supaAuth.User? supabaseUser;
  final fbAuth.User? firebaseUser;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;

  @override
  String toString() => 'AppUser(uid: $uid, email: $email)';
}
