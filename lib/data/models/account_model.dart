import 'package:firebase_auth/firebase_auth.dart';

class AccountModel {
  final String uid;
  final String email;
  final String displayName;
  final AccountMetadataModel metadata;

  AccountModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.metadata,
  });

  factory AccountModel.fromFirebaseUser(User user) {
    return AccountModel(
      uid: user.uid,
      email: user.email ?? 'empty',
      displayName: user.displayName ?? '',
      metadata: AccountMetadataModel.fromFirebaseMetadata(user.metadata),
    );
  }
}

class AccountMetadataModel {
  final DateTime lastSignInTime;

  AccountMetadataModel({required this.lastSignInTime});

  factory AccountMetadataModel.fromFirebaseMetadata(UserMetadata metadata) {
    return AccountMetadataModel(
      lastSignInTime: metadata.lastSignInTime ?? DateTime.now(),
    );
  }
}
