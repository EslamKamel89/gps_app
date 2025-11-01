import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/blogs/models/blog_model/blog_model.dart';
import 'package:gps_app/features/blogs/models/blog_model/comment_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BlogDetailsScreen extends StatefulWidget {
  final BlogModel blog;

  const BlogDetailsScreen({super.key, required this.blog});

  @override
  State<BlogDetailsScreen> createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  YoutubePlayerController? _youtubeController;
  final TextEditingController _commentController = TextEditingController();
  final ValueNotifier<List<CommentModel>> _commentsNotifier = ValueNotifier([]);
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    // Initialize comments in-memory from incoming blog (safe copy)
    _commentsNotifier.value = List<CommentModel>.from(widget.blog.comments ?? []);

    // Initialize YouTube controller if we have a valid video id
    if (widget.blog.type == "video" && widget.blog.link != null) {
      final vid = _extractYoutubeId(widget.blog.link!);
      if (vid != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: vid,
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
        );
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _commentController.dispose();
    _commentsNotifier.dispose();
    super.dispose();
  }

  /// Attempts to extract a YouTube video id from multiple possible URL formats.
  /// Returns `null` if extraction fails.
  String? _extractYoutubeId(String url) {
    try {
      // Use youtube_player_flutter helper if available; otherwise regex fallback
      final idFromYouTube = YoutubePlayer.convertUrlToId(url);
      if (idFromYouTube != null && idFromYouTube.isNotEmpty) return idFromYouTube;

      // Regex fallback (common patterns)
      final regExp = RegExp(
        r'(?:v=|v\/|embed\/|youtu\.be\/|\/v\/|watch\?v=|&v=)([A-Za-z0-9_-]{11})',
        caseSensitive: false,
      );
      final match = regExp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    } catch (_) {}
    return null;
  }

  void _onAddComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch,
      blogId: widget.blog.id,
      comment: text,
      createdAt: DateTime.now(),
      user: UserModel(
        id: 0,
        userName: "you",
        fullName: "You",
        image: ImageModel(path: "https://picsum.photos/seed/user/80/80"),
      ),
    );
    // Add to notifier list
    _commentsNotifier.value = [newComment, ..._commentsNotifier.value];
    _commentController.clear();
    // optional: scroll-to-top behavior could be added later
  }

  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;
    return Scaffold(
      backgroundColor: GPSColors.background,
      appBar: AppBar(
        title: const Text("Blog Details"),
        backgroundColor: GPSColors.primary,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media: either youtube player (if valid) or image
            _buildMediaSection(blog).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

            GPSGaps.h12,

            // Title
            Text(
              blog.title ?? "Untitled",
              style: const TextStyle(
                color: GPSColors.text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.15),

            GPSGaps.h8,

            // Content (trimmed to two lines)
            Text(
              blog.content ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: GPSColors.mutedText, fontSize: 15, height: 1.4),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.15),

            GPSGaps.h12,

            // Badges row (wrap)
            _buildBadges(
              blog,
            ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.95, 0.95)),

            GPSGaps.h16,

            // Add Comment field (above comments list per your instruction)
            _buildAddCommentField(),

            GPSGaps.h12,

            // Comments header
            Row(
              children: [
                const Text(
                  "Comments",
                  style: TextStyle(
                    color: GPSColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GPSGaps.w8,
                Text(
                  "(${_commentsNotifier.value.length})",
                  style: const TextStyle(color: GPSColors.mutedText, fontSize: 13),
                ),
              ],
            ).animate().fadeIn(duration: 300.ms),

            GPSGaps.h12,

            // Comments List (shrinkWrap ListView)
            ValueListenableBuilder<List<CommentModel>>(
              valueListenable: _commentsNotifier,
              builder: (context, comments, _) {
                if (comments.isEmpty) {
                  return Center(
                    child:
                        Column(
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: GPSColors.mutedText,
                            ),
                            GPSGaps.h8,
                            const Text(
                              "No comments yet",
                              style: TextStyle(color: GPSColors.mutedText),
                            ),
                          ],
                        ).animate().fadeIn(),
                  );
                }

                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final c = comments[idx];
                    return _buildCommentItem(c)
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: -0.05 * (idx % 2 == 0 ? 1 : -1));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// Media: Youtube player if possible, otherwise image
  /// ----------------------------------------------------------
  Widget _buildMediaSection(BlogModel blog) {
    final imageUrl = blog.image?.path ?? "";
    // If we have a youtube controller it means we successfully extracted an id
    if (_youtubeController != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: GPSColors.primary,
          progressColors: ProgressBarColors(
            playedColor: GPSColors.primary,
            handleColor: GPSColors.primary,
          ),
        ),
      );
    }

    // Fallback to image
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(color: GPSColors.cardBorder)
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  colors: [
                    GPSColors.cardBorder.withOpacity(0.3),
                    GPSColors.cardBorder.withOpacity(0.08),
                  ],
                  duration: 1.seconds,
                ),
        errorWidget:
            (context, url, error) => Container(
              height: 220,
              color: GPSColors.cardBorder,
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported, size: 48, color: GPSColors.mutedText),
            ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// Badges build (likes, comments count, type)
  /// ----------------------------------------------------------
  Widget _buildBadges(BlogModel blog) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        // Likes with heart icon (toggle in-memory)
        GestureDetector(
          onTap: () {
            setState(() => _liked = !_liked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: GPSColors.cardSelected.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GPSColors.cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _liked ? Icons.favorite : Icons.favorite_border,
                  color: _liked ? Colors.red : GPSColors.primary,
                  size: 16,
                ),
                GPSGaps.w8,
                Text(
                  "${blog.likesCount ?? 0}",
                  style: const TextStyle(fontWeight: FontWeight.w600, color: GPSColors.text),
                ),
              ],
            ),
          ),
        ),

        // Comments count badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: GPSColors.cardSelected.withOpacity(0.45),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.comment, size: 16, color: GPSColors.primary),
              GPSGaps.w8,
              Text(
                "${blog.commentsCount ?? (widget.blog.comments?.length ?? 0)}",
                style: const TextStyle(fontWeight: FontWeight.w600, color: GPSColors.text),
              ),
            ],
          ),
        ),

        // Type badge if available
        if (blog.type != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: GPSColors.cardSelected.withOpacity(0.45),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GPSColors.cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.label, size: 16, color: GPSColors.primary),
                GPSGaps.w8,
                Text(
                  blog.type!,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: GPSColors.text),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// ----------------------------------------------------------
  /// Add Comment Field (above comments)
  /// ----------------------------------------------------------
  Widget _buildAddCommentField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              textInputAction: TextInputAction.send,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Add a comment...",
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (_) => _onAddComment(),
            ),
          ),
          IconButton(
            onPressed: _onAddComment,
            icon: const Icon(Icons.send_rounded, color: GPSColors.primary),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.98, 0.98));
  }

  /// ----------------------------------------------------------
  /// Single Comment Item
  /// ----------------------------------------------------------
  Widget _buildCommentItem(CommentModel comment) {
    final user = comment.user;
    final avatarUrl = user?.image?.path ?? "";
    final username = user?.userName ?? user?.fullName ?? "Unknown";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: avatarUrl,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Container(width: 44, height: 44, color: GPSColors.cardBorder)
                    .animate(onPlay: (ctrl) => ctrl.repeat())
                    .shimmer(
                      colors: [
                        GPSColors.cardBorder.withOpacity(0.3),
                        GPSColors.cardBorder.withOpacity(0.08),
                      ],
                    ),
            errorWidget:
                (context, url, error) => Container(
                  width: 44,
                  height: 44,
                  color: GPSColors.cardBorder,
                  child: const Icon(Icons.person, color: GPSColors.mutedText),
                ),
          ),
        ),
        GPSGaps.w12,
        // Body
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username + timeago
              Row(
                children: [
                  Expanded(
                    child: Text(
                      username,
                      style: const TextStyle(
                        color: GPSColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    comment.createdAt != null ? timeago.format(comment.createdAt!) : "",
                    style: const TextStyle(color: GPSColors.mutedText, fontSize: 12),
                  ),
                ],
              ),
              GPSGaps.h6,
              // Comment content
              Text(
                comment.comment ?? "",
                style: const TextStyle(color: GPSColors.mutedText, fontSize: 14, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
