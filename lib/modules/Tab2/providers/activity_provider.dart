import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling/modules/Tab2/models/activity_model.dart';
import 'package:path_provider/path_provider.dart';

//Used for UI of the dialog screen for startTime
StateProvider<TimeOfDay> startTimeProvider =
    StateProvider((ref) => TimeOfDay(hour: 2, minute: 0));

//Used for UI of the dialog screen for endTime
StateProvider<TimeOfDay> endTimeProvider =
    StateProvider((ref) => TimeOfDay(hour: 4, minute: 0));

//Used for UI of the dialog screen for activity repeat handling
StateProvider<String> repeatProvider = StateProvider((ref) => 'Everyday');
//Used for UI of the dialog screen for activity repeat ending
StateProvider<String> endRepeatProvider = StateProvider((ref) => 'Never');
//Used for UI of the dialog screen for activity name
StateProvider<String> nameProvider = StateProvider((ref) => '');

//Controls the file state and functions performed on the json file stored
// in the device storage
//File read/Write operations
//Activity CRUD operations
class ActivityProvider extends StateNotifier<Map<String, List<Activity>>> {
  ActivityProvider() : super({}) {
    initialSetup();
  }

  initialSetup() async {
    await setupFile();
    await readJsonFile();
  }

  //Activity Dialog variables used to keep track of the options selected
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String? selectedRepeat;
  String? selectedEndRepeat;

  //Constant list for repeat options
  List<String> repeatDays = [
    'Everyday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  //constant list for repead end options
  List<String> repeatEndDays = [
    'Never',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  //This function sets up the file in storage.
  //If file doesnt exist it creates one with empty json object
  //Can also be used for adding dummy data to file
  setupFile() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    File jsonDataFile = File('${docDir.path}/tab_two.json');
    if (!await jsonDataFile.exists()) {
      await jsonDataFile.writeAsString("{}");
      // dummyDataToFile();
    }
  }

  //Function to identify and get the json file where needed
  Future<File> getDataFile() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    File jsonDataFile = File('${docDir.path}/tab_two.json');

    return jsonDataFile;
  }

  //This function add an activity to state and write the updated state to the file
  void addActivity(String date, Activity activity) async {
    if (!state.containsKey(date)) {
      state[date] = [];
    }
    state[date]!.add(activity);
    await writeJsonFile(state);
  }

  //This function update activity and update the provider state then write the update state to file
  void updateActivity(String date, Activity activity, int index) async {
    state[date]![index] = activity;
    await writeJsonFile(state);
  }

  // This function delete the activity from provider state and write new state to file.
  void deleteActivity(String date, String name) async {
    state[date]!.removeWhere((element) => element.name == name);
    await writeJsonFile(state);
    await readJsonFile();
  }

  //This function performs all the read operations on the file and returns the data as list to state of the provider
  Future<Map<String, List<Activity>>> readJsonFile() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    final file = await File('${docDir.path}/tab_two.json').readAsString();
    final jsonData = jsonDecode(file);
    final newList = parseMap(jsonData);
    state = newList;
    return newList;
  }

  // This function performs write operations on the file.
  //Receives state object , encode the state to json and write on the file
  Future<void> writeJsonFile(Map<String, List<Activity>> jsonData) async {
    Directory docDir = await getApplicationDocumentsDirectory();
    final file = File('${docDir.path}/tab_two.json').openWrite();
    final encodedJsonData = jsonEncode(jsonData);
    file.write(encodedJsonData);
    await readJsonFile();
  }

  // this function is intended to read the dynamic Map Object and convert to Our required Map with known types
  Map<String, List<Activity>> parseMap(Map<String, dynamic> data) {
    Map<String, List<Activity>> returnMap = {};
    for (var key in data.keys) {
      final list = data[key];
      List<Activity> activityList = [];
      for (var element in list) {
        var activity = Activity.fromJson(element);
        activityList.add(activity);
      }
      returnMap[key] = activityList;
    }
    return returnMap;
  }

  //This function can be called to add some dummy history data to file for testing history screen
  dummyDataToFile() async {
    String date = '23-Oct-2023';
    List<Activity> activity = [
      Activity(
          name: 'Househol chores',
          start: '6:00 am',
          end: '7:30 am',
          repeats: 'Everyday',
          ends: 'Never'),
      Activity(
          name: 'Exercise',
          start: '7:30 am',
          end: '8:30 am',
          repeats: 'Everyday',
          ends: 'Never'),
      Activity(
          name: 'Jiu-jitsu',
          start: '9:00 am',
          end: '10:30 am',
          repeats: 'Everyday',
          ends: 'Never'),
      Activity(
          name: 'App design',
          start: '11:00 am',
          end: '12:30 am',
          repeats: 'Everyday',
          ends: 'Never'),
      Activity(
          name: 'Code',
          start: '12:00 am',
          end: '5:30 pm',
          repeats: 'Everyday',
          ends: 'Never'),
      Activity(
          name: 'Logic Building',
          start: '6:00 am',
          end: '7:30 pm',
          repeats: 'Everyday',
          ends: 'Never'),
    ];

    Map<String, List<Activity>> activityMap = {
      date: activity,
    };
    await writeJsonFile(activityMap);
  }
}
