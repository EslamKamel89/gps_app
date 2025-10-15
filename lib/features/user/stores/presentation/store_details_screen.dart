import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/catalog_item_model.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/models/operating_time_model.dart';
import 'package:gps_app/features/auth/models/store_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/models/vendor_model/vendor_model.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/tabbar_delegate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<StoreDetailsScreen> createState() => StoreDetailsScreenState();
}

class StoreDetailsScreenState extends State<StoreDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isFav = false;

  StoreModel? get _store => widget.user.store;
  VendorModel? get _vendor => widget.user.vendor;

  List<CatalogSectionModel> get _sections => _store?.sections ?? [];

  String get _title =>
      _vendor?.vendorName?.trim().isNotEmpty == true
          ? _vendor!.vendorName!
          : (widget.user.fullName ?? 'Store');

  // Build a usable image URL or fallback (kept simple on purpose)
  String _imageUrl([ImageModel? img]) {
    final p = img?.path ?? widget.user.image?.path;
    if (p == null || p.isEmpty) {
      // nice neutral fallback
      return 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1600&auto=format&fit=crop';
    }
    // If your API serves relative "storage/..." paths, prepend your base URL.
    // To keep this file self-contained, we'll just return the path;
    // adjust as needed (e.g., "${Env.apiBase}/$p").
    return p.startsWith('http') ? p : p;
  }

  // Simple "open now" using today's range from operatingHours
  // operatingHours format: ["HH:MM","HH:MM"]
  bool get _isOpenNow {
    final oh = _vendor?.operatingHours;
    if (oh == null) return false;

    final now = DateTime.now();
    final weekdayKey =
        <int, String>{1: 'mon', 2: 'tue', 3: 'wed', 4: 'thu', 5: 'fri', 6: 'sat', 7: 'sun'}[now
            .weekday]!;

    List<String>? slot;
    switch (weekdayKey) {
      case 'mon':
        slot = oh.mon;
        break;
      case 'tue':
        slot = oh.tue;
        break;
      case 'wed':
        slot = oh.wed;
        break;
      case 'thu':
        slot = oh.thu;
        break;
      case 'fri':
        slot = oh.fri;
        break;
      case 'sat':
        slot = oh.sat;
        break;
      case 'sun':
        slot = oh.sun;
        break;
    }
    if (slot == null || slot.length < 2) return false;

    TimeOfDay? parse(String s) {
      final parts = s.split(':');
      if (parts.length != 2) return null;
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: h, minute: m);
    }

    final start = parse(slot[0]);
    final end = parse(slot[1]);
    if (start == null || end == null) return false;

    bool inside(TimeOfDay a, TimeOfDay b, DateTime x) {
      final xTod = TimeOfDay(hour: x.hour, minute: x.minute);
      int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;
      final xs = toMinutes(xTod), as = toMinutes(a), bs = toMinutes(b);
      if (as <= bs) return xs >= as && xs <= bs;
      // overnight range (e.g., 22:00 -> 06:00)
      return xs >= as || xs <= bs;
    }

    return inside(start, end, now);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _sections.map((s) => s.name ?? 'Section').toList();

    return DefaultTabController(
      length: tabs.isEmpty ? 1 : tabs.length,
      child: Scaffold(
        backgroundColor: GPSColors.background,
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerScrolled) => [
                // Hero / Media
                SliverAppBar(
                  backgroundColor: GPSColors.background,
                  expandedHeight: 260,
                  pinned: true,
                  elevation: 0,
                  leading: CircleBack(onTap: () => Navigator.of(context).maybePop()),
                  actions: [
                    IconButton(
                      tooltip: 'Share',
                      icon: const Icon(Icons.share_rounded, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(_imageUrl(), fit: BoxFit.cover)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .scale(begin: const Offset(1.02, 1.02), end: const Offset(1, 1)),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xAA000000), Color(0x55000000)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Header content
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: GPSColors.background,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + Fav
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: GPSColors.text,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: _isFav ? 'Remove from favorites' : 'Add to favorites',
                                onPressed: () => setState(() => _isFav = !_isFav),
                                icon: Icon(
                                  _isFav ? Icons.favorite_rounded : Icons.favorite_outline,
                                  color: _isFav ? Colors.redAccent : GPSColors.mutedText,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 280.ms).slideY(begin: .1),

                          GPSGaps.h12,

                          // Quick badges (address / open now / type)
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              if ((_vendor?.address ?? '').isNotEmpty)
                                const BadgeChip(icon: Icons.place_rounded, label: 'Address'),
                              BadgeChip(
                                icon: _isOpenNow ? Icons.schedule_rounded : Icons.schedule_rounded,
                                label: _isOpenNow ? 'Open now' : 'Closed',
                                iconColor: _isOpenNow ? Colors.green : GPSColors.mutedText,
                              ),
                              const BadgeChip(icon: Icons.storefront_rounded, label: 'Store'),
                            ],
                          ).animate(delay: 70.ms).fadeIn(duration: 250.ms).slideY(begin: .08),

                          GPSGaps.h16,

                          // Simple About (using whatever is available)
                          if ((_vendor?.address ?? '').isNotEmpty)
                            Text(
                              _vendor!.address!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: GPSColors.mutedText,
                                height: 1.4,
                              ),
                            ).animate().fadeIn(duration: 250.ms).slideY(begin: .06),

                          if ((_vendor?.address ?? '').isNotEmpty) GPSGaps.h16,

                          // Hours preview (today only, readable)
                          if (_vendor?.operatingHours != null)
                            TodayHoursRow(
                              operating: _vendor!.operatingHours!,
                            ).animate().fadeIn(duration: 240.ms).slideY(begin: .06),
                          if (_vendor?.operatingHours != null) GPSGaps.h16,
                        ],
                      ),
                    ),
                  ),
                ),

                // Pinned TabBar (only if we have sections)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: TabBarDelegate(
                    (tabs.isEmpty
                            ? const TabBar(
                              tabs: [Tab(text: 'Items')],
                              indicatorWeight: 3,
                              indicatorColor: GPSColors.primary,
                              labelColor: GPSColors.text,
                              unselectedLabelColor: GPSColors.mutedText,
                            )
                            : TabBar(
                              isScrollable: true,
                              indicatorWeight: 3,
                              indicatorColor: GPSColors.primary,
                              labelColor: GPSColors.text,
                              unselectedLabelColor: GPSColors.mutedText,
                              labelStyle: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                              tabs: [
                                for (final t in tabs)
                                  Tab(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                      child: Text(t, style: const TextStyle(fontSize: 16)),
                                    ),
                                  ),
                              ],
                            ))
                        .animate()
                        .fadeIn(duration: 220.ms)
                        .slideY(begin: .08),
                  ),
                ),
              ],
          body:
              tabs.isEmpty
                  ? EmptySectionList(items: _flatItems(), heroPrefix: 'all-0')
                  : TabBarView(
                    children: [
                      for (int ti = 0; ti < tabs.length; ti++)
                        SectionListView(section: _sections[ti], heroPrefix: 'tab$ti'),
                    ],
                  ),
        ),
      ),
    );
  }

  // If no sections, flatten items (kept very small/simple)
  List<CatalogItemModel> _flatItems() {
    final list = <CatalogItemModel>[];
    for (final s in _sections) {
      list.addAll(s.items ?? const []);
    }
    return list;
  }
}

class SectionListView extends StatelessWidget {
  const SectionListView({super.key, required this.section, required this.heroPrefix});

  final CatalogSectionModel section;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    final items =
        (section.items ?? const []).where((i) => (i.status ?? true) == true).toList()
          ..sort((a, b) => (a.position ?? 9999).compareTo(b.position ?? 9999));

    if (items.isEmpty) {
      return const EmptyState(message: 'No items in this section.');
    }

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: items.length,
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, index) {
        final delay = (70 * index).ms;
        return ItemCard(item: items[index], heroTag: '$heroPrefix-$index')
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}

class EmptySectionList extends StatelessWidget {
  const EmptySectionList({super.key, required this.items, required this.heroPrefix});
  final List<CatalogItemModel> items;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(message: 'No items available.');
    }
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: items.length,
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, index) {
        final delay = (70 * index).ms;
        return ItemCard(item: items[index], heroTag: '$heroPrefix-$index')
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.heroTag});

  final CatalogItemModel item;
  final String heroTag;

  String _imageUrl(ImageModel? img) {
    final p = img?.path;
    if (p == null || p.isEmpty) {
      return 'https://images.unsplash.com/photo-1557821552-17105176677c?q=80&w=1200&auto=format&fit=crop';
    }
    return p.startsWith('http') ? p : p;
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final price = (item.price ?? '').isEmpty ? null : item.price;

    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GPSColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            spreadRadius: -4,
            offset: Offset(0, 6),
            color: Color(0x1A000000),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Hero(
              tag: heroTag,
              child: Image.network(
                _imageUrl(item.image),
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? 'Item',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: txt.titleSmall?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GPSGaps.h8,
                  if ((item.description ?? '').isNotEmpty)
                    Text(
                      item.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.35),
                    ),
                  GPSGaps.h8,
                  if (price != null)
                    Text(
                      price,
                      style: txt.titleSmall?.copyWith(
                        color: GPSColors.text,
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [FontFeature.tabularFigures()],
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
}

class BadgeChip extends StatelessWidget {
  const BadgeChip({super.key, required this.label, this.icon, this.iconColor = GPSColors.primary});

  final String label;
  final IconData? icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? Icons.check_circle, size: 16, color: iconColor),
          GPSGaps.w8,
          Text(
            label,
            style: text.labelMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class CircleBack extends StatelessWidget {
  const CircleBack({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ).animate().fadeIn().scale(begin: const Offset(.95, .95)),
      ),
    );
  }
}

class TodayHoursRow extends StatelessWidget {
  const TodayHoursRow({super.key, required this.operating});

  final OperatingTimeModel operating;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final now = DateTime.now();
    final key =
        <int, String>{1: 'mon', 2: 'tue', 3: 'wed', 4: 'thu', 5: 'fri', 6: 'sat', 7: 'sun'}[now
            .weekday]!;

    List<String>? slot;
    switch (key) {
      case 'mon':
        slot = operating.mon;
        break;
      case 'tue':
        slot = operating.tue;
        break;
      case 'wed':
        slot = operating.wed;
        break;
      case 'thu':
        slot = operating.thu;
        break;
      case 'fri':
        slot = operating.fri;
        break;
      case 'sat':
        slot = operating.sat;
        break;
      case 'sun':
        slot = operating.sun;
        break;
    }

    final text =
        (slot == null || slot.length < 2) ? 'Hours unavailable' : 'Today: ${slot[0]} – ${slot[1]}';

    return Row(
      children: [
        const Icon(Icons.access_time_filled_rounded, color: GPSColors.mutedText, size: 18),
        GPSGaps.w8,
        Text(text, style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText)),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 42,
              color: GPSColors.mutedText,
            ).animate().fadeIn(duration: 250.ms).scale(begin: const Offset(.9, .9)),
            GPSGaps.h12,
            Text(
              message,
              textAlign: TextAlign.center,
              style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText),
            ).animate().fadeIn(duration: 260.ms).slideY(begin: .05),
          ],
        ),
      ),
    );
  }
}
