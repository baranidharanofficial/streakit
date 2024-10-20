import 'package:flutter/material.dart';

const String fontFamily = 'Montserrat';
const String appVersion = '1.0.0';

List<IconData> icons = [
  Icons.access_alarm,
  Icons.run_circle_outlined,
  Icons.payment_outlined,
  Icons.favorite_outline_rounded,
  Icons.eco_outlined,
  Icons.book_outlined,
];

List<Color> colors = [
  const Color(0xFFFF3030),
  const Color(0xFFAD26D6),
  const Color(0xFF4949FF),
  const Color(0xFFEDAE00),
  const Color(0xFF39CE48),
  const Color(0xFFFF8000),
];

ButtonStyle buttonStyle = FilledButton.styleFrom(
  backgroundColor: const Color(0xFF1D1B20),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(sizeConfig.large),
  ),
);

SizeConfig sizeConfig = SizeConfig(
  xxs: 4,
  xs: 8,
  small: 12,
  medium: 14,
  large: 16,
  xl: 18,
  xxl: 20,
  xxxl: 24,
  xxxxl: 28,
  xxxxxl: 32,
  tabBreakpoint: 768,
);

TextConfig textConfig = TextConfig(
  small: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  ),
  medium: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  ),
  large: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  ),
  title: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  ),
  greySmall: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  ),
  greyMedium: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  ),
  greyLarge: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  ),
  greyTitle: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.grey,
  ),
  whiteSmall: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  ),
  whiteMedium: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  ),
  whiteLarge: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
  whiteTitle: const TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
);

class TextConfig {
  TextStyle small;
  TextStyle medium;
  TextStyle large;
  TextStyle title;
  TextStyle greySmall;
  TextStyle greyMedium;
  TextStyle greyLarge;
  TextStyle greyTitle;
  TextStyle whiteSmall;
  TextStyle whiteMedium;
  TextStyle whiteLarge;
  TextStyle whiteTitle;

  TextConfig({
    required this.small,
    required this.medium,
    required this.large,
    required this.title,
    required this.greySmall,
    required this.greyMedium,
    required this.greyLarge,
    required this.greyTitle,
    required this.whiteSmall,
    required this.whiteMedium,
    required this.whiteLarge,
    required this.whiteTitle,
  });
}

class SizeConfig {
  double xxs;
  double xs;
  double small;
  double medium;
  double large;
  double xl;
  double xxl;
  double xxxl;
  double xxxxl;
  double xxxxxl;
  double tabBreakpoint;

  SizeConfig({
    required this.xxs,
    required this.xs,
    required this.small,
    required this.medium,
    required this.large,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.xxxxl,
    required this.xxxxxl,
    required this.tabBreakpoint,
  });
}
