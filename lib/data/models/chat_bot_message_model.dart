class ChatBotMessageModel {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  ChatBotMessageModel({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
    this.isLoading = false,
  }) : timestamp = timestamp ?? DateTime.now();
}