import 'package:flutter/material.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/models/habit.dart';
import 'package:streakit/pages/calendar.dart';
import 'package:streakit/pages/notifications.dart';
import 'package:streakit/pages/update_habit.dart';
import 'package:streakit/pages/new_habit.dart';
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

  @override
  void initState() {
    super.initState();
    _dbHelper = HabitDatabaseHelper.instance;
    threeWeeks = getLastThreeWeeks(DateTime.now());
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? habitAdded = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewHabitScreen()),
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
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.large,
          ),
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: EdgeInsets.only(
                  bottom: sizeConfig.large,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good",
                          style: textConfig.whiteTitle.copyWith(
                            color: const Color(0xFF747474),
                          ),
                        ),
                        Text(
                          "Morning",
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

              //Today Progress
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        margin: EdgeInsets.only(
                          top: sizeConfig.xl,
                        ),
                        padding: EdgeInsets.all(sizeConfig.large),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B),
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
                      SizedBox(height: sizeConfig.xl),

                      // Habits Grid View
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: sizeConfig.large,
                          mainAxisSpacing: sizeConfig.large,
                          childAspectRatio: 3 / 3.6,
                        ),
                        itemCount: habits.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return HabitBottomSheet(
                                    onChange:
                                        (Habit? habit, DateTime? date) async {
                                      if (habit != null && date != null) {
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
                              markHabitAsDone:
                                  (Habit habit, DateTime date) async {
                                if (habit.completedDays.contains(date)) {
                                  habit.completedDays = habit.completedDays
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HabitBottomSheet extends StatefulWidget {
  final Habit habit;
  final List<List<DateTime>> lastYearWeeks;
  final Function onChange;
  const HabitBottomSheet({
    super.key,
    required this.habit,
    required this.lastYearWeeks,
    required this.onChange,
  });

  @override
  State<HabitBottomSheet> createState() => _HabitBottomSheetState();
}

class _HabitBottomSheetState extends State<HabitBottomSheet> {
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
                      bool isUpdated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateHabitScreen(
                            habit: widget.habit,
                          ),
                        ),
                      );
                      if (isUpdated) {
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
                  focusedDay: DateTime.now(),
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
                            if (isCompleted)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors[widget.habit.color],
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
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.habit.completedDays.contains(
                                          widget.lastYearWeeks[windex][index])
                                      ? colors[widget.habit.color]
                                      : colors[widget.habit.color]
                                          .withOpacity(0.5),
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
                Icon(
                  Icons.check_circle_outline,
                  color: colors[widget.habit.color],
                ),
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
