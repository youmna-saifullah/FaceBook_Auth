/// Entity representing a user's profile in the home feature.
/// 
/// Contains user profile information displayed on the home screen.
class UserProfileEntity {
  /// Unique identifier for the user.
  final String id;

  /// User's email address.
  final String email;

  /// User's display name.
  final String? name;

  /// URL to user's profile photo.
  final String? photoUrl;

  /// Last login timestamp.
  final DateTime? lastLoginAt;

  const UserProfileEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.lastLoginAt,
  });

  /// Creates a copy with updated fields.
  UserProfileEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? lastLoginAt,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileEntity &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.photoUrl == photoUrl &&
        other.lastLoginAt == lastLoginAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        photoUrl.hashCode ^
        lastLoginAt.hashCode;
  }
}
