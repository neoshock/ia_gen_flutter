import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/request_model_gpt.dart';
import '../model/response_model_gpt.dart';

class GptApiService {
  final rootUrl = 'https://api.openai.com/v1/chat/completions';
  final apiKey = '';

  Future<ResponseModelGpt?> getGptResponse(String prompt) async {
    final RequestModelGPT requestModelGPT = RequestModelGPT(
      'gpt-4-0125-preview',
      [
        RequestMessageGPT('system',
            "You are a programming assistant specialized in Flutter. Generate code examples that begin with defining a theme of colors similar to the provided example. The theme should be a Map<String, Color> named 'customTheme' and include colors for 'primary', 'primaryVariant', 'secondary', and 'scaffoldBackgroundColor', each defined as hexadecimal values. No explanations or additional comments are required, only the code."),
        RequestMessageGPT('system',
            "After defining the 'customTheme', use it to configure the ThemeData in a MaterialApp widget. The designs should be complete, functional, and adaptive, aiming for around 200 to 300 lines. Use only material design components, without external libraries. Generate the code from start to end without any additional messages or comments, and include validations for nullable elements. Ensure all interfaces use the colors from 'customTheme' consistently. Don't add accentColor in themeData, not add primary or onPrimary in elevatedButtonTheme is not, it's just backgroundColor."),
        RequestMessageGPT('system',
            "All interfaces should have input fields with rounded borders of 15 and use an ElevatedButton with a height of 45 for consistency. The 'customTheme' should be placed right after 'void main()'."),
        RequestMessageGPT('user', prompt)
      ],
    );

    try {
      final response = await http.post(
        Uri.parse(rootUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode(requestModelGPT.toJson()),
      );
      if (response.statusCode == 200) {
        return ResponseModelGpt.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
