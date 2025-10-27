import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/update_controller.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/custom_stack.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/form_bottom_sheet.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/restaurant_details_forms.dart';
import 'package:gps_app/features/user/store_details/cubits/store_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({
    required this.enableEdit,
    super.key,
    required this.user,
    this.title = 'Contact',
  });

  final UserModel? user;
  final String title;
  final bool enableEdit;

  @override
  State<ContactCard> createState() => _ContactCardState();

  static String _normalizeUrl(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return t;
    final hasScheme = t.startsWith('http://') || t.startsWith('https://');
    return hasScheme ? t : 'https://$t';
  }
}

class _ContactCardState extends State<ContactCard> {
  bool get _hasEmail => (widget.user?.email?.trim().isNotEmpty ?? false);

  bool get _hasMobile => (widget.user?.mobile?.trim().isNotEmpty ?? false);

  bool get _hasWebsite => (widget.user?.storeOrFarm()?.website?.trim().isNotEmpty ?? false);

  bool get _hasAny => _hasEmail || _hasMobile || _hasWebsite;
  bool showEdit = false;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final List<Widget> rows = [];
    int order = 0;

    if (_hasEmail) {
      rows.add(
        CustomStack(
          enableEdit: widget.enableEdit && showEdit,
          actionWidget: EditButton(
            onPressed: () {
              _updateUserEmail(user: widget.user);
            },
          ),
          child: _ContactRow(
            icon: Icons.alternate_email_rounded,
            label: 'Email',
            value: widget.user?.email?.trim() ?? '',
            order: order++,
            onTap: null, // spec: only mobile & website navigate
            iconColor: GPSColors.primary,
            chevronColor: GPSColors.accent,
          ),
        ),
      );
    }
    if (_hasMobile) {
      rows.add(
        CustomStack(
          enableEdit: widget.enableEdit && showEdit,
          actionWidget: EditButton(
            onPressed: () {
              _updateUserMobile(user: widget.user);
            },
          ),
          child: _ContactRow(
            icon: Icons.call_rounded,
            label: 'Mobile',
            value: widget.user?.mobile?.trim() ?? '',
            order: order++,
            onTap: () => _callNumber(widget.user?.mobile?.trim() ?? '', context),
            iconColor: GPSColors.primary,
            chevronColor: GPSColors.accent,
          ),
        ),
      );
    }
    if (_hasWebsite) {
      rows.add(
        CustomStack(
          enableEdit: widget.enableEdit && showEdit,
          actionWidget: EditButton(onPressed: () {}),
          child: _ContactRow(
            icon: Icons.public_rounded,
            label: 'Website',
            value: ContactCard._normalizeUrl(widget.user?.storeOrFarm()?.website?.trim() ?? ''),
            order: order++,
            onTap: () => _openWebsite(widget.user?.storeOrFarm()?.website?.trim() ?? '', context),
            iconColor: GPSColors.primary,
            chevronColor: GPSColors.accent,
          ),
        ),
      );
    }

    return CustomStack(
      enableEdit: widget.enableEdit,
      actionWidget: EditButton(
        onPressed: () {
          setState(() {
            showEdit = !showEdit;
          });
        },
      ),

      child: Semantics(
        label: 'Contact card',
        child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: GPSColors.cardBorder),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    spreadRadius: -6,
                    offset: Offset(0, 8),
                    color: Color(0x14000000),
                  ),
                ],
                // subtle blended background leaning on primary/accent
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, GPSColors.accent.withOpacity(.06)],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Compact header chip with brand gradient
                        Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [GPSColors.primary, GPSColors.accent],
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.contact_phone_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  GPSGaps.w8,
                                  Text(
                                    widget.title,
                                    style: txt.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: .2,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 220.ms)
                            .slideY(begin: .08, curve: Curves.easeOutCubic)
                            .scale(begin: const Offset(.95, .95)),

                        GPSGaps.h8,

                        if (_hasAny)
                          ..._intersperse(
                            rows,
                            Divider(
                              height: 12,
                              thickness: 1,
                              color: GPSColors.cardBorder,
                            ).animate().fadeIn(duration: 180.ms),
                          )
                        else
                          _EmptyState(textStyle: txt.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .05, curve: Curves.easeOutCubic),
      ),
    );
  }

  Future<void> _callNumber(String number, BuildContext context) async {
    if (!(Platform.isIOS || Platform.isAndroid)) return;
    final uri = Uri(scheme: 'tel', path: number);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      _toast(context, 'Couldn’t open the phone app.');
    }
  }

  Future<void> _openWebsite(String site, BuildContext context) async {
    if (!(Platform.isIOS || Platform.isAndroid)) return;
    final uri = Uri.parse(ContactCard._normalizeUrl(site));
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      _toast(context, 'Couldn’t open the browser.');
    }
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  Future _updateUserEmail({required UserModel? user}) async {
    final cubit = context.read<StoreCubit>();
    final storage = serviceLocator<LocalStorage>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: user?.email,
            controller: ctl,
            label: 'Update your email',
          ),
    );
    if (newVal == null) return;
    user?.email = newVal;
    cubit.update(user!);
    final res = await UpdateController.update(path: 'user/${user.id}', data: {'email': newVal});
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(user);
    }
  }

  Future _updateUserMobile({required UserModel? user}) async {
    final cubit = context.read<StoreCubit>();
    final storage = serviceLocator<LocalStorage>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: user?.mobile,
            controller: ctl,
            label: 'Update your mobile',
            isNumeric: true,
          ),
    );
    if (newVal == null) return;
    user?.mobile = newVal;
    cubit.update(user!);
    final res = await UpdateController.update(path: 'user/${user.id}', data: {'mobile': newVal});
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(user);
    }
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.order,
    required this.iconColor,
    required this.chevronColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final int order;
  final Color iconColor;
  final Color chevronColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final row = InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // compact icon tile with accent border
            Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: GPSColors.accent.withOpacity(.6)),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                )
                .animate()
                .fadeIn(duration: 200.ms)
                .scale(begin: const Offset(.96, .96))
                .shimmer(delay: 100.ms * order, duration: 1000.ms),

            GPSGaps.w12,

            // labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: txt.labelSmall?.copyWith(
                      color: GPSColors.mutedText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: txt.bodyMedium?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            if (onTap != null) Icon(Icons.chevron_right_rounded, color: chevronColor, size: 18),
          ],
        ),
      ),
    );

    return Semantics(
      button: onTap != null,
      label: '$label: $value',
      child: row
          .animate(delay: (60 * order).ms)
          .fadeIn(duration: 220.ms, curve: Curves.easeOutCubic)
          .slideY(begin: .06, curve: Curves.easeOutCubic),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.textStyle});
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: GPSColors.accent, size: 18),
          GPSGaps.w8,
          Expanded(
            child: Text(
              'No contact details available.',
              style: textStyle?.copyWith(color: GPSColors.mutedText),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: .05);
  }
}

List<Widget> _intersperse(List<Widget> items, Widget separator) {
  if (items.isEmpty) return items;
  final out = <Widget>[];
  for (var i = 0; i < items.length; i++) {
    out.add(items[i]);
    if (i != items.length - 1) out.add(separator);
  }
  return out;
}
