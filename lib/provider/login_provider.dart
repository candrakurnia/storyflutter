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
      isLoadingLogin = false;
      notifyListeners();
      final result = await ApiService().goLogin(email, password);
      print(result);
      if (result.error == false) {
        _resultState = ResultState.hasData;
        isLoadingLogin = true;
        notifyListeners();
        return _loginModel = result;
      } else {
        _resultState = ResultState.noData;
        isLoadingLogin = true;
        notifyListeners();
        return _message = result.message;
      }
    } catch (e) {
      _resultState = ResultState.error;
      isLoadingLogin = true;
      print("error hit login $e");
      notifyListeners();
      return _message = "error ==> $e";
    }
  }
}
