import 'dart:io';

class ChatBotMessageModel {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;
  final File? imageFile;
  final String? imagePath;

  ChatBotMessageModel({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
    this.isLoading = false,
    this.imageFile,
    this.imagePath,
  }) : timestamp = timestamp ?? DateTime.now();

  // Helper method để kiểm tra có ảnh không
  bool get hasImage => imageFile != null || (imagePath != null && imagePath!.isNotEmpty);

  // Helper method để lấy file ảnh
  File? get getImageFile {
    if (imageFile != null) return imageFile;
    if (imagePath != null && imagePath!.isNotEmpty) {
      return File(imagePath!);
    }
    return null;
  }

  // Copy with method for state management
  ChatBotMessageModel copyWith({
    String? content,
    bool? isUser,
    DateTime? timestamp,
    bool? isLoading,
    File? imageFile,
    String? imagePath,
  }) {
    return ChatBotMessageModel(
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      imageFile: imageFile ?? this.imageFile,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'ChatBotMessageModel{content: $content, isUser: $isUser, timestamp: $timestamp, isLoading: $isLoading, hasImage: $hasImage}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChatBotMessageModel &&
              runtimeType == other.runtimeType &&
              content == other.content &&
              isUser == other.isUser &&
              timestamp == other.timestamp &&
              isLoading == other.isLoading &&
              imageFile?.path == other.imageFile?.path &&
              imagePath == other.imagePath;

  @override
  int get hashCode =>
      content.hashCode ^
      isUser.hashCode ^
      timestamp.hashCode ^
      isLoading.hashCode ^
      imageFile!.path.hashCode ^
      imagePath.hashCode;
}