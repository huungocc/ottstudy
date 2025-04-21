import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/data/models/chat_bot_message_model.dart';
import 'package:ottstudy/ui/widget/base_button.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/res/colors.dart';
import 'package:ottstudy/ui/widget/base_text_input.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import '../../../blocs/base_bloc/chat_bot_state.dart';
import '../../../blocs/chat_bot_cubit.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBotCubit>(
      create: (_) => ChatBotCubit(),
      child: const ChatBotBody(),
    );
  }
}

class ChatBotBody extends StatefulWidget {
  const ChatBotBody({super.key});

  @override
  State<ChatBotBody> createState() => _ChatBotBodyState();
}

class _ChatBotBodyState extends State<ChatBotBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Chat Bot',
      colorBackground: AppColors.background_white,
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatBotCubit, ChatBotState>(
                listener: (context, state) {
                  _scrollToBottom();
                },
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.messages.length,
                    padding: const EdgeInsets.only(top: 16),
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return _buildMessageBubble(message);
                    },
                  );
                },
              ),
            ),
            _buildInputField()
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatBotMessageModel message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? null
              : Colors.grey.shade200,
          gradient: message.isUser ? AppColors.base_gradient_1 : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: message.isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.base_pink,
          ),
        )
            : CustomTextLabel(
          message.content,
          color: message.isUser ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Row(
      children: [
        Expanded(
          child: CustomTextInput(
            textController: _messageController,
            hintText: 'Nhập tin nhắn...',
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.white, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.white, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            suffixIcon: IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.image_outlined),
            ),
            suffixIconMargin: 0,
          ),
        ),
        const SizedBox(width: 8),
        BlocBuilder<ChatBotCubit, ChatBotState>(
          builder: (context, state) {
            return BaseButton(
              onTap: state.isLoading
                  ? null
                  : () {
                final message = _messageController.text.trim();
                if (message.isNotEmpty) {
                  context.read<ChatBotCubit>().sendMessage(message);
                  _messageController.clear();
                }
              },
              title: 'Gửi',
              height: 42,
              borderRadius: 20,
              titleColor: state.isLoading ? AppColors.gray : AppColors.white,
            );
          },
        ),
      ],
    );
  }
}