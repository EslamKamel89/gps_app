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
              "You are an OCR-aware HTML-only assistant. OUTPUT MUST BE A SINGLE HTML FRAGMENT (one top-level element) AND NOTHING ELSE. Do NOT output markdown, tables, CSV, raw numeric arrays, JSON, YAML, code fences, or repeated lines. If you detect tabular/numeric data (nutrition panel, table), SUMMARIZE it in plain English inside the HTML (e.g., 'Nutrition panel: calories 250; sugar 12g; ...'), do NOT print the raw table or many numbers. If unreadable, return exactly: <div data-error='true'>OCR_FAILED</div>. If you violate these rules, your output will be discarded.",
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
      "max_tokens": 450,
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
Analyze the image and produce a single HTML fragment (one top-level element). Be professional with light friendly humor. Mention any metadata found (product name, ingredients, expiry date, certifications) when present; otherwise describe the image and state no metadata was detected. Use ASCII only. Output MUST be only the single HTML fragment and nothing else.

BAD (do NOT output):
| 6.5 | 1.5 | 1.5 | 1.5 | ...

your output must have the following structure
<div style="padding:8px;border:1px solid #eee;font-family:Arial,sans-serif;">
  <p style="font-weight:700;margin:0 0 6px 0;">Plate of Pasta</p>
  <p style="margin:0 0 6px 0;">No product labels detected. Image appears to be a plate of pasta.</p>
  <p style="margin:0;font-style:italic;">Looks delicious — napkin recommended.</p>
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

  bool looksLikeTableOrNumbers(String s) {
    final trimmed = s.trim();
    if (trimmed.isEmpty) return true;
    // markdown table pipe or many repeated numbers
    if (trimmed.contains('|') && RegExp(r'\|\s*\d').hasMatch(trimmed)) return true;
    // CSV-like lines of numbers
    if (RegExp(r'^[-\d.,\s]{20,}$').hasMatch(trimmed)) return true;
    // many numbers separated by spaces (more than, say, 10 small numbers)
    final numbers = RegExp(r'(-?\d+(\.\d+)?)').allMatches(trimmed).length;
    if (numbers > 20) return true;
    // repeating short fragment heuristic
    final prefix = trimmed.length >= 30 ? trimmed.substring(0, 30) : trimmed;
    final occurrences = RegExp(RegExp.escape(prefix)).allMatches(trimmed).length;
    if (occurrences > 3) return true;
    return false;
  }
}
