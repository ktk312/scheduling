// ignore_for_file: must_be_immutable, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../reusables.dart';
import '../models/activity_model.dart';
import '../providers/activity_provider.dart';
import '../layout_params.dart';

class ActivityDialogScreen extends ConsumerWidget {
  final String? date;
  final int? activityIndex;
  final StateNotifierProvider<ActivityProvider, Map<String, List<Activity>>>
      activityProvider;
  ActivityDialogScreen(this.date, this.activityIndex, this.activityProvider,
      {super.key});

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

    if (activityIndex != null) {
      Future(() =>
          assignActivity(widgetRef, date!, activityIndex!, activityProvider));
    }

    return WillPopScope(
      onWillPop: () async {
        resetActivity(widgetRef, activityProvider);
        return true;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            appBarTitle,
            style: blackText,
          ),
          centerTitle: true,
          backgroundColor: whiteColor,
          actions: [IconButton(onPressed: () {}, icon: settingIcon)],
        ),
        body: Container(
          padding: paddingScreen,
          child: ListView(
            children: [
              Row(
                children: [
                  Text(nameText, style: textStyle18),
                  sizedBoxh20,
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        controller: controller,
                        textAlignVertical: TextAlignVertical.center,
                        style: textStyle,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: white70),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: white70),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: white70),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              divider,
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
              divider,
              Consumer(
                builder: (context, ref, child) {
                  final endRepeatP = ref.watch(endRepeatProvider);
                  return itemRow(
                      context,
                      endRepeatText,
                      endRepeatP == "Never" ? endRepeatP : "On Date",
                      widgetRef.read(activityProvider.notifier).repeatEndDays,
                      onChanged: (value) {
                    ref.read(endRepeatProvider.notifier).state = value!;
                    widgetRef
                        .read(activityProvider.notifier)
                        .selectedEndRepeat = value;
                  });
                },
              ),
              divider,
              Consumer(
                builder: (context, ref, child) {
                  final endRepeatP = ref.watch(endRepeatProvider);
                  final endDateP = ref.watch(endDateProvider);
                  final today = DateTime.now();
                  if (endRepeatP == 'On Date') {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              endDateText,
                              style: textStyle20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: secondaryColor,
                                ),
                                onPressed: () async {
                                  final selectedEndDate = await showDatePicker(
                                      context: context,
                                      initialDate: today,
                                      firstDate: today,
                                      lastDate: DateTime(today.year + 5));

                                  if (selectedEndDate != null) {
                                    ref.read(endDateProvider.notifier).state =
                                        getFormattedDate(selectedEndDate);
                                    widgetRef
                                            .read(activityProvider.notifier)
                                            .selectedEndRepeat =
                                        getFormattedDate(selectedEndDate);
                                  }
                                },
                                child: Text(
                                  endDateP,
                                  style: textStyle.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ))
                          ],
                        ),
                        divider,
                        // itemRow(
                        //     context,
                        //     endDateText,
                        //     endRepeatP,
                        //     widgetRef
                        //         .read(activityProvider.notifier)
                        //         .repeatEndDays, onChanged: (value) {
                        //   ref.read(endRepeatProvider.notifier).state = value!;
                        //   widgetRef
                        //       .read(activityProvider.notifier)
                        //       .selectedEndRepeat = value;
                        // }),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),

              //date picker for end repeat date.

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
              divider,
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
                    resetActivity(widgetRef, activityProvider);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(submitText)),
              sizedBoxh10,
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteColor,
                  ),
                  onPressed: () {
                    resetActivity(widgetRef, activityProvider);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    cancelText,
                    style: blackText,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
