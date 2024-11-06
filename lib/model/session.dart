import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  String? session;
  String? token;

  Session({
    this.session,
    this.token,
  });

  @override
  String toString() => 'User(session: $session, token: $token)';

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Session && other.session == session && other.token == token;
  }

  @override
  int get hashCode => Object.hash(session, token);
}
