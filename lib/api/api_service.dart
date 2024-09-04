import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:storyflutter/model/all_stories.dart';
import 'package:storyflutter/model/detail_stories.dart';
import 'package:storyflutter/model/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:storyflutter/model/register_model.dart';
import 'package:storyflutter/model/upload_response.dart';

class ApiService {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  Future<LoginModel> goLogin(String email, String password) async {
    const String url = "$_baseUrl/login";

    var request = jsonEncode(
      <String, dynamic>{'email': email, 'password': password},
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: request,
    );

    if (response.statusCode == 200) {
      return LoginModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode != 200) {
      return LoginModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load Sign in API");
    }
  }

  Future<RegisterModel> goRegister(
      String email, String password, String username) async {
    const String url = "$_baseUrl/register";

    var request = jsonEncode(
      <String, dynamic>{
        'name': username,
        'email': email,
        'password': password,
      },
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: request,
    );

    if (response.statusCode == 201) {
      return RegisterModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode != 201) {
      return RegisterModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load Register API");
    }
  }

  Future<AllStories> getAllStories(String token) async {
    const String url = "$_baseUrl/stories";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("response story : ${jsonDecode(response.body)}");

    if (response.statusCode == 200) {
      return AllStories.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to get all stories");
    }
  }

  Future<DetailStories> getDetailStory(String token, String id) async {
    String url = "$_baseUrl/stories/$id";

    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      return DetailStories.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to hit API Detail");
    }
  }

  // Future<RegisterModel> sendPhoto(
  //     String token, File image, String description) async {
  //   String url = "$_baseUrl/stories";

  //   final response = await http.MultipartRequest(
  //     "POST",
  //     Uri.parse(url),
  //   );

  //   response.fields['description'] = description;
  //   response.files.add(await http.MultipartFile.fromPath('photo', ))
  // }

  Future<UploadResponse> sendPhoto(
    List<int> bytes,
    String fileName,
    String description,
  ) async {
    const String url = "$_baseUrl/stories";
 
    final uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
 
    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": description,
    };
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
    };
 
    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);
 
    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;
 
    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);
 
    if (statusCode == 201) {
      final UploadResponse uploadResponse = UploadResponse.fromJson(
        responseData,
      );
      return uploadResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
