// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'login_model.g.dart';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

@JsonSerializable()
class LoginModel {
  // @JsonKey(name: "login_result")
  bool error;
  String message;
  LoginResult loginResult;

  LoginModel({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
  // LoginModel(
  //     error: json["error"],
  //     message: json["message"],
  //     loginResult: LoginResult.fromJson(json["loginResult"]),
  // );

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
  // {
  //     "error": error,
  //     "message": message,
  //     "loginResult": loginResult.toJson(),
  // };
}

@JsonSerializable()
class LoginResult {
  String userId;
  String name;
  String token;

  LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);
  // LoginResult(
  //     userId: json["userId"],
  //     name: json["name"],
  //     token: json["token"],
  // );

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
  // {
  //     "userId": userId,
  //     "name": name,
  //     "token": token,
  // };
}
