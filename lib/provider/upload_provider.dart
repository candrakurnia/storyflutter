import 'package:flutter/material.dart';
import 'package:storyflutter/api/api_service.dart';
import 'package:storyflutter/model/upload_response.dart';

class UploadProvider extends ChangeNotifier {
  final ApiService apiService;

  UploadProvider({required this.apiService});
  
  bool isUploading = false;
  String message = "";
  UploadResponse? uploadResponse;

  Future<void> upload(
    List<int> bytes,
    String fileName,
    String description,
  ) async {
    try {
      message = "";
      uploadResponse = null;
      isUploading = true;
      notifyListeners();
      uploadResponse =
          await ApiService().sendPhoto(bytes, fileName, description);
      message = uploadResponse?.message ?? "success";
      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }
}
