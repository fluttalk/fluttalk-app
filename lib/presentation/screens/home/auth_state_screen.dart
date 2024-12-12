import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:fluttalk/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AuthStateScreen extends StatelessWidget {
  const AuthStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? HomeScreen()
              : SignInScreen(providers: [EmailAuthProvider()]);
        },
      ),
    );
  }
}
