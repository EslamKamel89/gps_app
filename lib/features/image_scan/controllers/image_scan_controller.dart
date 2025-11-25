import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/env.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';

class ImageScanController {
  final _api = serviceLocator<Dio>();
  Future<ApiResponseModel<String>> scan({required String imageUrl}) async {
    final t = prt('scan - ImageScanController');
    final body = {
      "model": "deepseek-ai/DeepSeek-OCR",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "image_url",
              "image_url": {"url": imageUrl},
            },
            {"type": "text", "text": _defaultJsonPrompt()},
          ],
        },
      ],
      // "max_tokens": 800,
    };
    try {
      final res = await _api.post(
        EndPoint.deepInfraUrl,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Env.DEEP_INFRA_API_KEY}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      pr(res, t);
      return ApiResponseModel(
        data: _extractDeepInfraContent(res.data),
        response: ResponseEnum.success,
      );
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occurred');
      }
      showSnackbar('Error', errorMessage, true);
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }

  String _defaultJsonPrompt() {
    return "You are an OCR assistant. Analyze the image and produce a short, upbeat english only summary in one single paragraph with no line breaks. The paragraph should be 2–4 sentences long and briefly mention the product name, the key ingredients, the expiry date if present, and any visible certifications. Keep the tone positive, friendly, and slightly humorous (think cheerful and light, not silly). Do NOT include headings, bullet points, JSON, code fences, or extra commentary — only one continuous paragraph. Be concise and helpful.";
  }

  String _extractDeepInfraContent(Map<String, dynamic> json) {
    try {
      final choices = json["choices"];
      if (choices is! List || choices.isEmpty) {
        return "";
      }

      final firstChoice = choices.first;
      if (firstChoice is! Map) return "";

      final message = firstChoice["message"];
      if (message is! Map) return "";

      final content = message["content"];
      if (content is String) {
        return content.trim();
      }

      return "";
    } catch (e) {
      return "";
    }
  }
}
