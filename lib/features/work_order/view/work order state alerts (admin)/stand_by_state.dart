import 'package:flutter/material.dart';

class StandByAlert extends StatelessWidget {
  const StandByAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'This work order is in Stand By mode',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
