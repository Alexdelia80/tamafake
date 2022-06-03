import 'package:flutter/material.dart';
import 'package:tamagotchi/screens/homePage.dart';
import 'package:tamagotchi/screens/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
          return MaterialApp(
            initialRoute: LoginPage.route,
            routes: {
              LoginPage.route: (context) => LoginPage(),
              HomePage.route: (context) => HomePage(),
            },
          );
  } //build
}//MyApp