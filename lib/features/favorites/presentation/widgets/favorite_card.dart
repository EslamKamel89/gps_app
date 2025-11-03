import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/helpers/image_url.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/favorites/cubits/favorites_cubit.dart';
import 'package:gps_app/features/favorites/models/favorite_model.dart';
import 'package:gps_app/features/favorites/presentation/widgets/chevron.dart';
import 'package:gps_app/features/favorites/presentation/widgets/expanded_details.dart';
import 'package:gps_app/features/favorites/presentation/widgets/favorite_avatar.dart';
import 'package:gps_app/features/favorites/presentation/widgets/type_chip.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/restaurant_detail_provider.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/show_action_sheet.dart';
import 'package:gps_app/features/user/store_details/presentation/store_details_screen.dart';
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

    String? imageUrl = (user?.images?.isNotEmpty ?? false) ? user!.images!.first.path : null;
    imageUrl = getImageUrl(imageUrl);

    final String? title = _sanitize(vendor?.vendorName);
    final String? subtitle = _sanitize(vendor?.address);

    final String type = (widget.favorite.favoriteType ?? '').toLowerCase().trim();
    final bool hasType = type == 'farm' || type == 'store' || type == 'restaurant';

    final IconData? typeIcon = _typeIconNullable(type);
    final String? typeLabel = _typeLabelNullable(type);

    final avatar = FavoriteAvatar(imageUrl: imageUrl, initials: _initials(title));

    return AnimatedContainer(
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
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                avatar,
                GPSGaps.w12,

                Expanded(
                  child:
                      (title == null && subtitle == null)
                          ? const SizedBox.shrink()
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (title != null)
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: GPSColors.text,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              if (subtitle != null) ...[
                                GPSGaps.h4,
                                Text(
                                  subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: GPSColors.mutedText,
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ],
                          ),
                ),

                GPSGaps.w8,

                if (hasType && typeIcon != null && typeLabel != null) ...[
                  TypeChip(icon: typeIcon, label: typeLabel),
                  GPSGaps.w8,
                ],

                Chevron(expanded: _expanded),
              ],
            ),
          ),

          AnimatedCrossFade(
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: 250.ms,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  ExpandedDetails(
                        ownerName: _sanitize(user?.fullName),
                        mobile: _sanitize(user?.mobile),
                        email: _sanitize(user?.email),
                        address: _sanitize(vendor?.address),
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

                  GPSGaps.h16,

                  SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _navigateToProfileScreen();
                          },
                          icon: const Icon(Icons.person_outline, size: 18),
                          label: const Text(
                            'Go to Profile',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GPSColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .move(
                        begin: const Offset(0, 10),
                        end: Offset.zero,
                        duration: 300.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  GPSGaps.h8,

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                          onPressed: () {
                            _removeFromFavorites();
                          },
                          icon: Icon(
                            MdiIcons.heartOffOutline,
                            size: 18,
                            color: GPSColors.mutedText,
                          ),
                          label: Text(
                            'Remove from favorites',
                            style: TextStyle(
                              color: GPSColors.mutedText,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            foregroundColor: GPSColors.mutedText,
                            overlayColor: GPSColors.cardSelected.withOpacity(0.25),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 250.ms)
                        .move(
                          begin: const Offset(0, 6),
                          end: Offset.zero,
                          duration: 250.ms,
                          curve: Curves.easeOut,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProfileScreen() {
    String? type = widget.favorite.favoriteType;
    if (type == 'restaurant') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (_) => RestaurantDetailProvider(
                restaurantId: widget.favorite.favoriteId ?? -1,
                enableEdit: false,
                enableCompleteProfile: false,
              ),
        ),
      );
    } else if (type == 'store' || type == 'farm') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (_) => StoreDetailsScreen(
                userId: widget.favorite.user?.id,
                publicPage: true,
                enableEdit: false,
                enableCompleteProfile: true,
              ),
        ),
      );
    }
  }

  Future _removeFromFavorites() async {
    final areYouSure = await showActionSheet(
      context,
      title: 'Are you sure you want to remove from favorites?',
      children: [
        Row(children: [Icon(MdiIcons.check), GPSGaps.w10, Text('Yes')]),
        Row(children: [Icon(MdiIcons.cancel), GPSGaps.w10, Text('No')]),
      ],
    );
    if (areYouSure != 0) return;
    final cubit = context.read<FavoritesCubit>();
    cubit.removeFromFavorites(widget.favorite);
  }

  String? _sanitize(String? v) {
    final s = v?.trim();
    return (s == null || s.isEmpty) ? null : s;
  }

  IconData? _typeIconNullable(String type) {
    switch (type) {
      case 'farm':
        return MdiIcons.barn;
      case 'store':
        return MdiIcons.storefrontOutline;
      case 'restaurant':
        return MdiIcons.silverwareForkKnife;
      default:
        return null;
    }
  }

  String? _typeLabelNullable(String type) {
    switch (type) {
      case 'farm':
        return 'Farm';
      case 'store':
        return 'Store';
      case 'restaurant':
        return 'Restaurant';
      default:
        return null;
    }
  }

  String _initials(String? name) {
    final n = _sanitize(name);
    if (n == null) return '';
    final parts = n.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}
