import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/helpers/image_url.dart';
import 'package:gps_app/features/blogs/models/blog_model/blog_model.dart';
import 'package:gps_app/features/blogs/presentation/blog_details_screen.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class BlogCard extends StatelessWidget {
  final BlogModel blog;

  const BlogCard({super.key, required this.blog});

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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlogDetailsScreen(blog: blog),
                  ),
                );
              },
              child: Column(
                children: [
                  _buildImage(blog.image?.path),
                  GPSGaps.h8,
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
                    style: const TextStyle(
                      color: GPSColors.mutedText,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2),
                  GPSGaps.h12,
                ],
              ),
            ),
            BadgesRow(blog: blog),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: CachedNetworkImage(
        imageUrl: getImageUrl(imageUrl),
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
              child: const Icon(
                Icons.image_not_supported,
                size: 48,
                color: GPSColors.mutedText,
              ),
            ),
      ),
    );
  }
}
