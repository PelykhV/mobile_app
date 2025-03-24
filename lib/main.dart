import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();

  // Функція для оновлення значення лічильника
  void _updateCounter() {
    final String inputText = _controller.text;

    if (inputText == 'Avada Kedavra') {
      setState(() {
        _counter = 0; // Скидаємо інкремент до 0
      });
    } else {
      try {
        // Перевірка, чи може текст бути перетворений на число
        final int inputNumber = int.parse(inputText);
        setState(() {
          _counter += inputNumber; // Додаємо число до інкременту
        });
      } catch (e) {
        // Якщо текст не можна перетворити на число, просто нічого не робимо
        ScaffoldMessenger.of(context).showSnackBar(
          // ignore: lines_longer_than_80_chars
          const SnackBar(content: Text('Введіть число або "Avada Kedavra" для скидання')),
        );
      }
    }

    // Очищуємо текстове поле після обробки
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введіть число або "Avada Kedavra"',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCounter,
              child: const Text('Оновити інкремент'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
