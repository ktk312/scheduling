//DateTime format in dd-mm-yyyy format
String getFormattedDate(DateTime dateTime) {
  String formattedDate = '${dateTime.day}-${dateTime.month}-${dateTime.year}';

  return formattedDate;
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
