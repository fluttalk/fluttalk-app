import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:fluttalk/core/api/pagination_response.dart';
import 'package:fluttalk/core/api/single_response.dart';
import 'package:fluttalk/core/network/end_points.dart';
import 'package:fluttalk/data/models/chat_model.dart';

class ChatRepository {
  final Dio _dio;
  final FirebaseFirestore _firestore;

  ChatRepository(this._dio, this._firestore);

  Future<PaginationResponse<ChatModel>> getChats({
    String? startAt,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.getChats,
      queryParameters: {if (startAt != null) 'startAt': startAt},
    );
    return PaginationResponse.fromJson(
      response.data,
      (json) => ChatModel.fromJson(json),
    );
  }

  Future<SingleResponse<ChatModel>> createChat({
    required String email,
    required String title,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.createChat,
      data: {'email': email, 'title': title},
    );
    return SingleResponse.fromJson(
      response.data,
      (json) => ChatModel.fromJson(json),
    );
  }

  Stream<ChatModel?> watchChat(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      return data != null ? ChatModel.fromJson(data) : null;
    });
  }
}
