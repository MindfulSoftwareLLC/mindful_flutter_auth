import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

typedef SendMagicLinkCallback = Function(String email);

/// UI component to create magic link login form
class MFMagicLinkLogin extends StatefulWidget {
  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final SendMagicLinkCallback onSendMagicLink;

  final Map<String, dynamic> metadata;

  final bool showSnackBarOnSuccess;
  final String invalidEmailErrorText;
  final String enterEmailText;
  final String buttonText;

  const MFMagicLinkLogin(
      {super.key,
      this.redirectUrl,
      required this.onSendMagicLink,
      required this.metadata,
      this.showSnackBarOnSuccess = true,
      this.invalidEmailErrorText = 'Invalid email',
      this.enterEmailText = 'Enter email.',
      this.buttonText = 'Sign in or Sign up.'});

  @override
  State<MFMagicLinkLogin> createState() => _MFMagicLinkLoginState();
}

class _MFMagicLinkLoginState extends State<MFMagicLinkLogin> {
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
                return widget.invalidEmailErrorText;
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              label: Text(widget.enterEmailText),
            ),
            controller: _email,
          ),
          SizedBox(height: 16),
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
                    widget.buttonText,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              setState(() {
                _isLoading = true;
              });
              await widget.onSendMagicLink(_email.text);
              setState(() {
                _isLoading = false;
              });
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
