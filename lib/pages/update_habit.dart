import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/models/habit.dart';
import 'package:streakit/service/db_service.dart';
import 'package:streakit/service/utils.dart';

class UpdateHabitScreen extends StatefulWidget {
  final Habit habit;
  const UpdateHabitScreen({
    super.key,
    required this.habit,
  });

  @override
  State<UpdateHabitScreen> createState() => _UpdateHabitScreenState();
}

class _UpdateHabitScreenState extends State<UpdateHabitScreen> {
  late HabitDatabaseHelper _dbHelper;
  TextEditingController nameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  int? selectedIcon;
  int? selectedColor;

  @override
  void initState() {
    super.initState();
    _dbHelper = HabitDatabaseHelper.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.text = widget.habit.name;
      notesController.text = widget.habit.notes;
      selectedIcon = widget.habit.icon;
      selectedColor = widget.habit.color;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: Text(
          "Update Habit",
          style: textConfig.whiteTitle.copyWith(
            fontSize: sizeConfig.xxl,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: sizeConfig.xl,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sizeConfig.large,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: sizeConfig.large,
                    ),
                    // Name Input Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: sizeConfig.xs,
                            bottom: sizeConfig.xxs,
                          ),
                          child: Text(
                            "Name",
                            style: textConfig.whiteLarge.copyWith(
                              fontSize: sizeConfig.medium,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: width,
                          padding: EdgeInsets.symmetric(
                            horizontal: sizeConfig.xl,
                            vertical: sizeConfig.xxs,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B2B2B),
                            borderRadius: BorderRadius.circular(
                              sizeConfig.large,
                            ),
                          ),
                          child: TextField(
                            controller: nameController,
                            style: textConfig.whiteLarge,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: "Ex., Morning Walk",
                              hintStyle: textConfig.greyLarge.copyWith(
                                color: const Color(0xFF6C6C6C),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeConfig.xxl,
                    ),
                    // Notes Input Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: sizeConfig.xs,
                            bottom: sizeConfig.xxs,
                          ),
                          child: Text(
                            "Notes",
                            style: textConfig.whiteLarge.copyWith(
                              fontSize: sizeConfig.medium,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: width,
                          padding: EdgeInsets.symmetric(
                            horizontal: sizeConfig.xl,
                            vertical: sizeConfig.xxs,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B2B2B),
                            borderRadius: BorderRadius.circular(
                              sizeConfig.large,
                            ),
                          ),
                          child: TextField(
                            controller: notesController,
                            style: textConfig.whiteLarge,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: "Ex., Take Water Bottle",
                              hintStyle: textConfig.greyLarge.copyWith(
                                color: const Color(0xFF6C6C6C),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeConfig.xxxl,
                    ),
                    // Select Icon
                    Padding(
                      padding: EdgeInsets.only(
                        left: sizeConfig.xs,
                        bottom: sizeConfig.xxs,
                      ),
                      child: Text(
                        "Select Icon",
                        style: textConfig.whiteLarge.copyWith(
                          fontSize: sizeConfig.medium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                      ),
                      itemCount: icons.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIcon = index;
                            });
                          },
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              margin: EdgeInsets.all(
                                sizeConfig.xxs,
                              ),
                              height: 60,
                              decoration: BoxDecoration(
                                color: selectedIcon == index
                                    ? Colors.white
                                    : const Color(0xFF2B2B2B),
                                borderRadius: BorderRadius.circular(
                                  sizeConfig.xl,
                                ),
                              ),
                              child: Center(
                                child: HugeIcon(
                                  icon: icons[index],
                                  color: selectedIcon == index
                                      ? Colors.black
                                      : const Color(0xFFE0E0E0),
                                  size: sizeConfig.xxxxxl,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Select Color
                    Padding(
                      padding: EdgeInsets.only(
                        left: sizeConfig.xs,
                        bottom: sizeConfig.xxs,
                      ),
                      child: Text(
                        "Select Color",
                        style: textConfig.whiteLarge.copyWith(
                          fontSize: sizeConfig.medium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                      ),
                      itemCount: icons.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = index;
                            });
                          },
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              margin: EdgeInsets.all(
                                sizeConfig.xxs,
                              ),
                              height: 60,
                              decoration: BoxDecoration(
                                color: colors[index],
                                border: Border.all(
                                  color: selectedColor == index
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(
                                  sizeConfig.xl,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: sizeConfig.xl,
            ),
            FilledButton(
              onPressed: () async {
                String habitName = nameController.text;
                String habitNotes = notesController.text;

                if (habitName.isEmpty) {
                  showSnackBar("Habit Name is required");
                  return;
                }

                if (selectedIcon == null) {
                  showSnackBar("Icon is required");
                  return;
                }

                if (selectedColor == null) {
                  showSnackBar("Color is required");
                  return;
                }

                final updatedHabit = Habit(
                  id: widget.habit.id,
                  name: habitName,
                  notes: habitNotes,
                  icon: selectedIcon!,
                  color: selectedColor!,
                  completedDays: widget.habit.completedDays,
                );

                await _dbHelper.updateHabit(updatedHabit);
                Navigator.pop(context, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                fixedSize: Size(width, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sizeConfig.large),
                ),
              ),
              child: Text(
                "Update Habit",
                style: textConfig.large,
              ),
            ),
            SizedBox(
              height: sizeConfig.xxxl * 2,
            ),
          ],
        ),
      ),
    );
  }
}
