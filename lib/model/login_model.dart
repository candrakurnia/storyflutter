// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    bool error;
    String message;
    LoginResult loginResult;

    LoginModel({
        required this.error,
        required this.message,
        required this.loginResult,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        error: json["error"],
        message: json["message"],
        loginResult: LoginResult.fromJson(json["loginResult"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "loginResult": loginResult.toJson(),
    };
}

class LoginResult {
    String userId;
    String name;
    String token;

    LoginResult({
        required this.userId,
        required this.name,
        required this.token,
    });

    factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        userId: json["userId"],
        name: json["name"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "token": token,
    };
}
