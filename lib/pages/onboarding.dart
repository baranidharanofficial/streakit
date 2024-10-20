import 'package:flutter/material.dart';
import 'package:streakit/constants.dart';
import 'package:streakit/pages/home.dart';

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
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: sizeConfig.xxxxxl,
                    ),
                    child: Image.asset(
                      "assets/images/onboarding.png",
                      width: width * 0.75,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: (height - (width * 1.15)),
                width: width,
                padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.xxxxxl,
                  horizontal: sizeConfig.xxxxxl,
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
                    Text(
                      "Effortlessly",
                      style: textConfig.greyTitle.copyWith(
                        fontSize: sizeConfig.xxl * 2,
                        color: const Color(0xFF383838),
                      ),
                    ),
                    Column(
                      children: [
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
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
                        SizedBox(
                          height: sizeConfig.xxl,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
