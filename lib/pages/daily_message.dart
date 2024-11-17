import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/models/habit.dart';

class DailyMessageScreen extends StatefulWidget {
  final DailyMessage message;
  const DailyMessageScreen({
    super.key,
    required this.message,
  });

  @override
  State<DailyMessageScreen> createState() => _DailyMessageScreenState();
}

class _DailyMessageScreenState extends State<DailyMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(sizeConfig.large),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message.title,
                    textAlign: TextAlign.left,
                    style: textConfig.title.copyWith(
                      color: Colors.white,
                      fontSize: sizeConfig.xxxxl,
                    ),
                  ),
                  SizedBox(
                    height: sizeConfig.xl,
                  ),
                  Text(
                    widget.message.quote,
                    textAlign: TextAlign.left,
                    style: textConfig.large.copyWith(
                      color: Colors.white,
                      fontSize: sizeConfig.xl,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: sizeConfig.xxxxxl * 2,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: FilledButton(
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          List<String>? claimed =
                              prefs.getStringList('claimed');

                          if (claimed != null) {
                            prefs.setStringList(
                              'claimed',
                              [...claimed, widget.message.quote],
                            );
                          }
                          setState(() {});

                          context.pop();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          "Claim Message",
                          style: textConfig.large,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
