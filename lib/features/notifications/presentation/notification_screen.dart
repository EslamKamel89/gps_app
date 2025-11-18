import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/extensions/context-extensions.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/notifications/cubits/notification_cubit.dart';
import 'package:gps_app/features/notifications/models/notification_model.dart';
import 'package:gps_app/features/notifications/presentation/widgets/notification_filter_toggle.dart';
import 'package:gps_app/features/notifications/presentation/widgets/notification_loading_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationCubit cubit;
  @override
  void initState() {
    cubit = context.read<NotificationCubit>();
    cubit.notifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, ApiResponseModel<List<NotificationModel>>>(
      builder: (context, state) {
        final notifications = cubit.filtered;
        return Scaffold(
          backgroundColor: GPSColors.background,
          appBar: AppBar(
            title: const Text('Notifications', style: TextStyle(color: Colors.white)),
            backgroundColor: GPSColors.primary,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: NotificationFilterToggle()),
                GPSGaps.h16,
                state.response == ResponseEnum.loading && state.data == null
                    ? NotificationsLoadingIndicator()
                    : cubit.filtered.isEmpty == true
                    ? Container(
                      padding: EdgeInsets.only(top: context.height / 3),
                      alignment: Alignment.center,
                      child: Text('There are no notification found'),
                    )
                    : Expanded(
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          final isUnread = notification.isRead == 0;

                          // Parse createdAt to DateTime for timeago
                          DateTime? dateTime;
                          if (notification.createdAt != null) {
                            try {
                              dateTime = DateTime.parse(notification.createdAt!);
                            } catch (e) {
                              // handle invalid date if needed
                            }
                          }
                          final formattedTime =
                              dateTime != null
                                  ? timeago.format(dateTime, locale: 'en')
                                  : 'Just now';

                          return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isUnread ? GPSColors.cardSelected : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isUnread
                                            ? GPSColors.primary.withOpacity(0.3)
                                            : GPSColors.cardBorder,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isUnread)
                                      Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: GPSColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                          .animate()
                                          .fadeIn(duration: 300.ms)
                                          .slideX(begin: -0.5, end: 0, duration: 400.ms),
                                    if (isUnread) GPSGaps.w10,
                                    Expanded(
                                      child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notification.content ?? 'No content',
                                                style: TextStyle(
                                                  color: GPSColors.text,
                                                  fontWeight:
                                                      isUnread
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                ),
                                              ),
                                              GPSGaps.h6,
                                              Text(
                                                formattedTime,
                                                style: TextStyle(
                                                  color: GPSColors.mutedText,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )
                                          .animate()
                                          .fadeIn(duration: 400.ms)
                                          .slideY(begin: 10, end: 0, duration: 500.ms),
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .slideY(begin: 20, end: 0, duration: 600.ms);
                        },
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
