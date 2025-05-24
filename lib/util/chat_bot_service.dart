import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotService {
  final String apiKey;
  late final GenerativeModel _textModel;
  late final GenerativeModel _visionModel;

  ChatBotService({
    required this.apiKey,
    String? apiUrl, // Not needed for official package
  }) {
    // Model cho text-only
    _textModel = GenerativeModel(
      model: 'gemini-2.0-flash-exp', // hoặc 'gemini-pro'
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );

    // Model cho vision (text + image)
    _visionModel = GenerativeModel(
      model: 'gemini-2.0-flash-exp', // hoặc 'gemini-pro-vision'
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
  }

  // Method cho text only
  Future<String> generateContent(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _textModel.generateContent(content);

      return response.text ?? 'Không có phản hồi';
    } catch (e) {
      print('Error generating text content: $e');
      return 'Xin lỗi, đã xảy ra lỗi: ${e.toString()}';
    }
  }

  // Method cho text + image
  Future<String> generateContentWithImage(String prompt, File imageFile) async {
    try {
      // Đọc bytes từ file ảnh
      final imageBytes = await imageFile.readAsBytes();

      // Xác định MIME type dựa trên extension
      String mimeType = _getMimeType(imageFile.path);

      // Tạo DataPart cho ảnh
      final imagePart = DataPart(mimeType, imageBytes);

      // Tạo content với text và ảnh
      final content = [
        Content.multi([
          TextPart(prompt.isEmpty ? 'Hãy mô tả và phân tích ảnh này một cách chi tiết' : prompt),
          imagePart,
        ])
      ];

      final response = await _visionModel.generateContent(content);

      return response.text ?? 'Không có phản hồi';
    } catch (e) {
      print('Error generating content with image: $e');
      return 'Xin lỗi, đã xảy ra lỗi khi xử lý ảnh: ${e.toString()}';
    }
  }

  // Helper method để xác định MIME type
  String _getMimeType(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'heif':
        return 'image/heif';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg'; // default fallback
    }
  }

  // Method để kiểm tra xem file có phải là ảnh hợp lệ không
  bool isValidImageFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    const validExtensions = ['jpg', 'jpeg', 'png', 'webp', 'heic', 'heif', 'gif'];
    return validExtensions.contains(extension);
  }

  // Method để kiểm tra kích thước file (optional - để tránh file quá lớn)
  Future<bool> isFileSizeValid(File file, {int maxSizeInMB = 20}) async {
    try {
      final fileStat = await file.stat();
      final fileSizeInMB = fileStat.size / (1024 * 1024);
      return fileSizeInMB <= maxSizeInMB;
    } catch (e) {
      print('Error checking file size: $e');
      return false;
    }
  }
}