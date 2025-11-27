import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/report/cubits/add_report_cubit.dart';
import 'package:gps_app/features/report/models/report_param.dart';

Future<Map<String, String>?> openReportBottomSheet(
  BuildContext context, {
  required int typeId,
  required String type,
}) {
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: ReportBottomSheetContent(typeId: typeId, type: type),
      );
    },
  );
}

class ReportBottomSheetContent extends StatefulWidget {
  const ReportBottomSheetContent({super.key, required this.typeId, required this.type});
  final int typeId;
  final String type;

  @override
  State<ReportBottomSheetContent> createState() => _ReportBottomSheetContentState();
}

class _ReportBottomSheetContentState extends State<ReportBottomSheetContent> {
  late AddReportCubit cubit;
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

  final ReportParam param = ReportParam();
  @override
  void initState() {
    super.initState();
    cubit = context.read<AddReportCubit>();
    param.type = widget.type;
    param.typeId = widget.typeId;
    param.option = null;
  }

  @override
  void dispose() {
    super.dispose();
    cubit.state.response = ResponseEnum.initial;
    cubit.state.errorMessage = null;
    cubit.state.data = null;
  }

  bool validationError = false;
  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        SlideEffect(begin: const Offset(0, 0.2), duration: 300.ms),
        FadeEffect(duration: 300.ms),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        physics: const ClampingScrollPhysics(),
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
                            groupValue: param.option,
                            onChanged: (v) {
                              setState(() {
                                param.option = v;
                              });
                            },
                          );
                        }).toList(),
                  ),
                ),
              ),

              if (param.option == 'Other') ...[
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
                        onChanged: (value) => param.description = value,
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
              if (validationError)
                Text(
                  'Sorry you have to select an option',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              GPSGaps.h16,
              BlocBuilder<AddReportCubit, ApiResponseModel<bool>>(
                builder: (context, state) {
                  if (state.response == ResponseEnum.failed) {
                    return Text(
                      'Sorry something went wrong, please try again later',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    );
                  }
                  return SizedBox();
                },
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
                    child: BlocConsumer<AddReportCubit, ApiResponseModel<bool>>(
                      listener: (context, state) {
                        if (state.response == ResponseEnum.success) {
                          Navigator.of(context).pop();
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () async {
                            pr(param.toJson(), 'param');
                            if (param.option == null) {
                              setState(() {
                                validationError = true;
                              });
                              return;
                            }
                            if (validationError) {
                              setState(() {
                                validationError = false;
                              });
                            }
                            await context.read<AddReportCubit>().add(param);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GPSColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (state.response == ResponseEnum.loading)
                                Container(
                                  width: 20,
                                  height: 20,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(right: 10),
                                  // color: Colors.red,
                                  child: CircularProgressIndicator(color: Colors.white),
                                ),
                              const Text('Submit'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
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
