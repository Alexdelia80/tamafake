import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:tamafake/screens/homepage.dart';
//import 'package:healthpoint/screens/avatarpage.dart';
//import 'package:healthpoint/utils/strings.dart';
//import 'package:healthpoint/models/analisi.dart';

class AuthorizationPage extends StatelessWidget {
  AuthorizationPage({Key? key}) : super(key: key);

  static const route = '/auth/';
  static const routename = 'AuthorizationPage';
  Map<int?, dynamic> daysteps = {};
  List<double?> stepsList = [0, 0, 0, 0, 0, 0, 0];

  // Valori forniti da fitbit per autorizzare la mia App
  String fitclientid = '238BYH';
  String fitclientsec = '9d8c4fb21e663b4f783f3f4fc6acffb8';
  String redirecturi = 'example://fitbit/auth';
  String callbackurl = 'example';
  String? userId;

  var Request = false;

  @override
  Widget build(BuildContext context) {
    print('${AuthorizationPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(AuthorizationPage.routename),
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

                    Request = true;

              },
              child: const Text('Tap to authorize'),
            ),
            
            // -------------------------- DISABILITA AUTORIZZAZIONE --------------------------
            ElevatedButton(
              onPressed: () async {
                await FitbitConnector.unauthorize(
                  clientID: fitclientid,
                  clientSecret: fitclientsec,
                );

                Request = false; 
              },
              child: const Text('Tap to unauthorize'),
            ),
          ],
        ),
      ),
    );
  } //build

} //AuthorizationPage