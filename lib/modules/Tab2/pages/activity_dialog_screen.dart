// ignore_for_file: must_be_immutable, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../reusables.dart';
import '../models/activity_model.dart';
import '../providers/activity_provider.dart';
import '../constants.dart';

class ActivityDialogScreen extends ConsumerWidget {
  final String? date;
  final int? activityIndex;
  final StateNotifierProvider<ActivityProvider, Map<String, List<Activity>>>
      activityProvider;
  ActivityDialogScreen(this.date, this.activityIndex, this.activityProvider,
      {super.key});

  DateTime timeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now(); // Get the current date
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    // ignore: unused_local_variable
    final activities = widgetRef.watch(activityProvider);

    final controller = TextEditingController(
        text: date != null && activityIndex != null
            ? widgetRef.read(activityProvider.notifier).state[date] != null
                ? widgetRef
                    .read(activityProvider.notifier)
                    .state[date]![activityIndex!]
                    .name
                : ''
            : '');

    assignActivity() {
      final activity = widgetRef
          .read(activityProvider.notifier)
          .state[date]![activityIndex!];

      widgetRef.read(activityProvider.notifier).selectedStartTime =
          activity.start != null ? timeOfDayFromString(activity.start!) : null;
      widgetRef.read(activityProvider.notifier).selectedEndTime =
          activity.end != null ? timeOfDayFromString(activity.end!) : null;
      widgetRef.read(activityProvider.notifier).selectedEndRepeat =
          activity.ends ?? "Never";
      widgetRef.read(activityProvider.notifier).selectedRepeat =
          activity.repeats ?? 'Everyday';

      widgetRef.read(startTimeProvider.notifier).state =
          timeOfDayFromString(activity.start!);
      widgetRef.read(endTimeProvider.notifier).state =
          timeOfDayFromString(activity.end!);
      widgetRef.read(repeatProvider.notifier).state =
          activity.repeats ?? 'Everyday';
      widgetRef.read(endRepeatProvider.notifier).state =
          activity.ends ?? 'Never';
    }

    resetActivity() {
      widgetRef.read(activityProvider.notifier).selectedStartTime = null;
      widgetRef.read(activityProvider.notifier).selectedEndTime = null;
      widgetRef.read(activityProvider.notifier).selectedEndRepeat = null;
      widgetRef.read(activityProvider.notifier).selectedRepeat = null;
      widgetRef.read(startTimeProvider.notifier).state =
          TimeOfDay(hour: 12, minute: 0);
      widgetRef.read(endTimeProvider.notifier).state =
          TimeOfDay(hour: 12, minute: 0);
      widgetRef.read(repeatProvider.notifier).state = 'Everyday';
      widgetRef.read(endRepeatProvider.notifier).state = 'Never';
    }

    if (activityIndex != null) {
      Future(() => assignActivity());
    }

    return WillPopScope(
      onWillPop: () async {
        resetActivity();
        return true;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            appBarTitle,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: whiteColor,
          actions: [IconButton(onPressed: () {}, icon: settingIcon)],
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: ListView(
            children: [
              Row(
                children: [
                  Text(nameText,
                      style: textStyle.copyWith(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                  sizedBoxh20,
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
              Consumer(
                builder: (context, ref, child) {
                  final repeatP = ref.watch(repeatProvider);
                  return itemRow(context, repeatText, repeatP,
                      widgetRef.read(activityProvider.notifier).repeatDays,
                      onChanged: (value) {
                    ref.read(repeatProvider.notifier).state = value!;
                    widgetRef.read(activityProvider.notifier).selectedRepeat =
                        value;
                  });
                },
              ),
              const Divider(height: 45, color: Colors.white70),
              Consumer(
                builder: (context, ref, child) {
                  final endRepeatP = ref.watch(endRepeatProvider);
                  return itemRow(context, endRepeatText, endRepeatP,
                      widgetRef.read(activityProvider.notifier).repeatEndDays,
                      onChanged: (value) {
                    ref.read(endRepeatProvider.notifier).state = value!;
                    widgetRef
                        .read(activityProvider.notifier)
                        .selectedEndRepeat = value;
                  });
                },
              ),
              const Divider(height: 45, color: Colors.white70),
              Consumer(
                builder: (context, ref, child) {
                  final startTimeP = ref.watch(startTimeProvider);

                  return timeRow(
                      context,
                      startTimeText,
                      getFormattedTime(
                        timeOfDayToDateTime(startTimeP),
                      ), onTap: () async {
                    final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: ref.read(startTimeProvider));
                    if (pickedTime != null) {
                      ref.read(startTimeProvider.notifier).state = pickedTime;
                      widgetRef
                          .read(activityProvider.notifier)
                          .selectedStartTime = pickedTime;
                    }
                  });
                },
              ),
              const Divider(height: 45, color: Colors.white70),
              Consumer(
                builder: (context, ref, child) {
                  final endTimeP = ref.watch(endTimeProvider);

                  return timeRow(context, endTimeText,
                      getFormattedTime(timeOfDayToDateTime(endTimeP)),
                      onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: ref.read(endTimeProvider),
                    );
                    if (pickedTime != null) {
                      ref.read(endTimeProvider.notifier).state = pickedTime;
                      widgetRef
                          .read(activityProvider.notifier)
                          .selectedEndTime = pickedTime;
                    }
                  });
                },
              ),
              sizedBoxh30,
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                  ),
                  onPressed: () async {
                    if (date != null && activityIndex != null) {
                      widgetRef.read(activityProvider.notifier).updateActivity(
                          date.toString(),
                          Activity(
                              name: controller.text.trim(),
                              start: widgetRef
                                          .read(activityProvider.notifier)
                                          .selectedStartTime !=
                                      null
                                  ? getFormattedTime(timeOfDayToDateTime(
                                      widgetRef
                                          .read(activityProvider.notifier)
                                          .selectedStartTime!))
                                  : null,
                              end: widgetRef
                                          .read(activityProvider.notifier)
                                          .selectedEndTime !=
                                      null
                                  ? getFormattedTime(timeOfDayToDateTime(
                                      widgetRef
                                          .read(activityProvider.notifier)
                                          .selectedEndTime!))
                                  : null,
                              ends: widgetRef
                                  .read(activityProvider.notifier)
                                  .selectedEndRepeat,
                              repeats: widgetRef
                                  .read(activityProvider.notifier)
                                  .selectedRepeat),
                          activityIndex!);
                    } else {
                      widgetRef.read(activityProvider.notifier).addActivity(
                          getFormattedDate(DateTime.now()),
                          Activity(
                              name: controller.text.trim(),
                              start: widgetRef
                                          .read(activityProvider.notifier)
                                          .selectedStartTime !=
                                      null
                                  ? getFormattedTime(timeOfDayToDateTime(
                                      widgetRef
                                          .read(activityProvider.notifier)
                                          .selectedStartTime!))
                                  : null,
                              end: widgetRef
                                          .read(activityProvider.notifier)
                                          .selectedEndTime !=
                                      null
                                  ? getFormattedTime(timeOfDayToDateTime(
                                      widgetRef
                                          .read(activityProvider.notifier)
                                          .selectedEndTime!))
                                  : null,
                              ends: widgetRef
                                  .read(activityProvider.notifier)
                                  .selectedEndRepeat,
                              repeats: widgetRef
                                  .read(activityProvider.notifier)
                                  .selectedRepeat));
                    }
                    resetActivity();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(submitText)),
              sizedBoxh10,
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    resetActivity();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    cancelText,
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
