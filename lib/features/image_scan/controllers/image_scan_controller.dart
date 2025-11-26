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
          "role": "system",
          "content":
              "You are a strict OCR-to-HTML assistant. ALWAYS respond ONLY in English. NEVER output any other language. NEVER output explanation. If the information is missing, set the field to an empty string. Output MUST be exactly a single HTML fragment enclosed in <div> ... </div> with only inline CSS (no classes). Use only these tags: div, p, span, strong, em, br, ul, li. Do NOT output any JSON or other wrappers. If you cannot parse text from the image, return: <div data-error=\"true\">OCR_FAILED</div>. Maximum output length: 700 tokens.",
        },
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
      "temperature": 0,
      "top_p": 1,
      "n": 1,
      "max_tokens": 700,
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
    // return "You are an OCR assistant. Analyze the image and produce a short, upbeat english only summary in one single paragraph with no line breaks. The paragraph should be 2–4 sentences long and briefly mention the product name, the key ingredients, the expiry date if present, and any visible certifications. Keep the tone positive, friendly, and slightly humorous (think cheerful and light, not silly). Do NOT include headings, bullet points, JSON, code fences, or extra commentary — only one continuous paragraph. Be concise and helpful.";
    return '''
Analyze the image and produce a single HTML fragment only (one top-level <div> block). The fragment must be a short product summary in English using ONLY basic tags with inline CSS. Use no classes or external CSS. Required content inside the top-level div (order them exactly): 
1) product name in a <p> with inline style making it bold and slightly larger;
2) ingredients in a <p> or <ul>;
3) expiry date if present in a <p>;
4) certifications in a <p>;
5) a short friendly one-line note in a <p>.  

Constraints:
- Output must be only the HTML fragment starting with <div ...> and ending with </div> (no extra text).
- Use inline style attributes only (e.g. style="font-size:14px; font-weight:600;").
- Must be 2–4 sentences equivalent; the textual content should be concise.
- Use only ASCII characters; if you detect non-ASCII characters, replace them with nearest ASCII equivalent.
- If a field cannot be found, produce an empty value (e.g., <p>Expiry: </p>).
- If OCR fails or image is unreadable, return exactly: <div data-error="true">OCR_FAILED</div>
Example output (copy exactly the structure):
<div style="padding:8px; border:1px solid #ddd;">
  <p style="font-size:16px; font-weight:700; margin:0;">Product Name</p>
  <p style="margin:4px 0 0 0;">Ingredients: sugar, water, ...</p>
  <p style="margin:4px 0 0 0;">Expiry: 2026-12-01</p>
  <p style="margin:4px 0 0 0;">Certifications: USDA Organic</p>
  <p style="margin:6px 0 0 0; font-style:italic;">A short upbeat note.</p>
</div>

''';
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
