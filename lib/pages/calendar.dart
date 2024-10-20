import 'package:flutter/material.dart';
import 'package:streakit/constants.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: Text(
          "Calendar View",
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: sizeConfig.xxxxxl * 3,
              color: const Color(0xFFD0D0D0),
            ),
            SizedBox(
              height: sizeConfig.xxxxxl,
            ),
            Text(
              "Calendar view",
              style: textConfig.whiteLarge,
            ),
            SizedBox(
              height: sizeConfig.xs,
            ),
            Text(
              "will come here",
              style: textConfig.whiteLarge,
            )
          ],
        ),
      ),
    );
  }
}
