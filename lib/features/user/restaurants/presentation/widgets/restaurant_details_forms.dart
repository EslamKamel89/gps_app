import 'package:flutter/material.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/user/categories/presentation/widgets/category_selector.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/form_bottom_sheet.dart';

class ProfileTextForm extends StatefulWidget {
  const ProfileTextForm({
    super.key,
    required this.controller,
    this.label = 'Name',
    this.isRequired = true,
    this.initialValue,
    this.isNumeric = false,
  });
  final BottomSheetFormController<String> controller;
  final String label;
  final bool isRequired;
  final String? initialValue;
  final bool isNumeric;
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
            keyboardType: widget.isNumeric ? TextInputType.number : null,
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
  CategorySelector selectedValue = CategorySelector();
  @override
  void dispose() {
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.controller.submit(selectedValue);
    }
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
        Form(
          key: _formKey,
          child: CategorySelectorProvider(
            onSelect: (s) {
              selectedValue = s;
            },
            isRequired: true,
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

class ProfileImageForm extends StatefulWidget {
  const ProfileImageForm({
    super.key,
    required this.controller,
    this.label = 'Name',
    this.isRequired = true,
  });
  final BottomSheetFormController<UploadedImage> controller;
  final String label;
  final bool isRequired;
  @override
  State<ProfileImageForm> createState() => _ProfileImageFormState();
}

class _ProfileImageFormState extends State<ProfileImageForm> {
  final _formKey = GlobalKey<FormState>();
  UploadedImage? _image;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _errorMessage = null;
      });
      if (_image != null) {
        widget.controller.submit(_image!);
      } else {
        setState(() {
          _errorMessage = 'You have to upload an image';
        });
      }
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
          child: ImageUploadField(
            multiple: false,
            // maxCount: 6,
            resource: UploadResource.common,
            initial: const [],
            onChanged: (images) {
              if (images.isEmpty) return;
              _image = images[0];
            },
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Text(widget.label),
            ),
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
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
