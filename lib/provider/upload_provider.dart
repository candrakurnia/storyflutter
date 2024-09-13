import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:storyflutter/api/api_service.dart';
import 'package:storyflutter/model/upload_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadProvider extends ChangeNotifier {
  final ApiService apiService;

  UploadProvider({required this.apiService});

  bool isUploading = false;
  String message = "";
  UploadResponse? uploadResponse;
  String? imagePath;
  XFile? imagefile;
  String? text;

  void setImageFile(XFile? value) {
    imagefile = value;
    notifyListeners();
  }

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setText(String? value) {
    text = value;
    notifyListeners();
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image =  img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      ///
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }

  Future<void> upload(
    List<int> bytes,
    String fileName,
    String description
  ) async {
    try {
      message = "";
      uploadResponse = null;
      isUploading = true;
      notifyListeners();
      final sharedPref = await SharedPreferences.getInstance();
      final token = sharedPref.getString("token") ?? "";
      if (token.isEmpty) {
        print("Token kosong");
      }
      uploadResponse =
          await ApiService().sendPhoto(bytes, fileName, description, token);
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
