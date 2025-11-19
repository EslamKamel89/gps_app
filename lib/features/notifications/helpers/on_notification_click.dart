import 'package:flutter/material.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/features/blogs/presentation/blog_list_screen.dart';
import 'package:gps_app/features/notifications/models/notification_model.dart';
import 'package:gps_app/features/wishlist/presentation/wishlist_screen.dart';

void onNotificationClick(NotificationModel model) {
  pr(model, 'notification model');
  BuildContext? context = navigatorKey.currentContext;
  // return;
  if (context == null) return;
  if (model.path == 'wishList') {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => WishListScreen(scrollTo: model.pathId)));
    return;
  }
  if (model.path == 'blogListScreen') {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BlogListScreen(scrollTo: 4)));
    return;
  }
}
