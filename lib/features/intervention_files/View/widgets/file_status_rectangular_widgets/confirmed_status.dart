import 'package:flutter/material.dart';

class ConfirmedState extends StatelessWidget {
  const ConfirmedState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          'This intervention file has been validated',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
