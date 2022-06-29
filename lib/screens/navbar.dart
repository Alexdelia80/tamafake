import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamafake/screens/assistancepage.dart';
import 'package:tamafake/screens/authpage.dart';
import 'package:tamafake/screens/homepage.dart';
import 'package:tamafake/screens/loginpage.dart';
import 'package:tamafake/screens/regulation.dart';
import 'package:tamafake/screens/shoppage.dart';
import 'package:tamafake/screens/trainingpage.dart';
import 'package:provider/provider.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:intl/intl.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color(0xFF75B7E1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                  color: const Color.fromARGB(255, 230, 67, 121)),
              accountName: const Text('Ash Ketchum',
                  style: TextStyle(
                    fontSize: 25,
                  )),
              accountEmail: const Text('bug@expert.com',
                  style: TextStyle(
                    fontSize: 18,
                  )),
              currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                child: Image.asset('assets/ash.png',
                    width: 90, height: 90, fit: BoxFit.cover),
              )),
            ),
            ListTile(
                iconColor: const Color.fromARGB(255, 230, 67, 121),
                leading: const Icon(Icons.shopping_cart, size: 30),
                title: const Text('Shop',
                    style: TextStyle(
                      fontSize: 23,
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShopPage()));
                }),
            const Divider(),
            ListTile(
                iconColor: const Color.fromARGB(255, 230, 67, 121),
                leading: const Icon(MdiIcons.run, size: 30),
                title: const Text('Train with Eevee',
                    style: TextStyle(
                      fontSize: 23,
                    )),
                onTap: () async {
                  int? datarec = await _loadData(context);
                  print('La ultima data inserita è: $datarec');
                  //int? lastdataint = (datarec.?[3] ?? 0).toInt();
                  if (datarec != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TrainingPage()));
                  } else {
                    print(
                        'ATTENZIONE: Devi caricare i dati prima di vedere il grafico!');
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => const AlertDialog(
                              //AlertDialog Title
                              backgroundColor:
                                  Color.fromARGB(255, 230, 67, 121),
                              title: Text("Please, pay attention",
                                  style: TextStyle(color: Colors.white)),

                              content: Text(
                                  "You need to load your data before to see your training's progress!",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ));
                  }
                }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.rule, size: 30),
              iconColor: Color.fromARGB(255, 230, 67, 121),
              title: const Text('Regulation',
                  style: TextStyle(
                    fontSize: 23,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegulationPage()));
              },
            ),
            const Divider(),
            ListTile(
              iconColor: const Color.fromARGB(255, 230, 67, 121),
              leading: const Icon(Icons.settings, size: 30),
              title: const Text('Authorization',
                  style: TextStyle(
                    fontSize: 23,
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AuthPage()));
              },
            ),
            const Divider(),
            ListTile(
              iconColor: const Color.fromARGB(255, 230, 67, 121),
              leading: const Icon(Icons.call, size: 30),
              title: const Text('Assistance',
                  style: TextStyle(
                    fontSize: 23,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AssistancePage()));
              },
            ),
            const Divider(),
            ListTile(
              iconColor: const Color.fromARGB(255, 230, 67, 121),
              leading: const Icon(Icons.logout, size: 30),
              title: const Text('Log Out',
                  style: TextStyle(
                    fontSize: 23,
                  )),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    //AlertDialog Title
                    backgroundColor: Color.fromARGB(255, 230, 67, 121),
                    title: const Text(
                        'Are you sure you want to leave us? Eevee is sad about this...',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    actions: <Widget>[
                      //Qui si può far scegliere all'utente se fare il log out oppure di rimanere nella home
                      TextButton(
                        //onPressed: () => Navigator.pop(context, 'Cancel'),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage())),
                        child: const Text('Stay',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () => _toLoginPage(context),
                        child: const Text('Log Out',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ); //showD
              },
            ),
            Divider(),
          ],
        ));
  }
}

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

Future<int?>? _loadData(context) async {
  final calcData = DateTime.now().subtract(const Duration(days: 1));
  int dataINT = int.parse(DateFormat("ddMMyyyy").format(calcData));

  final listtable =
      await Provider.of<DatabaseRepository>(context, listen: false).findUser();

  if (listtable.isNotEmpty) {
    int? indice = listtable.length - 1;
    int? lastdata = listtable[indice].data;
    if (lastdata == dataINT) {
      final sp = await SharedPreferences.getInstance();
      if (sp.getString('AuthorizationCheck') != null) {
        final datarec = listtable[indice];
        int? datavect = datarec.data;
        return datavect;
      } else {
        int? datavect = 0;
        return datavect;
      } // Endif lastData=dataint
    } else {
      int? datavect = 0;
      return datavect;
    }
  }
}
