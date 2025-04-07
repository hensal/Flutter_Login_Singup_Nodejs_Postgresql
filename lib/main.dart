import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_app/USER_SCREEN/forgot_password.dart';
import 'package:login_app/USER_SCREEN/reset_password.dart';
import 'package:login_app/USER_SCREEN/sing_up.dart';
import 'package:login_app/USER_SCREEN/sign_in.dart';
import 'package:login_app/USER_SCREEN/home.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());  // This removes the '#' from the URL
  //GoogleSignInPlatform.instance = GoogleSignInWeb();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final String? email = state.uri.queryParameters['email'];
          return ResetPasswordPage(email: email ?? '');
        },
      ),
        GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chat App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

