import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/helpers/validator.dart';
import 'package:gps_app/core/widgets/uploads/image_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/single_file_upload_field.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/models/operating_time_model.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/operating_hour_picker.dart';
import 'package:gps_app/features/auth/presentation/widgets/select_location_on_the_map.dart';
import 'package:gps_app/features/auth/presentation/widgets/state_district_selector.dart';
import 'package:gps_app/features/user/categories/presentation/widgets/category_selector.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/form_bottom_sheet.dart';

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

class ProfileLocationForm extends StatefulWidget {
  const ProfileLocationForm({
    super.key,
    required this.controller,
    required this.label,
    this.isRequired = true,
  });
  final BottomSheetFormController<LatLng> controller;
  final String label;
  final bool isRequired;
  @override
  State<ProfileLocationForm> createState() => _ProfileLocationFormState();
}

class _ProfileLocationFormState extends State<ProfileLocationForm> {
  final _formKey = GlobalKey<FormState>();
  LatLng? _selectedLocation;
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
      if (_selectedLocation != null) {
        widget.controller.submit(_selectedLocation!);
      } else {
        setState(() {
          _errorMessage = 'You have to pick location';
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
          child: SelectableLocationMap(
            onLocationSelected: (v) {
              _selectedLocation = v;
            },
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

class ProfileStateSelectionForm extends StatefulWidget {
  const ProfileStateSelectionForm({super.key, required this.controller});
  final BottomSheetFormController<SelectedStateAndDistrict> controller;

  @override
  State<ProfileStateSelectionForm> createState() => _ProfileStateSelectionFormState();
}

class _ProfileStateSelectionFormState extends State<ProfileStateSelectionForm> {
  final _formKey = GlobalKey<FormState>();
  SelectedStateAndDistrict selectedValue = SelectedStateAndDistrict();
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
        Text('Pick state and city', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Form(
          key: _formKey,
          child: StateDistrictProvider(
            onSelect: (s) {
              selectedValue = s;
            },
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

class ProfileOperatingHoursForm extends StatefulWidget {
  const ProfileOperatingHoursForm({
    super.key,
    required this.controller,
    this.label = 'Operating time',
    this.isRequired = true,
    this.initialValue,
  });
  final BottomSheetFormController<OperatingTimeModel> controller;
  final String label;
  final bool isRequired;
  final OperatingTimeModel? initialValue;
  @override
  State<ProfileOperatingHoursForm> createState() => _ProfileOperatingHoursFormState();
}

class _ProfileOperatingHoursFormState extends State<ProfileOperatingHoursForm> {
  final _formKey = GlobalKey<FormState>();
  OperatingTimeModel? _operatingTimeModel;
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
      if (_operatingTimeModel != null) {
        widget.controller.submit(_operatingTimeModel!);
      } else {
        setState(() {
          _errorMessage = 'You have to pick operating hours';
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
          child: OperatingHoursPicker(
            initialValue: widget.initialValue,
            onChanged: (val) {
              _operatingTimeModel = val;
            },
            buttonText: 'Pick Operating Time',
            icon: Icons.storefront,
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

class ProfileFileForm extends StatefulWidget {
  const ProfileFileForm({
    super.key,
    required this.controller,
    this.label = 'File',
    this.isRequired = true,
  });
  final BottomSheetFormController<UploadedFile> controller;
  final String label;
  final bool isRequired;
  @override
  State<ProfileFileForm> createState() => _ProfileFileFormState();
}

class _ProfileFileFormState extends State<ProfileFileForm> {
  final _formKey = GlobalKey<FormState>();
  UploadedFile? _file;
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
      if (_file != null) {
        widget.controller.submit(_file!);
      } else {
        setState(() {
          _errorMessage = 'You have to upload a file';
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
          child: SingleFileUploadField(
            baseUrl: EndPoint.baseUrl,
            dir: 'certificate',
            initialText: 'No file selected',
            onUploaded: (file) {
              _file = file;
            },
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
