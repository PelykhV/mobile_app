import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lab1/provides/auth_provider.dart';
import 'package:lab1/screens/home_page.dart';
import 'package:lab1/screens/login_page.dart';
import 'package:lab1/screens/port_setting_page.dart';
import 'package:lab1/screens/profile_page.dart';
import 'package:lab1/screens/qr_scanner_page.dart';
import 'package:lab1/screens/register_page.dart';
import 'package:lab1/services/internet.dart';
import 'package:lab1/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..loadUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Curtain',
        theme: AppTheme.lightTheme,
        home: const RootScreen(),
        routes: {
          '/login': (_) => const LoginPage(isConnected: true),
          '/register': (_) => const RegisterPage(),
          '/home': (_) => const HomePage(),
          '/profile': (_) => const ProfilePage(),
          '/scan': (_) => const ScanScreen(),
          '/serial_settings': (_) => const SerialPortSettingsScreen(), // маршрут для USB налаштувань
        },
      ),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> {
  final InternetService _internetService = InternetService();
  bool _isConnected = true;
  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();

    // ignore: lines_longer_than_80_chars
    _subscription = _internetService.connectivityStream.listen((ConnectivityResult result) {
      if (!mounted) return;

      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });

      if (!_isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Втрата з\'єднання з Інтернетом')),
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.user != null) {
          return const HomePage();
        } else {
          return LoginPage(isConnected: _isConnected);
        }
      },
    );
  }
}
