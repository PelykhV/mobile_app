import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> checkInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivity.onConnectivityChanged.map((results) =>
          results.isNotEmpty ? results.first : ConnectivityResult.none,);
}
