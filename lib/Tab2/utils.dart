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

var jsonList = {
  "Date": "23-Oct-2023",
  "Activities": {
    "1": {
      "Name": "Househol chores",
      "Start": "6:00 am",
      "End": "7:30 am",
      "Repeats": "Everyday",
      "Ends": "Never"
    },
    "2": {
      "Name": "Exercise",
      "Start": "7:30 am",
      "End": "8:00 am",
      "Repeats": "Mon, Wed, Fri",
      "Ends": "Never"
    },
    "3": {
      "Name": "Jiu-jitsu",
      "Start": "7:30 am",
      "End": "8:00 am",
      "Repeats": "Tue, Thu, Sat",
      "Ends": "Never"
    },
    "4": {
      "Name": "App design",
      "Start": "8:00 am",
      "End": "10:00 am",
      "Repeats": "Mon, Tue, Wed, Thu, Fri, Sat",
      "Ends": "30-Nov-2023"
    },
    "5": {
      "Name": "Activity name 5",
      "Start": "11:30 am",
      "End": "8:00 pm",
      "Repeats": "Fortnightly, Saturday",
      "Ends": "Never"
    },
    "6": {
      "Name": "Activity name 6",
      "Start": "11:30 am",
      "End": "8:00 pm",
      "Repeats": "Thrice-Monthly, 5-15-25",
      "Ends": "Never"
    },
    "7": {
      "Name": "Activity name 7",
      "Start": "11:30 am",
      "End": "8:00 pm",
      "Repeats": "Quarterly, Sunday",
      "Ends": "Never"
    }
  }
};
