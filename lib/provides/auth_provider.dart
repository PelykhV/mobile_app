import 'package:flutter/material.dart';
import 'package:lab1/data/user_repository.dart';

class AuthProvider with ChangeNotifier {
  final IUserRepository _userRepository = UserRepository();
  Map<String, String>? _user;

  Map<String, String>? get user => _user;

  Future<void> loadUser() async {
    final username = await _userRepository.getLoggedInUser();
    if (username != null) {
      _user = await _userRepository.getUser(username);
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    final userData = await _userRepository.getUser(username);
    if (userData != null && userData['password'] == password) {
      _user = userData;
      await _userRepository.setLoggedIn(username);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _userRepository.clearSession();
    _user = null;
    notifyListeners();
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    await _userRepository.saveUser(
      username: username,
      email: email,
      password: password,
    );
    _user = {
      'username': username,
      'email': email,
      'password': password,
    };
    await _userRepository.setLoggedIn(username);
    notifyListeners();
  }
}
