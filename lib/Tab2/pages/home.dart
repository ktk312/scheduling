import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling/Tab2/models/activity_model.dart';
import 'package:scheduling/Tab2/providers/activity_provider.dart';
import 'package:scheduling/Tab2/utils.dart';

final activityProvider =
    StateNotifierProvider<ActivityProvider, Map<String, List<Activity>>>((ref) {
  return ActivityProvider();
});

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    print("Home Widget");
    final activities = widgetRef.watch(activityProvider);

    final ref = widgetRef.read(activityProvider.notifier);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 19, 29, 59),
        appBar: AppBar(
          title: Text(
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
                icon: Icon(
                  Icons.settings,
                  color: Color.fromARGB(255, 255, 161, 0),
                ))
          ],
        ),
        body: ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final date = activities.keys.elementAt(index);
              final activitiesForDate = activities[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    width: 100,
                    height: 30,
                    color: Color.fromARGB(255, 61, 71, 97),
                    child: Center(
                        child: Text(
                      date,
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: activitiesForDate.length,
                    itemBuilder: (context, index) {
                      final activity = activitiesForDate[index];

                      return Container(
                        color: index % 2 == 0
                            ? null
                            : Color.fromARGB(255, 255, 161, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
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
                            Container(
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
                              padding: EdgeInsets.only(right: 10),
                              child: Center(
                                child: Text(
                                  ' ${activity.end}',
                                  style: textStyle,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // Column(
                  //   children: [
                  //     Text("Test Buttons for create and update "),
                  //     TextButton(
                  //       onPressed: () {
                  //         Activity activity = Activity(
                  //             name: 'test activity', date: '23-Oct-2023');
                  //         ref.addActivity('23-Oct-2023', activity);
                  //         print('activity added');
                  //       },
                  //       child: Text('Create test activity'),
                  //     ),
                  //     TextButton(
                  //       onPressed: () {
                  //         Activity activity = Activity(
                  //             name: 'test activity updated',
                  //             date: '23-Oct-2023');
                  //         ref.updateActivity('23-Oct-2023', activity, 2);
                  //         print('activity updated');
                  //       },
                  //       child: Text('Update test activity'),
                  //     ),
                  //   ],
                  // )
                ],
              );
            }),
        floatingActionButton: Container(
          width: MediaQuery.of(context).size.width - 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 255, 161, 0),
                onPressed: () {
                  // Add a new activity to the state.
                },
                child: Icon(
                  Icons.home,
                  size: 40,
                  color: Color.fromARGB(255, 19, 29, 59),
                ),
              ),
              FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 255, 161, 0),
                onPressed: () {
                  // Add a new activity to the state.
                },
                child: Icon(
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

  TextStyle textStyle =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
}
