class Activity {
  final String name;
  String? start;
  String? end;
  String? repeats;
  String? ends;
  final String date;

  Activity({
    required this.name,
    this.start,
    this.end,
    this.repeats,
    this.ends,
    required this.date,
  });

  Activity copyWith({
    String? name,
    String? start,
    String? end,
    String? repeats,
    String? ends,
    String? date,
  }) =>
      Activity(
        name: name ?? this.name,
        start: start ?? this.start,
        end: end ?? this.end,
        repeats: repeats ?? this.repeats,
        ends: ends ?? this.ends,
        date: date ?? this.date,
      );

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        name: json['Name'],
        start: json['Start'],
        end: json['End'],
        repeats: json['Repeats'],
        ends: json['Ends'],
        date: json['date'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Start': start,
        'End': end,
        'Repeats': repeats,
        'Ends': ends,
        'date': date,
      };
}
