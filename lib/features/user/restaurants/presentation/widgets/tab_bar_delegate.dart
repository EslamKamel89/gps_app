// tab_bar_delegate.dart
import 'package:flutter/material.dart';

/// Robust sliver header for a TabBar (or any PreferredSizeWidget).
/// - Guarantees a non-zero height even when the child is wrapped by animations.
/// - Provides a Material background so ink/indicator render correctly in slivers.
/// - Keeps the height fixed (min==max) so it pins cleanly under the AppBar.
class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;
  final Color? backgroundColor;
  final double? forcedHeight; // optional override if you want custom height

  TabBarDelegate(this.child, {this.backgroundColor, this.forcedHeight});

  double get _height {
    // Prefer an explicit height if provided; otherwise take the preferredSize.height.
    final h = forcedHeight ?? child.preferredSize.height;
    // Safety: never allow zero—iOS will collapse the sliver.
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
      elevation: overlapsContent ? 1.0 : 0.0, // slight lift so it isn't visually covered
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant TabBarDelegate old) {
    // Rebuild only if inputs change.
    return old.child != child ||
        old.backgroundColor != backgroundColor ||
        old.forcedHeight != forcedHeight;
  }
}
