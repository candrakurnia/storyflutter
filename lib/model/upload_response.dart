import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'upload_response.g.dart';

UploadResponse uploadResponseFromJson(String str) =>
    UploadResponse.fromJson(json.decode(str));

String uploadResponseToJson(UploadResponse data) => json.encode(data.toJson());

@JsonSerializable()
class UploadResponse {
  final bool error;
  final String message;

  UploadResponse({
    required this.error,
    required this.message,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseFromJson(json);
  // UploadResponse(
  //     error: json["error"],
  //     message: json["message"],
  // );

  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);
  // {
  //     "error": error,
  //     "message": message,
  // };
}
