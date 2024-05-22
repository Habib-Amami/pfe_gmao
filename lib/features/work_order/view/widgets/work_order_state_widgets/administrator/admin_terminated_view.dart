import 'package:flutter/material.dart';

class AdminTerminatedView extends StatelessWidget {
  const AdminTerminatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('This work order is Terminated'),
      ),
    );
  }
}
