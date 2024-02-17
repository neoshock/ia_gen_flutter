import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/request_model_gpt.dart';
import '../model/response_model_gpt.dart';

class GptApiService {
  final rootUrl = 'https://api.openai.com/v1/chat/completions';
  final apiKey = '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';

  Future<ResponseModelGpt?> getGptResponse(String prompt) async {
    final RequestModelGPT requestModelGPT = RequestModelGPT(
      'gpt-4',
      [
        RequestMessageGPT('system',
            "You are a programming assistant specialized in Flutter. Generate code examples using Material 3, focusing exclusively on interface design and widget construction. Begin the code with a randomly generated color palette named 'theme', which includes 'primaryColor', 'secondaryHeaderColor', and 'scaffoldBackgroundColor' defined as hexadecimal values (e.g., 0xFF311B92). No explanations or additional comments are required, only the code."),
        RequestMessageGPT('system',
            "The code must include the 'theme' color palette defined with hexadecimal colors at the beginning and follow with the application's structure, including the ThemeData configuration using Material 3. The designs should be complete, functional, and adaptive, not exceeding 300 lines. Use only material design components, without external libraries. Generate the code from start to end without any additional messages or comments, and include validations for nullable elements."),
        RequestMessageGPT('system',
            "All interfaces should have input fields with rounded borders of 15 and use an ElevatedButton with a height of 45 for consistency. The color palette should be placed as a constant 'theme' right after 'void main()'."),
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
