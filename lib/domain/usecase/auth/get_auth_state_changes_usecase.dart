import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fpdart/fpdart.dart';

class GetAuthStateChangesUseCase {
  final AuthRepository _authRepository;

  GetAuthStateChangesUseCase(this._authRepository);

  Stream<Either<AppException, MeEntity?>> execute() {
    return _authRepository
        .authStateChanges()
        .map<Either<AppException, MeEntity?>>((account) {
      try {
        if (account == null) {
          return const Right(
            null,
          );
        }
        return Right(
          MeEntity.fromAccount(
            accountModel: account,
          ),
        );
      } catch (e) {
        return Left(AppErrorHandler.handle(e));
      }
    });
  }
}
