import 'package:flutter/material.dart';

class CheckBadge extends StatelessWidget {
  final bool isSelected;
  const CheckBadge({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final bg =
        isSelected ? Theme.of(context).colorScheme.primary : Colors.white70;
    final fg = isSelected ? Colors.white : Colors.black87;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: 28,
      height: 28,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Icon(isSelected ? Icons.check : Icons.add, size: 18, color: fg),
    );
  }
}
