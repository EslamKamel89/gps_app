import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/features/auth/presentation/widgets/labeled_field.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/preferences/presentation/widgets/category_selector.dart';
import 'package:gps_app/features/wishlist/cubits/wishes_cubit.dart';

class WishListCreateWidget extends StatefulWidget {
  const WishListCreateWidget({super.key});

  @override
  State<WishListCreateWidget> createState() => _WishListCreateWidgetState();
}

class _WishListCreateWidgetState extends State<WishListCreateWidget> {
  String description = '';
  int? categoryId;
  int? subCategoryId;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  bool isLoading = false;
  Future _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<WishesCubit>();
    setState(() {
      isLoading = true;
    });
    await cubit.addWish(
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      description: description,
    );
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            Text(
              'Let’s make it happen — what’s your wish?',
              style: txt.labelMedium?.copyWith(
                color: GPSColors.mutedText,
                fontWeight: FontWeight.w700,
                letterSpacing: .2,
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: .04),

            GPSGaps.h8,

            LabeledField(
                  label: 'Make a wish come true',
                  child: TextFormField(
                    onChanged: (value) => description = value,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator:
                        (v) => validator(
                          input: v,
                          label: 'Wish',
                          isRequired: true,
                          minChars: 3,
                        ),
                    decoration: _inputDecoration(
                      'e.g., “I love vegan pizza” or “Gluten-free falafel wrap”',
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 240.ms)
                .slideY(begin: .06)
                .scale(begin: const Offset(.98, .98)),

            GPSGaps.h16,

            CategorySelectorProvider(
              onSelect: (selected) {
                categoryId = selected.selectedCategory?.id;
                subCategoryId = selected.selectedSubCategory?.id;
              },
              isRequired: true,
            ),
            GPSGaps.h24,

            Row(
              children: [
                OutlinedButton(
                  onPressed: _onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: GPSColors.text,
                    side: const BorderSide(color: GPSColors.cardBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),

                GPSGaps.w12,

                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                          onPressed: _onSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GPSColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 220.ms)
                        .scale(begin: const Offset(.98, .98)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GPSColors.primary, width: 1.6),
      ),
    );
  }
}
