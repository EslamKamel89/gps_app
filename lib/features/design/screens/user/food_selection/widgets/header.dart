import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String? subtitle;
  const Header({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: t.bodyMedium?.copyWith(
              color: t.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }
}
