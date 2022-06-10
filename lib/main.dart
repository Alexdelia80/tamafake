import 'package:flutter/material.dart';
import 'package:tamafake/screens/fetchuserdata.dart';
import 'package:tamafake/screens/homepage.dart';
import 'package:tamafake/screens/loginpage.dart';
import 'package:tamafake/screens/shoppage.dart';
import 'package:tamafake/screens/avatarchoice.dart';

void main() {
  runApp(const MyApp());
} //main

// login e fitbitter ok
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This specifies the app entrypoint
      initialRoute: LoginPage.route,
      //This maps names to the set of routes within the app
      routes: {
        LoginPage.route: (context) => const LoginPage(),
        HomePage.route: (context) => const HomePage(),
        '/shop/': (context) => const ShopPage(),
        '/fetchpage/': (context) => FetchPage(),
      },
    );
  } //build
}//MyApp