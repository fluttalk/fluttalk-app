class MessageModel {
  final String chatId;
  final String sender;
  final String content;
  final int sendedAt;

  const MessageModel({
    required this.chatId,
    required this.sender,
    required this.content,
    required this.sendedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        chatId: json['chatId'],
        sender: json['sender'],
        content: json['content'],
        sendedAt: json['sendedAt'],
      );

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'sender': sender,
        'content': content,
        'sendedAt': sendedAt,
      };
}
