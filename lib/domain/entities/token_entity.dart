import 'package:fluttalk/data/models/token_model.dart';

class TokenEntity {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory TokenEntity.from(TokenModel model) => TokenEntity(
        accessToken: model.accessToken,
        refreshToken: model.refreshToken,
        expiresAt: DateTime.fromMillisecondsSinceEpoch(model.expiresIn),
      );
}
