import 'package:flutter/material.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/auth/presentation/contact_support.dart';
import 'package:gps_app/features/blogs/presentation/blog_list_screen.dart';
import 'package:gps_app/features/favorites/presentation/favorites_screen.dart';
import 'package:gps_app/features/item_info/presentation/item_info_screen.dart';
import 'package:gps_app/features/notifications/models/notification_model.dart';
import 'package:gps_app/features/wishlist/presentation/wishlist_screen.dart';

void onNotificationClick(NotificationModel model) {
  pr(model, 'notification model - onNotificationClick handler');
  BuildContext? context = navigatorKey.currentContext;
  // return;
  if (context == null) return;
  if (_clean(model.path) == _clean(AppRoutesNames.wishList)) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WishListScreen(scrollTo: model.pathId)),
    );
    return;
  }
  if (_clean(model.path) == _clean(AppRoutesNames.favoritesScreen)) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FavoritesScreen(scrollTo: model.pathId),
      ),
    );
    return;
  }
  if (_clean(model.path) == _clean(AppRoutesNames.blogListScreen)) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => BlogListScreen(scrollTo: 4)));
    return;
  }

  if (_clean(model.path) == _clean(AppRoutesNames.accountBlockedScreen)) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => AccountBlockedScreen()),
      (_) => false,
    );
    return;
  }
  if (_clean(model.path) == _clean(AppRoutesNames.itemInfoScreen)) {
    if (model.content?.toLowerCase().contains('catalog item') == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ItemInfoScreen(itemId: model.id ?? -1, type: 'item'),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ItemInfoScreen(itemId: model.id ?? -1, type: 'meal'),
        ),
      );
    }
    return;
  }
}

String? _clean(String? v) {
  if (v == null) return null;
  return v.toLowerCase().replaceAll('/', '').trim();
}
