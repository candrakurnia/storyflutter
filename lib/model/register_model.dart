// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part'register_model.g.dart';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());
@JsonSerializable()
class RegisterModel {
    bool error;
    String message;

    RegisterModel({
        required this.error,
        required this.message,
    });

    factory RegisterModel.fromJson(Map<String, dynamic> json) => _$RegisterModelFromJson(json);
    // RegisterModel(
    //     error: json["error"],
    //     message: json["message"],
    // );

    Map<String, dynamic> toJson() => _$RegisterModelToJson(this);
    // {
    //     "error": error,
    //     "message": message,
    // };
}
