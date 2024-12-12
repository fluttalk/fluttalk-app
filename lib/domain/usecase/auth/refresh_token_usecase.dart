import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/domain/entities/token_entity.dart';
import 'package:fpdart/fpdart.dart';

class RefreshTokenUseCase {
  final AuthRepository _authRepository;

  RefreshTokenUseCase(this._authRepository);

  Future<Either<AppException, TokenEntity>> execute() async {
    try {
      final response = await _authRepository.refreshToken();

      if (response.code != null) {
        final code = response.code ?? 500;
        final message = response.message ?? '알 수 없는 오류가 발생했습니다';
        return Left(
          ApiException(
            code: code,
            message: message,
          ),
        );
      }

      final token = response.result;
      if (token == null) {
        return const Left(
          NoResultException(),
        );
      }

      return Right(TokenEntity.from(token));
    } catch (e) {
      return Left(
        AppErrorHandler.handle(e),
      );
    }
  }
}
