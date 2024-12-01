class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool disabled;
  final bool emailVerified;
  final List<String> friendIds;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.disabled,
    required this.emailVerified,
    required this.friendIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoUrl: json['photoURL'],
      disabled: json['disabled'] ?? false,
      emailVerified: json['emailVerified'] ?? false,
      friendIds: List<String>.from(json['friendIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        if (email != null) 'email': email,
        if (displayName != null) 'displayName': displayName,
        if (photoUrl != null) 'photoURL': photoUrl,
        'disabled': disabled,
        'emailVerified': emailVerified,
        'friendIds': friendIds,
      };
}
