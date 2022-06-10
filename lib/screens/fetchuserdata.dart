import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:healthpoint/screens/avatarpage.dart';
//import 'package:healthpoint/utils/strings.dart';
//import 'package:healthpoint/models/analisi.dart';

class Arguments{
  dynamic data;
  dynamic steps;
  dynamic calories;

  Arguments(this.data, this.steps, this.calories);
}

class FetchPage extends StatefulWidget {
  FetchPage({Key? key}) : super(key: key);

  static const route = '/fetchpage/';
  static const routename = 'FetchPage';

  @override
  State<FetchPage> createState() => _FetchPageState();
}

class _FetchPageState extends State<FetchPage> {
  Map<int?, dynamic> daysteps = {};

  List<double?> stepsList = [0, 0, 0, 0, 0, 0, 0];

  // questi sono i valori forniti da fitbit per
  String fitclientid = '238BYH';

  String fitclientsec = '9d8c4fb21e663b4f783f3f4fc6acffb8';

  String redirecturi = 'example://fitbit/auth';

  String callbackurl = 'example';

  String? userId;

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
            // ------------------------ LOAD STEPS DATA --------------------------
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
                //Fetch data
                final stepsData = await fitbitActivityTimeseriesDataManager
                    .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
                  date: DateTime.now().subtract(Duration(days: 1)),
                  userID: '7ML2XV',
                  resource: fitbitActivityTimeseriesDataManager.type,
                )) as List<FitbitActivityTimeseriesData>;
                print('$stepsData');

                final heartData = await fitbitActivityDataManager
                    .fetch(FitbitHeartAPIURL.dayWithUserID(
                  date: DateTime.now().subtract(Duration(days: 1)),
                  userID: '7ML2XV',
                )) as List<FitbitHeartData>;
                //Navigator.pushNamed(context, '/HomePage/', arguments: {stepsData[0], heartData[0]});
                // Navigator.push(  context, MaterialPageRoute(builder: (_) => AvatarPage()));
                print(heartData);

                Arguments(DateTime.now().subtract(Duration(days: 1)) as String, stepsData[0] as String, heartData[0] as String );
                /*
                final snackBar =
                    SnackBar(content: Text('day : ${stepsList[1]}'));
                Text('day 1 you walked ${stepsData[0].value} steps!');
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
               */
              },
              child: const Text('Load Steps Data'),
            ),
            // ---------------------------- HEART DATA ------------------------------
            ElevatedButton(
              onPressed: () async {
                FitbitHeartDataManager fitbitActivityDataManager =
                    FitbitHeartDataManager(
                  clientID: fitclientid,
                  clientSecret: fitclientsec,
                );

                final heartData = await fitbitActivityDataManager
                    .fetch(FitbitHeartAPIURL.dayWithUserID(
                  date: DateTime.now().subtract(Duration(days: 1)),
                  userID: '7ML2XV',
                )) as List<FitbitHeartData>;
                //Navigator.pushNamed(context, 'avatar', arguments: HeartData);
                // Navigator.push(  context, MaterialPageRoute(builder: (_) => AvatarPage()));
                print(heartData);
                
              },
              child: const Text('Load Heart Data'),
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
  } 
 //build
} //HomePage
