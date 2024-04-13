import 'package:flutter/material.dart';

// Widget for displaying a form field for equipment input
class EquipmentFormField extends StatelessWidget {
  final String hintText; // Hint text for the input field
  final Widget prefixIcon; // Prefix icon for the input field
  final String? Function(String?) validator; // Input validation function
  final void Function(String?)? onSaved; // Callback function for saving input
  final TextInputType? keyboardType; // Keyboard type for the input field
  final TextInputAction? textInputAction; // TextInputAction for the input field
  final int? maxLines; // Maximum number of lines for multiline input
  final int? maxLength; // Maximum length of input
  final bool? enabled; // Flag to enable/disable input field
  final TextEditingController? controller; // Controller for controlling input
  final String? initialValue; // Initial value for the input field

  const EquipmentFormField({
    required this.hintText,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.enabled,
    this.maxLength,
    this.maxLines,
    this.onSaved,
    this.initialValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      // TextFormField for input field
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLength: maxLength,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: prefixIcon,
          prefixIconColor: MaterialStateColor.resolveWith(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) {
                return Theme.of(context).colorScheme.primary;
              }
              if (states.contains(MaterialState.error)) {
                return Theme.of(context).colorScheme.error;
              }
              return Colors.grey.shade500;
            },
          ),
        ),
        validator: validator,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}
