import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streakit/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Column(
        children: [
          SafeArea(
            child: Container(
              height: height * 0.44,
              color: const Color(0xFF171717),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/onboarding.png",
                      width: width * 0.75,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: width,
              padding: EdgeInsets.only(
                top: sizeConfig.xxxxxl,
                bottom: sizeConfig.xxxxxl * 2,
                left: sizeConfig.xxxxxl,
                right: sizeConfig.xxxxxl,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(sizeConfig.xxl * 2),
                  topRight: Radius.circular(sizeConfig.xxl * 2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Track your",
                        style: textConfig.whiteTitle.copyWith(
                          fontSize: sizeConfig.xxl * 2,
                        ),
                      ),
                      Text(
                        "Habits",
                        style: textConfig.whiteTitle.copyWith(
                          fontSize: sizeConfig.xxl * 2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedTextKit(
                        repeatForever: true,
                        pause: const Duration(milliseconds: 0),
                        animatedTexts: [
                          RotateAnimatedText(
                            'Focus',
                            textStyle: textConfig.greyTitle.copyWith(
                              fontSize: sizeConfig.xxl * 2,
                              color: const Color(0xFFFF4F4F),
                            ),
                          ),
                          RotateAnimatedText(
                            'Track',
                            textStyle: textConfig.greyTitle.copyWith(
                              fontSize: sizeConfig.xxl * 2,
                              color: const Color(0xFFFFA837),
                            ),
                          ),
                          RotateAnimatedText(
                            'Achieve',
                            textStyle: textConfig.greyTitle.copyWith(
                              fontSize: sizeConfig.xxl * 2,
                              color: const Color(0xFF6DD242),
                            ),
                          ),
                        ],
                        onTap: () {
                          debugPrint("Tap Event");
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Get Started",
                        style: textConfig.whiteTitle.copyWith(
                          fontSize: sizeConfig.xxl,
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('onboarded', true);

                          context.go('/home');
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(
                            sizeConfig.medium,
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                          size: sizeConfig.xxxl,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
