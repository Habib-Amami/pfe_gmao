import 'package:flutter/material.dart';

class NotificationUI extends StatelessWidget {
  const NotificationUI({
    super.key,
    required this.notificationTitle,
    required this.notificationMessage,
    required this.notificationIcon,
  });
  final String notificationTitle;
  final String notificationMessage;
  final IconData notificationIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green.shade100,
              ),
              child: Icon(
                notificationIcon,
                color: Colors.green,
                size: 30,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    notificationMessage,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
