import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.placeholderText,
    required this.placeholderIcon,
    this.hideText,
    required this.onSave,
    required this.onValidation,
  });

  final String label;
  final String placeholderText;
  final IconData placeholderIcon;
  final bool? hideText;
  final void Function(String?) onSave;
  final String? Function(String?) onValidation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 6,
        ),
        TextFormField(
          obscureText: hideText ?? false,
          autocorrect: false,
          keyboardType: TextInputType.visiblePassword,
          onSaved: onSave,
          validator: onValidation,
          decoration: InputDecoration(
            label: Row(
              children: [
                Icon(placeholderIcon),
                const SizedBox(
                  width: 8,
                ),
                Text(placeholderText),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
