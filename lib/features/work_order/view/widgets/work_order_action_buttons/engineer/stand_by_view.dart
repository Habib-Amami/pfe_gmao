import 'package:flutter/material.dart';

class StandByView extends StatelessWidget {
  final void Function() onProgress;

  const StandByView({
    super.key,
    required this.onProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton.icon(
        icon: const Icon(Icons.play_arrow),
        label: Text(
          'In Progress',
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        onPressed: onProgress,
      ),
    );
  }
}
