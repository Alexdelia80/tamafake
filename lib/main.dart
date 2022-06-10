import 'package:flutter/material.dart';
import 'package:tamafake/screens/fetchuserdata.dart';
import 'package:tamafake/screens/homepage.dart';
import 'package:tamafake/screens/loginpage.dart';
import 'package:tamafake/screens/shoppage.dart';
//import 'package:tamafake/screens/avatarchoice.dart';
import 'package:tamafake/database/database.dart';
import 'package:tamafake/repository/databaserepository.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //This creates a new DatabaseRepository from the AppDatabase instance just initialized
  final databaseRepository = DatabaseRepository(database: database);

  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: MyApp(),
  ));
} //main//main


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