import 'package:fluttalk/data/models/message.dart';

class Chat {
  final String id;
  final String title;
  final List<String> members;
  final int createdAt;
  final int updatedAt;
  final Message? lastMessage;

  const Chat({
    required this.id,
    required this.title,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'],
        title: json['title'],
        members: List<String>.from(json['members']),
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        lastMessage: json['lastMessage'] != null
            ? Message.fromJson(json['lastMessage'])
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
