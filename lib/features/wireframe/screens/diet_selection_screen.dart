import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/wireframe/design/gps_colors.dart';
import 'package:gps_app/features/wireframe/design/gps_gaps.dart';
import 'package:gps_app/features/wireframe/entities/diet_options.dart';
import 'package:gps_app/features/wireframe/widgets/header.dart';

const _dietOptions = <DietOption>[
  DietOption(id: 'keto', label: 'Ketogenic', emoji: '🥑'),
  DietOption(id: 'paleo', label: 'Paleo', emoji: '🥕'),
  DietOption(id: 'vegan', label: 'Vegan', emoji: '🌱'),
  DietOption(id: 'vegetarian', label: 'Vegetarian', emoji: '🥬'),
  DietOption(id: 'pescatarian', label: 'Pescatarian', emoji: '🐟'),
  DietOption(id: 'carnivore', label: 'Carnivore', emoji: '🥩'),
];

class DietSelectionScreen extends StatefulWidget {
  const DietSelectionScreen({super.key});

  @override
  State<DietSelectionScreen> createState() => _DietSelectionScreenState();
}

class _DietSelectionScreenState extends State<DietSelectionScreen> {
  final Set<String> _selected = <String>{};

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GPSGaps.h24,
              GpsHeader(
                title: 'Which of these diets do you follow?',
                // onBack: () => Navigator.of(context).maybePop(),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: .2, curve: Curves.easeOutQuad),
              GPSGaps.h24,

              // Grid of options
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: _dietOptions.length,
                  itemBuilder: (context, index) {
                    final item = _dietOptions[index];
                    final selected = _selected.contains(item.id);

                    final card = _DietCard(
                      emoji: item.emoji,
                      label: item.label,
                      selected: selected,
                      onTap: () => _toggle(item.id),
                    );

                    // Staggered entrance animation per card
                    return card
                        .animate(delay: (80 * index).ms)
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: .15)
                        .scale(begin: const Offset(0.98, 0.98), curve: Curves.easeOutBack);
                  },
                ),
              ),

              GPSGaps.h12,

              // Footer actions
              _Footer(
                onSkip: () {
                  Navigator.of(context).pushNamed(AppRoutesNames.loginScreen);
                },
                onNext:
                    _selected.isNotEmpty
                        ? () {
                          // In a real flow, pass selections forward
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: ${_selected.join(', ')}')),
                          );
                          Future.delayed(300.ms, () {
                            Navigator.of(context).pushNamed(AppRoutesNames.loginScreen);
                          });
                        }
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DietCard extends StatelessWidget {
  const _DietCard({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? GPSColors.primary : GPSColors.cardBorder;
    final bg = selected ? GPSColors.cardSelected : Colors.white;

    final card = Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 42),
            ).animate(target: selected ? 1 : 0).scaleXY(begin: 1, end: 1.08, duration: 180.ms),
            GPSGaps.h12,
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );

    return card
        .animate(onPlay: (controller) => controller.forward())
        // .shadow(color: const Color(0x1A000000), begin: 0, end: 12, duration: 300.ms, curve: Curves.easeOut)
        .then()
        .shake(hz: selected ? 2 : 0, duration: selected ? 200.ms : 1.ms); // subtle tap feedback
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onSkip, required this.onNext});
  final VoidCallback onSkip;
  final VoidCallback? onNext; // null → disabled

  @override
  Widget build(BuildContext context) {
    final nextEnabled = onNext != null;

    return Row(
      children: [
        TextButton(
          onPressed: onSkip,
          child: const Text('Skip'),
        ).animate().fadeIn(duration: 250.ms).slideX(begin: -.1, curve: Curves.easeOut),
        const Spacer(),
        ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: nextEnabled ? GPSColors.primary : GPSColors.cardBorder,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Next'),
            )
            .animate(target: nextEnabled ? 1 : 0)
            .scaleXY(begin: 1.0, end: 1.03, duration: 300.ms, curve: Curves.easeInOut)
            .then(delay: 1200.ms)
            .tint(
              color: nextEnabled ? GPSColors.primary.withOpacity(.05) : Colors.transparent,
              duration: 500.ms,
            ),
      ],
    );
  }
}
