import 'package:flutter/material.dart';

class MenuActionItem extends StatelessWidget {
  const MenuActionItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!;
    final color = danger ? const Color(0xFFB42318) : const Color(0xFF0F172A);
    final iconColor = danger ? const Color(0xFFDC2626) : const Color(0xFF334155);

    void handleTap() {
      onTap?.call();

      _DropdownScope.of(context)?.close();
    }

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: handleTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: textStyle.copyWith(color: color, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClickDropdown extends StatefulWidget {
  const ClickDropdown({
    super.key,
    required this.child,
    required this.children,
    required this.offset,
    this.gap = 8.0,
    this.decoration,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    this.maxWidth = 240,
    this.alignment = Alignment.topLeft,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.shadow = const [
      BoxShadow(color: Color(0x1A000000), blurRadius: 14, spreadRadius: -2, offset: Offset(0, 8)),
    ],
  });

  final Widget child;
  final List<Widget> children;
  final double gap;
  final BoxDecoration? decoration;
  final EdgeInsets padding;
  final double maxWidth;
  final Alignment alignment;
  final BorderRadius borderRadius;
  final List<BoxShadow> shadow;
  final Offset offset;

  @override
  State<ClickDropdown> createState() => _ClickDropdownState();
}

class _ClickDropdownState extends State<ClickDropdown> {
  final LayerLink _link = LayerLink();
  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _entry;
  Size _childSize = Size.zero;

  bool get _isShowing => _entry != null;

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  void _toggle() => _isShowing ? _hide() : _show();

  void _captureChildSize() {
    final ctx = _childKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    _childSize = box.size;
  }

  void _show() {
    _captureChildSize();
    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _hide,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              offset: Offset(
                widget.alignment == Alignment.topRight
                    ? -widget.maxWidth + _childSize.width + widget.offset.dx
                    : widget.offset.dx,
                _childSize.height + widget.gap + widget.offset.dy,
              ),
              child: _DropdownCard(
                padding: widget.padding,
                maxWidth: widget.maxWidth,
                decoration: widget.decoration,
                borderRadius: widget.borderRadius,
                shadow: widget.shadow,
                onAnyItemTap: _hide,
                offset: Offset.zero,
                children: widget.children,
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);

    WidgetsBinding.instance.addPostFrameCallback((_) => _captureChildSize());
    setState(() {});
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        key: _childKey,
        behavior: HitTestBehavior.translucent,
        onTap: _toggle,
        child: widget.child,
      ),
    );
  }
}

class _DropdownCard extends StatelessWidget {
  const _DropdownCard({
    required this.children,
    required this.padding,
    required this.maxWidth,
    required this.borderRadius,
    required this.shadow,
    this.decoration,
    required this.onAnyItemTap,
    required this.offset,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final double maxWidth;
  final BorderRadius borderRadius;
  final List<BoxShadow> shadow;
  final BoxDecoration? decoration;
  final VoidCallback onAnyItemTap;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final card = Transform.translate(
      offset: offset,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: padding,
            decoration:
                decoration ??
                BoxDecoration(
                  color: Colors.white,
                  borderRadius: borderRadius,
                  boxShadow: shadow,
                  border: Border.all(color: const Color(0x11000000)),
                ),

            child: _DropdownScope(
              close: onAnyItemTap,
              child: Column(mainAxisSize: MainAxisSize.min, children: children),
            ),
          ),
        ),
      ),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, (1 - t) * 8), child: card),
        );
      },
    );
  }
}

class _DropdownScope extends InheritedWidget {
  const _DropdownScope({required this.close, required super.child, super.key});

  final VoidCallback close;

  static _DropdownScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_DropdownScope>();

  @override
  bool updateShouldNotify(covariant _DropdownScope oldWidget) => false;
}
