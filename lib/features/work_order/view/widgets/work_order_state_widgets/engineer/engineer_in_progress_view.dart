import 'package:flutter/material.dart';

class EngineerInProgressView extends StatefulWidget {
  final void Function() onFinished;
  final void Function() onStrandBy;
  const EngineerInProgressView({
    super.key,
    required this.onFinished,
    required this.onStrandBy,
  });

  @override
  State<EngineerInProgressView> createState() => _EngineerInProgressViewState();
}

class _EngineerInProgressViewState extends State<EngineerInProgressView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //Button to change the workorder state
        //to Finished
        SizedBox(
          width: 130,
          child: FilledButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Finish'),
            onPressed: widget.onFinished,
          ),
        ),
        //Button to change the workorder state
        //to Stand By
        SizedBox(
          width: 130,
          child: FilledButton.icon(
            icon: Icon(
              Icons.pause,
              color: Theme.of(context).colorScheme.background,
            ),
            label: Text(
              'Stand By',
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).colorScheme.error),
            ),
            onPressed: widget.onStrandBy,
          ),
        ),
      ],
    );
  }
}
