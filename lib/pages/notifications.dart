import 'package:flutter/material.dart';
import 'package:streakit/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: Text(
          "Notifications",
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
              Icons.notifications_outlined,
              size: sizeConfig.xxxxxl * 3,
              color: const Color(0xFFD0D0D0),
            ),
            SizedBox(
              height: sizeConfig.xxxxxl,
            ),
            Text(
              "Important App Updates",
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
