import 'package:flutter/material.dart';

class FinishedView extends StatelessWidget {
  const FinishedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Work order verification request is sent',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          Text(
            'please wait for response',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.background,
            ),
          )
        ],
      ),
    );
  }
}
