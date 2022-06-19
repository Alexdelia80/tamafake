import 'package:flutter/material.dart';
import 'package:tamafake/screens/shoppage.dart';
import 'package:tamafake/screens/fetchuserdata.dart';
import 'package:tamafake/screens/loginpage.dart';
import 'package:tamafake/screens/assistancepage.dart';
import 'package:tamafake/screens/progresspage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/homepage/';
  static const routename = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color(0xFF75B7E1),
          extendBody: true,
          body: Container(
            margin: const EdgeInsets.all(20),
            //color: Color.fromARGB(255, 255, 255, 255),
            width: 500,
            height: 500,

            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                        child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://www.woolha.com/media/2020/03/eevee.png'),
                      radius: 70,
                    )),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProgressPage()));
                    },
                    child: const Text('View your Progress'),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: FluidNavBar(
            icons: [
              FluidNavBarIcon(icon: Icons.home),
              FluidNavBarIcon(icon: Icons.shopping_cart),
              FluidNavBarIcon(icon: Icons.call),
              FluidNavBarIcon(icon: Icons.settings),
            ],
            onChange: _handleNavigationChange,
            style: FluidNavBarStyle(
                barBackgroundColor: Color.fromARGB(255, 64, 163, 212),
                iconBackgroundColor: Colors.white,
                iconSelectedForegroundColor: Color(0xFFFB5C66),
                iconUnselectedForegroundColor: Colors.black),
          )),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }

          break;
        case 1:
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ShopPage()));
          }

          break;
        case 2:
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AssistancePage()));
          }

          break;
        case 3:
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FetchPage()));
          }
          break;
      }

      AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
      );
    });
  }
}

void _toLoginPage(BuildContext context) async {
  //Unset the 'username' filed in SharedPreference
  final sp = await SharedPreferences.getInstance();
  sp.remove('username');

  //Pop the drawer first
  Navigator.pop(context);
  //Then pop the HomePage
  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  //Navigator.of(context).pushReplacementNamed(LoginPage.route);
} //_toCalendarPage


// CODICE ELIMINATO:
/*
        Container(
          margin: const EdgeInsets.all(20),
          //color: Color.fromARGB(255, 255, 255, 255),
          width: 500,
          height: 500,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // bottoni al centro della pagina
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Fetch User Data'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FetchPage()));
                  },
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('LogOut'),
                  onPressed: () => _toLoginPage(context),
                ),
                // fine pulsanti da mettere nella barra laterale
                // MyButton('label', Navigator.pop(context)),
              ],
            ),
          ),
        ),
        */