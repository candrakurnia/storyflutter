import 'package:flutter/foundation.dart';
import 'package:storyflutter/api/api_service.dart';
import 'package:storyflutter/constant/result_state.dart';
import 'package:storyflutter/model/register_model.dart';

class RegisterProvider extends ChangeNotifier {
  final ApiService apiService;

  RegisterProvider({required this.apiService});

  late RegisterModel _registerModel;
  late ResultState _resultState;
  String _message = "";
  bool isLoadingRegister = false;

  String get message => _message;
  RegisterModel get registerModel => _registerModel;
  ResultState get state => _resultState;

  Future<dynamic> postRegister(String name, String email, String password) async {
    try {
      _resultState = ResultState.loading;
      isLoadingRegister = true;
      notifyListeners();
      var result = await ApiService().goRegister(email, password, name);
      print(result);
      if (result.error == false) {
        _resultState = ResultState.hasData;
        isLoadingRegister = false;
        notifyListeners();
        return _message = result.message;
      } else if (result.error == true) {
        _resultState = ResultState.noData;
        isLoadingRegister = false;
        notifyListeners();
        return _message = result.message;
      }
    } catch (e) {
      _resultState = ResultState.error;
      isLoadingRegister = false;
      notifyListeners();
      return _message = "error ==> $e";
    }
  } 
}
