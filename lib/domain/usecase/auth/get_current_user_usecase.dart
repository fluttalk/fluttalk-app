import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Either<AppException, MeEntity?> execute() {
    try {
      final account = _authRepository.currentUser;
      if (account == null) {
        return const Right(null);
      }
      return Right(
        MeEntity.fromAccount(accountModel: account),
      );
    } catch (e) {
      return Left(
        AppErrorHandler.handle(e),
      );
    }
  }
}
