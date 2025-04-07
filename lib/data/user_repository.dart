import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IUserRepository {
  Future<void> saveUser({
    required String username,
    required String email,
    required String password,
  });

  Future<Map<String, String>?> getUser(String username);
  Future<void> setLoggedIn(String username);
  Future<String?> getLoggedInUser();
  Future<void> clearSession();
}

class UserRepository implements IUserRepository {
  static const _usersKey = 'users';
  static const _loggedInUserKey = 'loggedInUser';

  @override
  Future<void> saveUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    final Map<String, dynamic> users = usersJson != null
        ? Map<String, dynamic>.from(jsonDecode(usersJson) as Map)
        : {};

    users[username] = {
      'email': email,
      'password': password,
    };

    await prefs.setString(_usersKey, jsonEncode(users));
  }

  @override
  Future<Map<String, String>?> getUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return null;

    final Map<String, dynamic> users =
        Map<String, dynamic>.from(jsonDecode(usersJson) as Map);

    if (!users.containsKey(username)) return null;

    final Map<String, dynamic> userData =
        Map<String, dynamic>.from(users[username] as Map);

    return {
      'username': username,
      'email': userData['email'] as String,
      'password': userData['password'] as String,
    };
  }

  @override
  Future<void> setLoggedIn(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedInUserKey, username);
  }

  @override
  Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loggedInUserKey);
  }

  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInUserKey);
  }
}
