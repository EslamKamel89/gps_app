import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/helpers/image_url.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/features/blogs/cubits/blogs_cubit.dart';
import 'package:gps_app/features/blogs/models/blog_model/blog_model.dart';
import 'package:gps_app/features/blogs/models/blog_model/comment_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/form_bottom_sheet.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/restaurant_details_forms.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

  @override
  void initState() {
    super.initState();

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

    super.dispose();
  }

  String? _extractYoutubeId(String url) {
    try {
      final idFromYouTube = YoutubePlayer.convertUrlToId(url);
      if (idFromYouTube != null && idFromYouTube.isNotEmpty) return idFromYouTube;

      final regExp = RegExp(
        r'(?:v=|v\/|embed\/|youtu\.be\/|\/v\/|watch\?v=|&v=)([A-Za-z0-9_-]{11})',
        caseSensitive: false,
      );
      final match = regExp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    } catch (_) {}
    return null;
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
            MediaSection(
              blog: blog,
              youtubeController: _youtubeController,
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

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
            BadgesRow(
              blog: blog,
            ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.95, 0.95)),

            GPSGaps.h16,

            AddCommentWidget(blog: widget.blog),

            GPSGaps.h12,

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
                  "(${blog.comments?.length ?? 0})",
                  style: const TextStyle(color: GPSColors.mutedText, fontSize: 13),
                ),
              ],
            ).animate().fadeIn(duration: 300.ms),

            GPSGaps.h12,
            blog.comments?.isNotEmpty == true
                ? CommentsList(blog: blog)
                : Center(
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
                ),
            // Comments List (shrinkWrap ListView)
          ],
        ),
      ),
    );
  }
}

class MediaSection extends StatefulWidget {
  const MediaSection({super.key, required this.blog, required this.youtubeController});
  final BlogModel blog;
  final YoutubePlayerController? youtubeController;
  @override
  State<MediaSection> createState() => _MediaSectionState();
}

class _MediaSectionState extends State<MediaSection> {
  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.blog.image?.path ?? "";
    if (widget.youtubeController != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: YoutubePlayer(
          controller: widget.youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: GPSColors.primary,
          progressColors: ProgressBarColors(
            playedColor: GPSColors.primary,
            handleColor: GPSColors.primary,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: getImageUrl(imageUrl),
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
}

class BadgesRow extends StatefulWidget {
  const BadgesRow({super.key, required this.blog});
  final BlogModel blog;

  @override
  State<BadgesRow> createState() => _BadgesRowState();
}

class _BadgesRowState extends State<BadgesRow> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BlogsCubit>();
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        GestureDetector(
          onTap: () {
            cubit.likeBlog(blog: widget.blog);
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
                Icon(Icons.favorite, color: Colors.red, size: 16),
                GPSGaps.w8,
                Text(
                  "${widget.blog.likesCount ?? 0}",
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
                "${widget.blog.commentsCount ?? (widget.blog.comments?.length ?? 0)}",
                style: const TextStyle(fontWeight: FontWeight.w600, color: GPSColors.text),
              ),
            ],
          ),
        ),

        // Type badge if available
        if (widget.blog.type != null)
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
                Icon(
                  widget.blog.type == 'image' ? Icons.image : MdiIcons.youtube,
                  size: 16,
                  color: GPSColors.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class AddCommentWidget extends StatefulWidget {
  const AddCommentWidget({super.key, required this.blog});
  final BlogModel blog;
  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
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
              child: TextFormField(
                textInputAction: TextInputAction.send,
                controller: _commentController,
                minLines: 1,
                maxLines: 3,
                validator: (v) => validator(input: v, label: 'comment', isRequired: true),
                decoration: const InputDecoration(
                  hintText: "Add a comment...",
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),

                // onSubmitted: (_) => _onAddComment(),
              ),
            ),
            IconButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                context.read<BlogsCubit>().addComment(
                  blog: widget.blog,
                  content: _commentController.text,
                );
                setState(() {
                  _commentController.text = '';
                });
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(Icons.send_rounded, color: GPSColors.primary),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.98, 0.98)),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.comment});
  final CommentModel comment;
  @override
  Widget build(BuildContext context) {
    final user = comment.user;
    final avatarUrl = getImageUrl(user?.image?.path);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    comment.comment ?? "",
                    style: const TextStyle(color: GPSColors.mutedText, fontSize: 14, height: 1.4),
                  ),
                  if (userInMemory()?.id == comment.userId)
                    InkWell(
                      onTap: () async {
                        final String? newVal = await showFormBottomSheet<String>(
                          context,
                          builder:
                              (ctx, ctl) => ProfileTextForm(
                                initialValue: comment.comment,
                                controller: ctl,
                                label: 'Update Your Comment ',
                              ),
                        );
                        if (newVal == null) return;
                        context.read<BlogsCubit>().updateComment(comment: comment, content: newVal);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text('🖊️ Edit'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommentsList extends StatefulWidget {
  const CommentsList({super.key, required this.blog});
  final BlogModel blog;
  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  @override
  Widget build(BuildContext context) {
    context.watch<BlogsCubit>();
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.blog.comments?.length ?? 0,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final c = widget.blog.comments![idx];
        return CommentWidget(
          comment: c,
        ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.05 * (idx % 2 == 0 ? 1 : -1));
      },
    );
  }
}
