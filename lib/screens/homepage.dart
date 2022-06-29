import 'package:flutter/material.dart';
import 'package:tamafake/screens/authpage.dart';
import 'package:tamafake/screens/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:intl/intl.dart';
import 'package:tamafake/screens/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/homepage/';
  static const routename = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? value;
  String? uID;
  double? progress;
  int? exp;

  @override
  void initState() {
    super.initState();
    // fetchName function is a asynchronously to GET data
    _returnLevel(context).then((result) => {
          // Once we receive our name we trigger rebuild.
          setState(() {
            value = result;
          })
        });
    _checkprogress(context).then((result) => {
          // Once we receive our name we trigger rebuild.
          setState(() {
            progress = result;
          })
        });
    _checkexp(context).then((result) => {
          // Once we receive our name we trigger rebuild.
          setState(() {
            exp = result;
          })
        });
  }

  String fitclientid = '238BYH';
  String fitclientsec = '9d8c4fb21e663b4f783f3f4fc6acffb8';
  String redirecturi = 'example://fitbit/auth';
  String callbackurl = 'example';
  String? userID;
  String fixedUID = '7ML2XV';

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('TAMA-fit',
              style: TextStyle(fontFamily: 'Lobster', fontSize: 30)),
          backgroundColor: const Color.fromARGB(255, 230, 67, 121),
        ),
        backgroundColor: const Color(0xFF75B7E1),
        extendBody: true,
        body: Container(
          margin: const EdgeInsets.all(20),
          width: 500,
          height: 700,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -------------- STAMPO IL LIVELLO ATTUALE ---------------------
                        Text(
                          "LEVEL: $value",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                // ------------------------------- Experience Bar ------------------------------
                FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      final sp = snapshot.data as SharedPreferences;
                      if (sp.getDouble('progress') == null) {
                        sp.setDouble('progress', 0);
                        final progress = sp.getDouble('progress');
                        return SizedBox(
                          height: 20,
                          width: 300,
                          child: LinearProgressIndicator(
                              value: progress,
                              color: const Color.fromARGB(255, 67, 129, 230),
                              backgroundColor:
                                  const Color.fromARGB(255, 135, 169, 197)),
                        );
                      } else {
                        final progress = sp.getDouble('progress');
                        return SizedBox(
                          height: 20,
                          width: 300,
                          child: LinearProgressIndicator(
                              value: progress,
                              color: Color.fromARGB(255, 67, 129, 230),
                              backgroundColor:
                                  Color.fromARGB(255, 135, 169, 197)),
                        );
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
                ),
                // ------------------------------ END PROGRESS ---------------------------------
                const SizedBox(
                  height: 40,
                ),
                // ----------------------------- Immagine Evee ---------------------------------
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://www.woolha.com/media/2020/03/eevee.png'),
                      radius: 70,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),

                // -------------------------------- EXPERIENCE --------------------------------
                Text(
                  'Eevee\'s total experience: $exp',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 100,
                ),
                // --------------------- BUTTON: Load your progress ------------------------------
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 230, 67, 121)),
                      elevation: MaterialStateProperty.all<double>(1.5)),
                  onPressed: () async {
                    //Controllo che l'autorizzazione ci sia, altrimenti parte un alert
                    String? uID = await _checkauth(context);
                    final sp = await SharedPreferences.getInstance();

                    // ----------------  IF PRINCIPALE DELLO STATEMENT -----------------
                    if ((sp.getString('AuthorizationCheck') != null) &&
                        uID == null) {
                      // Instantiate a proper data manager
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

                      // Fetch Steps data
                      final stepsData =
                          await fitbitActivityTimeseriesDataManager.fetch(
                              FitbitActivityTimeseriesAPIURL.dayWithResource(
                        date: DateTime.now().subtract(const Duration(days: 1)),
                        userID: fixedUID,
                        resource: fitbitActivityTimeseriesDataManager.type,
                      )) as List<FitbitActivityTimeseriesData>;

                      // Fetch Heart data
                      final calcData =
                          DateTime.now().subtract(const Duration(days: 1));
                      int dataINT =
                          int.parse(DateFormat("ddMMyyyy").format(calcData));

                      final heartData = await fitbitActivityDataManager
                          .fetch(FitbitHeartAPIURL.dayWithUserID(
                        date: calcData,
                        userID: fixedUID,
                      )) as List<FitbitHeartData>;

                      print('Data: $dataINT');

                      //----------------------------  INSERIMENTO E GESTIONE CONFLITTO  -----------------------------------------
                      // ------- ESTRAPOLO L'ULTIMA DATA PRESENTE NEL DB E LA CONFRONTO CON IL FETCH---------
                      final listtable = await Provider.of<DatabaseRepository>(
                              context,
                              listen: false)
                          .findUser();
                      // Se la tabella non è vuota:
                      if (listtable.isNotEmpty) {
                        int? indice = listtable.length - 1;
                        int? lastdata = listtable[indice].data;
                        //Controllo che la data non sia già presente nel database
                        if (lastdata != dataINT) {
                          // Scrivo i dati nel database
                          await Provider.of<DatabaseRepository>(context,
                                  listen: false)
                              .insertUser(UserTable(
                                  dataINT,
                                  fixedUID,
                                  stepsData[0].value,
                                  heartData[0].caloriesCardio,
                                  heartData[0].caloriesFatBurn,
                                  heartData[0].caloriesPeak));
                          final steps = stepsData[0].value;
                          final calorie_cardio = heartData[0].caloriesCardio;
                          double cal_cardio =
                              calorie_cardio!.truncateToDouble();
                          final calorie_fatburn = heartData[0].caloriesFatBurn;
                          double cal_fatburn =
                              calorie_fatburn!.truncateToDouble();
                          final calorie_peak = heartData[0].caloriesPeak;
                          double cal_peak = calorie_peak!.truncateToDouble();

                          //Alert per avvisare l'utente che i dati sono stati caricati
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    //AlertDialog Title
                                    backgroundColor:
                                        const Color.fromARGB(255, 230, 67, 121),
                                    title: Text('Your progress:'),
                                    content: Text(
                                        'Steps: $steps' +
                                            '\n' +
                                            'Calories Cardio: $cal_cardio' +
                                            '\n' +
                                            'Calories Fat Burn: $cal_fatburn' +
                                            '\n' +
                                            'Calories Peak: $cal_peak' +
                                            '\n',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ));
                          // ------------------- aggiorno il portafoglio ---------------------
                          _returnMoney(stepsData[0].value);
                        }

                        // La data è già presente del database
                        else {
                          print(
                              'ATTENZIONE: Non puoi caricare due volte gli stessi dati!');
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  const SimpleDialog(
                                    //AlertDialog Title
                                    backgroundColor:
                                        Color.fromARGB(255, 230, 67, 121),
                                    title: Text(
                                        "Don't get cheat!" +
                                            "\n" +
                                            "You can't upload your progress twice!" +
                                            "\n",
                                        style: TextStyle(color: Colors.white)),
                                  ));
                          //alert
                        }
                      } else {
                        // ------ SE LA TABELLA E' VUOTA SCRIVO I DATI PER LA PRIMA VOLTA -------
                        await Provider.of<DatabaseRepository>(context,
                                listen: false)
                            .insertUser(UserTable(
                                dataINT,
                                fixedUID,
                                stepsData[0].value,
                                heartData[0].caloriesCardio,
                                heartData[0].caloriesFatBurn,
                                heartData[0].caloriesPeak));
                        final steps = stepsData[0].value;
                        final steps_int = steps!.toInt();
                        final calorie_cardio = heartData[0].caloriesCardio;
                        double cal_cardio = calorie_cardio!.truncateToDouble();
                        final calorie_fatburn = heartData[0].caloriesFatBurn;
                        double cal_fatburn =
                            calorie_fatburn!.truncateToDouble();
                        final calorie_peak = heartData[0].caloriesPeak;
                        double cal_peak = calorie_peak!.truncateToDouble();
                        //Alert per avvisare l'utente che i dati sono stati caricati
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => SimpleDialog(
                                  //AlertDialog Title
                                  backgroundColor:
                                      Color.fromARGB(255, 230, 67, 121),
                                  title: Text(
                                      'Steps: $steps' +
                                          '\n' +
                                          'Calories Cardio: $cal_cardio' +
                                          '\n' +
                                          'Calories Fat Burn: $cal_fatburn' +
                                          '\n' +
                                          'Calories Peak: $cal_peak' +
                                          '\n',
                                      style: TextStyle(color: Colors.white)),
                                ));
                        // ------------------- aggiorno il portafoglio -----------------------
                        _returnMoney(stepsData[0].value);
                      }
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          //AlertDialog Title
                          title: const Text('Attention!',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Color.fromARGB(255, 230, 67, 121),
                          //AlertDialog description
                          content: const Text(
                              'You have to authorize the app first!',
                              style: TextStyle(color: Colors.white)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AuthPage())),
                              child: const Text('Authorize',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    }
                  }, //onPressed
                  child: const Text('LOAD YOUR PROGRESS!',
                      style: TextStyle(fontSize: 18)),
                ),
                // ------------------- END LOAD YOUR PROGRESS -----------------------
              ],
            ),
          ),
        ),
        drawer: const NavBar(),
      ),
    );
  }
} //HomePage

// FUNCTIONS:

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

Future<int?> _returnLevel(context) async {
  //Estrappolo il livello
  final listavatar =
      await Provider.of<DatabaseRepository>(context, listen: false)
          .findAvatar();
  if (listavatar.isNotEmpty) {
    final int indice = listavatar.length - 1;
    int? level = listavatar[indice].level;
    return level;
  } else {
    int? level = 1;
    return level;
  }
}

Future<int?> _returnMoney(value) async {
  final sp = await SharedPreferences.getInstance();
  if (sp.getInt('portafoglio') == null) {
    sp.setInt('portafoglio', 0);
    final int money = (value ~/ 200);
    // Prendo il valore attuale del portafoglio con get
    final int? attPortafoglio = sp.getInt('portafoglio');
    // Aggiorno il valore del portafoglio che inserirò all'interno di sp
    final int aggPortafoglio = attPortafoglio! + money;
    sp.setInt('portafoglio', aggPortafoglio);
    print('Il valore del tuo portafoglio è: $aggPortafoglio');
    return aggPortafoglio;
  } else {
    // Calcolo i soldi che mi servono (guadagno 5 euro ogni 1000 steps)
    final int money = (value ~/ 200); // Divisione intera
    // Prendo il valore attuale del portafoglio con get
    final int? attPortafoglio = sp.getInt('portafoglio');
    // Aggiorno il valore del portafoglio che inserirò all'interno di sp
    final int aggPortafoglio = attPortafoglio! + money;
    sp.setInt('portafoglio', aggPortafoglio);
    print('Il valore del tuo portafoglio è: $aggPortafoglio');
    return aggPortafoglio;
  }
}

Future<String?> _checkauth(context) async {
  String fitclientid = '238BYH';
  String fitclientsec = '9d8c4fb21e663b4f783f3f4fc6acffb8';
  String redirecturi = 'example://fitbit/auth';
  String callbackurl = 'example';
  String? userId = '';
  userId = await FitbitConnector.authorize(
      context: context,
      clientID: fitclientid,
      clientSecret: fitclientsec,
      redirectUri: redirecturi,
      callbackUrlScheme: callbackurl);
  FitbitUserAPIURL fitbitUserApiUrl =
      FitbitUserAPIURL.withUserID(userID: userId);
  print('fitbitapiurl: $fitbitUserApiUrl');
  return userId;
}

Future<double?> _checkprogress(context) async {
  final sp = await SharedPreferences.getInstance();
  if (sp.getDouble('progress') == null) {
    sp.setDouble('progress', 0);
    final progress = sp.getDouble('progress');
    return progress;
  } else {
    final progress = sp.getDouble('progress');
    return progress;
  }
}

Future<int?> _checkexp(context) async {
  final listavatar =
      await Provider.of<DatabaseRepository>(context, listen: false)
          .findAvatar();
  if (listavatar.isNotEmpty) {
    final int indice = listavatar.length - 1;
    int lastexp = listavatar[indice].exp;
    return lastexp;
  } else {
    return 0;
  }
}
