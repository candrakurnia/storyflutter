// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
    bool error;
    String message;

    RegisterModel({
        required this.error,
        required this.message,
    });

    factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        error: json["error"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
    };
}
