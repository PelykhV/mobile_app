import 'dart:async';
import 'dart:math'; // для генерації випадкових значень
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef OnMessageReceived = void Function(String message);

class MqttService {
  final _client = MqttServerClient(
    'broker.hivemq.com', // Оновлений брокер
    'flutter_curtain_${DateTime.now().millisecondsSinceEpoch}',
  );

  final String publishTopic = 'curtain/set';
  final String subscribeTopic = 'curtain/status';

  OnMessageReceived? onCurtainPositionReceived;

  final logger = Logger();
  Timer? _timer; // Для автоматичної зміни позиції

  Future<void> connect() async {
    _client.port = 1883; // Порт для незашифрованого з'єднання
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_curtain_client')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMess;

    try {
      await _client.connect();
    } catch (e) {
      logger.e('MQTT Connection failed: $e');
      _client.disconnect();
      return;
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      logger.i('✅ MQTT Connected');
      _client.subscribe(subscribeTopic, MqttQos.atMostOnce);

      // Запускаємо таймер для зміни позиції кожні 5 секунд
      _startRandomPositionUpdate();

      _client.updates!.listen(
        (List<MqttReceivedMessage<MqttMessage>> messages) {
          final recMess = messages[0].payload as MqttPublishMessage;
          final payload = MqttPublishPayload.bytesToStringAsString(
            recMess.payload.message,
          );
          logger.i('📥 Curtain Position Received: $payload');

          onCurtainPositionReceived?.call(payload);
        },
      );
    }
  }

  void _startRandomPositionUpdate() {
    // Запускаємо таймер для зміни позиції кожні 5 секунд
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final randomPosition = Random().nextInt(101);
      publishCurtainPosition(randomPosition.toString());
      logger.i('🔄 Curtain moved to: $randomPosition%');
    });
  }

  void publishCurtainPosition(String position) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(position);

    _client.publishMessage(
      publishTopic,
      MqttQos.atMostOnce,
      builder.payload!,
    );
    logger.i('📤 Curtain Position Published: $position');
  }

  void disconnect() {
    _timer?.cancel(); // Зупиняємо таймер перед відключенням
    _client.disconnect();
  }

  void onDisconnected() {
    logger.w('⚠️ MQTT Disconnected');
  }

  void onConnected() {
    logger.i('🔌 MQTT Connected callback');
  }
}
