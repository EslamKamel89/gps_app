import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/features/notifications/cubits/notification_cubit.dart';

class NotificationCount extends StatelessWidget {
  const NotificationCount({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<NotificationCubit>();
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      child: Text(
        cubit.getUnreadCount().toString(),
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}
