import 'package:flutter/material.dart';

class DeniedState extends StatelessWidget {
  const DeniedState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xffba1a1a),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          'This intervention file has been denied',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
