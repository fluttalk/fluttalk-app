class FriendEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final bool disabled;
  final bool emailVerified;

  const FriendEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.disabled,
    required this.emailVerified,
  });

  FriendEntity copyWith({
    String? name,
    String? photoUrl,
    bool? disabled,
    bool? emailVerified,
  }) =>
      FriendEntity(
        id: id,
        email: email,
        name: name ?? this.name,
        photoUrl: photoUrl ?? this.photoUrl,
        disabled: disabled ?? this.disabled,
        emailVerified: emailVerified ?? this.emailVerified,
      );
}
