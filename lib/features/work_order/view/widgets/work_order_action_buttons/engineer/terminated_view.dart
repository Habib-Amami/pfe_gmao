import 'package:flutter/material.dart';

class TerminatedView extends StatelessWidget {
  const TerminatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'This work order is terminated',
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
