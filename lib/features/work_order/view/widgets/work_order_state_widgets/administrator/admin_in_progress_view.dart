import 'package:flutter/material.dart';

class AdminInProgressView extends StatelessWidget {
  const AdminInProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'This work order is still In Progress',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
