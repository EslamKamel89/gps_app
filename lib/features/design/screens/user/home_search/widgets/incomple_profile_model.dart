import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/globals.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/restaurant_detail_provider.dart';

//! this alert is disabled
bool _callOnce = true;
Future<void> handleIncompleteProfile() async {
  if (_callOnce) return;
  _callOnce = true;
  await Future.delayed(1000.ms);
  final user = serviceLocator<LocalStorage>().cachedUser;
  final ctx = navigatorKey.currentContext;
  if (user == null || ctx == null) return;

  if (user.userType?.type == 'user') return;

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
      elevation: 2,
      backgroundColor: cs.surface,
      surfaceTintColor: cs.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),

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

      content: const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          "Please finish your restaurant profile to unlock publishing and discovery features.",
        ),
      ),

      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text("Remind me later"),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).maybePop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => RestaurantDetailProvider(
                      restaurantId: userInMemory()?.restaurant?.id ?? 1,
                      enableEdit: false,
                      enableCompleteProfile: true,
                    ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text("Complete now"),
          style: FilledButton.styleFrom(
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
