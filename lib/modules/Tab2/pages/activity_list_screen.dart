// ignore_for_file: must_be_immutable, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling/modules/Tab2/models/activity_model.dart';
import 'package:scheduling/modules/Tab2/pages/activity_history_screen.dart';
import 'package:scheduling/modules/Tab2/providers/activity_provider.dart';
import '../../reusables.dart';
import 'activity_dialog_screen.dart';

final activityProvider =
    StateNotifierProvider<ActivityProvider, Map<String, List<Activity>>>((ref) {
  return ActivityProvider();
});

class ActivityListScreen extends ConsumerWidget {
  ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    final activities = widgetRef.watch(activityProvider);
    final date = getFormattedDate(DateTime.now());
    final activitiesForDate = activities[date] ?? [];

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 19, 29, 59),
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  width: 100,
                  height: 30,
                  color: const Color.fromARGB(255, 61, 71, 97),
                  child: Center(
                      child: Text(
                    date,
                    style: const TextStyle(color: Colors.white),
                  )),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ActivityHistoryScreen(),
                      ));
                    },
                    icon: const Icon(
                      Icons.history,
                      color: Color.fromARGB(255, 255, 161, 0),
                    ))
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activitiesForDate.length,
              itemBuilder: (context, index) {
                final activity = activitiesForDate[index];

                return GestureDetector(
                  onTap: () async {
                    bool? result =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ActivityDialogScreen(date, index, activityProvider),
                    ));
                    if (result != null) {
                      if (result) {
                        widgetRef.refresh(activityProvider);
                      }
                    }
                  },
                  onDoubleTap: () {
                    print('double tap');

                    widgetRef
                        .read(activityProvider.notifier)
                        .deleteActivity(date, activitiesForDate[index].name);
                  },
                  child: Container(
                    color: index % 2 == 0
                        ? Colors.transparent
                        : const Color.fromARGB(255, 255, 161, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 40,
                          child: Center(
                            child: Text(
                              activity.name.toString(),
                              style: textStyle,
                            ),
                          ),
                        ),
                        Text(
                          '|',
                          style: textStyle,
                        ),
                        SizedBox(
                          width: 80,
                          height: 40,
                          child: Center(
                            child: Text(
                              '${activity.start}',
                              style: textStyle,
                            ),
                          ),
                        ),
                        Text(
                          '|',
                          style: textStyle,
                        ),
                        Container(
                          width: 80,
                          height: 40,
                          padding: const EdgeInsets.only(right: 10),
                          child: Center(
                            child: Text(
                              ' ${activity.end}',
                              style: textStyle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 50,
            ),
            // Column(
            //   children: [
            //     const Text("Test Buttons for create and update "),
            //     TextButton(
            //       onPressed: () {
            //         Activity activity = Activity(
            //           name: 'test activity',
            //         );
            //         ref.addActivity('23-Oct-2023', activity);
            //         print('activity added');
            //       },
            //       child: const Text('Create test activity'),
            //     ),
            //     TextButton(
            //       onPressed: () {
            //         Activity activity = Activity(
            //           name: 'test activity updated',
            //         );
            //         ref.updateActivity('23-Oct-2023', activity, 2);
            //         print('activity updated');
            //       },
            //       child: const Text('Update test activity'),
            //     ),
            //   ],
            // )
          ],
        ),
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width - 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: 'a',
                backgroundColor: const Color.fromARGB(255, 255, 161, 0),
                onPressed: () {
                  // Add a new activity to the state.
                  // Activity activity = Activity(
                  //   name: 'test activity',
                  // );
                  // widgetRef
                  //     .read(activityProvider.notifier)
                  //     .addActivity('3-Nov-2023', activity);
                  // print('activity added');
                },
                child: const Icon(
                  Icons.home,
                  size: 40,
                  color: Color.fromARGB(255, 19, 29, 59),
                ),
              ),
              FloatingActionButton(
                heroTag: 'b',
                backgroundColor: const Color.fromARGB(255, 255, 161, 0),
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ActivityDialogScreen(null, null, activityProvider)));
                },
                child: const Icon(
                  Icons.add,
                  size: 40,
                  color: Color.fromARGB(255, 19, 29, 59),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle textStyle = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
}
