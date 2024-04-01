import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EquipmentDropDownMenu extends StatelessWidget {
  List<DropdownMenuItem<dynamic>>? items;
  Object? value;
  void Function(dynamic)? onChanged;

  EquipmentDropDownMenu({
    this.items,
    this.value,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey,
          width: 1.2,
        ),
      ),
      child: Center(
        child: DropdownButtonFormField(
          padding: const EdgeInsets.only(right: 16),
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.build_outlined,
            ),
            border: InputBorder.none,
          ),
          items: items,
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
