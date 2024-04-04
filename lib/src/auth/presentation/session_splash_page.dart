import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful_flutter_auth/src/auth/presentation/session_check_spinner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionSplashPage extends StatefulWidget {
  final String routeWithSession;
  final String routeWithoutSession;

  final Widget progressIndicator;
  SessionSplashPage(
      {super.key,
      this.progressIndicator = const CircularProgressIndicator(),
      this.routeWithSession = '/home',
      this.routeWithoutSession = '/login'});

  @override
  SessionSplashPageState createState() => SessionSplashPageState();
}

class SessionSplashPageState extends State<SessionSplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      context.go(widget.routeWithSession);
    } else {
      context.go(widget.routeWithoutSession);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: SessionCheckSpinner()),
    );
  }
}
