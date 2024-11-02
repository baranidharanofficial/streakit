import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/models/habit.dart';
import 'package:streakit/pages/calendar.dart';
import 'package:streakit/pages/notifications.dart';
import 'package:streakit/pages/reorder.dart';
import 'package:streakit/pages/update_habit.dart';
import 'package:streakit/pages/new_habit.dart';
import 'package:streakit/pages/widgets/custom_grid.dart';
import 'package:streakit/pages/widgets/habit_card.dart';
import 'package:streakit/service/db_service.dart';
import 'package:streakit/service/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HabitDatabaseHelper _dbHelper;
  int habitCount = 0;
  List<Habit> habits = [];
  List<List<DateTime>> threeWeeks = [];
  List<List<DateTime>> lastYearWeeks = [];
  String cardView = "grid";

  @override
  void initState() {
    super.initState();
    _dbHelper = HabitDatabaseHelper.instance;
    threeWeeks = getLastThreeWeeks(DateTime.now());
    lastYearWeeks = getLastYearWeeks(DateTime.now());
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    habitCount = 0;
    setState(() {});

    final allhabits = await _dbHelper.readAllHabits();

    for (var habit in allhabits) {
      if (habit.completedDays.contains(DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
        habitCount++;
      }
    }

    setState(() {
      habits = allhabits;
    });
  }

  void _deleteHabit(int id) async {
    await _dbHelper.deleteHabit(id);
    _loadHabits();
  }

  String getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Morning";
    } else if (hour < 18) {
      return "Afternoon";
    } else {
      return "Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    // bool positive = false;
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      floatingActionButton: habits.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                bool? habitAdded = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewHabitScreen()),
                );

                // If a habit was added, reload the list
                if (habitAdded == true) {
                  _loadHabits(); // Refresh the habit list
                }
              },
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  sizeConfig.xxxxl,
                ),
              ),
              child: Icon(
                Icons.add,
                size: sizeConfig.xxxxxl,
              ),
            )
          : const SizedBox(),
      body: Stack(
        children: [
          if (habits.isEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x2EA7FF6D),
                      Color(0x56FFAE34),
                    ],
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1000,
                sigmaY: 200,
              ),
              child: const SizedBox(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig.large,
            ),
            child: Column(
              children: [
                // App Bar
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good",
                            style: textConfig.whiteTitle.copyWith(
                              color: const Color(0xFFA8A8A8),
                            ),
                          ),
                          Text(
                            getTimeOfDay(),
                            style: textConfig.whiteTitle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          IconButton.filled(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationScreen(),
                                ),
                              );
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFF222222),
                              padding: EdgeInsets.all(
                                sizeConfig.xs,
                              ),
                            ),
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: sizeConfig.xxxl,
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CalendarScreen(),
                                ),
                              );
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFF222222),
                              padding: EdgeInsets.all(
                                sizeConfig.xs,
                              ),
                            ),
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.white,
                              size: sizeConfig.xxxl,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        //Today Progress
                        Container(
                          width: width,
                          padding: EdgeInsets.all(
                            sizeConfig.large,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF262626),
                            // gradient: const LinearGradient(
                            //   colors: [
                            //     Color(0x2EA7FF6D),
                            //     Color(0x56FFAE34),
                            //   ],
                            // ),
                            borderRadius: BorderRadius.circular(
                              sizeConfig.large,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: sizeConfig.xxs),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getFormattedDate(),
                                      style: textConfig.greyLarge.copyWith(),
                                    ),
                                    Text(
                                      "Today's Progress",
                                      style: textConfig.whiteTitle,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: sizeConfig.large,
                              ),
                              Text(
                                "${habitCount > 0 ? ((habitCount / habits.length) * 100).toInt() : 0}%",
                                style: textConfig.whiteTitle.copyWith(
                                  fontSize: sizeConfig.xxxxl * 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: sizeConfig.xs),
                                child: Text(
                                  "$habitCount / ${habits.length} Habits",
                                  style: textConfig.greyLarge.copyWith(),
                                ),
                              ),
                              SizedBox(
                                height: sizeConfig.xs,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: sizeConfig.xs),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(10, (index) {
                                    // Calculate how many circles to highlight based on the percentage
                                    int highlightedCircles = habitCount > 0
                                        ? (((habitCount / habits.length) * 100)
                                                    .toInt() /
                                                10)
                                            .ceil()
                                        : 0; // Divide percentage by 10 to get the number of circles

                                    return Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Container(
                                          margin: const EdgeInsets.all(2),
                                          // Add margin for spacing
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: index < highlightedCircles
                                                ? Colors
                                                    .green // Highlighted circles
                                                : Colors.green.withOpacity(
                                                    0.2), // Unhighlighted circles
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              )
                            ],
                          ),
                        ),

                        // Habits Grid View
                        if (habits.isNotEmpty)
                          Column(
                            children: [
                              SizedBox(height: sizeConfig.xl),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 30,
                                    margin: EdgeInsets.only(
                                      left: sizeConfig.xxs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2F2F2F),
                                      borderRadius: BorderRadius.circular(
                                        sizeConfig.xs,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              cardView = "grid";
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: sizeConfig.xs,
                                              ),
                                              decoration: BoxDecoration(
                                                color: cardView == "grid"
                                                    ? Colors.white
                                                    : const Color(0xFF2C2C2C),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  sizeConfig.xs,
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.grid_view_rounded,
                                                  color: cardView == "grid"
                                                      ? Colors.black
                                                      : Colors.white,
                                                  size: sizeConfig.xl,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              cardView = "list";
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: sizeConfig.xs,
                                              ),
                                              decoration: BoxDecoration(
                                                color: cardView == "list"
                                                    ? Colors.white
                                                    : const Color(0xFF2C2C2C),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  sizeConfig.xs,
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.table_rows_rounded,
                                                  color: cardView == "list"
                                                      ? Colors.black
                                                      : Colors.white,
                                                  size: sizeConfig.xl,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    style: IconButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () async {
                                      bool? isUpdated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReorderHabits(),
                                        ),
                                      );

                                      if (isUpdated == true) {
                                        _loadHabits();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.format_list_numbered_rounded,
                                      size: sizeConfig.xxl,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              CustomGridView(
                                crossAxisCount: cardView == "grid" ? 2 : 1,
                                crossAxisSpacing: sizeConfig.large,
                                length: habits.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                widgetOfIndex: (index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return HabitBottomSheet(
                                            onDelete: (Habit? habit) async {
                                              if (habit != null) {
                                                await _dbHelper
                                                    .deleteHabit(habit.id!);

                                                _loadHabits();
                                              }
                                            },
                                            onChange: (Habit? habit,
                                                DateTime? date) async {
                                              if (habit != null &&
                                                  date != null) {
                                                if (habit.completedDays
                                                    .contains(date)) {
                                                  habit.completedDays = habit
                                                      .completedDays
                                                      .where((cdate) =>
                                                          cdate != date)
                                                      .toList();
                                                } else {
                                                  habit.completedDays = [
                                                    ...habit.completedDays,
                                                    date,
                                                  ];
                                                }
                                                await _dbHelper
                                                    .updateHabit(habit);
                                              }

                                              _loadHabits();
                                            },
                                            lastYearWeeks: getLastYearWeeks(
                                              DateTime.now(),
                                            ),
                                            habit: habits[index],
                                          );
                                        },
                                      );
                                    },
                                    child: HabitCard(
                                      habit: habits[index],
                                      threeWeeks: threeWeeks,
                                      lastYearWeeks: lastYearWeeks,
                                      isGrid: cardView == "grid",
                                      markHabitAsDone:
                                          (Habit habit, DateTime date) async {
                                        if (habit.completedDays
                                            .contains(date)) {
                                          habit.completedDays = habit
                                              .completedDays
                                              .where((cdate) => cdate != date)
                                              .toList();
                                        } else {
                                          habit.completedDays = [
                                            ...habit.completedDays,
                                            date,
                                          ];
                                        }
                                        await _dbHelper.updateHabit(habit);
                                        _loadHabits();
                                      },
                                      deleteHabit: (Habit habit) {
                                        _deleteHabit(habit.id!);
                                        _loadHabits();
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                        if (habits.isEmpty)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/Empty.gif",
                                    height: 100,
                                    width: 100,
                                  ),
                                  SizedBox(
                                    height: sizeConfig.large,
                                  ),
                                  Text(
                                    "No Habits Created yet",
                                    style: textConfig.whiteLarge,
                                  ),
                                  SizedBox(
                                    height: sizeConfig.xl,
                                  ),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      bool? habitAdded = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NewHabitScreen()),
                                      );

                                      // If a habit was added, reload the list
                                      if (habitAdded == true) {
                                        _loadHabits(); // Refresh the habit list
                                      }
                                    },
                                    child: Text(
                                      "Add Habit",
                                      style: textConfig.large,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          height: sizeConfig.xxxxxl * 2,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HabitBottomSheet extends StatefulWidget {
  final Habit habit;
  final List<List<DateTime>> lastYearWeeks;
  final Function onChange;
  final Function onDelete;
  const HabitBottomSheet({
    super.key,
    required this.habit,
    required this.lastYearWeeks,
    required this.onChange,
    required this.onDelete,
  });

  @override
  State<HabitBottomSheet> createState() => _HabitBottomSheetState();
}

class _HabitBottomSheetState extends State<HabitBottomSheet> {
  DateTime focusDay = DateTime.now();
  bool isCalendar = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isCalendar ? 570 : 500,
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.xxl,
        vertical: sizeConfig.xxxxl,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(sizeConfig.xxl),
          topRight: Radius.circular(sizeConfig.xxl),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      icons[widget.habit.icon],
                      color: colors[widget.habit.color],
                      size: sizeConfig.xxxxxl,
                    ),
                    SizedBox(
                      width: sizeConfig.xs,
                    ),
                    Expanded(
                      child: Text(
                        widget.habit.name,
                        style: textConfig.whiteLarge.copyWith(
                          fontSize: sizeConfig.xl,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: sizeConfig.xxxxl,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // bool? isUpdated = await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => UpdateHabitScreen(
                      //       habit: widget.habit,
                      //     ),
                      //   ),
                      // );
                      // if (isUpdated != null && isUpdated) {
                      //   widget.onChange(null, null);
                      // }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xFF222222),
                            contentPadding: EdgeInsets.zero,
                            content: Container(
                              height: 170,
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: EdgeInsets.symmetric(
                                horizontal: sizeConfig.xxxl,
                                vertical: sizeConfig.xl,
                              ),
                              decoration: const BoxDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Are you sure ?",
                                    style: textConfig.whiteTitle,
                                  ),
                                  SizedBox(
                                    height: sizeConfig.xs,
                                  ),
                                  Text(
                                    "You can't retreive the action",
                                    style: textConfig.whiteLarge,
                                  ),
                                  SizedBox(
                                    height: sizeConfig.large,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FilledButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                sizeConfig.small,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Cancel",
                                            style: textConfig.whiteLarge,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: sizeConfig.small,
                                      ),
                                      Expanded(
                                        child: FilledButton(
                                          onPressed: () {
                                            widget.onDelete(widget.habit);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                sizeConfig.small,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Delete",
                                            style: textConfig.large,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      // Navigator.pop(context);
                    },
                    child: Container(
                      height: sizeConfig.xxl * 2,
                      width: sizeConfig.xxl * 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFF131313),
                        borderRadius: BorderRadius.circular(
                          sizeConfig.xxxxxl,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizeConfig.xs,
                  ),
                  GestureDetector(
                    onTap: () async {
                      bool? isUpdated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateHabitScreen(
                            habit: widget.habit,
                          ),
                        ),
                      );
                      if (isUpdated != null && isUpdated) {
                        widget.onChange(null, null);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: sizeConfig.xxl * 2,
                      width: sizeConfig.xxl * 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFF131313),
                        borderRadius: BorderRadius.circular(
                          sizeConfig.xxxxxl,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizeConfig.xs,
                  ),
                  GestureDetector(
                    onTap: () {
                      isCalendar = !isCalendar;
                      setState(() {});
                    },
                    child: Container(
                      height: sizeConfig.xxl * 2,
                      width: sizeConfig.xxl * 2,
                      decoration: BoxDecoration(
                        color: isCalendar
                            ? colors[widget.habit.color]
                            : const Color(0xFF131313),
                        borderRadius: BorderRadius.circular(
                          sizeConfig.xxxxxl,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: sizeConfig.xl,
          ),
          if (isCalendar)
            Expanded(
              child: SingleChildScrollView(
                child: TableCalendar(
                  calendarFormat: CalendarFormat.month,
                  firstDay: DateTime(2000),
                  lastDay: DateTime.now(),
                  focusedDay: focusDay,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: textConfig.whiteLarge,
                    leftChevronIcon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: sizeConfig.large,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: sizeConfig.large,
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    focusDay = selectedDay;
                    print(selectedDay.toIso8601String());
                    widget.onChange(
                      widget.habit,
                      DateTime(
                        selectedDay.year,
                        selectedDay.month,
                        selectedDay.day,
                      ),
                    );
                    setState(() {});
                  },
                  calendarBuilders: CalendarBuilders(
                    todayBuilder: (context, day, focusedDay) {
                      bool isCompleted =
                          widget.habit.completedDays.contains(DateTime(
                        focusedDay.year,
                        focusedDay.month,
                        focusedDay.day,
                      ));

                      print(isCompleted);

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? colors[widget.habit.color]
                                    : Colors.transparent,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      // Check if this day has a completed task
                      bool isCompleted =
                          widget.habit.completedDays.contains(DateTime(
                        day.year,
                        day.month,
                        day.day,
                      ));

                      print(isCompleted);

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? colors[widget.habit.color]
                                    : Colors.transparent,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      // Check if this day has a completed task
                      bool isCompleted =
                          widget.habit.completedDays.contains(DateTime(
                        day.year,
                        day.month,
                        day.day,
                      ));

                      print(isCompleted);

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Color(0xFF8E8E8E),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? colors[widget.habit.color]
                                    : Colors.transparent,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          if (!isCalendar)
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        getStreakNumber(widget.habit.completedDays).toString(),
                        style: textConfig.whiteTitle.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colors[widget.habit.color],
                          height: 1,
                          fontSize: sizeConfig.xxxl * 3,
                        ),
                      ),
                      SizedBox(
                        width: sizeConfig.xs,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: sizeConfig.xxs,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "days",
                              style: textConfig.whiteLarge.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "in a row",
                              style: textConfig.whiteLarge.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: sizeConfig.medium,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Row(
                        children: List.generate(widget.lastYearWeeks.length,
                            (windex) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(7, (index) {
                              return Container(
                                margin: const EdgeInsets.all(
                                  2,
                                ),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.habit.completedDays.contains(
                                          widget.lastYearWeeks[windex][index])
                                      ? colors[widget.habit.color]
                                      : colors[widget.habit.color]
                                          .withOpacity(0.2),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: sizeConfig.xl,
          ),
          FilledButton(
            onPressed: () {
              widget.onChange(
                widget.habit,
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
              );
              setState(() {});
            },
            style: FilledButton.styleFrom(
              backgroundColor: widget.habit.completedDays.contains(DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day))
                  ? colors[widget.habit.color]
                  : colors[widget.habit.color].withOpacity(0.2),
              fixedSize: Size(width, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  sizeConfig.large,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!widget.habit.completedDays.contains(DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day)))
                  Icon(
                    Icons.check_circle_outline,
                    color: colors[widget.habit.color],
                  ),
                if (!widget.habit.completedDays.contains(DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day)))
                  SizedBox(
                    width: sizeConfig.xs,
                  ),
                Text(
                  widget.habit.completedDays.contains(DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day))
                      ? "Undone"
                      : "Mark as done",
                  style: textConfig.whiteLarge,
                )
              ],
            ),
          ),
          SizedBox(
            height: sizeConfig.xxxxl,
          ),
        ],
      ),
    );
  }
}
