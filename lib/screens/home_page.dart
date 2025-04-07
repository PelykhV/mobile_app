  import 'package:flutter/material.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    double _curtainPosition = 0;

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
              },
              max: 100,
              label: '${_curtainPosition.toInt()}%',
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                _curtainPosition = 0;
              }),
              child: const Text('Закрити штори'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                _curtainPosition = 100;
              }),
              child: const Text('Відкрити штори'),
            ),
          ],
        ),
      );
    }
  }
