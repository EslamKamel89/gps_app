import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/favorites/cubits/favorites_cubit.dart';
import 'package:gps_app/features/favorites/models/favorite_model.dart';
import 'package:gps_app/features/favorites/presentation/widgets/empty_state.dart';
import 'package:gps_app/features/favorites/presentation/widgets/favorite_card.dart';
import 'package:gps_app/features/favorites/presentation/widgets/loading_favorities_widget.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, this.scrollTo});
  final int? scrollTo;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _currentTab = 1;
  late final FavoritesCubit cubit;
  late final AutoScrollController _autoScrollController;
  @override
  void initState() {
    super.initState();
    cubit = context.read<FavoritesCubit>();
    cubit.favorites();
    _autoScrollController = AutoScrollController(
      axis: Axis.vertical,
      // suggestedRowHeight: 120,
    );
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
        pr(e, '_maybeScrollToIndex - FavoritesScreen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesCubit, ApiResponseModel<List<FavoriteModel>>>(
      listener: (context, state) {
        if (state.response == ResponseEnum.success && widget.scrollTo != null) {
          final wishes = state.data ?? [];
          _maybeScrollToIndex(widget.scrollTo!, wishes.length);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: GPSColors.background,
          appBar: AppBar(
            backgroundColor: GPSColors.primary,
            elevation: 0,
            centerTitle: true,
            title: Text(
              '💖 Favorites',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child:
                state.data?.isNotEmpty == true
                    ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _autoScrollController,
                      shrinkWrap: true,
                      itemCount: state.data?.length ?? 0,
                      itemBuilder: (context, i) {
                        final fav = state.data![i];
                        return AutoScrollTag(
                          key: ValueKey(fav.id),
                          controller: _autoScrollController,
                          index: fav.id ?? 1,
                          highlightColor: GPSColors.primary.withOpacity(0.3),
                          child: FavoriteCard(
                                key: ValueKey('fav_${fav.id}-${fav.favoriteType}'),
                                favorite: fav,
                              )
                              .animate(delay: (50 * i).ms)
                              .fadeIn(duration: 300.ms)
                              .move(
                                begin: const Offset(0, 16),
                                end: Offset.zero,
                                duration: 400.ms,
                                curve: Curves.easeOut,
                              ),
                        );
                      },
                    )
                    : state.response == ResponseEnum.loading
                    ? LoadingFavoritesPlaceholder()
                    : EmptyState()
                        .animate()
                        .fade(duration: 300.ms)
                        .move(
                          begin: const Offset(0, 12),
                          end: Offset.zero,
                          duration: 400.ms,
                          curve: Curves.easeOut,
                        ),
          ),
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
}

extension SeparatedBy on List<Widget> {
  List<Widget> separatedBy(Widget Function() separatorBuilder) {
    final out = <Widget>[];
    for (var i = 0; i < length; i++) {
      out.add(this[i]);
      if (i != length - 1) out.add(separatorBuilder());
    }
    return out;
  }
}
