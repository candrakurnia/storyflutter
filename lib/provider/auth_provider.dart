import 'package:flutter/material.dart';
import 'package:storyflutter/core.dart';
import 'package:storyflutter/db/auth_repository.dart';
import 'package:storyflutter/model/session.dart';
import 'package:storyflutter/provider/all_stories_provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository) {
    gettingToken();
  }

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  String? _token;
  String? get token => _token;

  // Future<bool> login(User user) async {
  //   isLoadingLogin = true;
  //   notifyListeners();
  //   final userState = await authRepository.getUser();
  //   print("data user $user");
  //   print("data userState $userState");
  //   if (user == userState) {
  //     authRepository.login();
  //   }
  //   isLoggedIn = await authRepository.isLoggedIn();
  //   isLoadingLogin = false;
  //   notifyListeners();
  //   return isLoggedIn;
  // }

  Future<bool> sessionLogin(Session session) async {
    isLoadingLogin = true;
    await authRepository.saveUser2(session);
    // authRepository.setToken(session.token!);
    notifyListeners();
    final sessionUser = await authRepository.getUser();
    if (session == sessionUser) {
      authRepository.login();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogin = false;
    authRepository.setToken(session.token!);
    notifyListeners();
    return isLoggedIn;
  }

  // void getAllStories(AllStoriesProvider allStoriesProvider) async {
  //   final token = await authRepository.getToken();

  //   if (token.isEmpty) {
  //     debugPrint("token ternyata kosong");
  //     return;
  //   } else {
  //     allStoriesProvider.pageItems = 1;
  //     await allStoriesProvider.fetchallStories(token);
  //     debugPrint("token ternyata ada isinya");
  //     notifyListeners();
  //   }
  // }

  void gettingToken() async {
    _token = await authRepository.getToken();
    debugPrint("data token $_token");
    notifyListeners();
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }

  Future<bool> saveUser(Session user) async {
    isLoadingRegister = true;
    notifyListeners();
    final userState = await authRepository.saveUser2(user);
    isLoadingRegister = false;
    notifyListeners();
    return userState;
  }
}
