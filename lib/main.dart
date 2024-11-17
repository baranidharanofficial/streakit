import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:streakit/firebase_options.dart';
import 'package:streakit/models/habit.dart';
import 'package:streakit/pages/daily_message.dart';
import 'package:streakit/pages/home.dart';
import 'package:streakit/pages/new_habit.dart';
import 'package:streakit/pages/notifications.dart';
import 'package:streakit/pages/onboarding.dart';
import 'package:streakit/pages/reorder.dart';
import 'package:streakit/pages/splash.dart';
import 'package:streakit/pages/update_habit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/daily-message',
      builder: (context, state) => DailyMessageScreen(
        message: state.extra as DailyMessage,
      ),
    ),
    GoRoute(
      path: '/new-habit',
      builder: (context, state) => const NewHabitScreen(),
    ),
    GoRoute(
      path: '/update-habit',
      builder: (context, state) => UpdateHabitScreen(
        habit: state.extra as Habit,
      ),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/reorder',
      builder: (context, state) => const ReorderHabits(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Streakit',
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
