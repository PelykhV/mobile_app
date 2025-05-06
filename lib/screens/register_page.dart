import 'package:flutter/material.dart';
import 'package:lab1/data/user_repository.dart';
import 'package:lab1/domain/user_service.dart';
import 'package:lab1/widgets/custom_button.dart';
import 'package:lab1/widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  final UserService _userService = UserService(UserRepository());

  Future<void> _register() async {
    final username = _loginController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

    // Валідація
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Будь ласка, заповніть всі поля.';
      });
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _errorMessage = 'Некоректний формат email.';
      });
      return;
    }

    // Реєстрація
    await _userService.register(username, email, password);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(label: 'Логін', controller: _loginController),
            const SizedBox(height: 16),
            CustomTextField(label: 'Email', controller: _emailController),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Пароль',
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 16),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Зареєструватися',
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }
}
