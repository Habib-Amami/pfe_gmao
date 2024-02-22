import 'package:flutter/material.dart';

//This ColorSchema will be used in the application's light theme
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF166683),
  surfaceTint: Color(0xFF166683),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffc0e8ff),
  onPrimaryContainer: Color(0xff001e2b),
  secondary: Color(0xff865318),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffffdcbe),
  onSecondaryContainer: Color(0xff2d1600),
  tertiary: Color(0xff05677e),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xffb6ebff),
  onTertiaryContainer: Color(0xff001f28),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff410002),
  background: Color(0xfff6fafe),
  onBackground: Color(0xff171c1f),
  surface: Color(0xfff6fafe),
  onSurface: Color(0xff171c1f),
  surfaceVariant: Color(0xffdce3e9),
  onSurfaceVariant: Color(0xff40484c),
  outline: Color(0xff71787d),
  outlineVariant: Color(0xffc0c7cd),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff2c3134),
);

//This ColorSchema will be used in the application's dark theme
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff8ccff1),
  surfaceTint: Color(0xff8ccff1),
  onPrimary: Color(0xff003547),
  primaryContainer: Color(0xff004d66),
  onPrimaryContainer: Color(0xffc0e8ff),
  secondary: Color(0xfffdb975),
  onSecondary: Color(0xff4a2800),
  secondaryContainer: Color(0xff693c00),
  onSecondaryContainer: Color(0xffffdcbe),
  tertiary: Color(0xff87d1eb),
  onTertiary: Color(0xff003543),
  tertiaryContainer: Color(0xff004e60),
  onTertiaryContainer: Color(0xffb6ebff),
  error: Color(0xffffb4ab),
  onError: Color(0xff690005),
  errorContainer: Color(0xff93000a),
  onErrorContainer: Color(0xffffdad6),
  background: Color(0xff0f1417),
  onBackground: Color(0xffdfe3e7),
  surface: Color(0xff0f1417),
  onSurface: Color(0xffdfe3e7),
  surfaceVariant: Color(0xff40484c),
  onSurfaceVariant: Color(0xffc0c7cd),
  outline: Color(0xff8a9297),
  outlineVariant: Color(0xff40484c),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffdfe3e7),
  inversePrimary: Color(0xff166683),
);

//this is the TextTheme of the appliaction
const textTheme = TextTheme(
  //Display Type Style
  displayLarge: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 57,
    letterSpacing: -0.25,
  ),

  displayMedium: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 45,
  ),

  displaySmall: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 36,
  ),

  //Headline Type Style
  headlineLarge: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 32,
  ),

  headlineMedium: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 28,
  ),

  headlineSmall: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 24,
  ),

  //Title Type Style
  titleLarge: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 22,
  ),

  titleMedium: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: 0.15,
  ),

  titleSmall: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.1,
  ),

  //Lable Type Style
  labelLarge: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.1,
  ),

  labelMedium: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    letterSpacing: 0.5,
  ),

  labelSmall: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11,
    letterSpacing: 0.5,
  ),

  //Body Type Style
  bodyLarge: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: 0.5,
  ),

  bodyMedium: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.25,
  ),

  bodySmall: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.4,
  ),
);

//this ligthTheme of the application
final lightTheme = ThemeData(
  useMaterial3: true,
  // COLOR
  colorScheme: lightColorScheme,
  // TYPOGRAPHY
  fontFamily: "Roboto",
  textTheme: textTheme,
);

//this is the darktheme of the application
final darkTheme = ThemeData(
  useMaterial3: true,
  //COLOR
  colorScheme: darkColorScheme,
  // TYPOGRAPHY
  fontFamily: "Roboto",
  textTheme: textTheme,
);
