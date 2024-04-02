import 'package:flutter/material.dart';

class EquipmentFormField extends StatelessWidget {
  final String hintText;
  final Widget prefixIcon;
  final String? Function(String?) validator;
  final void Function(String?)? onSaved;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final bool? enabled;
  final TextEditingController? controller;
  final String? initialValue;

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
      // Area input field
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
