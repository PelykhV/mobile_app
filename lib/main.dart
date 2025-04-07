import 'package:flutter/material.dart';
import 'package:lab1/screens/home_page.dart';
import 'package:lab1/screens/login_page.dart';
import 'package:lab1/screens/profile_page.dart';
import 'package:lab1/screens/register_page.dart';
import 'package:lab1/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const HomePage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
