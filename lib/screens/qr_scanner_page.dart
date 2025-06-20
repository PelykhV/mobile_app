// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lab1/services/serial_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  void _onDetect(BuildContext context, BarcodeCapture capture) async {
    final barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null) {
      try {
        final Map<String, dynamic> data =
            jsonDecode(code) as Map<String, dynamic>;
        final login = data['login'] as String?;
        final password = data['password'] as String?;

        if (login != null && password != null) {
          // Відправляємо дані на мікроконтролер через Serial
          final success = await SerialService.instance.sendData(
            jsonEncode({'login': login, 'password': password}),
          );

          if (!success) {
            ScaffoldMessenger.of(context).showSnackBar(
              // ignore: lines_longer_than_80_chars
              const SnackBar(content: Text('Помилка надсилання даних через USB')),
            );
            return;
          }

          Navigator.pushReplacementNamed(
            context,
            '/last_message',
            arguments: {
              'login': login,
              'password': password,
            },
          );
        } else {
          throw const FormatException('Відсутні логін або пароль');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Невірний формат QR-коду: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Порожній QR-код')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканування QR-коду')),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: (barcodeCapture) => _onDetect(context, barcodeCapture),
      ),
    );
  }
}
