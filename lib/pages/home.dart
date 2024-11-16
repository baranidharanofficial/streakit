import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/models/habit.dart';
import 'package:streakit/pages/widgets/custom_grid.dart';
import 'package:streakit/pages/widgets/gradient_icon.dart';
import 'package:streakit/pages/widgets/habit_card.dart';
import 'package:streakit/service/db_service.dart';
import 'package:streakit/service/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isUpdateAvailable = false;
  bool isCalendar = false;
  bool isUniverse = false;
  DateTime focusDay = DateTime.now();
  DailyMessage? currentMessage;
  List<DailyMessage> messages = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = HabitDatabaseHelper.instance;
    threeWeeks = getLastThreeWeeks(DateTime.now());
    lastYearWeeks = getLastYearWeeks(DateTime.now());
    _loadHabits();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchVersionCollection();
      await fetchUniverseMessage();
    });
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

  Future<void> fetchVersionCollection() async {
    try {
      CollectionReference versionCollection =
          FirebaseFirestore.instance.collection('version');
      QuerySnapshot snapshot = await versionCollection.get();
      List<Map<String, dynamic>> versions = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      debugPrint(versions[0]['version'].toString());

      if (versions[0]['version'] > version) {
        isUpdateAvailable = true;
      }

      if (versions.isNotEmpty) {
        iosLink = versions[0]['ios_link'];
        androidLink = versions[0]['android_link'];
      }
      setState(() {});
    } catch (e) {
      debugPrint("Error fetching version collection: $e");
    }
  }

  Future<void> fetchUniverseMessage() async {
    try {
      CollectionReference notificationCollection =
          FirebaseFirestore.instance.collection('daily-message');
      QuerySnapshot snapshot = await notificationCollection.get();

      if (snapshot.docs.isNotEmpty) {
        var messagesData = snapshot.docs[0]['quotes'] as List<dynamic>;
        List<DailyMessage> data = messagesData
            .map((messageData) {
              return DailyMessage.fromMap(messageData as Map<String, dynamic>);
            })
            .toList()
            .reversed
            .toList();

        messages = data;

        if (messages
            .where((res) => isSameDate(res.createdAt, DateTime.now()))
            .isNotEmpty) {
          DailyMessage message = messages
              .where((res) => isSameDate(res.createdAt, DateTime.now()))
              .first;

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String>? claimed = prefs.getStringList('claimed');

          if (claimed != null && !claimed.contains(message.quote)) {
            isUniverse = true;
            currentMessage = message;
            setState(() {});
          }
        }
      }

      setState(() {});
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
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
                bool? habitAdded = await context.push('/new-habit');

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
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig.large,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Row(
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
                              context.push('/notifications');
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
                              isCalendar = !isCalendar;
                              setState(() {});
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: isCalendar
                                  ? Colors.white
                                  : const Color(0xFF222222),
                              padding: EdgeInsets.all(
                                sizeConfig.xs,
                              ),
                            ),
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: isCalendar ? Colors.black : Colors.white,
                              size: sizeConfig.xxxl,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: sizeConfig.xl,
                  ),
                  if (isUpdateAvailable)
                    Container(
                      margin: EdgeInsets.only(
                        bottom: sizeConfig.large,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: sizeConfig.xl,
                        vertical: sizeConfig.xl,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          sizeConfig.xxxl,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.5),
                            Colors.orange.withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "New version is available",
                            style: textConfig.whiteLarge,
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  sizeConfig.large,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (Platform.isAndroid &&
                                  !await launchUrl(Uri.parse(androidLink))) {
                                throw Exception(
                                  'Could not launch $androidLink',
                                );
                              }

                              if (Platform.isIOS &&
                                  !await launchUrl(Uri.parse(iosLink))) {
                                throw Exception(
                                  'Could not launch $androidLink',
                                );
                              }
                            },
                            child: Text(
                              "Update",
                              style: textConfig.large,
                            ),
                          )
                        ],
                      ),
                    ),
                  if (isCalendar)
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: sizeConfig.xxs,
                            ),
                            TableCalendar(
                              focusedDay: focusDay,
                              firstDay: DateTime(2000),
                              lastDay: DateTime(3000),
                              headerVisible: true,
                              daysOfWeekVisible: false,
                              rowHeight: 80,
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: textConfig.whiteMedium,
                                weekendStyle: textConfig.whiteMedium,
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: false,
                                titleTextStyle: textConfig.whiteLarge,
                                leftChevronVisible: false,
                                rightChevronVisible: false,
                                headerPadding: EdgeInsets.symmetric(
                                  horizontal: sizeConfig.xxs,
                                  vertical: sizeConfig.xs,
                                ),
                              ),
                              calendarFormat: CalendarFormat.week,
                              onDaySelected: (selectedDay, focusedDay) {
                                focusDay = selectedDay;
                                debugPrint(selectedDay.toIso8601String());
                                setState(() {});
                              },
                              calendarBuilders: CalendarBuilders(
                                todayBuilder: (context, day, focusedDay) {
                                  bool isCompleted = isSameDate(
                                    day,
                                    DateTime(
                                      focusedDay.year,
                                      focusedDay.month,
                                      focusedDay.day,
                                    ),
                                  );
                                  return DateWidget(
                                    isCompleted: isCompleted,
                                    day: day,
                                  );
                                },
                                defaultBuilder: (context, day, focusedDay) {
                                  bool isCompleted = isSameDate(
                                    day,
                                    DateTime(
                                      focusedDay.year,
                                      focusedDay.month,
                                      focusedDay.day,
                                    ),
                                  );

                                  return DateWidget(
                                    isCompleted: isCompleted,
                                    day: day,
                                  );
                                },
                                outsideBuilder: (context, day, focusedDay) {
                                  bool isCompleted = isSameDate(
                                    day,
                                    DateTime(
                                      focusedDay.year,
                                      focusedDay.month,
                                      focusedDay.day,
                                    ),
                                  );
                                  return DateWidget(
                                    isCompleted: isCompleted,
                                    day: day,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: sizeConfig.xxl,
                            ),
                            ListView.separated(
                              itemCount: habits.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: sizeConfig.medium,
                                );
                              },
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: sizeConfig.xl,
                                    vertical: sizeConfig.large,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF282828),
                                    borderRadius: BorderRadius.circular(
                                      sizeConfig.xs,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          HugeIcon(
                                            icon: icons[habits[index].icon],
                                            color: colors[habits[index].color],
                                          ),
                                          SizedBox(
                                            width: sizeConfig.small,
                                          ),
                                          Text(
                                            habits[index].name,
                                            style: textConfig.whiteLarge,
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (habits[index]
                                              .completedDays
                                              .contains(
                                                DateTime(
                                                  focusDay.year,
                                                  focusDay.month,
                                                  focusDay.day,
                                                ),
                                              )) {
                                            habits[index].completedDays =
                                                habits[index]
                                                    .completedDays
                                                    .where(
                                                      (cdate) =>
                                                          cdate !=
                                                          DateTime(
                                                            focusDay.year,
                                                            focusDay.month,
                                                            focusDay.day,
                                                          ),
                                                    )
                                                    .toList();
                                          } else {
                                            habits[index].completedDays = [
                                              ...habits[index].completedDays,
                                              DateTime(
                                                focusDay.year,
                                                focusDay.month,
                                                focusDay.day,
                                              ),
                                            ];
                                          }
                                          await _dbHelper
                                              .updateHabit(habits[index]);
                                          _loadHabits();
                                        },
                                        child: Container(
                                          height: sizeConfig.xxxxl,
                                          width: sizeConfig.xxxxl,
                                          decoration: BoxDecoration(
                                            color: habits[index]
                                                    .completedDays
                                                    .contains(
                                                      DateTime(
                                                        focusDay.year,
                                                        focusDay.month,
                                                        focusDay.day,
                                                      ),
                                                    )
                                                ? colors[habits[index].color]
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              sizeConfig.xxxxxl,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: habits[index]
                                                      .completedDays
                                                      .contains(
                                                        DateTime(
                                                          focusDay.year,
                                                          focusDay.month,
                                                          focusDay.day,
                                                        ),
                                                      )
                                                  ? colors[habits[index].color]
                                                  : Colors.white,
                                            ),
                                          ),
                                          child: habits[index]
                                                  .completedDays
                                                  .contains(
                                                    DateTime(
                                                      focusDay.year,
                                                      focusDay.month,
                                                      focusDay.day,
                                                    ),
                                                  )
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!isCalendar)
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
                                borderRadius: BorderRadius.circular(
                                  sizeConfig.xxxl,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: sizeConfig.xxs),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getFormattedDate(),
                                          style:
                                              textConfig.greyLarge.copyWith(),
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
                                    padding:
                                        EdgeInsets.only(left: sizeConfig.xs),
                                    child: Text(
                                      "$habitCount / ${habits.length} Habits",
                                      style: textConfig.greyLarge.copyWith(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeConfig.xs,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: sizeConfig.xs),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(10, (index) {
                                        // Calculate how many circles to highlight based on the percentage
                                        int highlightedCircles = habitCount > 0
                                            ? (((habitCount / habits.length) *
                                                            100)
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
                                                color: index <
                                                        highlightedCircles
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
                                                        : const Color(
                                                            0xFF2C2C2C),
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
                                                        : const Color(
                                                            0xFF2C2C2C),
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
                                      IconButton.filled(
                                        style: IconButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          backgroundColor:
                                              const Color(0xFF272727),
                                        ),
                                        onPressed: () async {
                                          await context.push('/reorder');
                                          _loadHabits();
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                      habit.completedDays =
                                                          habit.completedDays
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
                                          markHabitAsDone: (Habit habit,
                                              DateTime date) async {
                                            if (habit.completedDays
                                                .contains(date)) {
                                              habit.completedDays = habit
                                                  .completedDays
                                                  .where(
                                                      (cdate) => cdate != date)
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
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
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
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              sizeConfig.large,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          bool? habitAdded =
                                              await context.push('/new-habit');

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
          ),
          Visibility(
            visible: isUniverse,
            child: Positioned(
              bottom: MediaQuery.sizeOf(context).height * 0.3,
              left: 0,
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(sizeConfig.small),
                    bottomRight: Radius.circular(sizeConfig.small),
                  ),
                  // color: Colors.white,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF904CFF),
                      Color(0xFF2D8CFF),
                    ],
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          "Message from Universe",
                          style: textConfig.large.copyWith(
                            fontSize: sizeConfig.xxl,
                          ),
                        ),
                        content: Text(
                          "or perhaps from barani or something he stumbled upon.",
                          style: textConfig.medium,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(
                              "Cancel",
                              style: textConfig.large,
                            ),
                          ),
                          FilledButton(
                            onPressed: () {
                              isUniverse = false;
                              setState(() {});
                              context.pop();
                              context.push(
                                '/daily-message',
                                extra: currentMessage,
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: Text(
                              "View",
                              style: textConfig.large.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Center(
                    child: GradientIcon(
                      icon: HugeIcons.strokeRoundedSaturn01,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFFFFF),
                          Color(0xFFCDE4FF),
                        ],
                      ),
                      size: sizeConfig.xxxxl,
                    )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .rotate(
                          duration: const Duration(seconds: 6),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateWidget extends StatelessWidget {
  const DateWidget({
    super.key,
    required this.day,
    required this.isCompleted,
  });

  final DateTime day;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: sizeConfig.xs,
      ),
      height: 100,
      decoration: BoxDecoration(
        color: isCompleted ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(
          sizeConfig.large,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getWeekdayName(day.weekday).toUpperCase(),
              style: isCompleted
                  ? textConfig.medium.copyWith(
                      fontWeight: FontWeight.w500,
                    )
                  : textConfig.whiteMedium,
            ),
            Text(
              '${day.day}',
              style: isCompleted ? textConfig.title : textConfig.whiteTitle,
            ),
          ],
        ),
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
                                            context.pop();
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
                                            context.pop();
                                            context.pop();
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
                      bool? isUpdated = await context.push(
                        '/update-habit',
                        extra: widget.habit,
                      );

                      if (isUpdated != null && isUpdated) {
                        widget.onChange(null, null);
                      }
                      context.pop();
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
                    debugPrint(selectedDay.toIso8601String());
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

                      debugPrint(isCompleted.toString());

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

                      debugPrint(isCompleted.toString());

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

                      debugPrint(isCompleted.toString());

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
