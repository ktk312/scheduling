import 'dart:convert';

ActivityModel activityModelFromJson(String str) =>
    ActivityModel.fromJson(json.decode(str));

String activityModelToJson(ActivityModel data) => json.encode(data.toJson());

class ActivityModel {
  String? date;
  Map<String, Activity>? activities;

  ActivityModel({
    this.date,
    this.activities,
  });

  ActivityModel copyWith({
    String? date,
    Map<String, Activity>? activities,
  }) =>
      ActivityModel(
        date: date ?? this.date,
        activities: activities ?? this.activities,
      );

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        date: json["Date"],
        activities: Map.from(json["Activities"]!)
            .map((k, v) => MapEntry<String, Activity>(k, Activity.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "Date": date,
        "Activities": Map.from(activities!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Activity {
  String? name;
  String? start;
  String? end;
  String? repeats;
  String? ends;

  Activity({
    this.name,
    this.start,
    this.end,
    this.repeats,
    this.ends,
  });

  Activity copyWith({
    String? name,
    String? start,
    String? end,
    String? repeats,
    String? ends,
  }) =>
      Activity(
        name: name ?? this.name,
        start: start ?? this.start,
        end: end ?? this.end,
        repeats: repeats ?? this.repeats,
        ends: ends ?? this.ends,
      );

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        name: json["Name"],
        start: json["Start"],
        end: json["End"],
        repeats: json["Repeats"],
        ends: json["Ends"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Start": start,
        "End": end,
        "Repeats": repeats,
        "Ends": ends,
      };
}
