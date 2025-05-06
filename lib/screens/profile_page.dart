import 'package:flutter/material.dart';
import 'package:lab1/data/user_repository.dart';
import 'package:lab1/domain/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService(UserRepository());
  String _username = '...';
  String _email = '...';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await _userService.getUserData();
    setState(() {
      _username = user?['username'] ?? 'Невідомий користувач';
      _email = user?['email'] ?? '';
    });
  }

  void _logout() async {
    await _userService.logout();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Логін: $_username', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Email: $_email', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _logout, child: const Text('Вийти')),
          ],
        ),
      ),
    );
  }
}
