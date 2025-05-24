import 'dart:io';
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
        ),
        super(const ChatBotState());

  void sendMessage(String message, {File? imageFile}) async {
    // Validate input
    if (message.trim().isEmpty && imageFile == null) return;

    // Validate image file if provided
    if (imageFile != null) {
      if (!_chatBotService.isValidImageFile(imageFile)) {
        _showErrorMessage('Định dạng ảnh không được hỗ trợ. Vui lòng chọn ảnh JPG, PNG, WebP, HEIC hoặc GIF.');
        return;
      }

      // Check file size (optional)
      final isValidSize = await _chatBotService.isFileSizeValid(imageFile);
      if (!isValidSize) {
        _showErrorMessage('Kích thước ảnh quá lớn. Vui lòng chọn ảnh nhỏ hơn 20MB.');
        return;
      }
    }

    // Create user message
    final userMessage = ChatBotMessageModel(
      content: message.isEmpty ? 'Hãy phân tích ảnh này' : message,
      isUser: true,
      imageFile: imageFile,
    );

    // Create loading message
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
      String response;

      if (imageFile != null) {
        // Call API with image
        response = await _chatBotService.generateContentWithImage(
          message.isEmpty ? 'Hãy mô tả và phân tích ảnh này một cách chi tiết' : message,
          imageFile,
        );
      } else {
        // Call API with text only
        response = await _chatBotService.generateContent(message);
      }

      // Update messages
      final List<ChatBotMessageModel> updatedMessages = [...state.messages];
      updatedMessages.removeLast(); // Remove loading message
      updatedMessages.add(ChatBotMessageModel(
        content: response,
        isUser: false,
      ));

      emit(state.copyWith(
        messages: updatedMessages,
        isLoading: false,
      ));
    } catch (e) {
      print('ChatBot Error: $e');
      _handleError(e.toString());
    }
  }

  void _showErrorMessage(String errorMessage) {
    final errorMessageModel = ChatBotMessageModel(
      content: errorMessage,
      isUser: false,
    );

    emit(state.copyWith(
      messages: [...state.messages, errorMessageModel],
      isLoading: false,
    ));
  }

  void _handleError(String errorDetails) {
    final List<ChatBotMessageModel> updatedMessages = [...state.messages];
    updatedMessages.removeLast(); // Remove loading message
    updatedMessages.add(ChatBotMessageModel(
      content: 'Xin lỗi, tôi không thể xử lý yêu cầu của bạn lúc này. Vui lòng thử lại sau.',
      isUser: false,
    ));

    emit(state.copyWith(
      messages: updatedMessages,
      isLoading: false,
    ));
  }

  void clearChat() {
    emit(const ChatBotState());
  }

  void retryLastMessage() {
    if (state.messages.isNotEmpty) {
      final lastUserMessage = state.messages
          .where((message) => message.isUser)
          .lastOrNull;

      if (lastUserMessage != null) {
        // Remove the last bot response (error message)
        final messagesWithoutLastBot = state.messages
            .where((message) => message != state.messages.last || message.isUser)
            .toList();

        emit(state.copyWith(messages: messagesWithoutLastBot));

        // Retry with the same message and image
        sendMessage(
          lastUserMessage.content,
          imageFile: lastUserMessage.imageFile,
        );
      }
    }
  }
}