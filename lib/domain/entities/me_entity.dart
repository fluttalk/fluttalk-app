import 'package:fluttalk/data/models/account_model.dart';
import 'package:fluttalk/data/models/user_model.dart';

class MeEntity {
  final String id;
  final String email;
  final String? name;
  final DateTime lastSignIn;

  const MeEntity({
    required this.id,
    required this.email,
    this.name,
    required this.lastSignIn,
  });

  factory MeEntity.from({
    required UserModel userModel,
    required AccountModel accountModel,
  }) {
    return MeEntity(
      id: userModel.uid,
      email: userModel.email,
      name: userModel.displayName,
      lastSignIn: accountModel.metadata.lastSignInTime,
    );
  }

  factory MeEntity.fromAccount({
    required AccountModel accountModel,
  }) {
    return MeEntity(
      id: accountModel.uid,
      email: accountModel.email,
      name: accountModel.displayName,
      lastSignIn: accountModel.metadata.lastSignInTime,
    );
  }
}
