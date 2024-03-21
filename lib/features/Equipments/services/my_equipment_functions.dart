import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

String formattedDate(timeStamp) {
  DateTime dateFromTimestamp =
      DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
  return DateFormat('dd-MM-yyyy').format(dateFromTimestamp);
}

Widget showState(String data) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const Text(
        "Status:",
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      const SizedBox(width: 10),
      data.toLowerCase() == 'active'
          ? Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.green),
              child: const Icon(
                  size: 18, Ionicons.checkmark_sharp, color: Colors.white),
            )
          : data.toLowerCase() == 'shutdown'
              ? Container(
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  width: 22,
                  height: 22,
                  child: const Center(
                    child: Icon(
                        size: 18,
                        Icons.power_off_outlined,
                        color: Colors.white),
                  ),
                )
              : data.toLowerCase() == 'standby'
                  ? Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.yellow),
                      child: const Icon(
                        size: 18,
                        Ionicons.pause_circle_outline,
                        color: Colors.white,
                      ),
                    )
                  : const Text("please revise the state value!")
    ],
  );
}

Widget myProperty(String myTitle, String myValue, Widget myIcon) {
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
              width: 1.4,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: TextFormField(
              enabled: false,
              initialValue: myValue,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: myIcon,
                border: InputBorder.none,
              ),
            ),
          ),
        )
      ],
    ),
  );
}
