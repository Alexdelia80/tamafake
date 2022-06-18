import 'package:flutter/material.dart';
import 'package:tamafake/screens/fetchuserdata.dart';
import 'package:tamafake/screens/homepage.dart';
import 'package:tamafake/screens/loginpage.dart';
import 'package:tamafake/screens/shoppage.dart';
import 'package:tamafake/screens/assistancepage.dart';
import 'package:tamafake/database/database.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:provider/provider.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('application_database.db').build();
  final databaseRepository = DatabaseRepository(database: database);

  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: const MyApp(),
  ));
} //Main

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
        ShopPage.route: (context) => const ShopPage(),
        FetchPage.route: (context) => const FetchPage(),
        AssistancePage.route: (context) => const AssistancePage(),
      },
    );
  } //build
} //MyApp