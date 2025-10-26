import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/helpers/update_controller.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/cubits/restaurant_cubit.dart';
import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/export.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/custom_stack.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/form_bottom_sheet.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/restaurant_details_forms.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificationsScreen extends StatelessWidget {
  const CertificationsScreen({
    super.key,
    required this.items,
    required this.enableEdit,
    this.title = 'Certifications',
  });

  final List<Certification> items;
  final String title;
  final bool enableEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: GPSColors.primary, title: Text(title)),
      body:
          items.isEmpty
              ? const _EmptyState().animate().fadeIn(duration: 280.ms).slideY(begin: .08)
              : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                itemCount: items.length,
                separatorBuilder: (_, __) => GPSGaps.h12,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, i) {
                  final c = items[i];
                  final delay = (70 * i).ms;
                  return _CertificationCard(cert: c, enableEdit: enableEdit)
                      .animate(delay: delay)
                      .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
                      .slideY(begin: .08, curve: Curves.easeOutCubic)
                      .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
                },
              ),
    );
  }
}

class _CertificationCard extends StatefulWidget {
  const _CertificationCard({required this.cert, required this.enableEdit});
  final Certification cert;
  final bool enableEdit;
  static bool _isValidHttpUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final uri = Uri.tryParse(url.trim());
    return uri != null && (uri.isScheme('https') || uri.isScheme('http'));
  }

  @override
  State<_CertificationCard> createState() => _CertificationCardState();
}

class _CertificationCardState extends State<_CertificationCard> {
  RestaurantFile? get _firstFile =>
      (widget.cert.file != null && widget.cert.file!.isNotEmpty) ? widget.cert.file!.first : null;
  bool showEdit = false;
  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final firstUrl = _firstFile?.path?.trim();
    final hasValidUrl = _CertificationCard._isValidHttpUrl(firstUrl);
    context.watch<RestaurantCubit>();
    return CustomStack(
      enableEdit: widget.enableEdit,
      actionWidget: EditButton(
        onPressed: () {
          setState(() {
            showEdit = !showEdit;
          });
        },
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GPSColors.cardBorder),
          boxShadow: const [
            BoxShadow(
              blurRadius: 14,
              spreadRadius: -4,
              offset: Offset(0, 6),
              color: Color(0x1A000000),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomStack(
                      enableEdit: widget.enableEdit && showEdit,
                      actionWidget: EditButton(
                        onPressed: () => _updateCertificationTitle(cert: widget.cert),
                      ),
                      child: Text(
                        (widget.cert.title ?? 'Certification').trim(),
                        style: txt.titleMedium?.copyWith(
                          color: GPSColors.text,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              GPSGaps.h8,

              // Description
              if ((widget.cert.description ?? '').trim().isNotEmpty)
                CustomStack(
                  enableEdit: widget.enableEdit && showEdit,
                  actionWidget: EditButton(
                    onPressed: () => _updateCertificationDescription(cert: widget.cert),
                  ),
                  child: Text(
                    widget.cert.description!.trim(),
                    style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.35),
                  ).animate().fadeIn(duration: 200.ms).slideY(begin: .05),
                ),

              GPSGaps.h12,

              // Open button (first file only)
              Align(
                alignment: Alignment.centerRight,
                child: _OpenFileButton(
                  enabled: hasValidUrl,
                  onPressed: hasValidUrl ? () => _openUrl(context, firstUrl!) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    HapticFeedback.selectionClick();
    final uri = Uri.parse(url);
    final ok = await canLaunchUrl(uri);
    if (!ok) {
      _showSnack(context, 'Could not open the file.');
      return;
    }
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    );
    if (!launched) {
      _showSnack(context, 'Could not open the file.');
    }
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future _updateCertificationTitle({required Certification? cert}) async {
    final cubit = context.read<RestaurantCubit>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: cert?.title,
            controller: ctl,
            label: 'Update certification title',
          ),
    );
    if (newVal == null) return;
    cert?.title = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'certificates/${cert?.id}',
      data: {'title': newVal},
    );
  }

  Future _updateCertificationDescription({required Certification? cert}) async {
    final cubit = context.read<RestaurantCubit>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: cert?.description,
            controller: ctl,
            label: 'Update certification description',
          ),
    );
    if (newVal == null) return;
    cert?.description = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'certificates/${cert?.id}',
      data: {'description': newVal},
    );
  }
}

class _OpenFileButton extends StatefulWidget {
  const _OpenFileButton({required this.enabled, this.onPressed});
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  State<_OpenFileButton> createState() => _OpenFileButtonState();
}

class _OpenFileButtonState extends State<_OpenFileButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg =
        widget.enabled
            ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [GPSColors.primary, Color(0xFF2BB673)],
            )
            : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
            );

    final fg = widget.enabled ? Colors.white : Colors.white70;

    final core = Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: bg,
        boxShadow:
            widget.enabled
                ? const [
                  BoxShadow(
                    blurRadius: 16,
                    spreadRadius: -6,
                    offset: Offset(0, 10),
                    color: Color(0x3300A86B),
                  ),
                ]
                : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.open_in_new_rounded, size: 18, color: fg)
              .animate(target: widget.enabled ? 1 : 0, onPlay: (c) => c.repeat())
              .rotate(duration: 2200.ms, curve: Curves.linear),
          GPSGaps.w8,
          Text(
            'Open',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: fg,
              fontWeight: FontWeight.w800,
              letterSpacing: .3,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 180.ms).slideY(begin: .06, curve: Curves.easeOutCubic);

    if (!widget.enabled) {
      return Tooltip(message: 'No file available', child: core);
    }

    return Tooltip(
      message: 'Open in browser',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: core
            .animate(target: _pressed ? 1 : 0)
            .scale(begin: const Offset(1, 1), end: const Offset(.98, .98), duration: 120.ms)
            .then()
            .rotate(begin: 0, end: .12, duration: 140.ms, curve: Curves.easeOutCubic),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GPSColors.cardBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_rounded, color: GPSColors.mutedText),
            GPSGaps.w12,
            Expanded(
              child: Text(
                'No certifications to display.',
                style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
