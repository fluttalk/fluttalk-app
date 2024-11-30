class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? photoUrl;
  final String? pushToken;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final List<String> friendIds;
  final bool pushEnabled;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.photoUrl,
    this.pushToken,
    required this.createdAt,
    required this.lastLoginAt,
    required this.friendIds,
    this.pushEnabled = true,
  });

  UserEntity copyWith({
    String? name,
    String? phone,
    String? photoUrl,
    String? pushToken,
    DateTime? lastLoginAt,
    List<String>? friendIds,
    bool? pushEnabled,
  }) =>
      UserEntity(
        id: id,
        email: email,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        photoUrl: photoUrl ?? this.photoUrl,
        pushToken: pushToken ?? this.pushToken,
        createdAt: createdAt,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
        friendIds: friendIds ?? this.friendIds,
        pushEnabled: pushEnabled ?? this.pushEnabled,
      );
}
