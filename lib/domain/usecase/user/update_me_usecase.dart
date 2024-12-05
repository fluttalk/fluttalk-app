import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/data/repositories/user_repository.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fpdart/fpdart.dart';

class UpdateMeUseCase {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  UpdateMeUseCase(
    this._userRepository,
    this._authRepository,
  );

  Future<Either<AppException, MeEntity>> execute({required String name}) async {
    try {
      final account = _authRepository.currentUser;
      if (account == null) {
        return Left(NullUserException());
      }

      final response = await _userRepository.updateMe(name: name);

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

      final user = response.result;
      if (user == null) {
        return const Left(
          NoResultException(),
        );
      }

      return Right(MeEntity.from(
        userModel: user,
        accountModel: account,
      ));
    } catch (e) {
      return Left(
        AppErrorHandler.handle(e),
      );
    }
  }
}
