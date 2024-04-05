import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabeledValueRow extends StatelessWidget {
  final String label;
  final String value;
  final double labelWidth;

  const LabeledValueRow({
    required this.label,
    required this.value,
    required this.labelWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
