import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/data/models/chat_bot_message_model.dart';
import 'package:ottstudy/util/chat_bot_service.dart';
import 'base_bloc/chat_bot_state.dart';
import '../data/network/api_constant.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  final ChatBotService _chatBotService;

  ChatBotCubit() :
        _chatBotService = ChatBotService(
            apiKey: ApiConstant.geminiKey,
            apiUrl: ApiConstant.geminiUrl
        ),
        super(const ChatBotState());

  void sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Thêm tin nhắn của người dùng
    final userMessage = ChatBotMessageModel(content: message, isUser: true);

    // Thêm placeholder cho tin nhắn đang loading của bot
    final botLoadingMessage = ChatBotMessageModel(
      content: '...',
      isUser: false,
      isLoading: true,
    );

    emit(state.copyWith(
      messages: [...state.messages, userMessage, botLoadingMessage],
      isLoading: true,
    ));

    try {
      // Gọi API Gemini
      final response = await _chatBotService.generateContent(message);

      // Cập nhật tin nhắn từ bot
      final List<ChatBotMessageModel> updatedMessages = [...state.messages];
      // Xóa tin nhắn loading
      updatedMessages.removeLast();
      // Thêm tin nhắn thật từ bot
      updatedMessages.add(ChatBotMessageModel(
        content: response,
        isUser: false,
      ));

      emit(state.copyWith(
        messages: updatedMessages,
        isLoading: false,
      ));
    } catch (e) {
      print(e);
      // Xử lý lỗi
      final List<ChatBotMessageModel> updatedMessages = [...state.messages];
      // Xóa tin nhắn loading
      updatedMessages.removeLast();
      // Thêm tin nhắn lỗi
      updatedMessages.add(ChatBotMessageModel(
        content: 'Xin lỗi, tôi không thể xử lý yêu cầu của bạn lúc này. Vui lòng thử lại sau.',
        isUser: false,
      ));

      emit(state.copyWith(
        messages: updatedMessages,
        isLoading: false,
      ));
    }
  }

  void clearChat() {
    emit(const ChatBotState());
  }
}