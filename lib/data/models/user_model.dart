class UserModel {
  final String uid;
  final String email;
  final String? displayName;

  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'],
        email: json['email'],
        displayName: json['displayName']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      if (displayName != null) 'displayName': displayName,
    };
  }
}
