import 'package:dio/dio.dart';
import 'package:fluttalk/data/models/chat_model.dart';
import 'package:fluttalk/core/api/pagination_response.dart';

class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  Future<PaginationResponse<ChatModel>> getChats(GetChatsQuery query) async {
    final response = await _dio.get(
      'getChats',
      queryParameters: query.toQueryParameters(),
    );

    return PaginationResponse.fromJson(
      response.data,
      (json) => ChatModel.fromJson(json),
    );
  }

  Future<ChatModel> createChat(CreateChatRequest request) async {
    final response = await _dio.post(
      'createChat',
      data: request.toJson(),
    );
    return ChatModel.fromJson(response.data['result']);
  }
}

class GetChatsQuery {
  final String? startAt;

  const GetChatsQuery({this.startAt});

  Map<String, dynamic>? toQueryParameters() {
    if (startAt == null) return null;
    return {'startAt': startAt};
  }
}

class CreateChatRequest {
  final String email;
  final String title;

  const CreateChatRequest({
    required this.email,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'title': title,
    };
  }
}
