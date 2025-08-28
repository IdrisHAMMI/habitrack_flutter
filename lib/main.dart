import 'package:flutter/material.dart';
import 'screens/home_page.dart' as home;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitTrack Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      home: home.HomePage(),
    );
  }
}
