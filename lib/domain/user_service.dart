// ignore_for_file: lines_longer_than_80_chars

import 'package:lab1/data/user_repository.dart';

class UserService {
  final IUserRepository _repository;

  UserService(this._repository);

  Future<void> register(String username, String email, String password) async {
    await _repository.saveUser(username: username, email: email, password: password);
    await _repository.setLoggedIn(username);
  }

  Future<Map<String, String>?> getUserData() async {
    final username = await _repository.getLoggedInUser();
    if (username == null) return null;

    return await _repository.getUser(username);
  }

  Future<bool> login(String username, String password) async {
    final user = await _repository.getUser(username);
    if (user != null && user['password'] == password) {
      await _repository.setLoggedIn(username);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _repository.clearSession();
  }
}
