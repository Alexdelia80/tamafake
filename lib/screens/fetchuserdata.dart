import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:tamafake/database/entities/tables.dart';
//import 'package:tamafake/database/daos/tablesDao.dart';
import 'package:tamafake/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchPage extends StatefulWidget {
  const FetchPage({Key? key}) : super(key: key);

  static const route = '/fetchpage/';
  static const routename = 'FetchPage';

  @override
  State<FetchPage> createState() => _FetchPageState();
}

class _FetchPageState extends State<FetchPage> {
  String fitclientid = '238BYH';
  String fitclientsec = '9d8c4fb21e663b4f783f3f4fc6acffb8';
  String redirecturi = 'example://fitbit/auth';
  String callbackurl = 'example';
  String? userId;
  String fixedUID = '7ML2XV';
  List<String> stepsData = [];
  List<String> heartData = [];

  @override
  Widget build(BuildContext context) {
    print('${FetchPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(FetchPage.routename),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.arrow_back_sharp),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));

                  Scaffold.of(context).openDrawer();
                },
                tooltip:
                    MaterialLocalizations.of(context).openAppDrawerTooltip);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ------------------------ Autorizza il caricamento ------------------
            ElevatedButton(
              onPressed: () async {
                // Authorize the app
                String? userId = await FitbitConnector.authorize(
                    context: context,
                    clientID: fitclientid,
                    clientSecret: fitclientsec,
                    redirectUri: redirecturi,
                    callbackUrlScheme: callbackurl);
              },
              child: const Text('Tap to authorize'),
            ),
            // ------------------------ LOAD Heart and Steps DATA --------------------------
            ElevatedButton(
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
                final stepsData = await fitbitActivityTimeseriesDataManager
                    .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
                  date: DateTime.now().subtract(const Duration(days: 1)),
                  userID: fixedUID,
                  resource: fitbitActivityTimeseriesDataManager.type,
                )) as List<FitbitActivityTimeseriesData>;

                // conversione della data in int e stringa
                final calcData =
                    DateTime.now().subtract(const Duration(days: 1));
                String calcDataString =
                    DateFormat("dd-MM-yyyy").format(calcData);
                int dataID = int.parse(DateFormat("ddMMyyyy").format(calcData));
                // ----------------------------- fetch heart data ------------------------------------
                final heartData = await fitbitActivityDataManager
                    .fetch(FitbitHeartAPIURL.dayWithUserID(
                  date: calcData,
                  userID: fixedUID,
                )) as List<FitbitHeartData>;
                print(stepsData[0].value);
                print(heartData[0].caloriesCardio);
                print(calcDataString);
                //----------------------------  INSERIMENTO E GESTIONE CONFLITTO  -----------------------------------------
                // ------- ESTRAPOLO L'ULTIMA DATA PRESENTE NEL DB E LA CONFRONTO CON IL FETCH---------
                final listtable = await Provider.of<DatabaseRepository>(context,
                        listen: false)
                    .findUser();
                if (listtable.isNotEmpty) {
                  int? indice = listtable.length - 1;
                  int? lastdata = listtable[indice].id;
                  print(listtable);
                  print(indice);
                  print(lastdata);
                  if (lastdata != dataID || lastdata == null) {
                    // ------------------------------ scrivo i dati sul DB Principale ------------------
                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .insertUser(UserTable(dataID, fixedUID, calcDataString,
                            stepsData[0].value, heartData[0].caloriesCardio));
                    //---------------------------------carico i dati nel portafoglio----------------------
                    final sp = await SharedPreferences.getInstance();
                    if (sp.getInt('portafoglio') == null) {
                      sp.setInt('portafoglio', 0);
                    } else {
                      // calcolo i soldi che mi servono (considerando 2 euro per 1000 step)
                      final money =
                          stepsData[0].value! ~/ 500; //divisione intera
                      //prendo il valore attuale del portafoglio con get
                      final int? attPortafoglio = sp.getInt('portafoglio');
                      // aggiorno il valore del portafoglio che inserirò all'interno di sp
                      final int aggPortafoglio = attPortafoglio! + money;
                      sp.setInt('portafoglio', aggPortafoglio);
                      //print(aggPortafoglio);
                    }
                  } else {
                    print(
                        'ATTENZIONE: Non puoi caricare due volte gli stessi dati!');
                  }
                } else {
                  // ------ SE LA TABELLA E' VUOTA SCRIVO I DATI PER LA PRIMA VOLTA -------
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .insertUser(UserTable(dataID, fixedUID, calcDataString,
                          stepsData[0].value, heartData[0].caloriesCardio));
                  //---------------------------------carico i dati nel portafoglio----------------------
                  final sp = await SharedPreferences.getInstance();
                  if (sp.getInt('portafoglio') == null) {
                    sp.setInt('portafoglio', 0);
                  } else {
                    // calcolo i soldi che mi servono (considerando 2 euro per 1000 step)
                    final money = stepsData[0].value! ~/ 500; //divisione intera
                    //prendo il valore attuale del portafoglio con get
                    final int? attPortafoglio = sp.getInt('portafoglio');
                    // aggiorno il valore del portafoglio che inserirò all'interno di sp
                    final int aggPortafoglio = attPortafoglio! + money;
                    sp.setInt('portafoglio', aggPortafoglio);
                    //print(aggPortafoglio);
                  }
                }
              },
              child: const Text('Load your progress!'),
            ),
            // ---------------------------------- END CODICE CONFLITTO --------------------------------
            // -------------------------- DISABILITA AUTORIZZAZIONE --------------------------
            ElevatedButton(
              onPressed: () async {
                await FitbitConnector.unauthorize(
                  clientID: fitclientid,
                  clientSecret: fitclientsec,
                );
              },
              child: const Text('Tap to unauthorize'),
            ),
          ],
        ),
      ),
    );
  } //build
}

/*

class StepsClass extends ChangeNotifier {
  //For simplicity, a product is just a String.
  List<String> steps = [];

  void addSteps(String toAdd) {
    steps.add(toAdd);
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  } //addProduct

  void clearSteps() {
    steps.clear();
    //Call the notifyListeners() method to alert that something happened.
    notifyListeners();
  } //clearCart

}//Cart //HomePage
___________________________________________________________________
// };
                // ---------------------- PASSAGGIO PARAMETRI A AVATAR ---------------------
                 // final async {
                // final wp = stepsData[0].value;
                //No need to use a Consumer, we are just using a method of the DatabaseRepository
                // UserTable(this.id, this.data, this.steps, this.calories);
                //Provider.of<StepsClass>(context, listen: false).addSteps(stepsData[0].value as String);
                // Arguments(DateTime.now().subtract(Duration(days: 1)) as String,
                //    stepsData[0] as String, heartData[0] as String);
                //Arguments(DateTime.now().subtract(const Duration(days: 1)), stepsData, heartData);
                //Navigator.pushNamed(context, '/homepage/', arguments: stepsData);
                //Navigator.pushNamed(context, '/homepage/', arguments: {
                //  stepsData[0].dateOfMonitoring,
                //  heartData[0].caloriesCardio,
                // });
___________________________________________________________________


*/