import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/item_info/models/item_info.dart';

class ItemInfoScreen extends StatefulWidget {
  const ItemInfoScreen({super.key, required this.acceptorId, required this.itemId});
  final int acceptorId;
  final int itemId;
  @override
  State<ItemInfoScreen> createState() => _ItemInfoScreenState();
}

class _ItemInfoScreenState extends State<ItemInfoScreen> {
  late final ItemInfoEntity _item = ItemInfoEntity(
    itemImagePath:
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=1600&auto=format&fit=crop',
    isMeal: true,
    name: 'Fire-Grilled Lemon Chicken Bowl',
    description:
        'Free-range chicken, herb quinoa, roasted veggies, preserved lemon, tahini drizzle. Balanced macros and clean ingredients.',
    sectionName: "Today's Specials",
  );

  bool _isFav = false;

  @override
  Widget build(BuildContext context) {
    pr(widget.acceptorId, 'acceptorId');
    pr(widget.itemId, 'itemId');
    final txt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_item.itemImagePath != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                              _item.itemImagePath!,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              frameBuilder: (c, child, frame, wasSync) {
                                if (frame == null) {
                                  return Container(color: Colors.black12);
                                }
                                return child;
                              },
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.broken_image_rounded,
                                      color: GPSColors.mutedText,
                                      size: 40,
                                    ),
                                  ),
                            )
                            .animate()
                            .fadeIn(duration: 350.ms, curve: Curves.easeOutCubic)
                            .scale(
                              begin: const Offset(1.02, 1.02),
                              end: const Offset(1, 1),
                              duration: 400.ms,
                              curve: Curves.easeOut,
                            ),
                      ),
                    ),

                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0x66000000)],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 12,
                      right: 12,
                      child: Row(
                        children: [
                          _CircleIconButton(
                            icon: _isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            onTap: () => setState(() => _isFav = !_isFav),
                            foreground: _isFav ? Colors.redAccent : Colors.white,
                          ).animate().fadeIn(duration: 220.ms).scale(begin: const Offset(.9, .9)),
                          GPSGaps.w8,
                          _CircleIconButton(icon: Icons.share_rounded, onTap: () {})
                              .animate(delay: 60.ms)
                              .fadeIn(duration: 220.ms)
                              .scale(begin: const Offset(.9, .9)),
                        ],
                      ),
                    ),
                  ],
                ),

              GPSGaps.h16,

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_item.isMeal == true) const _BadgeChip(label: 'Meal'),
                  if (_item.sectionName != null) _BadgeChip(label: _item.sectionName!),
                ],
              ).animate().fadeIn(duration: 240.ms).slideY(begin: .08, curve: Curves.easeOutCubic),

              GPSGaps.h12,

              if (_item.name != null)
                Text(
                  _item.name!,
                  style: txt.headlineSmall?.copyWith(
                    color: GPSColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                ).animate().fadeIn(duration: 260.ms).slideY(begin: .06, curve: Curves.easeOutCubic),

              GPSGaps.h8,

              if (_item.description != null)
                Text(
                      _item.description!,
                      style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.4),
                    )
                    .animate(delay: 40.ms)
                    .fadeIn(duration: 260.ms)
                    .slideY(begin: .06, curve: Curves.easeOutCubic),

              GPSGaps.h16,

              _ActionCard(isMeal: _item.isMeal ?? false, sectionName: _item.sectionName)
                  .animate()
                  .fadeIn(duration: 260.ms)
                  .slideY(begin: .08, curve: Curves.easeOutCubic)
                  .scale(begin: const Offset(.98, .98)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GPSColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: -6,
            offset: Offset(0, 6),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: GPSColors.primary),
          GPSGaps.w8,
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onTap, this.foreground = Colors.white});

  final IconData icon;
  final VoidCallback? onTap;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, color: foreground, size: 22),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.isMeal, this.sectionName});

  final bool isMeal;
  final String? sectionName;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            spreadRadius: -6,
            offset: Offset(0, 8),
            color: Color(0x1A000000),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMeal ? 'Ready to order?' : 'Save for later',
                    style: txt.titleSmall?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (sectionName != null) ...[
                    GPSGaps.h4,
                    Text(
                      sectionName!,
                      style: txt.labelMedium?.copyWith(color: GPSColors.mutedText),
                    ),
                  ],
                ],
              ),
            ),
            GPSGaps.w12,
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: GPSColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.shopping_bag_rounded),
              label: Text(
                isMeal ? 'Add' : 'Save',
                style: txt.labelLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
