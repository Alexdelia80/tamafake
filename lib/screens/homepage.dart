import 'package:flutter/material.dart';
import 'package:tamafake/screens/fetchuserdata.dart';
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
  String fitclientid = '238BYH';
  String fitclientsec = '9d8c4fb21e663b4f783f3f4fc6acffb8';
  String redirecturi = 'example://fitbit/auth';
  String callbackurl = 'example';
  String? userID;
  String fixedUID = '7ML2XV';
  List<String> stepsData = [];
  List<String> heartData = [];

  @override
  Widget build(context) {
    final level = _returnLevel(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('TAMA-fit',
              style: TextStyle(fontFamily: 'Lobster', fontSize: 30)),
          backgroundColor: Color.fromARGB(255, 230, 67, 121),
        ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LEVEL: $level",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ],
                    ),
                  ],
                ),
                // Progress Bar
                FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      final sp = snapshot.data as SharedPreferences;
                      if (sp.getDouble('progress') == null) {
                        sp.setDouble('progress', 0);
                        final progress = sp.getDouble('progress');

                        print('Progresso:$progress');
                        return SizedBox(
                          height: 20,
                          width: 300,
                          child: LinearProgressIndicator(
                              value: progress,
                              color: Color.fromARGB(255, 67, 129, 230),
                              backgroundColor:
                                  Color.fromARGB(255, 135, 169, 197)),
                        );
                      } else {
                        final progress = sp.getDouble('progress');
                        print('Progresso:$progress');

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
                // Icon
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
                const Padding(padding: EdgeInsets.all(40)),
                // Load your progress
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 230, 67, 121)),
                      elevation: MaterialStateProperty.all<double>(1.5)),
                  onPressed: () async {
                    //Controllo che l'autorizzazione ci sia, altrimenti parte un alert
                    final sp = await SharedPreferences.getInstance();
                    if (sp.getString('AuthorizationCheck') != null) {
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

                      print(stepsData[0].value);
                      print(heartData[0].caloriesCardio);
                      print(dataINT);

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
                        print(listtable);
                        print(indice);
                        print(lastdata);
                        //Controllo che la data non sia già presente nel database
                        if (lastdata != dataINT || lastdata == null) {
                          // Scrivo i dati nel database
                          await Provider.of<DatabaseRepository>(context,
                                  listen: false)
                              .insertUser(UserTable(
                                  dataINT,
                                  fixedUID,
                                  stepsData[0].value,
                                  heartData[0].caloriesCardio));
                          final steps = stepsData[0].value;
                          final calorie = heartData[0].caloriesCardio;

                          //Alert per avvisare l'utente che i dati sono stati caricati
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => SimpleDialog(
                                    //AlertDialog Title
                                    backgroundColor:
                                        Color.fromARGB(255, 230, 67, 121),
                                    title: Text(
                                        'Your Progress:' +
                                            '\n' +
                                            'Steps: $steps' +
                                            '\n' +
                                            'Calories: $calorie' +
                                            '\n',
                                        style: TextStyle(color: Colors.white)),
                                  ));

                          // Aggiorno il portafoglio
                          final sp = await SharedPreferences.getInstance();
                          if (sp.getInt('portafoglio') == null) {
                            sp.setInt('portafoglio', 0);
                            final money =
                                stepsData[0].value! ~/ 200; // Divisione intera
                            // Prendo il valore attuale del portafoglio con get
                            final int? attPortafoglio =
                                sp.getInt('portafoglio');
                            // Aggiorno il valore del portafoglio che inserirò all'interno di sp
                            final int aggPortafoglio = attPortafoglio! + money;
                            sp.setInt('portafoglio', aggPortafoglio);
                            print(aggPortafoglio);
                          } else {
                            // Calcolo i soldi che mi servono (guadagno 5 euro ogni 1000 steps)
                            final money =
                                stepsData[0].value! ~/ 200; // Divisione intera
                            // Prendo il valore attuale del portafoglio con get
                            final int? attPortafoglio =
                                sp.getInt('portafoglio');
                            // Aggiorno il valore del portafoglio che inserirò all'interno di sp
                            final int aggPortafoglio = attPortafoglio! + money;
                            sp.setInt('portafoglio', aggPortafoglio);
                            print(aggPortafoglio);
                          }
                        }

                        // La data è già presente del database
                        else {
                          print(
                              'ATTENZIONE: Non puoi caricare due volte gli stessi dati!');
                          //Alert per avvisare che i dati non possono essere caricati due volte lo stesso giorno
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => SimpleDialog(
                                    //AlertDialog Title
                                    backgroundColor:
                                        Color.fromARGB(255, 230, 67, 121),
                                    title: Text(
                                        "Don't get smart with us!" +
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
                                heartData[0].caloriesCardio));
                        final steps = stepsData[0].value;
                        final calorie = heartData[0].caloriesCardio;

                        //Alert per avvisare l'utente che i dati sono stati caricati
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => SimpleDialog(
                                  //AlertDialog Title
                                  backgroundColor:
                                      Color.fromARGB(255, 230, 67, 121),
                                  title: Text(
                                      'Your Progress:' +
                                          '\n' +
                                          '\n' +
                                          'Steps: $steps' +
                                          '\n' +
                                          'Calories: $calorie' +
                                          '\n',
                                      style: TextStyle(color: Colors.white)),
                                ));

                        final sp = await SharedPreferences.getInstance();
                        if (sp.getInt('portafoglio') == null) {
                          sp.setInt('portafoglio', 0);
                          final money =
                              stepsData[0].value! ~/ 200; // Divisione intera
                          // Prendo il valore attuale del portafoglio con get
                          final int? attPortafoglio = sp.getInt('portafoglio');
                          // Aggiorno il valore del portafoglio che inserirò all'interno di sp
                          final int aggPortafoglio = attPortafoglio! + money;
                          sp.setInt('portafoglio', aggPortafoglio);
                          print(aggPortafoglio);
                        } else {
                          // Calcolo i soldi che mi servono (guadagno 2 euro ogni 1000 steps)
                          final money =
                              stepsData[0].value! ~/ 200; // Divisione intera
                          // Prendo il valore attuale del portafoglio con get
                          final int? attPortafoglio = sp.getInt('portafoglio');
                          // Aggiorno il valore del portafoglio che inserirò all'interno di sp
                          final int aggPortafoglio = attPortafoglio! + money;
                          sp.setInt('portafoglio', aggPortafoglio);
                          print(aggPortafoglio);
                        }
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
                            //Qui si può far scegliere all'utente di tornare alla home oppure di rimanere nello shop
                            TextButton(
                              //onPressed: () => Navigator.pop(context, 'Cancel'),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const FetchPage())),
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
              ],
            ),
          ),
        ),
        drawer: NavBar(),
      ),
    );
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
