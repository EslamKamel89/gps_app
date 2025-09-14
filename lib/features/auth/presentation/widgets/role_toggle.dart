import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

enum AuthRole { user, restaurant }

AuthRole authRole = AuthRole.user;

class RoleToggle extends StatefulWidget {
  const RoleToggle({super.key, this.isInLoginScreen = true});
  final bool isInLoginScreen;
  @override
  State<RoleToggle> createState() => _RoleToggleState();
}

class _RoleToggleState extends State<RoleToggle> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    isUser() => authRole == AuthRole.user;
    final duration = 300.ms;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2), width: 1),
      ),
      child: Stack(
        children: [
          Align(
            // duration: const Duration(milliseconds: 300),
            // width: MediaQuery.of(context).size.width - 24,
            // left: isUser ? 0 : MediaQuery.of(context).size.width * 0.5 - 24,
            // left: isUser() ? 0 : null,
            // right: !isUser() ? 0 : null,
            alignment: isUser() ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5 - 24,
              height: 44,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: GPSColors.primary,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: GPSColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: duration).scale(duration: duration),

          Row(
            children: [
              // User option
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      widget.isInLoginScreen
                          ? AppRoutesNames.loginScreen
                          : AppRoutesNames.registerScreen,
                      (_) => false,
                    );
                    setState(() {
                      authRole = AuthRole.user;
                    });
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                    child: Center(
                      child: Text(
                            'Consumer',
                            style: TextStyle(
                              color: isUser() ? Colors.white : GPSColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )
                          .animate()
                          .scale(duration: duration, begin: const Offset(0.9, 0.9))
                          .fade(duration: duration),
                    ),
                  ),
                ),
              ),

              // Restaurant option
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   widget.isInLoginScreen
                    //       ? AppRoutesNames.restaurantLoginScreen
                    //       : AppRoutesNames.restaurantRegisterScreen,
                    //   (_) => false,
                    // );
                    setState(() {
                      authRole = AuthRole.restaurant;
                    });
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                    child: Center(
                      child: Text(
                            'Vendor',
                            style: TextStyle(
                              color: !isUser() ? Colors.white : GPSColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )
                          .animate()
                          .scale(duration: duration, begin: const Offset(0.9, 0.9))
                          .fade(duration: duration),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack, begin: const Offset(0.95, 0.95));
  }
}
