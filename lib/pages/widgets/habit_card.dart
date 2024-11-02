import 'package:flutter/material.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/models/habit.dart';
import 'package:streakit/service/utils.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.deleteHabit,
    required this.markHabitAsDone,
    required this.threeWeeks,
    required this.isGrid,
    required this.lastYearWeeks,
  });

  final Habit habit;
  final Function deleteHabit;
  final Function markHabitAsDone;
  final List<List<DateTime>> threeWeeks;
  final List<List<DateTime>> lastYearWeeks;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sizeConfig.large),
      margin: EdgeInsets.only(
        bottom: sizeConfig.large,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          sizeConfig.large,
        ),
        color: const Color(0xFF262626),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      icons[habit.icon],
                      color: colors[habit.color],
                      size: sizeConfig.xxxl,
                    ),
                    SizedBox(
                      width: sizeConfig.xxs,
                    ),
                    Expanded(
                      child: Text(
                        habit.name,
                        style: textConfig.whiteLarge.copyWith(
                          fontSize: sizeConfig.large,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: sizeConfig.xl,
              ),
              GestureDetector(
                onTap: () {
                  markHabitAsDone(
                    habit,
                    DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ),
                  );
                },
                child: Container(
                  height: sizeConfig.xxxxl,
                  width: sizeConfig.xxxxl,
                  decoration: BoxDecoration(
                    color: habit.completedDays.contains(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      ),
                    )
                        ? colors[habit.color]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      sizeConfig.xxxxxl,
                    ),
                    border: Border.all(
                      width: 1,
                      color: habit.completedDays.contains(
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        ),
                      )
                          ? colors[habit.color]
                          : Colors.white,
                    ),
                  ),
                  child: habit.completedDays.contains(
                    DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
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
          SizedBox(
            height: sizeConfig.xl,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                getStreakNumber(habit.completedDays).toString(),
                style: textConfig.whiteTitle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors[habit.color],
                  height: 1,
                  fontSize: sizeConfig.xxxxl * 2,
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
                      style: textConfig.whiteMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "in a row",
                      style: textConfig.whiteMedium.copyWith(
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
          isGrid
              ? Column(
                  children: List.generate(threeWeeks.length, (windex) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (index) {
                        return Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              margin: const EdgeInsets.all(
                                2,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSameDate(threeWeeks[windex][index],
                                          DateTime.now())
                                      ? colors[habit.color]
                                      : Colors.transparent,
                                  width: 1,
                                ),
                                color: habit.completedDays
                                        .contains(threeWeeks[windex][index])
                                    ? colors[habit.color]
                                    : colors[habit.color].withOpacity(0.2),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                )
              : Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          children:
                              List.generate(lastYearWeeks.length, (windex) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(7, (index) {
                                return Container(
                                  margin: const EdgeInsets.all(
                                    1,
                                  ),
                                  height: 14,
                                  width: 14,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSameDate(
                                              lastYearWeeks[windex][index],
                                              DateTime.now())
                                          ? colors[habit.color]
                                          : Colors.transparent,
                                      width: 1,
                                    ),
                                    color: habit.completedDays.contains(
                                            lastYearWeeks[windex][index])
                                        ? colors[habit.color]
                                        : colors[habit.color].withOpacity(0.2),
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
        ],
      ),
    );
  }
}
