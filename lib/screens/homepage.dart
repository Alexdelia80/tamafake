import 'package:flutter/material.dart';
//import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
//import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
//import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
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
  Widget? _child;

  String fitclientid = '238BYH';
  String fitclientsec = '9d8c4fb21e663b4f783f3f4fc6acffb8';
  String redirecturi = 'example://fitbit/auth';
  String callbackurl = 'example';
  String? userID;
  String fixedUID = '7ML2XV';
  List<String> stepsData = [];
  List<String> heartData = [];

  @override
  void initState() {
    _child = HomePage();
    super.initState();
  }

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
                  /*
                  IconRoundedProgressBar(
                    icon: Padding(
                        padding: EdgeInsets.all(8), child: Icon(Icons.person)),
                    theme: RoundedProgressBarTheme.blue,
                    margin: EdgeInsets.symmetric(vertical: 30),
                    borderRadius: BorderRadius.circular(6),
                    percent: 50,
                  ), */
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
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 230, 67, 121)),
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
                          .insertUser(UserTable(dataINT, userID,
                              stepsData[0].value, heartData[0].caloriesCardio));

                      final controllo = await Provider.of<DatabaseRepository>(
                              context,
                              listen: false)
                          .findData(dataINT);
                      print(controllo);

                      //////////////////////// Portafoglio
                      final sp = await SharedPreferences.getInstance();
                      if (sp.getInt('portafoglio') == null) {
                        sp.setInt('portafoglio', 0);
                        final money =
                            stepsData[0].value! ~/ 500; // Divisione intera
                        // Prendo il valore attuale del portafoglio con get
                        final int? attPortafoglio = sp.getInt('portafoglio');
                        // Aggiorno il valore del portafoglio che inserirò all'interno di sp
                        final int aggPortafoglio = attPortafoglio! + money;
                        sp.setInt('portafoglio', aggPortafoglio);
                        print(aggPortafoglio);
                      } else {
                        // Calcolo i soldi che mi servono (guadagno 2 euro ogni 1000 steps)
                        final money =
                            stepsData[0].value! ~/ 500; // Divisione intera
                        // Prendo il valore attuale del portafoglio con get
                        final int? attPortafoglio = sp.getInt('portafoglio');
                        // Aggiorno il valore del portafoglio che inserirò all'interno di sp
                        final int aggPortafoglio = attPortafoglio! + money;
                        sp.setInt('portafoglio', aggPortafoglio);
                        print(aggPortafoglio);
                      }
                    },
                    child: const Text('LOAD YOUR PROGRESS!',
                        style: TextStyle(fontSize: 18)),
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
            /*scaleFactor: 1.5,
            defaultIndex: 0,
            itemBuilder:(icon, item) => Semantics(
            label: icon.extras!["label"],
            child: item,), */
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
            _child:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }

          break;
        case 1:
          {
            _child:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ShopPage()));
          }

          break;
        case 2:
          {
            _child:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AssistancePage()));
          }

          break;
        case 3:
          {
            _child:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FetchPage()));
          }
          break;
        case 4:
          {
            _child:
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                //AlertDialog Title
                title: const Text(
                    'Are you sure you want to leave us? Eevee is sad about this'),
                actions: <Widget>[
                  //Qui si può far scegliere all'utente se fare il log out oppure di rimanere nella home
                  TextButton(
                    //onPressed: () => Navigator.pop(context, 'Cancel'),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage())),
                    child: const Text('Stay'),
                  ),
                  TextButton(
                    onPressed: () => _toLoginPage(context),
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            ); //showD

            //_toLoginPage(context);
          }
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 100),
        child: _child,
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