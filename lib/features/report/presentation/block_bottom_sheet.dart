import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/report/cubits/block_user_cubit.dart';
import 'package:gps_app/features/report/presentation/report_modal.dart';

Future<Map<String, String>?> openBlockBottomSheet(
  BuildContext context, {
  required int blockUserId,
}) {
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: BlockBottomSheetContent(blockUserId: blockUserId),
      );
    },
  );
}

class BlockBottomSheetContent extends StatefulWidget {
  const BlockBottomSheetContent({super.key, required this.blockUserId});
  final int blockUserId;

  @override
  State<BlockBottomSheetContent> createState() =>
      _BlockBottomSheetContentState();
}

class _BlockBottomSheetContentState extends State<BlockBottomSheetContent> {
  late BlockUserCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<BlockUserCubit>();
  }

  @override
  void dispose() {
    super.dispose();
    cubit.state.response = ResponseEnum.initial;
    cubit.state.errorMessage = null;
    cubit.state.data = null;
  }

  String reason = '';
  bool validationError = false;
  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        SlideEffect(begin: const Offset(0, 0.2), duration: 300.ms),
        FadeEffect(duration: 300.ms),
      ],
      child: SingleChildScrollView(
        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    child: Icon(
                      Icons.report_problem,
                      color: GPSColors.warning,
                      size: 20,
                    ),
                  ),
                  GPSGaps.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Block User',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Select a reason so our moderators can review the user',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B6B6B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              GPSGaps.h16,

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
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    GPSGaps.h8,
                    TextField(
                      onChanged: (value) => reason = value,
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              GPSGaps.h16,

              BlocBuilder<BlockUserCubit, ApiResponseModel<bool>>(
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
                    child: BlocConsumer<BlockUserCubit, ApiResponseModel<bool>>(
                      listener: (context, state) {
                        pr(state.response, 'debug');
                        if (state.response == ResponseEnum.success) {}
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () async {
                            context.read<BlockUserCubit>().blockUser(
                              widget.blockUserId,
                              reason,
                            );
                            Future.delayed(500.ms, () {
                              showReportAcknowledgementModal(isBlock: true);
                            });
                            Navigator.of(context).pushReplacementNamed(
                              AppRoutesNames.homeSearchScreen,
                            );
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
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
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
