import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamafake/screens/assistancepage.dart';
import 'package:tamafake/screens/fetchuserdata.dart';
import 'package:tamafake/screens/homepage.dart';
import 'package:tamafake/screens/loginpage.dart';
import 'package:tamafake/screens/shoppage.dart';
import 'package:tamafake/screens/regulation.dart';


class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color.fromARGB(255, 179, 210, 236),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 230, 67, 121)),
              accountName: Text('Eevee',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              accountEmail: Text('bug@expert.com',
                  style: TextStyle(
                    fontSize: 18,
                  )),
              currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                      //child: Image.asset('', width: 90, height: 90, fit: BoxFit.cover),
                      )),
            ),
            ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Shop', style: TextStyle(
                    fontSize: 18,
                  )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShopPage()));
                }),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Authorization', style: TextStyle(
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FetchPage()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.rule),
              title: Text('Regulation', style: TextStyle(
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegulationPage()));
              },
            ),
             Divider(),
            ListTile(
              leading: Icon(Icons.call),
              title: Text('Assistance', style: TextStyle(
                    fontSize: 18,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AssistancePage()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out', style: TextStyle(
                    fontSize: 18,
                  )),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    //AlertDialog Title
                    title: const Text(
                        'Are you sure you want to leave us? Eevee is sad about this'),
                    actions: <Widget>[
                      //Qui si può far scegliere all'utente se fare il log out oppure di rimanere nella home
                      TextButton(
                        //onPressed: () => Navigator.pop(context, 'Cancel'),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage())),
                        child: const Text('Stay'),
                      ),
                      TextButton(
                        onPressed: () => _toLoginPage(context),
                        child: const Text('Log Out'),
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