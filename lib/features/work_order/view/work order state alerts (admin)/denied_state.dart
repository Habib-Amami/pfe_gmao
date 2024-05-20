import 'package:flutter/material.dart';

class DeniedAlert extends StatelessWidget {
  const DeniedAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffba1a1a),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: Text(
          'This work order is denied',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
