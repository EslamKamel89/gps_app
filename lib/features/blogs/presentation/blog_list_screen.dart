import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/blogs/cubits/blogs_cubit.dart';
import 'package:gps_app/features/blogs/models/blog_model/blog_model.dart';
import 'package:gps_app/features/blogs/presentation/widgets/blog_card.dart';
import 'package:gps_app/features/blogs/presentation/widgets/blog_list_loading_state.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key, this.scrollTo});
  final int? scrollTo;

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  late final BlogsCubit cubit;
  late final AutoScrollController _autoScrollController;
  int _currentTab = 4;
  @override
  void initState() {
    cubit = context.read<BlogsCubit>();
    cubit.blogs();
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
        pr(e, '_maybeScrollToIndex - BlogListScreen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogsCubit, ApiResponseModel<List<BlogModel>>>(
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
            title: const Text("Blogs"),
            backgroundColor: GPSColors.primary,
            foregroundColor: Colors.white,
            elevation: 1,
          ),
          body:
              state.response == ResponseEnum.loading && state.data == null
                  ? BlogListLoadingState()
                  : SingleChildScrollView(
                    controller: _autoScrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: List.generate(state.data?.length ?? 0, (index) {
                        final blog = state.data?[index];
                        if (blog == null) return SizedBox();
                        final delay = (index * 200).ms;
                        return AutoScrollTag(
                          key: ValueKey(blog.id),
                          controller: _autoScrollController,
                          index: blog.id ?? 1,
                          highlightColor: GPSColors.primary.withOpacity(0.3),
                          child: BlogCard(blog: blog)
                              .animate(delay: delay)
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                        );
                      }),
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
