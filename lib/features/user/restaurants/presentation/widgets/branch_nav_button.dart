import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class BranchCTAButton extends StatelessWidget {
  const BranchCTAButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.storefront_rounded,
    this.tooltip = 'Open branch details',
    this.expand = true,
  });

  final String label;

  final VoidCallback onPressed;

  final IconData icon;

  final String tooltip;

  final bool expand;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final buttonCore = _ButtonCore(
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          // .animate(onPlay: (c) => c.repeat()).rotate(duration: 2200.ms, curve: Curves.linear),
          GPSGaps.w12,
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: txt.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: .3,
              ),
            ),
          ),
        ],
      ),
    );

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: label,
        hint: tooltip,
        child: _TapWrapper(
          onTap: () {
            HapticFeedback.selectionClick();
            onPressed();
          },
          child: expand ? SizedBox(width: double.infinity, child: buttonCore) : buttonCore,
        ),
      ),
    );
  }
}

class _ButtonCore extends StatelessWidget {
  const _ButtonCore({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [GPSColors.primary, Color(0xFF2BB673)],
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            spreadRadius: -6,
            offset: Offset(0, 10),
            color: Color(0x3300A86B),
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Colors.white),
        child: Center(child: child),
      ),
    ).animate().fadeIn(duration: 220.ms).slideY(begin: .08, curve: Curves.easeOutCubic);
  }
}

class _TapWrapper extends StatefulWidget {
  const _TapWrapper({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_TapWrapper> createState() => _TapWrapperState();
}

class _TapWrapperState extends State<_TapWrapper> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: widget.child
          .animate(target: _pressed ? 1 : 0)
          .scale(begin: const Offset(1, 1), end: const Offset(.98, .98), duration: 120.ms)
          .then()
          .rotate(begin: 0, end: .15, duration: 140.ms, curve: Curves.easeOutCubic),
    );
  }
}
