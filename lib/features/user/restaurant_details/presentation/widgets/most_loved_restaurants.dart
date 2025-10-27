import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/cubits/restaurants_cubit.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_main_data.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/restaurant_detail_provider.dart';

class MostLovedRestaurantsProvider extends StatelessWidget {
  const MostLovedRestaurantsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantsCubit()..restaurantsIndex(),
      child: const MostLovedRestaurantsWidget(),
    );
  }
}

class MostLovedRestaurantsWidget extends StatefulWidget {
  const MostLovedRestaurantsWidget({super.key});

  @override
  State<MostLovedRestaurantsWidget> createState() => _MostLovedRestaurantsWidgetState();
}

class _MostLovedRestaurantsWidgetState extends State<MostLovedRestaurantsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, ApiResponseModel<List<RestaurantMainData>>>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Most ❤️ Restaurants",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: GPSColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                ).animate().fadeIn(duration: 250.ms).slideY(begin: .15),
              ),
              GPSGaps.h12,
              SizedBox(
                height: 140,
                child:
                    state.response == ResponseEnum.success
                        ? ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.data?.length ?? 0,
                          separatorBuilder: (_, __) => GPSGaps.w12,
                          itemBuilder: (context, i) {
                            final it = state.data![i];
                            return _RestaurantItem(
                                  restaurant: it,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => RestaurantDetailProvider(
                                              restaurantId: it.id ?? 1,
                                              enableEdit: false,
                                            ),
                                      ),
                                    );
                                  },
                                )
                                .animate()
                                .fadeIn(duration: 280.ms, delay: (i * 60).ms)
                                .slideX(begin: .08);
                          },
                        )
                        : const _LoadingListShimmer(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RestaurantItem extends StatelessWidget {
  const _RestaurantItem({required this.restaurant, required this.onTap});

  final RestaurantMainData restaurant;
  final VoidCallback onTap;

  static const double _avatarSize = 80;

  @override
  Widget build(BuildContext context) {
    final imageUrl = "${EndPoint.baseUrl}/${restaurant.path}";
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        child: Column(
          children: [
            Stack(
                  children: [
                    ClipOval(
                      child: Ink(
                        width: _avatarSize,
                        height: _avatarSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: GPSColors.cardBorder),
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder:
                              (_, __) => const _CircleImagePlaceholderShimmer(size: _avatarSize),
                          errorWidget: (_, __, ___) => const _CircleImageError(size: _avatarSize),
                          fadeInDuration: 250.ms,
                        ),
                      ),
                    ),
                  ],
                )
                .animate(onPlay: (c) => c.repeat(reverse: false, count: 1))
                .shimmer(delay: 1200.ms, duration: 1000.ms),
            GPSGaps.h8,

            SizedBox(
              width: 80,
              child: Text(
                restaurant.vendorName ?? '',
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: GPSColors.text,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingListShimmer extends StatelessWidget {
  const _LoadingListShimmer();

  @override
  Widget build(BuildContext context) {
    const itemCount = 6;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      separatorBuilder: (_, __) => GPSGaps.w12,
      itemBuilder: (context, i) {
        return Column(
          children: [
            const _CircleImagePlaceholderShimmer(
              size: 80,
            ).animate(delay: (i * 60).ms).fadeIn(duration: 250.ms).shimmer(duration: 1200.ms),
            GPSGaps.h8,
            Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: GPSColors.cardBorder.withOpacity(.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                )
                .animate(delay: (i * 60).ms + 120.ms)
                .fadeIn(duration: 250.ms)
                .shimmer(duration: 1200.ms),
          ],
        );
      },
    );
  }
}

class _CircleImagePlaceholderShimmer extends StatelessWidget {
  const _CircleImagePlaceholderShimmer({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: GPSColors.cardBorder.withOpacity(.25),
          shape: BoxShape.circle,
          border: Border.all(color: GPSColors.cardBorder),
        ),
      ).animate().shimmer(duration: 1200.ms, delay: 100.ms),
    );
  }
}

class _CircleImageError extends StatelessWidget {
  const _CircleImageError({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: GPSColors.cardBorder.withOpacity(.18),
        shape: BoxShape.circle,
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: const Icon(Icons.broken_image_outlined, size: 24, color: Colors.black54),
    ).animate().fadeIn(duration: 200.ms).shake(hz: 3, offset: const Offset(2, 0), duration: 350.ms);
  }
}
