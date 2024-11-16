import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/models/habit.dart';
import 'package:streakit/service/db_service.dart';

class ReorderHabits extends StatefulWidget {
  const ReorderHabits({super.key});

  @override
  State<ReorderHabits> createState() => _ReorderHabitsState();
}

class _ReorderHabitsState extends State<ReorderHabits> {
  final HabitDatabaseHelper _dbHelper = HabitDatabaseHelper.instance;
  int? _selectedHabitIndex;
  List<Habit> _habits = [];
  bool isReordering = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    isLoading = true;
    setState(() {});
    _habits = await _dbHelper.readAllHabits();
    isLoading = false;
    setState(() {});
  }

  Future<void> _updateHabitOrder() async {
    for (int i = 0; i < _habits.length; i++) {
      await _dbHelper.updateHabitOrder(_habits[i].id!, i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: Text(
          "Reorder Habits",
          style: textConfig.whiteTitle.copyWith(
            fontSize: sizeConfig.xxl,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: sizeConfig.xl,
          ),
        ),
      ),
      body: _habits.isEmpty
          ? isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Text(
                    "No Habits Created yet",
                    style: textConfig.whiteLarge,
                  ),
                )
          : Padding(
              padding: EdgeInsets.all(sizeConfig.large),
              child: Theme(
                data: ThemeData.dark(),
                child: ReorderableListView(
                  onReorderStart: (value) {
                    isReordering = true;
                    setState(() {});
                  },
                  onReorderEnd: (value) {
                    isReordering = false;
                    setState(() {});
                  },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex--;
                      }
                      final Habit habit = _habits.removeAt(oldIndex);
                      _habits.insert(newIndex, habit);
                    });
                    _updateHabitOrder(); // Update the order in the database
                  },
                  children: _habits.map((habit) {
                    int index = _habits
                        .indexOf(habit); // Get the index of the current habit
                    return Column(
                      key: ValueKey(habit.id),
                      children: [
                        ListTile(
                          tileColor: isReordering
                              ? Colors.transparent
                              : const Color(0xFF1A1A1A),
                          selectedTileColor: const Color(0xFF222222),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(sizeConfig.xs),
                          ),
                          title: Text(
                            habit.name,
                            style: textConfig.whiteLarge,
                          ),
                          trailing: const Icon(
                            Icons.drag_handle,
                            color: Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              _selectedHabitIndex = _selectedHabitIndex == index
                                  ? null
                                  : index; // Toggle selection
                            });
                          },
                        ),
                        SizedBox(height: sizeConfig.xs),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
