class Activity {
  final String name;
  String? start;
  String? end;
  String? repeats;
  String? ends;

  Activity({
    required this.name,
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
        name: json['Name'],
        start: json['Start'],
        end: json['End'],
        repeats: json['Repeats'],
        ends: json['Ends'],
      );

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Start': start,
        'End': end,
        'Repeats': repeats,
        'Ends': ends,
      };
}
