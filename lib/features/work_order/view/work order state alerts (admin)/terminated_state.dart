import 'package:flutter/material.dart';

class TerminatedAlert extends StatelessWidget {
  const TerminatedAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'This work order is Terminated',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
