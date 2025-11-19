import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/wish_button.dart';
import 'package:gps_app/features/wishlist/cubits/wishes_cubit.dart';
import 'package:gps_app/features/wishlist/models/acceptor_model/wish_model.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/wish_card.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key, this.scrollTo});
  final int? scrollTo;
  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> with TickerProviderStateMixin {
  late final WishesCubit cubit;
  late final AutoScrollController _autoScrollController;
  int _currentTab = 3;
  @override
  void initState() {
    cubit = context.read<WishesCubit>();
    cubit.wishes();
    _autoScrollController = AutoScrollController(
      axis: Axis.vertical,
      // suggestedRowHeight: 120,
    );
    super.initState();
  }

  @override
  void dispose() {
    _autoScrollController.dispose();
    super.dispose();
  }

  Future<void> _maybeScrollToIndex(int id, int itemCount) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _autoScrollController.scrollToIndex(id, preferPosition: AutoScrollPosition.begin);
        _autoScrollController.highlight(id);
      } catch (e) {
        pr(e, '_maybeScrollToIndex - WishListScreen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return BlocConsumer<WishesCubit, ApiResponseModel<List<WishModel>>>(
      listener: (context, state) {
        if (state.response == ResponseEnum.success && widget.scrollTo != null) {
          final wishes = state.data ?? [];
          _maybeScrollToIndex(widget.scrollTo!, wishes.length);
        }
      },
      builder: (context, state) {
        final wishes = state.data ?? [];
        return Scaffold(
          backgroundColor: GPSColors.background,
          appBar: _appBar(),
          body: SafeArea(
            child:
                state.response == ResponseEnum.success
                    ? ListView.separated(
                      controller: _autoScrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: wishes.length,
                      separatorBuilder: (_, __) => GPSGaps.h12,
                      itemBuilder: (context, index) {
                        final wish = wishes[index];
                        return AutoScrollTag(
                          key: ValueKey(wish.id),
                          controller: _autoScrollController,
                          index: wish.id ?? 1,
                          highlightColor: GPSColors.primary.withOpacity(0.3),
                          child: WishCard(wish: wish)
                              .animate(delay: (60 * index).ms)
                              .fadeIn(duration: 280.ms, curve: Curves.easeOutCubic)
                              .slideY(begin: .08, curve: Curves.easeOutCubic)
                              .scale(begin: const Offset(.98, .98)),
                        );
                      },
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: 4,
                      separatorBuilder: (_, __) => GPSGaps.h12,
                      itemBuilder: (context, index) {
                        return WishCardSkeleton()
                            .animate(delay: (60 * index).ms)
                            .fadeIn(duration: 280.ms, curve: Curves.easeOutCubic)
                            .slideY(begin: .08, curve: Curves.easeOutCubic)
                            .scale(begin: const Offset(.98, .98));
                      },
                    ),
          ),
          floatingActionButton: WishButton(),
          bottomNavigationBar: GPSBottomNav(
            currentIndex: _currentTab,
            onChanged: (i) {
              setState(() => _currentTab = i);
            },
          ),
        );
      },
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: GPSColors.background,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 12,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: GPSColors.primary.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GPSColors.cardBorder),
            ),
            child: const Icon(Icons.local_florist_rounded, color: GPSColors.primary, size: 22),
          ).animate().fadeIn(duration: 280.ms).scale(begin: const Offset(.9, .9)),
          GPSGaps.w12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userInMemory()?.userName ?? '',
                style: TextStyle(color: GPSColors.text, fontWeight: FontWeight.w800),
              ),
              // Text(
              //   _userRank,
              //   style: txt.labelMedium?.copyWith(color: GPSColors.mutedText, height: 1.2),
              // ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: GPSColors.text),
        ).animate().fadeIn(),
        GPSGaps.w8,
      ],
    );
  }
}
