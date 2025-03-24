import 'package:flutter/material.dart';
import 'package:lab1/screens/home_page.dart';
import 'package:lab1/screens/login_page.dart';
import 'package:lab1/screens/profile_page.dart';
import 'package:lab1/screens/register_page.dart';
import 'package:lab1/theme.dart';

void main() {
  runApp(const SmartCurtainsApp());
}

class SmartCurtainsApp extends StatelessWidget {
  const SmartCurtainsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Curtains',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
