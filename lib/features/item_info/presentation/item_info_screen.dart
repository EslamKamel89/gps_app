import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/image_url.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/item_info/cubits/item_info_cubit.dart';
import 'package:gps_app/features/item_info/models/item_info.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/price_badge.dart';

class ItemInfoScreen extends StatefulWidget {
  const ItemInfoScreen({super.key, this.acceptorId, this.type, required this.itemId});
  final int? acceptorId;
  final String? type;
  final int itemId;
  @override
  State<ItemInfoScreen> createState() => _ItemInfoScreenState();
}

class _ItemInfoScreenState extends State<ItemInfoScreen> {
  bool _isFav = false;
  late final ItemInfoCubit cubit;
  @override
  void initState() {
    cubit = context.read<ItemInfoCubit>();
    cubit.getItem(type: widget.type, acceptorId: widget.acceptorId, itemId: widget.itemId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return BlocConsumer<ItemInfoCubit, ApiResponseModel<ItemInfoEntity>>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(backgroundColor: GPSColors.primary, title: Text(state.data?.name ?? '')),
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Builder(
                builder: (context) {
                  final item = state.data;
                  if (item == null || state.response == ResponseEnum.loading) {
                    return const _LoadingShimmer();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (item.itemImagePath != null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                    getImageUrl(item.itemImagePath),
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
                                      icon:
                                          _isFav
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                      onTap: () => setState(() => _isFav = !_isFav),
                                      foreground: _isFav ? Colors.redAccent : Colors.white,
                                    )
                                    .animate()
                                    .fadeIn(duration: 220.ms)
                                    .scale(begin: const Offset(.9, .9)),
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
                              _BadgeChip(label: item.isMeal == true ? 'Meal' : 'Product'),
                              if (item.sectionName != null) _BadgeChip(label: item.sectionName!),
                              PriceBadge(price: double.parse(item.price ?? '0')),
                            ],
                          )
                          .animate()
                          .fadeIn(duration: 240.ms)
                          .slideY(begin: .08, curve: Curves.easeOutCubic),

                      GPSGaps.h12,

                      if (item.name != null)
                        Text(
                              item.name!,
                              style: txt.headlineSmall?.copyWith(
                                color: GPSColors.text,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 260.ms)
                            .slideY(begin: .06, curve: Curves.easeOutCubic),

                      GPSGaps.h8,

                      if (item.description != null)
                        Text(
                              item.description!,
                              style: txt.bodyMedium?.copyWith(
                                color: GPSColors.mutedText,
                                height: 1.4,
                              ),
                            )
                            .animate(delay: 40.ms)
                            .fadeIn(duration: 260.ms)
                            .slideY(begin: .06, curve: Curves.easeOutCubic),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
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

/// ----------- Loading Shimmer (flutter_animate) -----------

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32; // padding accounted for in parent
    final chipHeights = 34.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image skeleton (16:9)
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(color: Colors.white)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 1200.ms, color: Colors.white)
                .fadeIn(duration: 240.ms),
          ),
        ),

        GPSGaps.h16,

        // Chips row skeleton
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ShimmerBox(width: 90, height: chipHeights, radius: 18),
            _ShimmerBox(width: 120, height: chipHeights, radius: 18),
            _ShimmerBox(width: 100, height: chipHeights, radius: 18),
          ],
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .06),

        GPSGaps.h12,

        // Title skeleton
        _ShimmerBox(
          width: width * 0.65,
          height: 26,
          radius: 8,
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .06),

        GPSGaps.h8,

        // Description lines skeleton
        _ShimmerBox(
          width: width * 0.95,
          height: 14,
          radius: 6,
        ).animate(delay: 40.ms).fadeIn(duration: 220.ms).slideY(begin: .06),
        GPSGaps.h6,
        _ShimmerBox(
          width: width * 0.90,
          height: 14,
          radius: 6,
        ).animate(delay: 80.ms).fadeIn(duration: 220.ms).slideY(begin: .06),
        GPSGaps.h6,
        _ShimmerBox(
          width: width * 0.60,
          height: 14,
          radius: 6,
        ).animate(delay: 120.ms).fadeIn(duration: 220.ms).slideY(begin: .06),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.width, required this.height, this.radius = 12});

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: GPSColors.cardBorder),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: -6,
                offset: Offset(0, 6),
                color: Color(0x14000000),
              ),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1100.ms, color: Colors.white)
        .fadeIn(duration: 200.ms)
        .scale(begin: const Offset(.995, .995));
  }
}
