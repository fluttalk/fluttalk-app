import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class RevokeTokenUseCase {
  final AuthRepository _authRepository;

  RevokeTokenUseCase(this._authRepository);

  Future<Either<AppException, Unit>> execute() async {
    try {
      await _authRepository.revokeToken();
      return const Right(unit);
    } catch (e) {
      return Left(
        AppErrorHandler.handle(e),
      );
    }
  }
}
