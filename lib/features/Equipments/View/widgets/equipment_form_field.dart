import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EquipmentFormField extends StatelessWidget {
  final String hintText;
  final Widget prefixIcon;
  final String? Function(String?) validator;
  void Function(String?)? onSaved;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  int? maxLines;
  int? maxLength;
  bool? enabled;
  TextEditingController? controller;

  EquipmentFormField({
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
      ),
    );
  }
}
