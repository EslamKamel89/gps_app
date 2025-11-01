import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/blogs/models/blog_model/blog_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  late final List<BlogModel> blogs;

  @override
  void initState() {
    super.initState();

    // Dummy blog list
    blogs = List.generate(
      5,
      (index) => BlogModel(
        id: index + 1,
        title: "Blog Post #${index + 1}",
        content:
            "This is a short preview of the blog content. It demonstrates the trimming behavior of the text widget.",
        type: index % 2 == 0 ? "image" : "video",
        likesCount: 12 + index * 2,
        commentsCount: 3 + index,
        image: ImageModel(
          path: "https://picsum.photos/seed/blog${index + 1}/600/400", // dummy image
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      appBar: AppBar(
        title: const Text("Blogs"),
        backgroundColor: GPSColors.primary,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(blogs.length, (index) {
            final blog = blogs[index];
            // Apply sequential animation delay for each card
            final delay = (index * 200).ms;
            return _BlogCard(blog: blog)
                .animate(delay: delay)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
          }),
        ),
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final BlogModel blog;

  const _BlogCard({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(blog.image?.path),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title ?? "Untitled",
                  style: const TextStyle(
                    color: GPSColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2),
                GPSGaps.h8,
                Text(
                  blog.content ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: GPSColors.mutedText, fontSize: 14, height: 1.4),
                ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2),
                GPSGaps.h12,
                _buildBadges(blog),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? "",
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(color: GPSColors.cardBorder)
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  colors: [
                    GPSColors.cardBorder.withOpacity(0.3),
                    GPSColors.cardBorder.withOpacity(0.1),
                  ],
                  duration: 1.seconds,
                ),
        errorWidget:
            (context, url, error) => Container(
              color: GPSColors.cardBorder,
              height: 200,
              child: const Icon(Icons.image_not_supported, size: 48, color: GPSColors.mutedText),
            ),
      ),
    );
  }

  Widget _buildBadges(BlogModel blog) {
    return Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _buildBadge(
              icon: Icons.favorite,
              label: "${blog.likesCount ?? 0}",
              iconColor: Colors.red,
            ),
            _buildBadge(
              icon: Icons.comment,
              label: "${blog.commentsCount ?? 0}",
              iconColor: GPSColors.primary,
            ),
            if (blog.type != null)
              _buildBadge(icon: Icons.label, label: blog.type!, iconColor: GPSColors.primary),
          ],
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    Color iconColor = GPSColors.primary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: GPSColors.cardSelected.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          GPSGaps.w4,
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: GPSColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
