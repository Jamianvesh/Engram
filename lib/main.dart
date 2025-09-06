import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase/firebase_options.dart';
import 'routes.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quality English',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routes: appRoutes,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (_) => appRoutes['/welcome']!(context),
            ),
          );
        } else {
          return Navigator(
            onGenerateRoute: (settings) =>
                MaterialPageRoute(builder: (_) => appRoutes['/']!(context)),
          );
        }
      },
    );
  }
}
