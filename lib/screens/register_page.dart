import 'package:flutter/material.dart';
import 'package:lab1/widgets/custom_button.dart';
import 'package:lab1/widgets/custom_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomTextField(label: 'Ім’я'),
            const SizedBox(height: 16),
            const CustomTextField(label: 'Email'),
            const SizedBox(height: 16),
            const CustomTextField(label: 'Пароль', isPassword: true),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Зареєструватися',
              onPressed: () => Navigator.pushNamed(context, '/home'),
            ),
          ],
        ),
      ),
    );
  }
}
