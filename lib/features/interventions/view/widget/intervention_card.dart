import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.typeOfCard,
  });
  final String title;
  final String subtitle;
  final DateTime date;
  final String typeOfCard;

  // function to convert month from int to his abbreviation string
  String monthIntToString(int monthInInt) {
    late String monthInString;
    switch (monthInInt) {
      case 1:
        monthInString = 'Jan';
        break;
      case 2:
        monthInString = 'Fab';
        break;
      case 3:
        monthInString = 'Mar';
        break;
      case 4:
        monthInString = 'Apr';
        break;
      case 5:
        monthInString = 'May';
        break;
      case 6:
        monthInString = 'Jun';
        break;
      case 7:
        monthInString = 'Jul';
        break;
      case 8:
        monthInString = 'Aug';
        break;
      case 9:
        monthInString = 'Sep';
        break;
      case 10:
        monthInString = 'Oct';
        break;
      case 11:
        monthInString = 'Nov';
        break;
      case 12:
        monthInString = 'Dec';
        break;
    }
    return monthInString;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.lightBlueAccent,
        ),
        height: 80,
        width: MediaQuery.sizeOf(context).width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    //color: Colors.lightBlueAccent.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  height: 80,
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            date.day.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                          ),
                        ),
                        Text(
                          monthIntToString(date.month),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.background,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    top: 8,
                    left: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'INT-000$title  (In Progress)',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.onInverseSurface
                            //color: Theme.of(context).colorScheme.inverseSurface,
                            ),
                      ),
                      Text(
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                        'TGN-201: $subtitle',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                size: 24,
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
