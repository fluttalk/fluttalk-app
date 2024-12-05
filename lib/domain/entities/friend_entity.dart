import 'package:fluttalk/data/models/user_model.dart';

class FriendEntity {
  final String id;
  final String email;
  final String? name;

  const FriendEntity({
    required this.id,
    required this.email,
    this.name,
  });

  factory FriendEntity.fromUserModel(UserModel userModel) {
    return FriendEntity(
      id: userModel.uid,
      email: userModel.email,
      name: userModel.displayName,
    );
  }
}
