import 'package:dio/dio.dart';
import 'package:fluttalk/data/models/user_model.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<UserModel> getMe() async {
    final response = await _dio.get('getMe');
    return UserModel.fromJson(response.data['result']);
  }

  Future<UserModel> updateMe(UpdateMeRequest request) async {
    final response = await _dio.post(
      'updateMe',
      data: request.toJson(),
    );
    return UserModel.fromJson(response.data['result']);
  }
}

class UpdateMeRequest {
  final String name;

  const UpdateMeRequest({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}
