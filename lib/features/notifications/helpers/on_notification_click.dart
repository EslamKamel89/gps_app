import 'package:flutter/material.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/blogs/presentation/blog_list_screen.dart';
import 'package:gps_app/features/notifications/models/notification_model.dart';
import 'package:gps_app/features/wishlist/presentation/wishlist_screen.dart';

void onNotificationClick(NotificationModel model) {
  pr(model, 'notification model');
  BuildContext? context = navigatorKey.currentContext;
  // return;
  if (context == null) return;
  if (_clean(model.path) == _clean(AppRoutesNames.wishList)) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => WishListScreen(scrollTo: model.pathId)));
    return;
  }
  if (_clean(model.path) == _clean(AppRoutesNames.blogListScreen)) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BlogListScreen(scrollTo: 4)));
    return;
  }
  if (_clean(model.path) == _clean(AppRoutesNames.homeSearchScreen)) {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutesNames.homeSearchScreen, (_) => false);
    return;
  }
  if (_clean(model.path) == _clean(AppRoutesNames.accountBlockedScreen)) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutesNames.accountBlockedScreen, (_) => false);
    return;
  }
}

String? _clean(String? v) {
  if (v == null) return null;
  return v.toLowerCase().replaceAll('/', '').trim();
}
