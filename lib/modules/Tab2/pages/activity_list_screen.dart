// ignore_for_file: must_be_immutable, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduling/modules/Tab2/models/activity_model.dart';
import 'package:scheduling/modules/Tab2/pages/activity_history_screen.dart';
import 'package:scheduling/modules/Tab2/providers/activity_provider.dart';
import '../../reusables.dart';
import '../layout_params.dart';
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
                icon: settingIcon),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DateWidget(date: date),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ActivityHistoryScreen(),
                    ));
                  },
                  icon: historyIcon,
                )
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
                    widgetRef
                        .read(activityProvider.notifier)
                        .deleteActivity(date, activitiesForDate[index].name);
                  },
                  child: Container(
                    color: index % 2 == 0 ? transparentColor : secondaryColor,
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
                          // height: 40,
                          padding: paddingRight10,
                          child: Center(
                            child: Text(
                              ' ${activity.end}, ${activity.ends}, ${activity.repeats}',
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
            sizedBoxh50
          ],
        ),
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width - 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                  heroTag: 'a',
                  backgroundColor: secondaryColor,
                  onPressed: () {},
                  child: homeIcon),
              FloatingActionButton(
                heroTag: 'b',
                backgroundColor: secondaryColor,
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ActivityDialogScreen(null, null, activityProvider)));
                },
                child: addIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
