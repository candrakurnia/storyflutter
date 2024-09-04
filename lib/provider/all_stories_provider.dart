import 'package:flutter/material.dart';
import 'package:storyflutter/api/api_service.dart';
import 'package:storyflutter/constant/result_state.dart';
import 'package:storyflutter/model/all_stories.dart';

class AllStoriesProvider extends ChangeNotifier {
  final ApiService apiService;

  AllStoriesProvider({required this.apiService});

  AllStories? _allStories;
  List<ListStory> data = [];
  ResultState? _state;
  String _message = "";

  AllStories? get allStories => _allStories;
  ResultState? get state => _state;
  String get message => _message;

  Future<dynamic> fetchallStories(String token) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      var response = await ApiService().getAllStories(token);
      if (response.error == false) {
        _state = ResultState.hasData;
        notifyListeners();
        data = data + response.listStory;
        return _allStories = response;
      } else {
        _state = ResultState.noData;
        notifyListeners();
        return _message = response.message;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      print("error $e");
      return _message = "error ==> $e";
      
    }
  }
}
