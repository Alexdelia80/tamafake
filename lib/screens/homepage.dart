import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart'; 
import 'package:tamafake/screens/shoppage.dart';
import 'package:tamafake/screens/fetchuserdata.dart';
import 'package:tamafake/screens/loginpage.dart';
import 'package:tamafake/screens/assistancepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/homepage/';
  static const routename = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fitclientid = '238BYH';
  String fitclientsec = '9d8c4fb21e663b4f783f3f4fc6acffb8';
  String redirecturi = 'example://fitbit/auth';
  String callbackurl = 'example';
  String? userId;
  String fixedUID = '7ML2XV';
  List<String> stepsData = [];
  List<String> heartData = [];

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color(0xFF75B7E1),
          extendBody: true,
          body: Container(
            margin: const EdgeInsets.all(20),
            width: 500,
            height: 500,

            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  
                  IconRoundedProgressBar(
                    icon: Padding(
                        padding: EdgeInsets.all(8), child: Icon(Icons.person)),
                    theme: RoundedProgressBarTheme.blue,
                    margin: EdgeInsets.symmetric(vertical: 30),
                    borderRadius: BorderRadius.circular(6),
                    percent: 50,
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://www.woolha.com/media/2020/03/eevee.png'),
                        radius: 70,
                      ),
                    ),
                  ),
                  
                  Padding(padding: EdgeInsets.all(40)),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 230, 67, 121)),
                    elevation: MaterialStateProperty.all<double>(1.5)), 
                    onPressed: () async {
                      //Instantiate a proper data manager
                      FitbitActivityTimeseriesDataManager
                          fitbitActivityTimeseriesDataManager =
                          FitbitActivityTimeseriesDataManager(
                        clientID: fitclientid,
                        clientSecret: fitclientsec,
                        type: 'steps',
                      );
                      FitbitHeartDataManager fitbitActivityDataManager =
                          FitbitHeartDataManager(
                        clientID: fitclientid,
                        clientSecret: fitclientsec,
                      );

                      // Fetch steps data
                      final stepsData =
                          await fitbitActivityTimeseriesDataManager.fetch(
                              FitbitActivityTimeseriesAPIURL.dayWithResource(
                        date: DateTime.now().subtract(const Duration(days: 1)),
                        userID: fixedUID,
                        resource: fitbitActivityTimeseriesDataManager.type,
                      )) as List<FitbitActivityTimeseriesData>;

                      // Fetch heart data
                      final calcData =
                          DateTime.now().subtract(const Duration(days: 1));
                      String calcDataString =
                          DateFormat("dd-MM-yyyy").format(calcData);
                      int dataINT =
                          int.parse(DateFormat("ddMMyyyy").format(calcData));
                      final heartData = await fitbitActivityDataManager
                          .fetch(FitbitHeartAPIURL.dayWithUserID(
                        date: calcData,
                        userID: fixedUID,
                      )) as List<FitbitHeartData>;

                      print(stepsData[0].value);
                      print(heartData[0].caloriesCardio);
                      print(calcDataString);

                      await Provider.of<DatabaseRepository>(context,
                              listen: false)
                          .insertUser(UserTable(dataINT, userId,
                              stepsData[0].value, heartData[0].caloriesCardio));

                      //final rec = await Provider.of<DatabaseRepository>(context, listen:false).findData(calcDataString);
                      //print(rec);
                    },
                    child: const Text('LOAD YOUR PROGRESS!', style: TextStyle(fontSize:18)),
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
              FluidNavBarIcon(icon: Icons.logout),
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
        case 4:
          {
            _toLoginPage(context);
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
} //HomePage

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