import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
                // Fetch heart data
                final calcData =
                    DateTime.now().subtract(const Duration(days: 1));
                String calcDataString =
                    DateFormat("yyyy-MM-dd hh:mm:ss").format(calcData);
                final heartData = await fitbitActivityDataManager
                    .fetch(FitbitHeartAPIURL.dayWithUserID(
                  date: calcData,
                  userID: fixedUID,
                )) as List<FitbitHeartData>;
                print(stepsData[0].value);
                print(heartData[0].caloriesCardio);
                print(calcDataString);
                await Provider.of<DatabaseRepository>(context, listen: false)
                    .insertUser(UserTable(fixedUID, calcDataString,
                        stepsData[0].value, heartData[0].caloriesCardio));
              },
              child: const Text('Load all Data'),
            ),
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