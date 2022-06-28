import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:tamafake/database/daos/tablesDao.dart';
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
  String? userID;
  String fixedUID = '7ML2XV';
  List<String> stepsData = [];
  List<String> heartData = [];

  @override
  Widget build(BuildContext context) {
    print('Authorization');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 67, 121),
        title: const Text('Authorization'),
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
        //Aggiunta didascalia
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 50),
                child: (Column(
                  children: [
                    Text(
                        'Eevee needs your data in order to function! Log into your FitBit profile and authorize the upload, you can delete your data at any time by clicking "unauthorize":',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ],
                ))),
            // ------------------------ Autorizza il caricamento ------------------
            ElevatedButton(
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                // Authorize the app
                String? userId = await FitbitConnector.authorize(
                    context: context,
                    clientID: fitclientid,
                    clientSecret: fitclientsec,
                    redirectUri: redirecturi,
                    callbackUrlScheme: callbackurl);
                sp.setString('AuthorizationCheck', userId!);
              },
              child: const Text('Tap to authorize'),
            ),

            // -------------------------- DISABILITA AUTORIZZAZIONE --------------------------
            ElevatedButton(
              onPressed: () async {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    //AlertDialog Title
                    title: const Text('Attention!'),
                    //AlertDialog description
                    content: const Text(
                        'Please note: If you revoke permission all your data will be deleted. Do you want to proceed?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          FitbitConnector.unauthorize(
                              clientID: fitclientid,
                              clientSecret: fitclientsec);
                          //eliminiamo tutto il database.
                          await Provider.of<DatabaseRepository>(context,
                                  listen: false)
                              .cleanAvatar();
                          await Provider.of<DatabaseRepository>(context,
                                  listen: false)
                              .cleanUser();
                          final sp = await SharedPreferences.getInstance();
                          await sp.remove('portafoglio');
                          await sp.remove('progress');
                          await sp.remove('AuthorizationCheck');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        child: const Text('Delete all'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Stay'),
                        child: const Text('Stay'),
                      ),
                    ],
                  ),
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
