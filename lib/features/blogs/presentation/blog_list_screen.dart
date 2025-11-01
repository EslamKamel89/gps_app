import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/blogs/cubits/blogs_cubit.dart';
import 'package:gps_app/features/blogs/models/blog_model/blog_model.dart';
import 'package:gps_app/features/blogs/presentation/widgets/blog_card.dart';
import 'package:gps_app/features/blogs/presentation/widgets/blog_list_loading_state.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  late final BlogsCubit cubit;
  int _currentTab = 4;
  @override
  void initState() {
    cubit = context.read<BlogsCubit>();
    cubit.blogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogsCubit, ApiResponseModel<List<BlogModel>>>(
      listener: (context, state) {},
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
              state.response == ResponseEnum.loading
                  ? BlogListLoadingState()
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: List.generate(state.data?.length ?? 0, (index) {
                        final blog = state.data?[index];
                        if (blog == null) return SizedBox();
                        final delay = (index * 200).ms;
                        return BlogCard(blog: blog)
                            .animate(delay: delay)
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
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
