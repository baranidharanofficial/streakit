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
  List<String> lines = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      lines = widget.message.quote.split(" /n ");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(sizeConfig.large),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Container(
                      padding: EdgeInsets.all(sizeConfig.xxxxl),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 39, 39, 39),
                        borderRadius: BorderRadius.circular(sizeConfig.xxl),
                      ),
                      child: ListView.separated(
                        itemCount: lines.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: sizeConfig.xl,
                          );
                        },
                        itemBuilder: (context, index) {
                          final line = lines[index]
                              .trim(); // Trim leading/trailing spaces
                          if (line.isEmpty) {
                            return const SizedBox.shrink(); // Skip empty lines
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              line,
                              textAlign: TextAlign.left,
                              style: textConfig.large.copyWith(
                                color: Colors.white,
                                fontSize: sizeConfig.large,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: sizeConfig.xxxxxl * 4,
                    ),
                  ],
                ),
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
