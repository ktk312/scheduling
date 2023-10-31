import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:scheduling/Tab2/models/activity_model.dart';
import 'package:path_provider/path_provider.dart';

class ActivityProvider extends StateNotifier<Map<String, List<Activity>>> {
  ActivityProvider() : super({}) {
    setupFile();
    readJsonFile();
  }

  setupFile() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    File jsonDataFile = File('${docDir.path}/tab_two.json');
    if (!await jsonDataFile.exists()) {
      await jsonDataFile.writeAsString("{}");
    }
  }

  Future<File> getDataFile() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    File jsonDataFile = File('${docDir.path}/tab_two.json');

    return jsonDataFile;
  }

  void addActivity(String date, Activity activity) {
    if (!state.containsKey(date)) {
      state[date] = [];
    }

    state[date]!.add(activity);
    writeJsonFile(state);
  }

  void updateActivity(String date, Activity activity, int index) {
    state[date]![index] = activity;
    writeJsonFile(state);
  }

  void deleteActivity(String date, String name) {
    state[date]!.removeWhere((element) => element.name == name);
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
    readJsonFile();
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
}
