import 'package:flutter/material.dart';
import 'package:pro/screens/home/home.dart';
import 'package:pro/screens/home/profile/profile.dart';
import 'package:pro/screens/login_register/login.dart';
import 'package:pro/screens/login_register/login_register.dart';
import 'package:pro/screens/login_register/register.dart';
import 'package:pro/screens/welcome.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login_register': (context) => const login_register_Screen(),
  '/register': (context) => const RegisterPage(),
  '/login': (context) => const LoginPage(),
  '/welcome': (context) => const WelcomePage(),
  '/home': (context) => const HomeScreen(),
  '/profile': (context) => const ProfilePage(),
};
