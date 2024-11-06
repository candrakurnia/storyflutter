import 'dart:convert';

import 'package:storyflutter/model/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String stateKey = "state";
  final String userKey = "user";
  final String token = 'token';
  final String session = 'sessionKey';

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, true);
  }

  Future<bool> setToken(String session) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(token, session);
  }

  Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getString('token') ?? "";
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(token, "");
  }

  Future<bool> saveSession(Session session) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString('sessionKey', jsonEncode(session.toJson()));
  }

  Future<Session?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final jsonString = preferences.getString('sessionKey') ?? "";
    Session? user;
    if (jsonString != null && jsonString.isNotEmpty) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      user = Session.fromJson(json);
    } catch (e) {
      user = null;
    }
  }
    return user;
  }
}