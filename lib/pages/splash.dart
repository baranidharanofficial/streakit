import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streakit/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<String>? claimed = prefs.getStringList('claimed');
        if (claimed == null) {
          prefs.setStringList('claimed', []);
        }
        final bool onboarded = prefs.getBool('onboarded') ?? false;

        if (onboarded) {
          context.go('/home');
        } else {
          context.go('/onboarding');
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 80,
              width: 80,
            ),
            SizedBox(
              height: sizeConfig.xxl,
            ),
            Text(
              "Streakit",
              style: textConfig.whiteLarge.copyWith(
                fontSize: sizeConfig.xxxl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
