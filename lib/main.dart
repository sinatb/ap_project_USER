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
      theme: ThemeData(
        primaryColor: CommonColors.themeColorBlue,
        scaffoldBackgroundColor: CommonColors.themeColorPlatinum,
        errorColor: CommonColors.red,
        buttonColor: CommonColors.green,
        iconTheme: IconThemeData(
          color: CommonColors.themeColorRed,
        ),
      textTheme: TextTheme(
        headline1: TextStyle(color: CommonColors.themeColorRed ,fontWeight: FontWeight.bold, fontSize: 22),
        headline2: TextStyle(color: CommonColors.themeColorBlack , fontSize: 20),
        bodyText1: TextStyle(fontSize: 18),
        bodyText2: TextStyle(fontSize: 16),
      ),
    ),
      home: SignUpPanel(),
    );
  }
}

