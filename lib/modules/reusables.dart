// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scheduling/modules/Tab2/layout_params.dart';

import 'Tab2/models/activity_model.dart';
import 'Tab2/providers/activity_provider.dart';

//DateTime format in dd-mm-yyyy format
String getFormattedDate(DateTime dateTime) {
  String formattedDate =
      '${dateTime.day}-${DateFormat('MMM').format(dateTime)}-${dateTime.year}';

  return formattedDate;
}

//This function converts the json time string to TimeOfDay object
//Time strings are in 12 hour format. This functions handles that too
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

//Time picker uses the TimeOfDay format and this function converts the TimeOfDay format to DateTime Object
//As activity add/Update is only allowed for current date this functions gets TimeOfDay
//and generates a date Time Object with hours and minutes passed to it
DateTime timeOfDayToDateTime(TimeOfDay timeOfDay) {
  final now = DateTime.now(); // Get the current date
  return DateTime(
      now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
}

//DateTime format in 12 hour time
//Pure function to convert a DateTime Object to a 12 hour time format
// i.e 12:00 AM and returns a String
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

/// Dropdown button row
/// This is the item row having a label and a dropdown button
/// this is used to select a day used for repeat activity and end repeat activity options
Widget itemRow(BuildContext context, String title, String selectedOption,
    List<String> options,
    {final ValueChanged<String?>? onChanged}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: textStyle20,
      ),
      Container(
        color: secondaryColor,
        padding: padding10,
        child: DropdownButton<String>(
          value: selectedOption,
          underline: Container(),
          style: textStyle,
          items: options
              .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: blackText,
                  )))
              .toList(),
          onChanged: onChanged,
        ),
      )
    ],
  );
}

//Dropdown Button Row for activity
//This is used to have a label with a button to select time
//Time Picker is used for time picking and the function is also passed down to
//respect the respective screen scenerio and usage
Widget timeRow(BuildContext context, String title, String time,
    {final VoidCallback? onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: textStyle20,
      ),
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          color: transparentColor,
          child: Text(
            time,
            style: textStyle20,
          ),
        ),
      ),
    ],
  );
}

//This function assigns the activity on dialog page if the user wants to update activity
// this will prefill the activity to be updated
assignActivity(
    WidgetRef widgetRef,
    String date,
    int activityIndex,
    StateNotifierProvider<ActivityProvider, Map<String, List<Activity>>>
        activityProvider) {
  final activity =
      widgetRef.read(activityProvider.notifier).state[date]![activityIndex];

  widgetRef.read(activityProvider.notifier).selectedStartTime =
      activity.start != null ? timeOfDayFromString(activity.start!) : null;
  widgetRef.read(activityProvider.notifier).selectedEndTime =
      activity.end != null ? timeOfDayFromString(activity.end!) : null;
  widgetRef.read(activityProvider.notifier).selectedEndRepeat =
      activity.ends ?? "Never";
  widgetRef.read(activityProvider.notifier).selectedRepeat =
      activity.repeats ?? 'Everyday';

  widgetRef.read(startTimeProvider.notifier).state =
      timeOfDayFromString(activity.start!);
  widgetRef.read(endTimeProvider.notifier).state =
      timeOfDayFromString(activity.end!);
  widgetRef.read(repeatProvider.notifier).state =
      activity.repeats ?? 'Everyday';
  widgetRef.read(endRepeatProvider.notifier).state = activity.ends ?? 'Never';
}

//This function is called whenever we need to clear provider values and start with fresh state
//for example when User cancels the add activity flow or Submit the activity.
//This also works with hardware back button on android
resetActivity(
    WidgetRef widgetRef,
    StateNotifierProvider<ActivityProvider, Map<String, List<Activity>>>
        activityProvider) {
  widgetRef.read(activityProvider.notifier).selectedStartTime = null;
  widgetRef.read(activityProvider.notifier).selectedEndTime = null;
  widgetRef.read(activityProvider.notifier).selectedEndRepeat = null;
  widgetRef.read(activityProvider.notifier).selectedRepeat = null;
  widgetRef.read(startTimeProvider.notifier).state =
      const TimeOfDay(hour: 12, minute: 0);
  widgetRef.read(endTimeProvider.notifier).state =
      const TimeOfDay(hour: 12, minute: 0);
  widgetRef.read(repeatProvider.notifier).state = 'Everyday';
  widgetRef.read(endRepeatProvider.notifier).state = 'Never';
}

//This is the widget that is placed above activity list.
//Used in activity list and activity history screens
class DateWidget extends StatelessWidget {
  final String date;
  const DateWidget({super.key, required this.date});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginScreen,
      width: 100,
      height: 30,
      color: primaryColor,
      child: Center(
          child: Text(
        date,
        style: textStyle,
      )),
    );
  }
}
