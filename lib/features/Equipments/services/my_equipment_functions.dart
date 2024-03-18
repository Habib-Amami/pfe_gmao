import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String formattedDate(timeStamp) {
  var dateFromTimestamp =
      DateTime.fromMicrosecondsSinceEpoch(timeStamp.seconds * 1000);
  return DateFormat('dd-MM-yyyy').format(dateFromTimestamp);
}

Widget myProperty(String myTitle, String myValue) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            myTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 24,
            ),
          ),
        ),
        Container(
          height: 58,
          margin: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade500,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            enabled: false,
            initialValue: myValue,
            style: const TextStyle(fontSize: 20, color: Colors.black),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
          ),
        )
      ],
    ),
  );
}
