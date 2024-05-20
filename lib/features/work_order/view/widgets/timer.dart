import 'package:flutter/material.dart';
import 'package:pfe_gmao/features/work_order/view/widgets/work_order_form_field.dart';

class Timer extends StatefulWidget {
  final TextEditingController hourController;
  final TextEditingController minuteController;
  const Timer({
    super.key,
    required this.hourController,
    required this.minuteController,
  });

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: WorkOrderFormField(
            textAlign: TextAlign.center,
            textStyle: Theme.of(context).textTheme.headlineLarge,
            controller: widget.hourController,
            readOnly: true,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              ":",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: WorkOrderFormField(
            controller: widget.minuteController,
            readOnly: true,
            textAlign: TextAlign.center,
            textStyle: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              bottom: 8.0,
              right: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      barrierDismissible: false,
                    );
                    if (pickedTime != null) {
                      setState(() {
                        widget.hourController.text =
                            pickedTime.hour.toString().padLeft(2, '0');
                        widget.minuteController.text =
                            pickedTime.minute.toString().padLeft(2, '0');
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.timer_outlined,
                  ),
                ),
                Text(
                  "Pick",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
