import 'package:dio/dio.dart';
import 'package:fluttalk/data/models/user.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<User> getMe() async {
    final response = await _dio.get('getMe');
    return User.fromJson(response.data['result']);
  }

  Future<User> updateMe(UpdateMeRequest request) async {
    final response = await _dio.post(
      'updateMe',
      data: request.toJson(),
    );
    return User.fromJson(response.data['result']);
  }
}

class UpdateMeRequest {
  final String name;

  const UpdateMeRequest({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}
