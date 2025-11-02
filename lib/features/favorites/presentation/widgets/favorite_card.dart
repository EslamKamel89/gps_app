// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/vendor_model/vendor_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/favorites/models/favorite_model.dart';
import 'package:gps_app/features/favorites/presentation/widgets/chevron.dart';
import 'package:gps_app/features/favorites/presentation/widgets/expanded_details.dart';
import 'package:gps_app/features/favorites/presentation/widgets/favorite_avatar.dart';
import 'package:gps_app/features/favorites/presentation/widgets/title_and_subtitle.dart';
import 'package:gps_app/features/favorites/presentation/widgets/type_chip.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FavoriteCard extends StatefulWidget {
  final FavoriteModel favorite;

  const FavoriteCard({super.key, required this.favorite});

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final user = widget.favorite.user;
    final vendor = user?.vendor;
    final imageUrl = (user?.images?.isNotEmpty ?? false) ? user!.images!.first.path : null;

    final type = (widget.favorite.favoriteType ?? '').toLowerCase().trim();
    final typeIcon = _typeIcon(type);
    final typeLabel = _typeLabel(type);
    final avatar = FavoriteAvatar(imageUrl: imageUrl, initials: _initials(vendor?.vendorName));

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: 250.ms,
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _expanded ? GPSColors.cardSelected.withOpacity(0.35) : Colors.white,
          border: Border.all(color: GPSColors.cardBorder),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_expanded ? 0.06 : 0.04),
              blurRadius: _expanded ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                avatar,
                GPSGaps.w12,
                Expanded(
                  child: TitleAndSubtitle(
                    title: vendor?.vendorName ?? 'Unknown',
                    subtitle: vendor?.address ?? 'No address available',
                  ),
                ),
                GPSGaps.w8,
                TypeChip(icon: typeIcon, label: typeLabel),
                GPSGaps.w8,
                Chevron(expanded: _expanded),
              ],
            ),
            // Expanded Content
            AnimatedCrossFade(
              crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: 250.ms,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ExpandedDetails(
                      ownerName: user?.fullName,
                      mobile: user?.mobile,
                      email: user?.email,
                      address: vendor?.address,
                      seatingCapacity: vendor?.seatingCapacity,
                    )
                    .animate()
                    .fadeIn(duration: 250.ms)
                    .move(
                      begin: const Offset(0, -4),
                      end: Offset.zero,
                      duration: 250.ms,
                      curve: Curves.easeOut,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'farm':
        return MdiIcons.barn; // or barn variant
      case 'store':
        return MdiIcons.storefrontOutline;
      case 'restaurant':
        return MdiIcons.silverwareForkKnife;
      default:
        return MdiIcons.tagOutline;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'farm':
        return 'Farm';
      case 'store':
        return 'Store';
      case 'restaurant':
        return 'Restaurant';
      default:
        return 'Other';
    }
  }

  String _initials(String? name) {
    final n = (name ?? '').trim();
    if (n.isEmpty) return 'V';
    final parts = n.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return n.characters.first.toUpperCase();
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}
