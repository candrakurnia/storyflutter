import 'package:flutter/material.dart';
import 'package:storyflutter/api/api_service.dart';
import 'package:storyflutter/constant/result_state.dart';
import 'package:storyflutter/core.dart';
import 'package:storyflutter/model/detail_stories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyflutter/provider/auth_provider.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailStoryProvider({required this.apiService});

  DetailStories? _detailStories;
  ResultState? _resultState;
  String _message = "";

  DetailStories? get detailStories => _detailStories;
  ResultState? get resultState => _resultState;
  String get message => _message;

  void fetchDetail(String id) async {
    try {
      _resultState = ResultState.loading;
      notifyListeners();
      final sharedPref = await SharedPreferences.getInstance();
      final token = sharedPref.getString("token") ?? "";
      if (token.isEmpty) {
        print("Token kosong");
      }
      var response = await ApiService().getDetailStory(token, id);
      if (response.error == false) {
        _resultState = ResultState.hasData;
        _message = response.message;
        _detailStories = response;
        notifyListeners();
      } else {
        _resultState = ResultState.noData;
        notifyListeners();
        _message = response.message;
      }
    } catch (e) {
      _resultState = ResultState.error;
      notifyListeners();
      _message = "Error ==> $e";
    }
  }
}
