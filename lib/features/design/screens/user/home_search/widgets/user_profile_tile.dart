import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.onTap,
    this.backgroundColor,
    this.initialsBackgroundColor,
  });

  final String name;
  final String email;
  final String avatarUrl;
  final VoidCallback? onTap;

  final Color? backgroundColor;
  final Color? initialsBackgroundColor;

  String _initialsFrom(String name, String email) {
    String sanitize(String s) => s.trim().replaceAll(RegExp(r'\s+'), ' ');
    final n = sanitize(name);
    if (n.isNotEmpty) {
      final parts = n.split(' ');
      if (parts.length >= 2) {
        return (parts[0].isNotEmpty ? parts[0][0] : '') +
            (parts[1].isNotEmpty ? parts[1][0] : '');
      }

      return n.substring(0, n.length >= 2 ? 2 : 1);
    }

    final local = email.split('@').first;
    if (local.isNotEmpty) {
      return local.substring(0, local.length >= 2 ? 2 : 1);
    }
    return '??';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    const baseTextColor = Color(0xFF0F172A);
    const subTextColor = Color(0xFF475569);
    const iconBorder = Color(0xFFE2E8F0);

    final tileBg = backgroundColor ?? theme.colorScheme.surface;
    final initialsBg = initialsBackgroundColor ?? const Color(0xFFE2E8F0);

    final initials = _initialsFrom(name, email).toUpperCase();

    void handleTap() => onTap?.call();

    return Material(
      color: tileBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap == null ? null : handleTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: iconBorder),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: avatarUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 180),
                      fadeOutDuration: const Duration(milliseconds: 120),
                      placeholder:
                          (context, url) => Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color: initialsBg,
                            alignment: Alignment.center,
                            child: Text(
                              initials,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: baseTextColor,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: baseTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: subTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Color(0xFF334155),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
