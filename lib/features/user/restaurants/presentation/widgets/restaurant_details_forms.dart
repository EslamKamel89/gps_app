import 'package:flutter/material.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/features/user/categories/presentation/widgets/category_selector.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/form_bottom_sheet.dart';

class ProfileTextForm extends StatefulWidget {
  const ProfileTextForm({
    super.key,
    required this.controller,
    this.label = 'Name',
    this.isRequired = true,
    this.initialValue,
  });
  final BottomSheetFormController<String> controller;
  final String label;
  final bool isRequired;
  final String? initialValue;
  @override
  State<ProfileTextForm> createState() => _ProfileTextFormState();
}

class _ProfileTextFormState extends State<ProfileTextForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  @override
  void initState() {
    _nameCtrl.text = widget.initialValue ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.controller.submit(_nameCtrl.text.trim());
    }
  }

  void _cancel() => widget.controller.cancel();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // wrap content, lets sheet size to content
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameCtrl,
            autofocus: true,
            decoration: InputDecoration(border: OutlineInputBorder()),
            validator:
                (v) => validator(input: v, label: widget.label, isRequired: widget.isRequired),
            onFieldSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(height: 16),
        FormActionBar(
          onCancel: _cancel,
          onSubmit: _submit,
          cancelLabel: 'Cancel',
          submitLabel: 'Save',
        ),
      ],
    );
  }
}

class ProfileCategorySelectionForm extends StatefulWidget {
  const ProfileCategorySelectionForm({super.key, required this.controller});
  final BottomSheetFormController<CategorySelector> controller;

  @override
  State<ProfileCategorySelectionForm> createState() => _ProfileCategorySelectionFormState();
}

class _ProfileCategorySelectionFormState extends State<ProfileCategorySelectionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   widget.controller.submit(_nameCtrl.text.trim());
    // }
  }

  void _cancel() => widget.controller.cancel();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // wrap content, lets sheet size to content
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pick Category', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Form(key: _formKey, child: CategorySelectorProvider(onSelect: (_) {})),
        const SizedBox(height: 16),
        FormActionBar(
          onCancel: _cancel,
          onSubmit: _submit,
          cancelLabel: 'Cancel',
          submitLabel: 'Save',
        ),
      ],
    );
  }
}
