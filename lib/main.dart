import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'sign_up_panel.dart';

void main() {
  runApp(Head(child : MyApp() , server:  UserServer()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.from(colorScheme: colorScheme1, textTheme: textTheme1)
          .copyWith(
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        cardColor: Color(0xfffaf9f5),
      ),
      home: SignUpPanel(),
    );
  }
}

const colorScheme1 = ColorScheme(
  primary: CommonColors.themeColorBlue,
  onPrimary: CommonColors.themeColorPlatinumLight,
  primaryVariant: CommonColors.themeColorBlueLight,
  error: CommonColors.themeColorRed,
  onError: CommonColors.themeColorPlatinumLight,
  secondary: CommonColors.themeColorYellow,
  onSecondary: CommonColors.themeColorPlatinumLight,
  secondaryVariant: CommonColors.themeColorYellowDark,
  background: CommonColors.themeColorPlatinumLight,
  brightness: Brightness.light,
  onBackground: CommonColors.themeColorBlack,
  surface: CommonColors.themeColorPlatinumLight,
  onSurface: CommonColors.themeColorBlack,
);

const textTheme1 = TextTheme(
  headline3: TextStyle(color: CommonColors.themeColorPlatinumLight, fontSize: 22, fontWeight: FontWeight.normal),
  headline4: TextStyle(color: CommonColors.themeColorPlatinumLight ,fontWeight: FontWeight.bold, fontSize: 22),
  headline1: TextStyle(color: CommonColors.themeColorBlack, fontSize: 22, fontWeight: FontWeight.normal),
  headline2: TextStyle(color: CommonColors.themeColorBlack, fontWeight: FontWeight.bold, fontSize: 22),
  headline5: TextStyle(color: CommonColors.themeColorBlack, fontSize: 18, fontWeight: FontWeight.w600),
);

