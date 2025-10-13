import 'package:flutter/material.dart';

/// Controls how a bottom-sheet form returns values.
class BottomSheetFormController<T> {
  BottomSheetFormController(this._ctx);

  final BuildContext _ctx;

  /// Call from your child form when the user taps "Save"/"Submit".
  void submit(T value) => Navigator.of(_ctx).pop<T>(value);

  /// Call from your child form when the user taps "Cancel".
  void cancel() => Navigator.of(_ctx).pop<T>(null);
}

/// Builder signature for your form widget.
/// You receive a controller that lets you submit(T) or cancel().
typedef BottomSheetFormBuilder<T> =
    Widget Function(BuildContext context, BottomSheetFormController<T> controller);

/// Shows a modal bottom sheet that returns a `Future<T?>`.
/// - On submit → returns T
/// - On cancel → returns null
Future<T?> showFormBottomSheet<T>(
  BuildContext context, {
  required BottomSheetFormBuilder<T> builder,

  // Commonly-used sheet options (tweak as needed)
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
      // SafeArea + padding so forms play nice with keyboards
      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            // Lift content above the keyboard when expanded
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

/// Optional: a handy row with spacing for both buttons.
/// Place it at the bottom of your form.
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
    return IconButton(
      tooltip: 'Edit',
      icon: const Icon(Icons.edit, color: Colors.black),
      onPressed: onPressed,
    );
  }
}
