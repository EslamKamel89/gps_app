import 'package:flutter/material.dart';

class TimeChip extends StatelessWidget {
  const TimeChip({
    super.key,
    required this.label,
    required this.text,
    required this.onTap,
    required this.disabledColor,
  });
  final String label;
  final String text;
  final VoidCallback? onTap;
  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    final active = onTap != null;
    final border =
        active ? Theme.of(context).colorScheme.primary : disabledColor;
    return ActionChip(
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Text(text, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      onPressed: onTap,
      shape: StadiumBorder(side: BorderSide(color: border)),
      avatar: const Icon(Icons.access_time),
    );
  }
}
