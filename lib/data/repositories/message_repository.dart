import 'package:dio/dio.dart';
import 'package:fluttalk/core/api/list_response.dart';
import 'package:fluttalk/core/api/pagination_response.dart';
import 'package:fluttalk/core/api/single_response.dart';
import 'package:fluttalk/core/network/end_points.dart';
import 'package:fluttalk/data/models/message_model.dart';

class MessageRepository {
  final Dio _dio;

  MessageRepository(this._dio);

  // 메시지 목록 조회 (페이지네이션)
  Future<PaginationResponse<MessageModel>> getMessages({
    required String chatId,
    String? startAt,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.getMessages,
      queryParameters: {
        'chatId': chatId,
        if (startAt != null) 'startAt': startAt,
      },
    );
    return PaginationResponse.fromJson(
      response.data,
      (json) => MessageModel.fromJson(json),
    );
  }

  // 새 메시지 조회
  Future<ListResponse<MessageModel>> getNewMessages({
    required String chatId,
    required int lastNewestSentAt,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.getNewMessages,
      queryParameters: {
        'chatId': chatId,
        'lastNewestSentAt': lastNewestSentAt,
      },
    );
    return ListResponse.fromJson(
      response.data,
      (json) => MessageModel.fromJson(json),
    );
  }

  // 메시지 전송
  Future<SingleResponse<MessageModel>> sendMessage({
    required String chatId,
    required String content,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.sendMessage,
      data: {
        'chatId': chatId,
        'content': content,
      },
    );
    return SingleResponse.fromJson(
      response.data,
      (json) => MessageModel.fromJson(json),
    );
  }
}
