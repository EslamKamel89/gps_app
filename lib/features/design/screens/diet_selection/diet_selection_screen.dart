import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/entities/diet_options.dart';
import 'package:gps_app/features/design/screens/diet_selection/widgets/diet_card.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/footer.dart';
import 'package:gps_app/features/design/widgets/header.dart';

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

                    final card = DietCard(
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
              Footer(
                onSkip: () {
                  Navigator.of(context).pushNamed(AppRoutesNames.categorySelectionScreen);
                },
                onNext:
                    _selected.isNotEmpty
                        ? () {
                          // In a real flow, pass selections forward
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: ${_selected.join(', ')}')),
                          );
                          Future.delayed(300.ms, () {
                            Navigator.of(context).pushNamed(AppRoutesNames.categorySelectionScreen);
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
