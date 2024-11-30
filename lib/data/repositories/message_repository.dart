import 'package:dio/dio.dart';
import 'package:fluttalk/data/models/message.dart';

class MessageRepository {
  final Dio _dio;
  MessageRepository(this._dio);

  Future<Message> sendMessage(SendMessageRequest request) async {
    final response = await _dio.post(
      'sendMessage',
      data: request.toJson(),
    );
    return Message.fromJson(response.data['result']);
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
