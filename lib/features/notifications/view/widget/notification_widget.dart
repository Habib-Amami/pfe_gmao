import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationUI extends StatelessWidget {
  final DateTime notificationDateOfCreation;
  final String notificationTitle;
  final String notificationMessage;
  final IconData notificationIcon;
  final Color notificationColor;

  const NotificationUI({
    super.key,
    required this.notificationDateOfCreation,
    required this.notificationTitle,
    required this.notificationMessage,
    required this.notificationIcon,
    required this.notificationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            DateFormat('MMM d, yyyy - hh:mm a')
                .format(notificationDateOfCreation)
                .toString(),
          ),
        ),
        Card(
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
                    color: notificationColor.withOpacity(0.3),
                  ),
                  child: Icon(
                    notificationIcon,
                    color: notificationColor,
                    size: 35,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationTitle,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        notificationMessage,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
