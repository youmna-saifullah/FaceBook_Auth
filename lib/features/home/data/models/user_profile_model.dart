import '../../domain/entities/user_profile_entity.dart';

/// Data model for user profile with JSON serialization.
/// 
/// Used for data transfer between data sources and domain layer.
class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.lastLoginAt,
  });

  /// Creates a model from JSON map.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      photoUrl: json['photoUrl'] as String?,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  /// Converts model to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  /// Creates a model from domain entity.
  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
      lastLoginAt: entity.lastLoginAt,
    );
  }

  /// Converts to domain entity.
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      lastLoginAt: lastLoginAt,
    );
  }
}
