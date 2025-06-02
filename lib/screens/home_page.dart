import 'package:flutter/foundation.dart'; // для compute
import 'package:flutter/material.dart';
import 'package:lab1/services/serial_service.dart';

bool checkLightBelow50(double value) {
  return value < 50;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _curtainPosition = 0;
  final SerialService _serialService = SerialService.instance;

  @override
  void initState() {
    super.initState();
    _initSerial();
  }

  Future<void> _initSerial() async {
    // Тут треба вибрати пристрій і відкрити порт.
    // Якщо у тебе вже є логіка вибору пристрою — виконай її.
    final devices = await _serialService.getAvailableDevices();

    if (devices.isNotEmpty) {
      final bool opened = await _serialService.setPort(devices.first);
      if (opened) {
        _readPositionFromPort();
      } else {
        // Обробка помилки відкриття порту
      }
    } else {
      // Пристрої не знайдені
    }
  }

  Future<void> _readPositionFromPort() async {
    final data = await _serialService.readSavedData();
    if (data != null) {
      final double newPos = double.tryParse(data) ?? 0.0;
      setState(() {
        _curtainPosition = newPos;
      });

      final bool isLowLight = await compute(checkLightBelow50, newPos);
      if (isLowLight && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Світло нижче 50%'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _sendCurtainPosition(double position) async {
    final success = await _serialService.sendData(position.toString());
    if (!success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Помилка надсилання позиції')),
        );
      }
    }
  }

  @override
  void dispose() {
    _serialService.closePort();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Розумні штори'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Позиція штор:', style: TextStyle(fontSize: 20)),
          Slider(
            value: _curtainPosition,
            onChanged: (value) async {
              setState(() {
                _curtainPosition = value;
              });
              await _sendCurtainPosition(value);
            },
            max: 100,
            label: '${_curtainPosition.toInt()}%',
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _curtainPosition = 0;
              });
              await _sendCurtainPosition(0);
            },
            child: const Text('Закрити штори'),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _curtainPosition = 100;
              });
              await _sendCurtainPosition(100);
            },
            child: const Text('Відкрити штори'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Наприклад, оновити позицію зі серійного порту вручну
              await _readPositionFromPort();
            },
            child: const Text('Оновити позицію зі серійного порту'),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/scan') as String?;
              if (result != null && mounted) {
                showDialog<void>(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Результат QR-коду'),
                    content: Text(result),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Сканувати QR-код'),
          ),
        ],
      ),
    );
  }
}
