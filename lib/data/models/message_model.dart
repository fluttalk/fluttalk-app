class MessageModel {
  final String chatId;
  final String sender;
  final String content;
  final int sentAt;

  const MessageModel({
    required this.chatId,
    required this.sender,
    required this.content,
    required this.sentAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        chatId: json['chatId'],
        sender: json['sender'],
        content: json['content'],
        sentAt: json['sentAt'],
      );

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'sender': sender,
        'content': content,
        'sentAt': sentAt,
      };
}
