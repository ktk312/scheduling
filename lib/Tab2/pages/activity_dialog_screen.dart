// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling/Tab2/utils.dart';

import '../models/activity_model.dart';
import '../providers/activity_provider.dart';

final activityProvider =
    StateNotifierProvider<ActivityProvider, Map<String, List<Activity>>>((ref) {
  return ActivityProvider();
});

class ActivityDialogScreen extends ConsumerWidget {
  final String? date;
  final int? activityIndex;
  ActivityDialogScreen(this.date, this.activityIndex, {super.key});
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String selectedRepeat = '';
  String selectedEndRepeat = '';

  DateTime timeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now(); // Get the current date
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  List<String> items = [
    'Everyday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  List<String> repeat = [
    'Never',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    print("Activity Dialog");
    final activities = widgetRef.watch(activityProvider);
    final ref = widgetRef.read(activityProvider.notifier);
    final controller = TextEditingController(
        text: date != null && activityIndex != null
            ? ref.state[date] != null
                ? ref.state[date]![activityIndex!].name
                : ''
            : '');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 29, 59),

      appBar: AppBar(
        title: const Text(
          'Time Management',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                print('settings');
              },
              icon: const Icon(
                Icons.settings,
                color: Color.fromARGB(255, 255, 161, 0),
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: ListView(
          children: [
            Row(
              children: [
                Text('Name: ',
                    style: textStyle.copyWith(
                        fontSize: 18, fontWeight: FontWeight.normal)),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: controller,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 45, color: Colors.white70),
            itemRow(
              context,
              'Repeat',
              items,
              onChanged: (value) => selectedRepeat = value!,
            ),
            const Divider(height: 45, color: Colors.white70),
            itemRow(
              context,
              'End Repeat',
              repeat,
              onChanged: (value) => selectedEndRepeat = value!,
            ),
            const Divider(height: 45, color: Colors.white70),
            timeRow(
                context,
                'Start Time',
                getFormattedTime(selectedStartTime != null
                    ? timeOfDayToDateTime(selectedStartTime!)
                    : DateTime.now()), onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedStartTime ?? TimeOfDay.now(),
              );
              if (pickedTime != null) {
                selectedStartTime = pickedTime;
                print(selectedStartTime);
              }
            }),
            const Divider(height: 45, color: Colors.white70),
            timeRow(
                context,
                'End Time',
                getFormattedTime(selectedEndTime != null
                    ? timeOfDayToDateTime(selectedEndTime!)
                    : DateTime.now()), onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedStartTime ?? TimeOfDay.now(),
              );
              if (pickedTime != null) {
                selectedEndTime = pickedTime;
                print(timeOfDayToDateTime(selectedEndTime!));
              }
            }),
            const SizedBox(height: 30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 161, 0),
                ),
                onPressed: () async {
                  // create / update activity
                  if (date != null && activityIndex != null) {
                    ref.updateActivity(
                        date.toString(),
                        Activity(
                            name: controller.text.trim(),
                            start: selectedStartTime != null
                                ? getFormattedTime(
                                    timeOfDayToDateTime(selectedStartTime!))
                                : null,
                            end: selectedEndTime != null
                                ? getFormattedTime(
                                    timeOfDayToDateTime(selectedEndTime!))
                                : null,
                            ends: selectedEndRepeat,
                            repeats: selectedRepeat),
                        activityIndex!);
                  } else {
                    ref.addActivity(
                        getFormattedDate(DateTime.now()),
                        Activity(
                            name: controller.text.trim(),
                            start: selectedStartTime != null
                                ? getFormattedTime(
                                    timeOfDayToDateTime(selectedStartTime!))
                                : null,
                            end: selectedEndTime != null
                                ? getFormattedTime(
                                    timeOfDayToDateTime(selectedEndTime!))
                                : null,
                            ends: selectedEndRepeat,
                            repeats: selectedRepeat));
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Submit')),
            const SizedBox(height: 10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
      ),
      // bottomNavigationBar: Container(height: ,),
    );
  }

  Widget timeRow(BuildContext context, String title, String time,
      {final VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 30,
            color: Colors.transparent,
            child: Text(
              time,
              style:
                  textStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemRow(BuildContext context, String title, List<String> options,
      {final ValueChanged<String?>? onChanged}) {
    String selectedOption = options.first;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        Container(
          color: const Color.fromARGB(255, 255, 161, 0),
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: DropdownButton<String>(
            value: selectedOption,
            underline: Container(),
            style: const TextStyle(color: Colors.white),
            items: options
                .map((option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: const TextStyle(color: Colors.black),
                    )))
                .toList(),
            onChanged: onChanged,
          ),
          // TextButton(
          //     style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.all(Colors.yellow),
          //     ),
          //     onPressed: () {
          //       print('pressed this button');
          //       showDialog(
          //         context: context,
          //         builder: (context) => ListView(
          //           children: [Text('Repeat'), Text('Repeat'), Text('Repeat')],
          //         ),
          //       );
          //     },
          //     child: Text(text)),
        )
      ],
    );
  }

  TextStyle textStyle = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
}
