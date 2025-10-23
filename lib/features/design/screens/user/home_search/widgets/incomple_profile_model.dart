import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/user/restaurants/presentation/restaurant_detail_provider.dart';

bool _callOnce = false;
Future<void> handleIncompleteProfile() async {
  if (_callOnce) return;
  _callOnce = true;
  await Future.delayed(1000.ms);
  final user = serviceLocator<LocalStorage>().cachedUser;
  final ctx = navigatorKey.currentContext;
  if (user == null || ctx == null) return;

  // Only warn restaurant users
  if (user.userType?.type != 'restaurant') return;

  await showDialog<void>(
    context: ctx,
    barrierDismissible: true, // let them tap outside to dismiss
    builder: (context) => _IncompleteProfileDialog(),
  );
}

class _IncompleteProfileDialog extends StatelessWidget {
  const _IncompleteProfileDialog();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      // Modern look & feel
      elevation: 2,
      backgroundColor: cs.surface,
      surfaceTintColor: cs.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),

      // Header with warning icon + title
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: cs.errorContainer,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.warning_amber_rounded,
              color: cs.onErrorContainer,
              size: 28,
              semanticLabel: 'Warning',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "You're almost set!",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),

      // Friendly, concise message
      content: const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          "Please finish your restaurant profile to unlock publishing and discovery features.",
        ),
      ),

      // Action buttons
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text("Remind me later"),
        ),
        FilledButton.icon(
          // Use your routing here, or accept a callback
          onPressed: () {
            Navigator.of(context).maybePop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => RestaurantDetailProvider(
                      restaurantId: user()?.restaurant?.id ?? 1,
                      enableEdit: false,
                      enableCompleteProfile: true,
                    ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text("Complete now"),
          style: FilledButton.styleFrom(
            backgroundColor: GPSColors.primary,
            // subtle warning vibe via tertiary / secondary hues
            // (keeps good contrast in light/dark themes)
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
