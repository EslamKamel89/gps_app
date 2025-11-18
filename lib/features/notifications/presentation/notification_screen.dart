import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/notifications/models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      content: "Your reservation at Green Bistro is confirmed for tonight!",
      createdAt: "2025-11-18 11:24:02",
      isRead: 0,
    ),
    NotificationModel(
      content: "New restaurant 'Ocean Delight' joined EcoEats!",
      createdAt: "2025-11-18 10:15:30",
      isRead: 0,
    ),
    NotificationModel(
      content: "Your review for 'Vegan Roots' earned you 50 EcoPoints!",
      createdAt: "2025-11-17 18:42:10",
      isRead: 1,
    ),
    NotificationModel(
      content: "Reminder: Complete your profile to unlock exclusive offers.",
      createdAt: "2025-11-16 09:30:00",
      isRead: 1,
    ),
    NotificationModel(
      content: "Your wish for gluten-free options was matched with 3 restaurants!",
      createdAt: "2025-11-15 14:20:45",
      isRead: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: GPSColors.text)),
        backgroundColor: GPSColors.background,
        elevation: 0,
        foregroundColor: GPSColors.text,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Static dropdown filter (no logic)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: GPSColors.cardBorder),
              ),
              child: DropdownButtonFormField<String>(
                initialValue: 'All',
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Notifications')),
                  DropdownMenuItem(value: 'Unread', child: Text('Unread Only')),
                  DropdownMenuItem(value: 'Read', child: Text('Read Only')),
                ],
                onChanged: null, // static – no logic
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down, color: GPSColors.mutedText),
                style: const TextStyle(color: GPSColors.text),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            GPSGaps.h16,
            // Notifications list
            Expanded(
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
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
                      dateTime != null ? timeago.format(dateTime, locale: 'en') : 'Just now';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isUnread ? GPSColors.cardSelected : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isUnread ? GPSColors.primary.withOpacity(0.3) : GPSColors.cardBorder,
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
                                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                  GPSGaps.h6,
                                  Text(
                                    formattedTime,
                                    style: TextStyle(color: GPSColors.mutedText, fontSize: 12),
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 10, end: 0, duration: 500.ms),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 20, end: 0, duration: 600.ms);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
