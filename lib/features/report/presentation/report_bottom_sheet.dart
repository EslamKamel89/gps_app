import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

Future<Map<String, String>?> openReportBottomSheet(BuildContext context) {
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _ReportBottomSheetContent(),
      );
    },
  );
}

class _ReportBottomSheetContent extends StatefulWidget {
  @override
  State<_ReportBottomSheetContent> createState() => _ReportBottomSheetContentState();
}

class _ReportBottomSheetContentState extends State<_ReportBottomSheetContent> {
  final List<String> _options = [
    'Spam or misleading',
    'Nudity / Sexual content',
    'Hate speech / Discrimination',
    'Harassment / Bullying',
    'Self-harm / Suicide content',
    'Illegal activity / Solicitation',
    'Impersonation',
    'Privacy violation / Doxxing',
    'Intellectual property infringement',
    'Other',
  ];

  String? _selected;
  final TextEditingController _otherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = null;
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        SlideEffect(begin: const Offset(0, 0.2), duration: 300.ms),
        FadeEffect(duration: 300.ms),
      ],
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            GPSGaps.h12,

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GPSColors.warning.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.report_problem, color: GPSColors.warning, size: 20),
                ),
                GPSGaps.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Report content',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Select a reason so our moderators can review the content',
                        style: TextStyle(fontSize: 13, color: Color(0xFF6B6B6B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            GPSGaps.h16,

            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
              child: SingleChildScrollView(
                child: Column(
                  children:
                      _options.map((opt) {
                        return _ReportOptionTile(
                          label: opt,
                          value: opt,
                          groupValue: _selected,
                          onChanged: (v) {
                            setState(() {
                              _selected = v;

                              if (v != 'Other') {
                                _otherController.clear();
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
              ),
            ),

            if (_selected == 'Other') ...[
              GPSGaps.h12,

              Animate(
                effects: [
                  FadeEffect(duration: 220.ms),
                  SlideEffect(begin: const Offset(0, 0.05), duration: 220.ms),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please describe',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    GPSGaps.h8,
                    TextField(
                      controller: _otherController,
                      maxLines: 4,
                      minLines: 3,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'Add details (helpful for faster moderation)',
                        hintStyle: const TextStyle(fontSize: 13),
                        filled: true,
                        fillColor: GPSColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: GPSColors.cardBorder),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Choose one reason that best matches the issue.',
                  style: TextStyle(fontSize: 12, color: GPSColors.mutedText),
                ),
              ),

            GPSGaps.h16,

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                GPSGaps.w12,
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _selected == null
                            ? null
                            : () {
                              final result = {
                                'reason': _selected!,
                                'description':
                                    (_selected == 'Other') ? (_otherController.text.trim()) : '',
                              };
                              Navigator.of(context).pop(result);
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GPSColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportOptionTile extends StatelessWidget {
  final String label;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const _ReportOptionTile({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return ListTile(
      onTap: () => onChanged(value),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: selected ? GPSColors.cardSelected : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? GPSColors.primary.withOpacity(0.2) : Colors.transparent,
          ),
        ),
        child: Icon(
          selected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: selected ? GPSColors.primary : Colors.grey.shade500,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: GPSColors.text,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: GPSColors.primary,
      ),
    );
  }
}

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report BottomSheet Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Reporting demo'), backgroundColor: GPSColors.primary),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final res = await openReportBottomSheet(context);

              debugPrint('Report result: $res');
              if (res != null) {
                final reason = res['reason']!;
                final desc = (res['description'] ?? '').trim();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reported: $reason${desc.isNotEmpty ? " — $desc" : ""}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: GPSColors.primary),
            child: const Text('Open report sheet'),
          ),
        ),
      ),
    );
  }
}
