import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling/modules/Tab2/models/activity_model.dart';
import 'package:path_provider/path_provider.dart';

StateProvider<TimeOfDay> startTimeProvider =
    StateProvider((ref) => TimeOfDay(hour: 2, minute: 0));

StateProvider<TimeOfDay> endTimeProvider =
    StateProvider((ref) => TimeOfDay(hour: 4, minute: 0));

StateProvider<String> repeatProvider = StateProvider((ref) => 'Everyday');

StateProvider<String> endRepeatProvider = StateProvider((ref) => 'Never');

StateProvider<String> nameProvider = StateProvider((ref) => '');

class ActivityProvider extends StateNotifier<Map<String, List<Activity>>> {
  ActivityProvider() : super({}) {
    initialSetup();
  }

  initialSetup() async {
    await setupFile();
    await readJsonFile();
  }

  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String? selectedRepeat;
  String? selectedEndRepeat;

  List<String> repeatDays = [
    'Everyday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  List<String> repeatEndDays = [
    'Never',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  setupFile() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    File jsonDataFile = File('${docDir.path}/tab_two.json');
    if (!await jsonDataFile.exists()) {
      await jsonDataFile.writeAsString("{}");
      // dummyDataToFile();
    }
  }

  Future<File> getDataFile() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    File jsonDataFile = File('${docDir.path}/tab_two.json');

    return jsonDataFile;
  }

  void addActivity(String date, Activity activity) async {
    if (!state.containsKey(date)) {
      state[date] = [];
    }

    state[date]!.add(activity);
    await writeJsonFile(state);
  }

  void updateActivity(String date, Activity activity, int index) async {
    state[date]![index] = activity;
    await writeJsonFile(state);
  }

  void deleteActivity(String date, String name) async {
    state[date]!.removeWhere((element) => element.name == name);
    await writeJsonFile(state);
    await readJsonFile();
  }

  //read and write json file
  Future<Map<String, List<Activity>>> readJsonFile() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    final file = await File('${docDir.path}/tab_two.json').readAsString();
    final jsonData = jsonDecode(file);
    final newList = parseMap(jsonData);
    state = newList;
    return newList;
  }

  Future<void> writeJsonFile(Map<String, List<Activity>> jsonData) async {
    Directory docDir = await getApplicationDocumentsDirectory();
    final file = File('${docDir.path}/tab_two.json').openWrite();
    final encodedJsonData = jsonEncode(jsonData);
    file.write(encodedJsonData);
    await readJsonFile();
  }

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
