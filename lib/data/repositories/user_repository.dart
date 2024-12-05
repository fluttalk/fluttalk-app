import 'package:dio/dio.dart';
import 'package:fluttalk/core/api/single_response.dart';
import 'package:fluttalk/core/network/end_points.dart';
import 'package:fluttalk/data/models/user_model.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<SingleResponse<UserModel>> getMe() async {
    final response = await _dio.get(
      ApiEndpoints.getMe,
    );
    return SingleResponse.fromJson(
      response.data,
      (json) => UserModel.fromJson(json),
    );
  }

  Future<SingleResponse<UserModel>> updateMe({required String name}) async {
    final response = await _dio.put(
      ApiEndpoints.updateMe,
      data: {'name': name},
    );
    return SingleResponse.fromJson(
      response.data,
      (json) => UserModel.fromJson(json),
    );
  }
}
