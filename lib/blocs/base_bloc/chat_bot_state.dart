import 'package:equatable/equatable.dart';

import '../../data/models/chat_bot_message_model.dart';

class ChatBotState extends Equatable {
  final List<ChatBotMessageModel> messages;
  final bool isLoading;

  const ChatBotState({
    this.messages = const [],
    this.isLoading = false,
  });

  ChatBotState copyWith({
    List<ChatBotMessageModel>? messages,
    bool? isLoading,
  }) {
    return ChatBotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading];
}