import 'package:flutter/material.dart';

class AdminFinishedView extends StatelessWidget {
  final void Function() onDeny;
  final void Function() onTerminate;
  const AdminFinishedView({
    super.key,
    required this.onDeny,
    required this.onTerminate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 140,
          child: FilledButton.icon(
            icon: const Icon(Icons.check),
            onPressed: onTerminate,
            label: Text(
              'Terminate',
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 140,
          child: FilledButton.icon(
            icon: const Icon(Icons.cancel),
            onPressed: onDeny,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).colorScheme.error),
            ),
            label: Text(
              'Deny',
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
