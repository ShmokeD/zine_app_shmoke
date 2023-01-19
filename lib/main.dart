import 'package:flutter/material.dart';
import 'package:zineapp2023/screens/onboarding/landing.dart';
import 'package:zineapp2023/screens/onboarding/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home:LoginPage(),
    );
  }
}
