import 'package:storyflutter/model/session.dart';
import 'package:storyflutter/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {

  final String stateKey = "state";
  final String userKey = "user";
  final String token = 'token';
 
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
    return preferences.getString(token) ?? "";
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  Future<bool> saveUser(User user) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(token, user.toJson());
  }
  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(token, "");
  }

  Future<bool> saveUser2(Session session) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(token, session.toJson());
  }

  Future<Session?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final json = preferences.getString(token) ?? "";
    Session? user;
    try {
      user = Session.fromJson(json);
    } catch (e) {
      user = null;
    }
    return user;
  }
}