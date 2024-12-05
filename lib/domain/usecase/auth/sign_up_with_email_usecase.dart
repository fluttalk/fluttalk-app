import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/data/repositories/user_repository.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fpdart/fpdart.dart';

class SignUpWithEmailUseCase {
  final AuthRepository _authRepository;

  SignUpWithEmailUseCase(this._authRepository);

  Future<Either<AppException, MeEntity>> execute({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
      );
      return Right(
        MeEntity.fromAccount(
          accountModel: account,
        ),
      );
    } catch (e) {
      return Left(
        AppErrorHandler.handle(e),
      );
    }
  }
}
