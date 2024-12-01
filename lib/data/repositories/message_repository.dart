import 'package:dio/dio.dart';
import 'package:fluttalk/data/models/message_model.dart';

class MessageRepository {
  final Dio _dio;
  MessageRepository(this._dio);

  Future<MessageModel> sendMessage(SendMessageRequest request) async {
    final response = await _dio.post(
      'sendMessage',
      data: request.toJson(),
    );
    return MessageModel.fromJson(response.data['result']);
  }
}

class SendMessageRequest {
  final String chatId;
  final String content;

  const SendMessageRequest({
    required this.chatId,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'content': content,
      };
}
