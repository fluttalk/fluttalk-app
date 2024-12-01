import 'package:fluttalk/data/models/message_model.dart';

class ChatModel {
  final String id;
  final String title;
  final List<String> members;
  final int createdAt;
  final int updatedAt;
  final MessageModel? lastMessage;

  const ChatModel({
    required this.id,
    required this.title,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['id'],
        title: json['title'],
        members: List<String>.from(json['members']),
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        lastMessage: json['lastMessage'] != null
            ? MessageModel.fromJson(json['lastMessage'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'members': members,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        if (lastMessage != null) 'lastMessage': lastMessage!.toJson(),
      };
}
