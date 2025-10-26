// import 'package:flutter/material.dart';
// import 'package:gps_app/features/design/utils/gps_colors.dart';

// class TabBarDelegate extends SliverPersistentHeaderDelegate {
//   TabBarDelegate(this._tabBar);
//   final Widget _tabBar;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Container(
//       color: GPSColors.background,
//       child: SafeArea(
//         bottom: false,
//         child: Container(
//           decoration: const BoxDecoration(
//             color: GPSColors.background,
//             border: Border(
//               bottom: BorderSide(color: GPSColors.cardBorder),
//               top: BorderSide(color: GPSColors.cardBorder),
//             ),
//           ),
//           child: _tabBar,
//         ),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 52;
//   @override
//   double get minExtent => 52;
//   @override
//   bool shouldRebuild(covariant TabBarDelegate oldDelegate) => false;
// }
