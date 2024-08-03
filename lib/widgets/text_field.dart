import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.placeholderText,
    required this.placeholderIcon,
    required this.onSave,
    required this.onValidation,
    this.hideText,
    this.onChanged,
  });

  final String label;
  final String placeholderText;
  final IconData placeholderIcon;
  final bool? hideText;
  final void Function(String?) onSave;
  final void Function(String?)? onChanged;
  final String? Function(String?) onValidation;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isTextHidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 6,
        ),
        TextFormField(
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          obscureText: widget.hideText == true ? _isTextHidden : false,
          autocorrect: false,
          // keyboardType: TextInputType.visiblePassword,
          onSaved: widget.onSave,
          validator: widget.onValidation,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            suffixIcon: widget.hideText ?? false
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isTextHidden = !_isTextHidden;
                      });
                      
                    },
                    icon: _isTextHidden
                        ? const Icon(Icons.visibility_outlined)
                        : const Icon(Icons.visibility_off_outlined),
                  )
                : null,
            label: Row(
              children: [
                Icon(widget.placeholderIcon),
                const SizedBox(
                  width: 8,
                ),
                Text(widget.placeholderText),
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
