import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/main.dart';

String getFormattedDate() {
  DateTime today = DateTime.now();
  DateFormat dateFormat = DateFormat("d MMMM, E");
  return dateFormat.format(today);
}

void showSnackBar(String message) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: textConfig.whiteLarge,
        ),
      ],
    ),
  );
  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}

List<List<DateTime>> getLastThreeWeeks(DateTime currentDate) {
  // Find the most recent Sunday before or on the current date and set its time to 00:00:00
  DateTime lastSunday =
      DateTime(currentDate.year, currentDate.month, currentDate.day)
          .subtract(Duration(days: currentDate.weekday % 7));

  // Create a list to store the weeks (each week is a list of DateTime objects)
  List<List<DateTime>> lastThreeWeeks = [];

  // Generate the weeks (starting from last Sunday and going back 3 weeks)
  for (int i = 0; i < 3; i++) {
    List<DateTime> week = [];
    for (int j = 0; j < 7; j++) {
      // Each week contains 7 days (Sunday to Saturday) with time set to 00:00:00
      DateTime day = lastSunday.subtract(Duration(days: j + (i * 7)));
      week.add(DateTime(day.year, day.month, day.day)); // Set time to 00:00:00
    }
    // Add the week (in reverse order so that Sunday to Saturday is the correct order)
    lastThreeWeeks.add(week.reversed.toList());
  }

  return lastThreeWeeks;
}

int getStreakNumber(List<DateTime> completedDays) {
  if (completedDays.isEmpty) {
    return 0;
  }
  completedDays.sort((a, b) => b.compareTo(a));
  int streak = 1;
  for (int i = 0; i < completedDays.length; i++) {
    DateTime normalizedDay = DateTime(
      completedDays[i].year,
      completedDays[i].month,
      completedDays[i].day,
    );
    if (i == 0) {
      continue;
    }
    DateTime previousDay = DateTime(
      completedDays[i - 1].year,
      completedDays[i - 1].month,
      completedDays[i - 1].day,
    );
    int dayDifference = previousDay.difference(normalizedDay).inDays;

    if (dayDifference == 1) {
      streak++;
    } else {
      break;
    }
  }

  return streak;
}

List<List<DateTime>> getLastYearWeeks(DateTime currentDate) {
  DateTime lastSunday =
      DateTime(currentDate.year, currentDate.month, currentDate.day)
          .subtract(Duration(days: currentDate.weekday % 7));
  List<List<DateTime>> lastYearWeeks = [];
  for (int i = 0; i < 52; i++) {
    List<DateTime> week = [];
    for (int j = 0; j < 7; j++) {
      DateTime day = lastSunday.subtract(Duration(days: j + (i * 7)));
      week.add(DateTime(day.year, day.month, day.day));
    }
    lastYearWeeks.add(week.reversed.toList());
  }
  return lastYearWeeks.reversed.toList();
}
