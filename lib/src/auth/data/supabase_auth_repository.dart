import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseAuthRepositoryProvider = Provider((ref) {
  return SupabaseAuthRepository(Supabase.instance.client.auth);
});

class SupabaseAuthRepository {
  SupabaseAuthRepository(this._auth);
  final GoTrueClient _auth;

  Stream<AuthState?> authStateChanges() => _auth.onAuthStateChange;
  Session? get session => _auth.currentSession;
  // You can have an unverified user without a session
  User? get currentUser => _auth.currentUser;

  Future<void> signUp({
    String? email,
    String? phone,
    required String password,
    String? emailRedirectTo,
    Map<String, dynamic>? data,
    String? captchaToken,
    OtpChannel channel = OtpChannel.sms,
  }) {
    try {
      return _auth.signUp(
          password: password,
          email: email,
          phone: phone,
          captchaToken: captchaToken,
          channel: channel,
          data: data,
          emailRedirectTo: emailRedirectTo);
    } catch (e, s) {
      print('Error Signing up');
      print(e);
      print(s);
      return Future.value(null);
    }
  }

  Future<void> logout() => _auth.signOut();

  signInWithPassword(
      {required String email,
      required String password,
      String? phone,
      String? captchaToken}) {
    try {
      return _auth.signInWithPassword(
        password: password,
        email: email,
        phone: phone,
        captchaToken: captchaToken,
      );
    } catch (e, s) {
      print('Error Signing in with password');
      print(e);
      print(s);
      return Future.value(null);
    }
  }

  signInWithOtp({
    String? email,
    String? phone,
    String? emailRedirectTo,
    bool? shouldCreateUser,
    Map<String, dynamic>? data,
    String? captchaToken,
    OtpChannel channel = OtpChannel.sms,
  }) {
    try {
      return _auth.signInWithOtp(
          email: email,
          phone: phone,
          emailRedirectTo: emailRedirectTo,
          shouldCreateUser: shouldCreateUser,
          data: data,
          captchaToken: captchaToken,
          channel: channel);
    } catch (e, s) {
      print('Error Signing up');
      print(e);
      print(s);
      return Future.value(null);
    }
  }
}
