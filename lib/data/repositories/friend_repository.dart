import 'package:dio/dio.dart';
import 'package:fluttalk/data/models/user_model.dart';

class FriendRepository {
  final Dio _dio;

  FriendRepository(this._dio);

  Future<List<UserModel>> getFriends() async {
    final response = await _dio.get('getFriends');
    return (response.data['results'] as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  Future<UserModel> addFriendByEmail(AddFriendRequest request) async {
    final response = await _dio.post(
      'addFriendByEmail',
      data: request.toJson(),
    );
    return UserModel.fromJson(response.data['result']);
  }

  Future<UserModel> removeFriendByEmail(RemoveFriendRequest request) async {
    final response = await _dio.post(
      'removeFriendByEmail',
      data: request.toJson(),
    );
    return UserModel.fromJson(response.data['result']);
  }
}

class AddFriendRequest {
  final String email;

  const AddFriendRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class RemoveFriendRequest {
  final String email;

  const RemoveFriendRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}
