import 'package:flutter/material.dart';
import 'package:lab1/data/user_repository.dart';
import 'package:lab1/domain/user_service.dart';

class LoginPage extends StatefulWidget {
  final bool isConnected;
  const LoginPage({required this.isConnected, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  final UserService _userService = UserService(UserRepository());

  Future<void> _login() async {
    if (!widget.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Відсутнє з\'єднання з Інтернетом')),
      );
      return;
    }
    final inputUsername = _usernameController.text.trim();
    final inputPassword = _passwordController.text.trim();

    if (inputUsername.isEmpty || inputPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Будь ласка, заповніть всі поля.';
      });
      return;
    }

    final bool success = await _userService.login(inputUsername, inputPassword);

    if (success) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Неправильний логін або пароль.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Логін')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Логін'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Увійти'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
              child: const Text('Ще не має акаунта? Зареєструватися'),
            ),
          ],
        ),
      ),
    );
  }
}
