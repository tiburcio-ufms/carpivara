import 'user.dart';

class Session {
  User user;
  String token;

  Session({required this.token, required this.user});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      token: json['token'],
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}
