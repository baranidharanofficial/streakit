import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/main.dart';

String getFormattedDate() {
  DateTime today = DateTime.now();
  DateFormat dateFormat = DateFormat("d MMMM, E");
  return dateFormat.format(today);
}

String formatDate(DateTime date) {
  DateFormat dateFormat = DateFormat("dd MMM, yyyy");
  return dateFormat.format(date);
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
  // Start from the Sunday of the current week (shift back to Sunday)
  DateTime startOfCurrentWeek = currentDate
      .subtract(Duration(days: currentDate.weekday % 7)); // Start from Sunday

  List<List<DateTime>> lastThreeWeeks = [];

  // Loop for the current week and the last two weeks
  for (int i = 0; i < 3; i++) {
    List<DateTime> week = [];
    for (int j = 0; j < 7; j++) {
      DateTime day = startOfCurrentWeek.add(Duration(days: j - (i * 7)));
      week.add(DateTime(day.year, day.month, day.day));
    }
    lastThreeWeeks
        .add(week); // No need to reverse, we want [Sunday -> Saturday]
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
  // Start from the Sunday of the current week (shift back to Sunday)
  DateTime startOfCurrentWeek = currentDate
      .subtract(Duration(days: currentDate.weekday % 7)); // Start from Sunday

  List<List<DateTime>> lastThreeWeeks = [];

  // Loop for the current week and the last two weeks
  for (int i = 0; i < 52; i++) {
    List<DateTime> week = [];
    for (int j = 0; j < 7; j++) {
      DateTime day = startOfCurrentWeek.add(Duration(days: j - (i * 7)));
      week.add(DateTime(day.year, day.month, day.day));
    }
    lastThreeWeeks
        .add(week); // No need to reverse, we want [Sunday -> Saturday]
  }

  return lastThreeWeeks.reversed.toList();
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String getWeekdayName(int day) {
  const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  if (day >= 1 && day <= 7) {
    return days[day - 1];
  } else {
    return "Invalid day";
  }
}

hasInternet() async {
  return await InternetConnection().hasInternetAccess;
}
