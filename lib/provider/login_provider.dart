import 'package:flutter/foundation.dart';
import 'package:storyflutter/api/api_service.dart';
import 'package:storyflutter/constant/result_state.dart';
import 'package:storyflutter/model/login_model.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService apiService;

  LoginProvider({
    required this.apiService,
  });

  late LoginModel _loginModel;
  late ResultState _resultState;
  String _message = "";
  bool isLoadingLogin = false;

  String get message => _message;
  LoginModel get loginModel => _loginModel;
  ResultState get state => _resultState;

  Future<dynamic> postLogin(email, password) async {
    try {
      _resultState = ResultState.loading;
      isLoadingLogin = true;
      notifyListeners();
      final result = await ApiService().goLogin(email, password);
      print("object result ${result.error}");
      if (result.error == false) {
        _resultState = ResultState.hasData;
        isLoadingLogin = false;
        notifyListeners();
        return _loginModel = result;
      } else if (result.error == true) {
        _resultState = ResultState.noData;
        isLoadingLogin = false;
        notifyListeners();
        return _message = result.message;
      }
    } catch (e) {
      _resultState = ResultState.error;
      isLoadingLogin = false;
      print("error hit login $e");
      notifyListeners();
      return _message = "error ==> $e";
    }
  }
}
