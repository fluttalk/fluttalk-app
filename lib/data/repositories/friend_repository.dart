import 'package:dio/dio.dart';
import 'package:fluttalk/core/api/list_response.dart';
import 'package:fluttalk/core/api/single_response.dart';
import 'package:fluttalk/core/network/end_points.dart';
import 'package:fluttalk/data/models/user_model.dart';

class FriendRepository {
  final Dio _dio;

  FriendRepository(this._dio);

  Future<ListResponse<UserModel>> getFriends() async {
    final response = await _dio.get(ApiEndpoints.getFriends);
    return ListResponse.fromJson(
      response.data,
      (json) => UserModel.fromJson(json),
    );
  }

  Future<SingleResponse<UserModel>> addFriendByEmail(
      {required String email}) async {
    final response = await _dio.post(
      ApiEndpoints.addFriendByEmail,
      data: {'email': email},
    );
    return SingleResponse.fromJson(
      response.data,
      (json) => UserModel.fromJson(json),
    );
  }

  Future<SingleResponse<UserModel>> removeFriendByEmail(
      {required String email}) async {
    final response = await _dio.delete(
      ApiEndpoints.removeFriendByEmail,
      data: {'email': email},
    );
    return SingleResponse.fromJson(
      response.data,
      (json) => UserModel.fromJson(json),
    );
  }
}
