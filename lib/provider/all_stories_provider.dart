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
  // int? pageItems = 1;
  // int sizeItems = 15;
  int _currentPage = 1;
  int _pageSize = 10;
  bool _hasMore = true;

  AllStories? get allStories => _allStories;
  ResultState? get state => _state;
  String get message => _message;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMore => _hasMore;

   //Setter for hasMore
  void setHasMore(bool isHasMore) {
    _hasMore = isHasMore;
    notifyListeners();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  // Setter for pageSize
  void setPageSize(int size) {
    _pageSize = size;
    notifyListeners();
  }

  void nextLoad() {
    _currentPage = _currentPage + 1;
    if (data.length == pageSize) {
      Timer(const Duration(milliseconds: 1000), () {
        setHasMore(true);
      });
    }
  }

  Future<dynamic> fetchallStories() async {
    try {
      if (_currentPage == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }
      final sharedPref = await SharedPreferences.getInstance();
      final token = sharedPref.getString("token") ?? "";
      var response =
          await ApiService().getAllStories(_currentPage,_pageSize,token);
      if (response.error == false) {
        _state = ResultState.hasData;
        // if (response.listStory.length < sizeItems) {
        //   pageItems = null;
        // } else {
        //   pageItems = pageItems! + 1;
        //   print("masuk kesini");
        // }
        notifyListeners();

        data = data + response.listStory;
          if (data.length < pageSize || data.length < 6) {
            setHasMore(false);
          }
        // data = data + response.listStory;
        return _allStories = response;
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
