import 'package:flutter/foundation.dart'; // для compute
import 'package:flutter/material.dart';
import 'package:lab1/services/mqtt.dart';

// Функція, яку викликає compute у ізоляті
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
  final MqttService _mqttService = MqttService();

  @override
  void initState() {
    super.initState();
    _startMqtt();
  }

  void _startMqtt() {
    _mqttService.onCurtainPositionReceived = (String value) async {
      final double newPos = double.tryParse(value) ?? 0.0;
      setState(() {
        _curtainPosition = newPos;
      });

      // Перевірка в ізоляті
      final bool isLowLight = await compute(checkLightBelow50, newPos);
      if (isLowLight && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Світло нижче 50%'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    };

    _mqttService.connect();
  }

  void _sendCurtainPosition(double position) {
    _mqttService.publishCurtainPosition(position.toString());
  }

  @override
  void dispose() {
    _mqttService.disconnect();
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
            onChanged: (value) {
              setState(() {
                _curtainPosition = value;
              });
              _sendCurtainPosition(value);
            },
            max: 100,
            label: '${_curtainPosition.toInt()}%',
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _curtainPosition = 0;
              });
              _sendCurtainPosition(0);
            },
            child: const Text('Закрити штори'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _curtainPosition = 100;
              });
              _sendCurtainPosition(100);
            },
            child: const Text('Відкрити штори'),
          ),
        ],
      ),
    );
  }
}
