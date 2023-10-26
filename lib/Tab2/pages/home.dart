import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling/Tab2/models/activity_model.dart';
import 'package:scheduling/Tab2/providers/activities_provider.dart';
import 'package:scheduling/Tab2/utils.dart';

final activitiesProvider =
    StateNotifierProvider<ActivitiesProvider, ActivityModel>((ref) {
  return ActivitiesProvider(jsonList);
});

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    final provider = widgetRef.watch(activitiesProvider);
    List<Activity> activityList =
        provider.activities!.values.toList() as List<Activity>;
    // final activityModel = state.;

    // print(state);
    // print(state.length);

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
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 30,
                    color: Color.fromARGB(255, 61, 71, 97),
                    child: Center(
                        child: Text(
                      provider.date.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                  Icon(
                    Icons.settings,
                    color: Color.fromARGB(255, 255, 161, 0),
                    size: 30,
                  )
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: activityList.length,
              itemBuilder: (context, index) {
                final activity = activityList[index];

                return Row(
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
                );

                // return ListTile(
                //   title: Text(
                //     activity.name.toString(),
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   subtitle: Text(
                //     '${activity.start} - ${activity.end}',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add a new activity to the state.
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  TextStyle textStyle =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
}
