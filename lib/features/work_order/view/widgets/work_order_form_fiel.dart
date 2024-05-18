import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Widget for displaying a form field for work order input
class WorkOrderFormField extends StatelessWidget {
  final String? hintText; // Hint text for the input field
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffexIcon; // Prefix icon for the input field
  final String? Function(String?)? validator; // Input validation function
  final void Function(String?)? onSaved; // Callback function for saving input
  final void Function(String)?
      onChanged; // Callback function for changing input
  final void Function(String)?
      onFieldSubmitted; // Callback function for submitting the fielf input
  final TextInputType? keyboardType; // Keyboard type for the input field
  final TextInputAction? textInputAction;
  final TextStyle? textStyle; // TextInputAction for the input field
  final TextAlign? textAlign;
  final bool? enabled; // Flag to enable/disable input field
  final TextEditingController? controller; // Controller for controlling input
  final String? initialValue; // Initial value for the input field
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters; //controlle the input format
  final bool? readOnly;
  const WorkOrderFormField({
    this.readOnly,
    this.validator,
    this.hintText,
    this.prefixIcon,
    this.suffexIcon,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.enabled,
    this.onSaved,
    this.initialValue,
    this.textStyle,
    this.textAlign,
    this.maxLines,
    this.onChanged,
    this.onFieldSubmitted,
    this.hintStyle,
    this.inputFormatters,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      // TextFormField for input field
      child: TextFormField(
        readOnly: readOnly ?? false,
        style: textStyle,
        textAlign: textAlign ?? TextAlign.start,
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          hintText: hintText,
          hintStyle: hintStyle ??
              TextStyle(
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
          suffixIcon: suffexIcon,
          suffixIconColor: MaterialStateColor.resolveWith(
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
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
        initialValue: initialValue,
        maxLines: maxLines,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
