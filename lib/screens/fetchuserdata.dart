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
      backgroundColor: const Color.fromARGB(255, 179, 210, 236),
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

        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                          final  sp = await SharedPreferences.getInstance();
                          await sp.remove('portafoglio');
                          await sp.remove('progress');
                          await sp.remove('AuthorizationCheck');
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
