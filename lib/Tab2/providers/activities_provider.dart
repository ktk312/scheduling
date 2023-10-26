import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling/Tab2/models/activity_model.dart';
import '../utils.dart';

class ActivitiesProvider extends StateNotifier<ActivityModel> {
  ActivitiesProvider(this.jsonData)
      : super(activityModelFromJson(json.encode(jsonList)));
  final Map<String, dynamic> jsonData;
  ActivityModel activityModel = activityModelFromJson(jsonEncode(jsonList));

  Future<void> createActivity(Activity activity) async {
    // TODO: Implement this method to create a new activity in your database.
  }

  Future<void> updateActivity(Activity activity) async {
    // TODO: Implement this method to update an existing activity in your database.
  }

  Future<void> deleteActivity(String id) async {
    // TODO: Implement this method to delete an activity from your database.
  }

  Future<ActivityModel> getActivityModel() async {
    return activityModel;
  }

  void getAllActivities() async {
    if (activityModel.activities != null) {
      // state = activityModel.activities!.values.toList();
    }
  }
}
