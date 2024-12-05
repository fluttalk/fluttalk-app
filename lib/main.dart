import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttalk/core/network/dio_client.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/data/repositories/chat_repository.dart';
import 'package:fluttalk/data/repositories/friend_repository.dart';
import 'package:fluttalk/data/repositories/message_repository.dart';
import 'package:fluttalk/data/repositories/user_repository.dart';
import 'package:fluttalk/firebase_options.dart';
import 'package:fluttalk/presentation/screens/auth_state_screen.dart';
import 'package:fluttalk/presentation/screens/welcome_screen.dart';
import 'package:fluttalk/presentation/theme/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => DioClient(
            baseUrl: '',
          ),
        ),
        RepositoryProvider(
          create: (context) => AuthRepository(
            FirebaseAuth.instance,
          ),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(
            context.read<DioClient>().dio,
          ),
        ),
        RepositoryProvider(
          create: (context) => FriendRepository(
            context.read<DioClient>().dio,
          ),
        ),
        RepositoryProvider(
          create: (context) => ChatRepository(
            context.read<DioClient>().dio,
            firestore,
          ),
        ),
        RepositoryProvider(
          create: (context) => MessageRepository(
            context.read<DioClient>().dio,
          ),
        ),
      ],
      child: MaterialApp(
        theme: MyTheme.light(),
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser != null
            ? const AuthStateScreen()
            : const WelcomeScreen(),
      ),
    );
  }
}
