import 'dart:convert';
import 'package:ottstudy/data/network/api_constant.dart';

import '../data/network/network_impl.dart';

class ChatBotService {
  final String apiKey;
  final String apiUrl;
  final Network _network;

  ChatBotService({
    required this.apiKey,
    required this.apiUrl,
    Network? network
  }) : _network = network ?? Network();

  Future<String> generateContent(String prompt) async {
    final url = '$apiUrl?key=$apiKey';

    try {
      final response = await _network.post(
        url: url,
        isOriginData: true,
        body: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        },
      );

      if (response.code == 200) {
        // Kiểm tra kiểu dữ liệu của response.data
        var data;
        if (response.data is String) {
          // Nếu là string, parse thành JSON
          data = jsonDecode(response.data);
        } else if (response.data is Map) {
          // Nếu đã là Map thì dùng trực tiếp
          data = response.data;
        } else {
          throw Exception('Kiểu dữ liệu response không hỗ trợ: ${response.data.runtimeType}');
        }

        // Lấy text từ phần tử trong JSON response
        return data['candidates'][0]['content']['parts'][0]['text'] ?? 'Không có phản hồi';
      } else {
        throw Exception('Lỗi khi gọi API Gemini: ${response.code}');
      }
    } catch (e) {
      return 'Xin lỗi, đã xảy ra lỗi: ${e.toString()}';
    }
  }
}