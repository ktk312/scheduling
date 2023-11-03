import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduling/modules/Tab2/constants.dart';

//DateTime format in dd-mm-yyyy format
String getFormattedDate(DateTime dateTime) {
  String formattedDate =
      '${dateTime.day}-${DateFormat('MMM').format(dateTime)}-${dateTime.year}';

  return formattedDate;
}

TimeOfDay timeOfDayFromString(String time) {
  int hours = int.parse(time.split(':')[0]);
  int minutes = int.parse(time.split(':')[1].split(' ')[0]);
  if (time.contains('am') || time.contains('AM') && hours == 12) {
    hours = 0;
  } else if (time.contains('pm') || time.contains('PM')) {
    hours += 12;
  }
  TimeOfDay timeOfDay = TimeOfDay(
    hour: hours,
    minute: minutes,
  );

  return timeOfDay;
}

//DateTime format in 12 hour time
String getFormattedTime(DateTime dateTime) {
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  String period = hour < 12 ? 'AM' : 'PM';
  // Convert to 12-hour format
  if (hour > 12) {
    hour -= 12;
  } else if (hour == 0) {
    hour = 12;
  }
  // Format the time in 12-hour format
  String formattedTime = '$hour:${minute.toString().padLeft(2, '0')} $period';
  return formattedTime;
}

/// Time row for activity
Widget itemRow(BuildContext context, String title, String selectedOption,
    List<String> options,
    {final ValueChanged<String?>? onChanged}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: textStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      Container(
        color: const Color.fromARGB(255, 255, 161, 0),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: DropdownButton<String>(
          value: selectedOption,
          underline: Container(),
          style: const TextStyle(color: Colors.white),
          items: options
              .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: const TextStyle(color: Colors.black),
                  )))
              .toList(),
          onChanged: onChanged,
        ),
      )
    ],
  );
}

//Dropdown Button Row for activity
Widget timeRow(BuildContext context, String title, String time,
    {final VoidCallback? onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: textStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          color: Colors.transparent,
          child: Text(
            time,
            style:
                textStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    ],
  );
}
