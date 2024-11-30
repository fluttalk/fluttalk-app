import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Either<AppException, void>> execute() async {
    try {
      await _repository.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
