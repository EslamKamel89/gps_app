import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/vendor_model/vendor_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/favorites/models/favourtie_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final List<FavoriteModel> _favorites;

  @override
  void initState() {
    super.initState();
    // Dummy Unsplash data (varied types)
    _favorites = [
      FavoriteModel(
        id: 1,
        favoriteType: 'restaurant',
        favoriteId: 101,
        user: UserModel(
          id: 1001,
          fullName: 'Layla Mahmoud',
          email: 'layla@example.com',
          mobile: '+20 100 123 4567',
          vendor: VendorModel(
            id: 501,
            vendorName: 'Nile Breeze Restaurant',
            address: '12 Corniche El Nile, Maadi, Cairo',
            seatingCapacity: 120,
          ),
          images: [
            ImageModel(
              id: 9001,
              path:
                  'https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=1200&auto=format&fit=crop',
            ),
          ],
        ),
      ),
      FavoriteModel(
        id: 2,
        favoriteType: 'store',
        favoriteId: 102,
        user: UserModel(
          id: 1002,
          fullName: 'Omar Hassan',
          email: 'omar@example.com',
          mobile: '+20 122 555 7788',
          vendor: VendorModel(
            id: 502,
            vendorName: 'Green Valley Market',
            address: '45 El-Nozha St, Heliopolis, Cairo',
            seatingCapacity: null,
          ),
          images: [
            ImageModel(
              id: 9002,
              path:
                  'https://images.unsplash.com/photo-1511690743698-d9d85f2fbf38?q=80&w=1200&auto=format&fit=crop',
            ),
          ],
        ),
      ),
      FavoriteModel(
        id: 3,
        favoriteType: 'farm',
        favoriteId: 103,
        user: UserModel(
          id: 1003,
          fullName: 'Sara Youssef',
          email: 'sara@example.com',
          mobile: '+20 111 222 3344',
          vendor: VendorModel(
            id: 503,
            vendorName: 'Al-Fayoum Organic Farm',
            address: 'Wadi El Rayan Rd, Fayoum',
            seatingCapacity: 30,
          ),
          images: [
            ImageModel(
              id: 9003,
              path:
                  'https://images.unsplash.com/photo-1500937386664-56f3d81d41b2?q=80&w=1200&auto=format&fit=crop',
            ),
          ],
        ),
      ),
      // One with no image to show fallback:
      FavoriteModel(
        id: 4,
        favoriteType: 'restaurant',
        favoriteId: 104,
        user: UserModel(
          id: 1004,
          fullName: 'Mostafa Adel',
          email: 'mostafa@example.com',
          mobile: '+20 109 888 9090',
          vendor: VendorModel(
            id: 504,
            vendorName: 'Koshary Corner',
            address: '15 Talaat Harb, Downtown, Cairo',
            seatingCapacity: 60,
          ),
          images: const [],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: GPSColors & GPSGaps are defined in your codebase already.
    return Scaffold(
      backgroundColor: GPSColors.background,
      appBar: AppBar(
        backgroundColor: GPSColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Favorites',
          style: TextStyle(color: GPSColors.text, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child:
            _favorites.isEmpty
                ? _EmptyState()
                    .animate()
                    .fade(duration: 300.ms)
                    .move(
                      begin: const Offset(0, 12),
                      end: Offset.zero,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    )
                : Column(
                  children: [
                    ..._favorites.indexed.map((entry) {
                      final i = entry.$1;
                      final fav = entry.$2;
                      return FavoriteCard(key: ValueKey('fav_$i'), favorite: fav)
                          .animate(delay: (50 * i).ms)
                          .fadeIn(duration: 300.ms)
                          .move(
                            begin: const Offset(0, 16),
                            end: Offset.zero,
                            duration: 400.ms,
                            curve: Curves.easeOut,
                          );
                    }),
                    GPSGaps.h24,
                  ],
                ),
      ),
    );
  }
}

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
    final avatar = _Avatar(imageUrl: imageUrl, initials: _initials(vendor?.vendorName));

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
                  child: _TitleAndSubtitle(
                    title: vendor?.vendorName ?? 'Unknown',
                    subtitle: vendor?.address ?? 'No address available',
                  ),
                ),
                GPSGaps.w8,
                _TypeChip(icon: typeIcon, label: typeLabel),
                GPSGaps.w8,
                _Chevron(expanded: _expanded),
              ],
            ),
            // Expanded Content
            AnimatedCrossFade(
              crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: 250.ms,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _ExpandedDetails(
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

/// ------------------------------------------------------------
/// Pieces
/// ------------------------------------------------------------
class _Avatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;

  const _Avatar({required this.imageUrl, required this.initials});

  @override
  Widget build(BuildContext context) {
    final size = 52.0;

    if (imageUrl == null || imageUrl!.isEmpty) {
      // No image → initials in a colored circle
      return _InitialsAvatar(size: size, initials: initials);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        fadeInDuration: 200.ms,
        placeholder: (context, _) => _ImagePlaceholder(size: size),
        errorWidget: (context, _, __) => _ErrorAvatar(size: size),
      ).animate(
        onPlay: (c) => c,
        // ..fadeIn(duration: 200.ms).scale(
        //   begin: const Offset(0.98, 0.98),
        //   end: const Offset(1, 1),
        //   duration: 200.ms,
        // ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final double size;
  final String initials;
  const _InitialsAvatar({required this.size, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: GPSColors.cardSelected,
        border: Border.all(color: GPSColors.cardBorder),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: TextStyle(color: GPSColors.text, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ).animate().shimmer(duration: 800.ms, delay: 50.ms); // subtle glint
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final double size;
  const _ImagePlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    final base = Container(
      width: size,
      height: size,
      color: GPSColors.cardSelected.withOpacity(0.5),
      child: Icon(Icons.image, color: GPSColors.mutedText),
    );
    return base
        .animate(
          onPlay: (c) => c.repeat(reverse: false), // continuous shimmer while loading
        )
        .shimmer(duration: 1200.ms);
  }
}

class _ErrorAvatar extends StatelessWidget {
  final double size;
  const _ErrorAvatar({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: GPSColors.cardSelected.withOpacity(0.4),
        border: Border.all(color: GPSColors.cardBorder),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.broken_image_outlined, color: GPSColors.mutedText),
    );
  }
}

class _TitleAndSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _TitleAndSubtitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title - 1 line
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: GPSColors.text, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        GPSGaps.h4,
        // Subtitle (address) - 2 lines
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: GPSColors.mutedText, fontSize: 13, height: 1.2),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TypeChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: GPSColors.accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: GPSColors.accent),
              GPSGaps.w4,
              Text(
                label,
                style: TextStyle(
                  color: GPSColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 250.ms)
        .scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1), duration: 200.ms);
  }
}

class _Chevron extends StatelessWidget {
  final bool expanded;
  const _Chevron({required this.expanded});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        RotateEffect(begin: expanded ? 0.5 : 0, duration: 220.ms, curve: Curves.easeOut),
        FadeEffect(duration: 150.ms),
      ],
      child: Icon(Icons.keyboard_arrow_down_rounded, color: GPSColors.mutedText, size: 24),
    );
  }
}

class _ExpandedDetails extends StatelessWidget {
  final String? ownerName;
  final String? mobile;
  final String? email;
  final String? address;
  final int? seatingCapacity;

  const _ExpandedDetails({
    required this.ownerName,
    required this.mobile,
    required this.email,
    required this.address,
    required this.seatingCapacity,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      _DetailRow(icon: MdiIcons.accountCircleOutline, label: 'Owner', value: ownerName),
      _DetailRow(icon: MdiIcons.phone, label: 'Mobile', value: mobile),
      _DetailRow(icon: MdiIcons.emailOutline, label: 'Email', value: email),
      _DetailRow(
        icon: MdiIcons.mapMarkerOutline,
        label: 'Address',
        value: address,
        multiline: true,
      ),
      if (seatingCapacity != null)
        _DetailRow(icon: MdiIcons.seatOutline, label: 'Seating', value: '$seatingCapacity'),
    ];

    return Column(children: [GPSGaps.h8, ...rows.separatedBy(() => GPSGaps.h8)]);
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool multiline;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: GPSColors.primary),
        GPSGaps.w8,
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    color: GPSColors.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                TextSpan(
                  text: text,
                  style: TextStyle(
                    color: GPSColors.mutedText,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            maxLines: multiline ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final icon = Icon(MdiIcons.heartOutline, size: 56, color: GPSColors.mutedText);
    final text = Text(
      'No favorites exist',
      style: TextStyle(color: GPSColors.mutedText, fontSize: 15, fontWeight: FontWeight.w600),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GPSGaps.h24,
        icon
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(0.96, 0.96),
              end: const Offset(1.04, 1.04),
              duration: 900.ms,
              curve: Curves.easeInOut,
            ),
        GPSGaps.h12,
        text.animate().fadeIn(duration: 350.ms),
      ],
    );
  }
}

/// ------------------------------------------------------------
/// Small iterable extension for spacing helpers
/// ------------------------------------------------------------
extension _SeparatedBy on List<Widget> {
  List<Widget> separatedBy(Widget Function() separatorBuilder) {
    final out = <Widget>[];
    for (var i = 0; i < length; i++) {
      out.add(this[i]);
      if (i != length - 1) out.add(separatorBuilder());
    }
    return out;
  }
}
