import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ottstudy/data/models/chat_bot_message_model.dart';
import 'package:ottstudy/ui/widget/base_button.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/res/colors.dart';
import 'package:ottstudy/ui/widget/base_text_input.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../blocs/base_bloc/chat_bot_state.dart';
import '../../../blocs/chat_bot_cubit.dart';
import '../../../gen/assets.gen.dart';
import '../../widget/custom_snack_bar.dart';

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
  File? _image;
  final picker = ImagePicker();

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

  Future showPickImageOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const CustomTextLabel(
                  'Camera',
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  getImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const CustomTextLabel(
                  'Thư viện',
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImagesFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future pickImagesFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future getImageFromCamera() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } else if (status.isPermanentlyDenied) {
      CustomSnackBar.showMessage(context, mess: "Quyền truy cập camera bị từ chối");
    }
  }

  void _removeSelectedImage() {
    setState(() {
      _image = null;
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
                  if (state.messages.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.images.imgGirlHome.image(scale: 2),
                        const SizedBox(height: 20,),
                        const CustomTextLabel('Xin chào! mình là trợ lý ảo của bạn.\nCó thắc mắc gì đừng ngại hỏi '
                            'mình '
                            'nhé!', textAlign: TextAlign.center, fontSize: 15, gradient: AppColors.base_gradient_1,
                          fontWeight: FontWeight.bold,)
                      ],
                    );
                  }
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
            // Preview selected image
            if (_image != null) Align(alignment: Alignment.centerLeft, child: _buildImagePreview()),
            _buildInputField()
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gray.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: -8,
            right: -8,
            child: IconButton(
              onPressed: _removeSelectedImage,
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image if exists
            if (message.hasImage && message.imageFile != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    message.imageFile!,
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
              ),
            // Display loading or text content
            message.isLoading
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
          ],
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
              onPressed: showPickImageOptions,
              icon: Icon(
                Icons.image_outlined,
                color: _image != null ? AppColors.base_pink : AppColors.gray,
              ),
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
                if (message.isNotEmpty || _image != null) {
                  context.read<ChatBotCubit>().sendMessage(
                    message,
                    imageFile: _image,
                  );
                  _messageController.clear();
                  _removeSelectedImage();
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