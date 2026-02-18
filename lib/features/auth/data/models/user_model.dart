import '../../domain/entities/user_entity.dart';

/// User model for data layer
class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String email,
    String? name,
    String? photoUrl,
  }) : super(
          id: id,
          email: email,
          name: name,
          photoUrl: photoUrl,
        );

  /// Create a model from raw auth values.
  factory UserModel.fromAuthData({
    required String id,
    required String email,
    String? name,
    String? photoUrl,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
    );
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
        photoUrl: json['photoUrl'] as String?,
      );

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'photoUrl': photoUrl,
      };
}
