import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class BottomSheetFormController<T> {
  BottomSheetFormController(this._ctx);

  final BuildContext _ctx;

  void submit(T value) => Navigator.of(_ctx).pop<T>(value);

  void cancel() => Navigator.of(_ctx).pop<T>(null);
}

typedef BottomSheetFormBuilder<T> =
    Widget Function(BuildContext context, BottomSheetFormController<T> controller);

Future<T?> showFormBottomSheet<T>(
  BuildContext context, {
  required BottomSheetFormBuilder<T> builder,

  bool isScrollControlled = true,
  ShapeBorder? shape,
  Color? backgroundColor,
  double? elevation,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape:
        shape ??
        const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (sheetCtx) {
      final controller = BottomSheetFormController<T>(sheetCtx);

      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,

            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 16,
            top: 16,
          ),
          child: builder(sheetCtx, controller),
        ),
      );
    },
  );
}

class FormCancelButton extends StatelessWidget {
  const FormCancelButton({super.key, required this.onPressed, this.label = 'Cancel'});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onPressed, child: Text(label));
  }
}

class FormSubmitButton extends StatelessWidget {
  const FormSubmitButton({super.key, required this.onPressed, this.label = 'Save'});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}

class FormActionBar extends StatelessWidget {
  const FormActionBar({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    this.cancelLabel = 'Cancel',
    this.submitLabel = 'Save',
  });

  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final String cancelLabel;
  final String submitLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: FormCancelButton(onPressed: onCancel, label: cancelLabel)),
        const SizedBox(width: 12),
        Expanded(child: FormSubmitButton(onPressed: onSubmit, label: submitLabel)),
      ],
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({super.key, this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: GPSColors.primary.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(4),
        child: const Icon(Icons.edit, color: Colors.white, size: 16),
      ),
    );
  }
}
