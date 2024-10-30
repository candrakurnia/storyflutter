import 'dart:async';

import 'package:flutter/material.dart';
import 'package:storyflutter/api/api_service.dart';
import 'package:storyflutter/constant/result_state.dart';
import 'package:storyflutter/model/all_stories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllStoriesProvider extends ChangeNotifier {
  final ApiService apiService;

  AllStoriesProvider({required this.apiService});

  AllStories? _allStories;
  List<ListStory> data = [];
  ResultState? _state;
  String _message = "";
  int? pageItems = 1;
  int sizeItems = 10;

  AllStories? get allStories => _allStories;
  ResultState? get state => _state;
  String get message => _message;

  Future<dynamic> fetchallStories() async {
    try {
      if (pageItems == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }
      final sharedPref = await SharedPreferences.getInstance();
      final token = sharedPref.getString("token") ?? "";
      var response =
          await ApiService().getAllStories(pageItems!,sizeItems,token);
      if (response.error == false) {
        _state = ResultState.hasData;
          data.addAll(response.listStory);

        if (response.listStory.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }
        notifyListeners();
      } else {
        _state = ResultState.noData;
        notifyListeners();
        return _message = response.message;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      debugPrint("error $e");
      return _message = "error ==> $e";
    }
  }
}
