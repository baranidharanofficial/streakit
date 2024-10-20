import 'package:flutter/material.dart';
import 'package:streakit/models/habit.dart';
import 'package:streakit/pages/splash.dart';
import 'package:streakit/service/db_service.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streakit',
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class HabitListPage extends StatefulWidget {
  const HabitListPage({super.key});

  @override
  _HabitListPageState createState() => _HabitListPageState();
}

class _HabitListPageState extends State<HabitListPage> {
  late HabitDatabaseHelper _dbHelper;
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = HabitDatabaseHelper.instance;
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await _dbHelper.readAllHabits();
    setState(() {
      _habits = habits;
    });
  }

  void _addHabit() async {
    final newHabit = Habit(
      name: 'New Habit',
      notes: '',
      icon: Icons.star.codePoint,
      color: Colors.blue.value,
      completedDays: [
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 7,
        )
      ],
    );
    await _dbHelper.createHabit(newHabit);
    _loadHabits();
  }

  void _deleteHabit(int id) async {
    await _dbHelper.deleteHabit(id);
    _loadHabits();
  }

  void _editHabit(Habit habit) async {
    habit.name = 'Updated Habit';
    habit.completedDays = [
      ...habit.completedDays,
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    ];
    await _dbHelper.updateHabit(habit);
    _loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: Column(
        children: [
          if (_habits.isNotEmpty)
            TableCalendar(
              calendarFormat: CalendarFormat.month,
              firstDay: DateTime(2000),
              lastDay: DateTime(3000),
              focusedDay: DateTime.now(),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                print(selectedDay.toIso8601String());
              },
              calendarBuilders: CalendarBuilders(
                todayBuilder: (context, day, focusedDay) {
                  bool isCompleted =
                      _habits.first.completedDays.contains(DateTime(
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
                          style: TextStyle(
                            color: isCompleted ? Colors.blue : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (isCompleted)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                          )
                      ],
                    ),
                  );
                },
                defaultBuilder: (context, day, focusedDay) {
                  // Check if this day has a completed task
                  bool isCompleted =
                      _habits.first.completedDays.contains(DateTime(
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
                          style: TextStyle(
                            color: isCompleted ? Colors.blue : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (isCompleted)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return ListTile(
                  title: Text(habit.name),
                  subtitle: Text('Icon: ${habit.icon}, Color: ${habit.color}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (habit.completedDays.isNotEmpty)
                        Text(
                          habit.completedDays.first.toIso8601String(),
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editHabit(habit),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteHabit(habit.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
