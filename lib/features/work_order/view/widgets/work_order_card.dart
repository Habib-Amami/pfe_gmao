import 'package:flutter/material.dart';

class WorkOrderCard extends StatelessWidget {
  const WorkOrderCard(
      {super.key,
      required this.date,
      required this.status,
      required this.interventionType,
      required this.woID,
      required this.startingTime,
      required this.finishingTime});
  final DateTime date;
  final String status;
  final String interventionType;
  final String woID;
  final TimeOfDay startingTime;
  final TimeOfDay finishingTime;
  // formatting TimeOfDay to String
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

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
    String starting = formatTimeOfDay(startingTime);
    String finishing = formatTimeOfDay(finishingTime);
    String reference =
        'WO-${woID[0].toUpperCase()}${woID[1].toUpperCase()}${woID[2].toUpperCase()}${woID[3].toUpperCase()}';
    return Container(
      height: 70,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(25, 118, 210, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromRGBO(187, 222, 251, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        monthIntToString(date.month),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8, left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$reference  ($status)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      '$interventionType: $starting - $finishing',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.read_more_rounded,
              size: 36,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
