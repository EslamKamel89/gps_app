import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/core/helpers/clean_reply.dart';
import 'package:gps_app/core/helpers/print_helper.dart';

void showResult(String content) {
  final context = navigatorKey.currentContext;
  if (context == null) return;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 2),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 45,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Text(
                  "Analysis Result",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Html(
                      data: pr(cleanReply(content), 'clean reply'),
                      // textAlign: TextAlign.right,
                      style: {
                        'h1': Style(fontSize: FontSize(30)),
                        'h2': Style(fontSize: FontSize(28)),
                        'p': Style(fontSize: FontSize(16)),
                        '*': Style(textAlign: TextAlign.left),
                      },
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text("Close", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
