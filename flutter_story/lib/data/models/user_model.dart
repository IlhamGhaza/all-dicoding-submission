import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String userId,
    required String name,
    required String token,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

User userFromJsonWithToken(Map<String, dynamic> json, String token) {
  return User(userId: json['userId'] ?? '', name: json['name'] ?? '', token: token);
}
