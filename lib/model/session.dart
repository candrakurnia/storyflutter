import 'dart:convert';

class Session {
  String? session;
  String? token;

  Session({
    this.session,
    this.token,
  });
 
  @override
  String toString() => 'User(session: $session, token: $token)';

   Map<String, dynamic> toMap() {
    return {
      'session': session,
      'token': token,
    };
  }
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      session: map['session'],
      token: map['token'],
    );
  }
  String toJson() => json.encode(toMap());
  factory Session.fromJson(String source) => Session.fromMap(json.decode(source));

   @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Session &&
      other.session == session &&
      other.token == token;
  }
  @override
  int get hashCode => Object.hash(session, token); 

}