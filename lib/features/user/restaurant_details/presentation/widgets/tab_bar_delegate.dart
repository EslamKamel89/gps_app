import 'package:flutter/material.dart';

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;
  final Color? backgroundColor;
  final double? forcedHeight;

  TabBarDelegate(this.child, {this.backgroundColor, this.forcedHeight});

  double get _height {
    final h = forcedHeight ?? child.preferredSize.height;

    return (h == 0 || h.isNaN) ? kTextTabBarHeight : h;
  }

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      elevation: overlapsContent ? 1.0 : 0.0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant TabBarDelegate old) {
    return old.child != child ||
        old.backgroundColor != backgroundColor ||
        old.forcedHeight != forcedHeight;
  }
}
