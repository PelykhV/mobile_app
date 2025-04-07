import 'package:flutter/material.dart';
import 'package:lab1/widgets/custom_button.dart';
import 'package:lab1/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вхід')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomTextField(label: 'Email'),
            const SizedBox(height: 16),
            const CustomTextField(label: 'Пароль', isPassword: true),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Увійти',
              onPressed: () => Navigator.pushNamed(context, '/home'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Реєстрація'),
            ),
          ],
        ),
      ),
    );
  }
}
