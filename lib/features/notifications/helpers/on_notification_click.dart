import 'package:flutter/material.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/notifications/models/notification_model.dart';

void onNotificationClick(NotificationModel model) {
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) return;
  if (model.path == 'wishList') {
    Navigator.of(context).pushNamed(
      AppRoutesNames.wishList,
      // (_) => false
    );
    return;
  }
  pr(model, 'notification model');
}
