import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fluttalk/domain/usecase/user/get_me_usecase.dart';
import 'package:fluttalk/domain/usecase/user/update_me_usecase.dart';
import 'package:fpdart/fpdart.dart';

class UserService {
  final GetMeUseCase _getMeUseCase;
  final UpdateMeUseCase _updateMeUseCase;

  UserService(
    this._getMeUseCase,
    this._updateMeUseCase,
  );

  // 현재 로그인된 사용자의 서버 정보를 가져옵니다
  Future<Either<AppException, MeEntity>> getMe() {
    return _getMeUseCase.execute();
  }

  // 사용자 이름을 업데이트합니다
  Future<Either<AppException, MeEntity>> updateName({
    required String name,
  }) {
    return _updateMeUseCase.execute(name: name);
  }
}
