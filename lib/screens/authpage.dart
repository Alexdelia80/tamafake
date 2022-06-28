import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:tamafake/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static const route = '/authpage/';
  static const routename = 'AuthPage';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
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
      backgroundColor: Color(0xFF75B7E1),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 67, 121),
        centerTitle: true,
        title: const Text('Authorization', style: TextStyle(fontSize: 25)),
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
            Image.asset('assets/eevee.png', width: 150, height: 150),
            Container(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 50),
                child: (Column(
                  children: const [
                    Text(
                        'Eevee needs your data in order to train!' +
                            '\n' +
                            '\n' +
                            'Log into your Fitbit profile and authorize the upload of your data, but please remember that you can delete your data at any time by clicking "Unauthorize":',
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
              child: const Text('AUTHORIZE'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 230, 67, 121)),
                  elevation: MaterialStateProperty.all<double>(1.5)),
            ),

            // -------------------------- DISABILITA AUTORIZZAZIONE --------------------------
            ElevatedButton(
              onPressed: () async {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    //AlertDialog Title
                    backgroundColor: const Color.fromARGB(255, 230, 67, 121),
                    title: const Text('Attention!',
                        style: TextStyle(color: Colors.white)),
                    //AlertDialog description
                    content: const Text(
                        'Please note: If you revoke permission all your data will be deleted. Do you want to proceed?',
                        style: TextStyle(color: Colors.white)),
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
                        child: const Text('Delete all',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Stay'),
                        child: const Text('Stay',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('UNAUTHORIZE'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 230, 67, 121)),
                  elevation: MaterialStateProperty.all<double>(1.5)),
            ),
          ],
        ),
      ),
    );
  } //build
}
