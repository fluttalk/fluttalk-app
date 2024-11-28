class User {
  final String uid;
  final String? email;
  final String? displayName;
  final List<String> friendIds; // Firebase에 저장되는 User 모델에는 friendIds가 있네요

  const User({
    required this.uid,
    this.email,
    this.displayName,
    required this.friendIds,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      friendIds: List<String>.from(json['friendIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        if (email != null) 'email': email,
        if (displayName != null) 'displayName': displayName,
        'friendIds': friendIds,
      };
}
