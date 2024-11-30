class Message {
  final String chatId;
  final String sender;
  final String content;
  final int sendedAt;

  const Message({
    required this.chatId,
    required this.sender,
    required this.content,
    required this.sendedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
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
