import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/favorites/presentation/widgets/error_avatar.dart';
import 'package:gps_app/features/favorites/presentation/widgets/image_placeholder.dart';
import 'package:gps_app/features/favorites/presentation/widgets/initials_avatar.dart';

class FavoriteAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;

  const FavoriteAvatar({
    super.key,
    required this.imageUrl,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    final size = 52.0;

    if (imageUrl == null || imageUrl!.isEmpty) {
      // No image → initials in a colored circle
      return InitialsAvatar(size: size, initials: initials);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        fadeInDuration: 200.ms,
        placeholder: (context, _) => ImagePlaceholder(size: size),
        errorWidget: (context, _, __) => ErrorAvatar(size: size),
      ).animate(
        onPlay: (c) => c,
        // ..fadeIn(duration: 200.ms).scale(
        //   begin: const Offset(0.98, 0.98),
        //   end: const Offset(1, 1),
        //   duration: 200.ms,
        // ),
      ),
    );
  }
}
