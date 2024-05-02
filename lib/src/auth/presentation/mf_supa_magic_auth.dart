import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/localizations/supa_magic_auth_localization.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// UI component to create magic link login form
class MFSupaMagicAuth extends StatefulWidget {
  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function() onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  /// Localization for the form
  final SupaMagicAuthLocalization localization;

  final Map<String, dynamic> metadata;

  final bool showSnackBarOnSuccess;

  const MFSupaMagicAuth(
      {super.key,
      this.redirectUrl,
      required this.onSuccess,
      this.onError,
      this.localization = const SupaMagicAuthLocalization(),
      required this.metadata,
      this.showSnackBarOnSuccess = true});

  @override
  State<MFSupaMagicAuth> createState() => _MFSupaMagicAuthState();
}

class _MFSupaMagicAuthState extends State<MFSupaMagicAuth> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = widget.localization;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !EmailValidator.validate(_email.text)) {
                return localization.validEmailError;
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              label: Text(localization.enterEmail),
            ),
            controller: _email,
          ),
          spacer(16),
          ElevatedButton(
            child: (_isLoading)
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      strokeWidth: 1.5,
                    ),
                  )
                : Text(
                    localization.continueWithMagicLink,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              setState(() {
                _isLoading = true;
              });
              try {
                await supabase.auth.signInWithOtp(
                  email: _email.text,
                  emailRedirectTo: widget.redirectUrl,
                  data: widget.metadata,
                );
                if (context.mounted && widget.showSnackBarOnSuccess) {
                  context.showSnackBar(localization.checkYourEmail);
                }
                widget.onSuccess();
              } on AuthException catch (error) {
                if (widget.onError == null && context.mounted) {
                  context.showErrorSnackBar(error.message);
                } else {
                  widget.onError?.call(error);
                }
              } catch (error) {
                if (widget.onError == null && context.mounted) {
                  context.showErrorSnackBar(
                      '${localization.unexpectedError}: $error');
                } else {
                  widget.onError?.call(error);
                }
              }
              setState(() {
                _isLoading = false;
              });
            },
          ),
          spacer(10),
        ],
      ),
    );
  }
}
