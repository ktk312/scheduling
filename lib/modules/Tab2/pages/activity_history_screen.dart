// ignore_for_file: must_be_immutable, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling/modules/Tab2/layout_params.dart';
import 'package:scheduling/modules/Tab2/models/activity_model.dart';
import 'package:scheduling/modules/Tab2/providers/activity_provider.dart';
import 'package:scheduling/modules/reusables.dart';

final activityProvider =
    StateNotifierProvider<ActivityProvider, Map<String, List<Activity>>>((ref) {
  return ActivityProvider();
});

class ActivityHistoryScreen extends ConsumerWidget {
  ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    final activities = widgetRef.watch(activityProvider);
    widgetRef.refresh(activityProvider.notifier);

    return Directionality(
      textDirection: TextDirection.ltr,
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
          actions: [
            IconButton(
                onPressed: () {
                  print('settings');
                },
                icon: settingIcon)
          ],
        ),
        body: ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, idx) {
              final date = activities.keys.toList().reversed.elementAt(idx);
              final activitiesForDate = activities[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateWidget(
                    date: date,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activitiesForDate.length,
                    itemBuilder: (context, index) {
                      final activity = activitiesForDate[index];

                      return Container(
                        color:
                            index % 2 == 0 ? transparentColor : secondaryColor,
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
                      );
                    },
                  ),
                  sizedBoxh60
                ],
              );
            }),
      ),
    );
  }
}
