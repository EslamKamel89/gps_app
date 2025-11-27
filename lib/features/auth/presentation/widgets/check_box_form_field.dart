import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    super.key,
    required String label,
    super.onSaved,
    super.validator,
    bool super.initialValue = false,
    bool autovalidate = false,
  }) : super(
         builder: (FormFieldState<bool> state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 children: [
                   Checkbox(
                     value: state.value,
                     onChanged: (value) {
                       state.didChange(value);
                     },
                   ),
                   Text(label),
                 ],
               ),
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsets.only(left: 12),
                   child: Text(state.errorText!, style: const TextStyle(color: Colors.red)),
                 ),
             ],
           );
         },
       );
}
