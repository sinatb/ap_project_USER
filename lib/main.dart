import 'package:flutter/material.dart';
import 'package:models/models.dart';

void main() {
  Server s = Server(DataBase.empty());
  FakeData f = FakeData(s.dataBase!, s);
  f.fill();
  s.login('09321321321', 'user321');
  runApp(Head(child : MyApp() , server:  s));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ,
    );
  }
}

