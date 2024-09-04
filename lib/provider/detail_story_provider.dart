import 'package:flutter/material.dart';
import 'package:storyflutter/api/api_service.dart';
import 'package:storyflutter/constant/result_state.dart';
import 'package:storyflutter/model/detail_stories.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailStoryProvider({required this.apiService});

  DetailStories? _detailStories;
  ResultState? _resultState;
  String _message = "";

  DetailStories? get detailStories => _detailStories;
  ResultState? get resultState => _resultState;
  String get message => _message;

  Future<dynamic> fetchDetail(String token, String id) async {
    try {
      _resultState = ResultState.loading;
      notifyListeners();
      var response = await ApiService().getDetailStory(token, id);
      if (response.error == false) {
        _resultState = ResultState.hasData;
        _message = response.message;
        notifyListeners();
        return _detailStories = response;
      } else {
        _resultState = ResultState.noData;
        notifyListeners();
        return _message = response.message;
      }
    } catch (e) {
      _resultState = ResultState.error;
      notifyListeners();
      return _message = "Error ==> $e";
    }
  }
}
