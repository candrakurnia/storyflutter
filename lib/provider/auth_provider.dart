import 'package:flutter/material.dart';
import 'package:storyflutter/core.dart';
import 'package:storyflutter/db/auth_repository.dart';
import 'package:storyflutter/model/session.dart';
import 'package:storyflutter/model/user.dart';
import 'package:storyflutter/provider/all_stories_provider.dart';

class AuthProvider extends ChangeNotifier{
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
    var saveSession = await authRepository.saveUser2(session);
    print("save session : $saveSession");
    notifyListeners();
    final sessionUser = await authRepository.getUser();
    print("session $session");
    print("sessionUser $sessionUser");
    if (session == sessionUser) {
      authRepository.login();
      await authRepository.setToken(session.token!);
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
  }

  void getAllStories(AllStoriesProvider allStoriesProvider) async {
    final token = await authRepository.getToken();

    if (token.isEmpty) {
      return;
    }

    await allStoriesProvider.fetchallStories(token);
    notifyListeners();

  }

  //  void getDetailStories(DetailStoryProvider detailStoryProvider) async {
  //   final token = await authRepository.getToken();

  //   if (token.isEmpty) {
  //     return;
  //   }

  //   await detailStoryProvider.fetchDetail(token, );
  //   notifyListeners();

  // }

  Future<void> gettingToken() async {
    _token = await authRepository.getToken();
    print("data token $_token");
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
  Future<bool> saveUser(User user) async {
    isLoadingRegister = true;
    notifyListeners();
    final userState = await authRepository.saveUser(user);
    isLoadingRegister = false;
    notifyListeners();
    return userState;
  }
}